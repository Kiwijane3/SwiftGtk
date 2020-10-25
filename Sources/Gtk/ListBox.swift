//
//  ListBoxProtocol.swift
//  Atk
//
//  Created by Jane Fraser on 4/04/20.
//

import Foundation
import GIO
import GLibObject
import CGtk

public typealias CreateWidgetHandler = (Any) -> Widget;

public typealias CreateWidgetHandlerHolder = ClosureHolder<Any, Widget>;

// MARK:- List organisation handler assignment.

public extension ListBoxProtocol {
	
	func _bind<B: GIO.ListModelProtocol, T: AnyObject>(to model: Model<B, T>, using widgetCreator: @escaping CreateWidgetHandler) {
		let holder = ClosureHolder(widgetCreator);
		let opaqueHolder = Unmanaged<ClosureHolder>.passRetained(holder).toOpaque();
		bind(model: model.model, createWidgetFunc: { (itemPointer, holderPointer) -> UnsafeMutablePointer<GtkWidget>? in
			// Unwrap the itemPointer.
			if let itemPointer = itemPointer, let holderPointer = holderPointer {
				let holder = Unmanaged<CreateWidgetHandlerHolder>.fromOpaque(holderPointer).takeUnretainedValue();
				let item = Gtk.swiftObj(fromRaw: itemPointer) as! Wrapper;
				let widget = holder.call(item.value);
				// Have the widget become swift widget, so the swift object wrapper is retained for the lifecycle of the widget.
				widget.becomeSwiftObjIfInitial();
				return widget.widget_ptr;
			} else {
				return nil;
			}
		}, userData: opaqueHolder) { (holderPointer) in
			if let holderPointer = holderPointer {
				Unmanaged<CreateWidgetHandlerHolder>.fromOpaque(holderPointer).release();
			}
		}
	}
	
	func bind<B: GIO.ListModelProtocol, T: AnyObject>(to model: Model<B, T>, using widgetCreator: @escaping (T) -> Widget) {
		self._bind(to: model) { (item) -> Widget in
			return widgetCreator(item as! T);
		}
	}
	
}

public typealias ListBoxFilterHandler = (ListBoxRowProtocol) -> Bool;

public typealias ListBoxFilterHandlerHolder = ClosureHolder<ListBoxRowProtocol, Bool>;

public typealias ListBoxSortHandler = (ListBoxRowProtocol, ListBoxRowProtocol) -> Int;

public typealias ListBoxSortHandlerHolder = DualClosureHolder<ListBoxRowProtocol, ListBoxRowProtocol, Int>;

public typealias ListBoxUpdateHeaderHandler = (ListBoxRowProtocol, ListBoxRowProtocol?) -> Void;

public typealias ListBoxUpdateHeaderHandlerHolder = DualClosureHolder<ListBoxRowProtocol, ListBoxRowProtocol?, Void>;

public extension ListBoxProtocol {
	
	/// By setting a filter function on the box one can decide dynamically which of the rows to show. For instance, to implement a search function on a list that filters the original list to only show the matching rows.
	/// The filter_func will be called for each row after the call, and it will continue to be called each time a row changes (via rowChanged()) or when  invalidateFilter() is called.
	/// Note that using a filter function is incompatible with using a model.
	/// - Parameter row: The row to be evaluated; If a compatible swiftObj has been set for the row, that will be provided.
	/// - Returns: Whether to display the specified row.
	public func onFilter(_ handler: @escaping ListBoxFilterHandler) {
		let holder = ClosureHolder(handler);
		let opaqueHolder = Unmanaged.passRetained(holder).toOpaque();
		self.set(filterFunc: { (rowPointer, holderPointer) -> gboolean in
			if let rowPointer = rowPointer, let holderPointer = holderPointer {
				let holder = Unmanaged<ListBoxFilterHandlerHolder>.fromOpaque(holderPointer).takeUnretainedValue();
				let row = swiftRepresentation(of: ListBoxRowRef(raw: rowPointer));
				return holder.call(row) ? 1 : 0;
			}
			return 1;
		}, userData: opaqueHolder) { (pointer) in
			if let pointer = pointer {
				Unmanaged<ListBoxFilterHandlerHolder>.fromOpaque(pointer).release();
			}
		}
	}
	
	public func onFilter<T: ListBoxRowProtocol>(_ handler: @escaping (T) -> Bool, as filter: T.Type) {
		self.onFilter { (row) -> Bool in
			if let row = row as? T {
				return handler(row);
			} else {
				return false;
			}
		}
	}
	
	/// By setting a sort function on the box one can dynamically reorder the rows of the list, based on the contents of the rows.
	/// The sort_func will be called for each row after the call, and will continue to be called each time a row changes (via rowChanged()) and when invalidateSort() is called.
	/// Note that using a sort function is incompatible with using a model.
	/// - Parameter a: A row to be sorted. If a compatible swiftObj has been set, that will be provided.
	/// - Parameter b: Another row to be sorted. If a compatible swiftObj has been set, that will be provided.
	/// - Returns: An integer indicating the order of the rows. <0 indicates a should be before b, >0 indicates b should be before a, and 0 indicates they have equal priority.
	public func onSort(_ handler: @escaping ListBoxSortHandler) {
		let holder = DualClosureHolder(handler);
		let opaqueHolder = Unmanaged.passRetained(holder).toOpaque();
		self.set(sortFunc: { (aPointer, bPointer, holderPointer) -> gint in
			if let aPointer = aPointer, let bPointer = bPointer, let holderPointer = holderPointer {
				let holder = Unmanaged<ListBoxSortHandlerHolder>.fromOpaque(holderPointer).takeUnretainedValue();
				let a = swiftRepresentation(of: ListBoxRowRef(cPointer: aPointer));
				let b = swiftRepresentation(of: ListBoxRowRef(cPointer: bPointer));
				let rv = holder.call(a, b);
				return Int32(rv);
			}
			return 0;
		}, userData: opaqueHolder) { (holderPointer) in
			if let holderPointer = holderPointer {
				Unmanaged<ListBoxSortHandlerHolder>.fromOpaque(holderPointer).release();
			}
		}
	}
	
	public func onSort<T: ListBoxRowProtocol>(_ handler: @escaping (T, T) -> Int, as type: T.Type) {
		self.onSort { (a, b) -> Int in
			if let a = a as? T, let b = b as? T {
				return handler(a, b);
			} else {
				return 0;
			}
		}
	}
	
	///By setting a header function on the box one can dynamically add headers in front of rows, depending on the contents of the row and its position in the list. For instance, one could use it to add headers in front of the first item of a new kind, in a list sorted by the kind.
	/// The update_header can look at the current header widget and either update the state of the widget as needed, or set a new one using row.setHeader(). If no header is needed, set the header to nil.
	/// Note that you may get many calls update_header to this for a particular row when e.g. changing things that don’t affect the header. In this case it is important for performance to not blindly replace an existing header with an identical one.
	/// The update_header function will be called for each row after the call, and it will continue to be called each time a row changes (via rowChanged()) and when the row before changes (either by rowChanged() on the previous row, or when the previous row becomes a different row). It is also called for all rows when invalidateHeaders() is called.
	/// - Parameter row: The row whose header should be modified. If a compatible swiftObj has been set, that will be provided.
	/// - Parameter before: The row immediately before row. If a compatible swiftObj has been set, that will be provided.
	public func onUpdateHeader(_ handler: @escaping ListBoxUpdateHeaderHandler) {
		let holder = DualClosureHolder(handler);
		let opaqueHolder = Unmanaged.passRetained(holder).toOpaque();
		self.setHeaderFunc(updateHeader: { (rowPointer, beforePointer, holderPointer) in
			if let rowPointer = rowPointer, let holderPointer = holderPointer {
				let holder = Unmanaged<ListBoxUpdateHeaderHandlerHolder>.fromOpaque(holderPointer).takeUnretainedValue();
				let rowRef = ListBoxRowRef(cPointer: rowPointer);
				let row = rowRef.swiftObj as? ListBoxRowProtocol ?? rowRef;
				var before: ListBoxRowProtocol?;
				if let beforePointer = beforePointer {
					let beforeRef = ListBoxRowRef(cPointer: beforePointer);
					before = beforeRef.swiftObj as? ListBoxRowProtocol ?? beforeRef;
				} else {
					before = nil;
				}
				holder.call(row, before);
			}
		}, userData: opaqueHolder) { (holderPointer) in
			if let holderPointer = holderPointer {
				Unmanaged<ListBoxUpdateHeaderHandlerHolder>.fromOpaque(holderPointer).release();
			}
		}
	}
	
	public func onUpdateHeader<T: ListBoxRowProtocol>(_ handler: @escaping (T, T?) -> Void, as type: T.Type) {
		self.onUpdateHeader { (row, before) in
			if let row = row as? T {
				handler(row, before as? T);
			}
		}
	}
		
}

// MARK:- Signal handlers

public typealias RowHandler = (ListBoxProtocol, ListBoxRowProtocol) -> Void;

public typealias RowHandlerHolder = DualClosureHolder<ListBoxProtocol, ListBoxRowProtocol, Void>;

public typealias OptionalRowHandler = (ListBoxProtocol, ListBoxRowProtocol?) -> Void;

public typealias OptionalRowHandlerHolder = DualClosureHolder<ListBoxProtocol, ListBoxRowProtocol?, Void>;

public typealias BoxHandler = (ListBoxProtocol) -> Void;

public typealias BoxHandlerHolder = ClosureHolder<ListBoxProtocol, Void>;

public extension ListBoxProtocol {
	
	internal func _connect(signal name: UnsafePointer<gchar>, flags: ConnectFlags, data: RowHandlerHolder, handler: @convention(c) @escaping (gpointer, gpointer, gpointer) -> Void) -> Int {
		let opaqueHolder = Unmanaged.passRetained(data).toOpaque();
		let callback = unsafeBitCast(handler, to: GLibObject.Callback.self);
		return signalConnectData(detailedSignal: name, cHandler: callback, data: opaqueHolder, destroyData: { (holderPointer, _) in
			if let holderPointer = holderPointer {
				let holder = Unmanaged<RowHandlerHolder>.fromOpaque(holderPointer);
				holder.release();
			}
		}, connectFlags: flags);
	}
	
	public func connectRow(name: UnsafePointer<gchar>, flags: ConnectFlags = ConnectFlags(0), handler: @escaping RowHandler) -> Int {
		// The handler is stored in a holder, which is stored as a user data object with the signal.
		return _connect(signal: name, flags: flags, data: DualClosureHolder(handler)) { (boxPointer, rowPointer, holderPointer) in
			let holder = Unmanaged<RowHandlerHolder>.fromOpaque(holderPointer).takeUnretainedValue();
			let box = swiftRepresentation(of: ListBoxRef(raw: boxPointer));
			let rowRef = ListBoxRowRef(raw: rowPointer);
			let row = swiftRepresentation(of: ListBoxRowRef(raw: rowPointer));
			holder.call(box, row);
		}
	}
	
	internal func _connect(signal name: UnsafePointer<gchar>, flags: ConnectFlags, data: OptionalRowHandlerHolder, handler: @convention(c) @escaping (gpointer, gpointer?, gpointer) -> Void) -> Int {
		let opaqueHolder = Unmanaged.passRetained(data).toOpaque();
		let callback = unsafeBitCast(handler, to: GLibObject.Callback.self);
		return signalConnectData(detailedSignal: name, cHandler: callback, data: opaqueHolder, destroyData: { (holderPointer, _) in
			if let holderPointer = holderPointer {
				let holder = Unmanaged<OptionalRowHandlerHolder>.fromOpaque(holderPointer);
				holder.release();
			}
		}, connectFlags: flags);
	}
	
	public func connectRow(name: UnsafePointer<gchar>, flags: ConnectFlags = ConnectFlags(0), handler: @escaping OptionalRowHandler) -> Int {
		// The handler is stored in a holder, which is stored as a user data object with the signal.
		return _connect(signal: name, flags: flags, data: DualClosureHolder(handler)) { (boxPointer, rowPointer, holderPointer) in
			let holder = Unmanaged<OptionalRowHandlerHolder>.fromOpaque(holderPointer).takeUnretainedValue();
			let box = swiftRepresentation(of: ListBoxRef(raw: boxPointer));
			var row: ListBoxRowProtocol? = nil;
			if let rowPointer = rowPointer {
				row = swiftRepresentation(of: ListBoxRowRef(raw: rowPointer));
			}
			holder.call(box, row);
		}
	}
	
	internal func _connect(signal name: UnsafePointer<gchar>, flags: ConnectFlags, data: BoxHandlerHolder, handler: @convention(c) @escaping (gpointer, gpointer) -> Void) -> Int {
		let opaqueHolder = Unmanaged.passRetained(data).toOpaque();
		let callback = unsafeBitCast(handler, to: GLibObject.Callback.self);
		return signalConnectData(detailedSignal: name, cHandler: callback, data: opaqueHolder, destroyData: { (holderPointer, _) in
			if let holderPointer = holderPointer {
				let holder = Unmanaged<BoxHandlerHolder>.fromOpaque(holderPointer);
				holder.release();
			}
		}, connectFlags: flags);
	}
	
	public func connectBox(name: UnsafePointer<gchar>, flags: ConnectFlags = ConnectFlags(0), handler: @escaping BoxHandler) -> Int {
		// The handler is stored in a holder, which is stored as a user data object with the signal.
		return _connect(signal: name, flags: flags, data: ClosureHolder(handler)) { (boxPointer, holderPointer) in
			let holder = Unmanaged<BoxHandlerHolder>.fromOpaque(holderPointer).takeUnretainedValue();
			let box = swiftRepresentation(of: ListBoxRef(raw: holderPointer));
			holder.call(box);
		}
	}
	
	/// The row-activated signal is emitted when a row has been activated by the user.
	/// - Parameter box: The box on which the row has been activated. If a compatible swiftObj has been assigned, that will be returned.
	/// - Parameter row: The row that was activated. If a compatible swiftObj has been assigned, that will be returned.
	public func onActivateRow(_ handler: @escaping RowHandler) -> Int {
		return self.connectRow(name: ListBoxSignalName.rowActivated.rawValue, handler: handler);
	}
	
	/// The row-selected signal is emitted when a new row is selected, or (with a NULL row ) when the selection is cleared.
	/// When the box is using GTK_SELECTION_MULTIPLE, this signal will not give you the full picture of selection changes, and you should use the “selected-rows-changed” signal instead.
	/// - Parameter box: The box on which rows have been selected. If a compatible swiftObj has been assigned, that will be returned.
	/// - Parameter row: The row that was selected, or nil if a selection has been cleared.
	public func onRowSelected(_ handler: @escaping OptionalRowHandler) -> Int {
		return self.connectRow(name: ListBoxSignalName.rowSelected.rawValue, handler: handler);
	}
	
	/// The selected-rows-changed signal is emitted when the set of selected rows changes.
	/// - Parameter box: The box on which the selected rows have changed. If a compatible swiftObj has been assigned, that will be returned.
	public func onSelectedRowsChanged(_ handler: @escaping BoxHandler) -> Int {
		return self.connectBox(name: ListBoxSignalName.selectedRowsChanged.rawValue, handler: handler);
	}
}

public extension ListBoxRowProtocol {
	
	/// Ensures this row has no header.
	public func clearHeader() {
		gtk_list_box_row_set_header(self.list_box_row_ptr, nil);
	}
	
}
