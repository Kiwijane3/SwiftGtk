//
//  GObject.swift
//  Gtk
//
//  Created by Jane Fraser on 4/04/20.
//

import Foundation
import GLibObject

public let swiftObjKey = "swiftobj";

public extension GLibObject.ObjectProtocol {
	
	// The primary swift object that handles the underlying GObject. Can be used to get the relevant swift object for a c-provided gobject, such as in a listbox filter function. Needs to be set manually at present. May not exist.
	public var swiftObj: Any? {
		get {
			let pointer = getData(key: swiftObjKey);
			if pointer != nil {
				return Unmanaged<AnyObject>.fromOpaque(pointer!).takeUnretainedValue();
			} else {
				return nil;
			}
		}
		nonmutating set {
			if let selfObj = newValue as? AnyObject {
				setData(key: swiftObjKey, data: Unmanaged.passUnretained(selfObj).toOpaque());
			}
		}
	}
	
	// Will set this swift instance to be the swiftObj if it does not already have one. Can be used in situations where you want to ensure a swiftObj exists, but do not want to override a pre-exsting swiftobj; i.e, in a constructor.
	public func becomeSwiftObjIfInitial() {
		if swiftObj == nil {
			swiftObj = self;
		}
	}
	
}
