//
//  GObject.swift
//  Gtk
//
//  Created by Jane Fraser on 4/04/20.
//

import Foundation
import GLibObject
import GObjectCHelpers

public let swiftObjKey = "swiftobj";

public let gtrue: gboolean = 1;

public let gfalse: gboolean = 0;

public extension GLibObject.ObjectProtocol {
	
	// The primary swift object that handles the underlying GObject. Can be used to get the relevant swift object for a c-provided gobject, such as in a listbox filter function. Needs to be set manually at present. May not exist.
	public var swiftObj: AnyObject? {
		get {
			let pointer = getData(key: swiftObjKey);
			if pointer != nil {
				return Unmanaged<AnyObject>.fromOpaque(pointer!).takeUnretainedValue();
			} else {
				return nil;
			}
		}
		nonmutating set {
			// Setting swift object to the already existing swiftObj is a no-op, in order to avoid duplicate toggleRefs, which never fire and thus cause reference cycles.
			guard let newValue = newValue, newValue !== swiftObj else {
				return
			}
			// Get a strong pointer to swiftObj
			let pointer = Unmanaged<AnyObject>.passRetained(newValue).toOpaque();
			setData(key: swiftObjKey, data: pointer);
			// In the majority of cases, swiftObj will be the swift wrapper for this gobject's c implementation. To prevent orphaning, these should be equivalent for memory management purposes; If one is referenced, the other is referenced. A naive way to implement this is to have both strongly reference each other, but this creates a strong reference cycle. Therefore, the wrapper has a strong toggle reference to the gobject, which tells us when there are other references. In this instance, the wrapper should be referenced, so the gobject strongly references it. Otherwise, the gobject weakly references it, allowing it, and thus the gobject, to be released once it is not referenced in swift-space.
			addToggleRef { (_, selfPointer, lastRef) in
				let swiftObjPointer = Unmanaged<AnyObject>.fromOpaque(g_object_get_data(selfPointer, swiftObjKey));
				switch lastRef {
				case gfalse:
					// Make the gobject strongly reference the wrapper.
					swiftObjPointer.retain();
				case gtrue:
					// Make the gobject weakly reference the wrapper.
					swiftObjPointer.release();
				default:
					break;
				}
			}
			// Release the regular reference so we don't have two references from the wrapper.
			unref();
		}
	}
	
}

public extension GLibObject.Object {
	
	// Will set this swift instance to be the swiftObj if it does not already have one. Can be used in situations where you want to ensure a swiftObj exists, but do not want to override a pre-exsting swiftobj; i.e, in a constructor.
	public func becomeSwiftObjIfInitial() {
		if swiftObj == nil {
			swiftObj = self;
		}
	}
	
}

public func swiftObj(fromRaw raw: UnsafeMutableRawPointer) -> AnyObject? {
	let objPointer = g_object_get_data(raw.assumingMemoryBound(to: GObject.self), swiftObjKey);
	if let objPointer = objPointer {
		return Unmanaged<AnyObject>.fromOpaque(objPointer).takeUnretainedValue();
	} else {
		return nil;
	}
}

// Gives the best representation of a gobject for presenting to swift code. Returns the object's swiftObj if it exists and is of a compatible type, otherwise returns the provided represenation.
public func swiftRepresentation<T: GLibObject.ObjectProtocol>(of gobject: T) -> T {
	if let swiftObj = gobject.swiftObj as? T {
		return swiftObj;
	} else {
		return gobject;
	}
}

public extension GLibObject.ObjectProtocol {
	
	public func getType() -> GType {
		object_ptr.pointee.g_type_instance.g_class.pointee.g_type
	}
	
}

public func resolveType(of ptr: UnsafeMutablePointer<GObject>!) -> GType {
	return ptr.pointee.g_type_instance.g_class.pointee.g_type;
}

public func objectIs(_ ptr: UnsafeMutablePointer<GObject>!, a type: GType) -> Bool {
	return g_type_is_a(resolveType(of: ptr), type) != 0;
}

/// Generates a reference-counted object representation of the given class from the given pointer. This will be swiftObj if available, otherwise it will be a new instance of the given class wrapping the pointer. This function assumes the pointer is of an appropriate type, so only use if you know the pointer is of an appropriate type.
public func objectRepresentation<T: GLibObject.Object>(from raw: UnsafeMutableRawPointer, as type: T.Type) -> T {
	if let swiftObj = swiftObj(fromRaw: raw) as? T {
		return swiftObj;
	} else {
		return T.init(retainingRaw: raw);
	}
}
