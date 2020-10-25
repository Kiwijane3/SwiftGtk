//
//  FlowBox.swift
//  Gtk
//
//  Created by Jane Fraser on 14/10/20.
//

import Foundation
import GIO
import GLibObject
import CGtk


public extension FlowBoxProtocol {
	
	/**public func _bind<B: GIO.ListModelProtocol, T: AnyObject>(to model: Model<B, T>, using creator: @escaping CreateWidgetHandler) {
		let holder = ClosureHolder(creator);
		let opaqueHolder = Unmanaged<ClosureHolder>.passRetained(holder).toOpaque();
		self.bind(model: model.model, createWidgetFunc: { (itemPointer, holderPointer) -> UnsafeMutablePointer<GtkWidget>? in
			if let itemPointer = itemPointer, let holderPointer = holderPointer {
				let holder = Unmanaged<CreateWidgetHandlerHolder>.fromOpaque(holderPointer).takeUnretainedValue();
				let item = Object(raw: itemPointer) as! AnyObject;
				let widget = holder.call(item);
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
	
	public func bind<B: GIO.ListModelProtocol, T: AnyObject>(to model: Model<B, T>, using creator: @escaping (T) -> Widget) {
		self._bind(to: model) { (item) -> Widget in
			return creator(item as! T);
		}
	} */
	
}

public typealias ChildHandler = (FlowBoxProtocol, FlowBoxChildProtocol) -> Void;

public typealias ChildHandlerHolder = DualClosureHolder<FlowBoxProtocol, FlowBoxChildProtocol, Void>;

public typealias FlowBoxHandler = (FlowBoxProtocol) -> Void;

public typealias FlowBoxHandlerHolder = ClosureHolder<FlowBoxProtocol, Void>;

public extension FlowBoxProtocol {
	
	@usableFromInline internal func _connectChild(signal name: UnsafePointer<gchar>, flags: ConnectFlags, data: ChildHandlerHolder, handler: @convention(c) @escaping (gpointer, gpointer, gpointer) -> Void) -> Int {
		let opaqueHolder = Unmanaged.passRetained(data).toOpaque();
		let callback = unsafeBitCast(handler, to: GCallback.self);
		return signalConnectData(detailedSignal: name, cHandler: callback, destroyData: { (holderPointer, _) in
			if let holderPointer = holderPointer {
				Unmanaged<ChildHandlerHolder>.fromOpaque(holderPointer).release();
			}
		}, connectFlags: flags);
	}
	
	@discardableResult
	@inlinable func connectChild(signal name: UnsafePointer<gchar>, flags f : ConnectFlags = ConnectFlags(0), handler: @escaping ChildHandler) -> Int {
		let holder = ChildHandlerHolder(handler);
		return _connectChild(signal: name, flags: f, data: holder) { (boxPointer, rowPointer, holderPointer) in
			let holder = Unmanaged<ChildHandlerHolder>.fromOpaque(holderPointer).takeUnretainedValue();
			let box = swiftRepresentation(of: FlowBoxRef(raw: boxPointer));
			let row = swiftRepresentation(of: FlowBoxChildRef(raw: rowPointer));
			holder.call(box, row);
		}
	}
	
	public func onChildActivated(_ handler: @escaping ChildHandler) {
		self.connectChild(signal: FlowBoxSignalName.childActivated.rawValue, handler: handler);
	}
	
	public func onChildActivated<T: FlowBoxChildProtocol>(_ handler: @escaping ChildHandler, as type: T.Type) {
		self.onChildActivated { (box, row) in
			if let row = row as? T {
				handler(box, row);
			}
		}
	}
	
	@usableFromInline internal func _connect(signal name: UnsafePointer<gchar>, flags: ConnectFlags, data: FlowBoxHandlerHolder, handler: @convention(c) @escaping(gpointer, gpointer) -> Void) -> Int {
		let opaqueHolder = Unmanaged.passRetained(data).toOpaque();
		let callback = unsafeBitCast(handler, to: GCallback.self);
		return signalConnectData(detailedSignal: name, cHandler: callback, data: opaqueHolder, destroyData: { (holderPointer, _) in
			if let holderPointer = holderPointer {
				Unmanaged<FlowBoxHandlerHolder>.fromOpaque(holderPointer).release();
			}
		}, connectFlags: flags);
	}
	
	@discardableResult @inlinable func connect(signal name: UnsafePointer<gchar>, flags f: ConnectFlags = ConnectFlags(0), handler: @escaping FlowBoxHandler) -> Int {
		let holder = FlowBoxHandlerHolder(handler);
		return _connect(signal: name, flags: f, data: holder) { (boxPointer, holderPointer) in
			let holder = Unmanaged<FlowBoxHandlerHolder>.fromOpaque(holderPointer).takeUnretainedValue();
			let box = swiftRepresentation(of: FlowBoxRef(raw: boxPointer));
			holder.call(box);
		}
	}
	
	public func onSelectionChanged(_ handler: @escaping FlowBoxHandler) {
		self.connect(signal: FlowBoxSignalName.selectedChildrenChanged.rawValue, handler: handler);
	}
	
}
