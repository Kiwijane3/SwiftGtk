//
//  Model.swift
//  Gtk
//
//  Created by Jane Fraser on 13/10/20.
//

import Foundation
import CGLib
import GLibObject
import GIO

// Model is a wrapper for GListModel that provides
public class Model<B: GIO.ListModelProtocol, T> {
	
	public var model: B;
	
	public var count: Int {
		get {
			return model.nItems;
		}
	}
	
	public init(model: B) {
		self.model = model;
	}
	
}

// Store bridges to ListStore in order to provide swift generics.
public class Store<T: Any>: Model<GIO.ListStore, T> {
	
	public init() {
		super.init(model: GIO.ListStore(itemType: .object));
	}
	
	public init(content: [T]) {
		super.init(model: GIO.ListStore(itemType: .object));
		self.append(content);
	}
	
	public subscript(_ position: Int) -> T {
		get {
			let wrapper = swiftObj(fromRaw: model.getItem(position: position)) as! Wrapper;
			return wrapper.value as! T;
		}
	}
	
	public func insert(_ item: T, at position: Int) {
		model.insert(position: position, item: Wrapper(value: item));
	}
	
	public func _insert(_ item: Object, handler: @escaping SortHandler) {
		let holder = DualClosureHolder(handler);
		let opaqueHolder = Unmanaged<SortHandlerHolder>.passUnretained(holder).toOpaque();
		model.insertSorted(item: Wrapper(value: item), compareFunc: { (aPointer, bPointer, holderPointer) -> gint in
			if let aPointer = aPointer, let bPointer = bPointer, let holderPointer = holderPointer {
				let holder = Unmanaged<SortHandlerHolder>.fromOpaque(holderPointer).takeUnretainedValue();
				let a = Object(raw: aPointer).swiftObj as! AnyObject;
				let b = Object(raw: bPointer).swiftObj as! AnyObject;
				return holder.call(a, b);
			} else {
				return 0;
			}
		}, userData: opaqueHolder);
	}
	
	public func append(_ items: [T]) {
		splice(at: model.nItems, removing: 0, adding: items);
	}
	
	public func remove(at position: Int) {
		model.remove(position: position);
	}
	
	public func remove(where handler: @escaping (T) -> Bool) {
		var i = 0;
		while i < count {
			if handler(self[i]) {
				model.remove(position: i);
			} else {
				i += 1;
			}
		}
	}
	 
	public func removeAll() {
		model.removeAll()
	}
	
	public func replace(with content: [T]) {
		self.removeAll();
		self.append(content);
	}
	
	public func splice(at position: Int, removing removals: Int, adding additions: [T]) {
		let additionWrappers = additions.map { (item) -> Object in
			return Wrapper(value: item);
		}
		var additionPointers = additionWrappers.map { (wrapper) -> gpointer? in
			return wrapper.ptr;
		}
		model.splice(position: position, nRemovals: removals, additions: &additionPointers, nAdditions: additions.count);
	}
	
}

public typealias SortHandler = (AnyObject, AnyObject) -> Int32;

public typealias SortHandlerHolder = DualClosureHolder<AnyObject, AnyObject, Int32>;

internal class Wrapper: GLibObject.Object {
	
	internal var value: Any!;
	
	internal init(value: Any) {
		self.value = value;
		super.init(g_object_new_with_properties(g_object_get_type(), 0, nil, nil));
		becomeSwiftObjIfInitial();
	}
	
	internal required init(retainingRaw raw: UnsafeMutableRawPointer) {
		super.init(retainingRaw: raw);
	}
	
}
