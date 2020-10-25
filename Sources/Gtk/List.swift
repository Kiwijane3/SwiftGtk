//
//  List.swift
//  GtkMvc
//
//  Created by Jane Fraser on 19/10/20.
//

import Foundation
import GLib
import CGLib

public extension ListProtocol {
	
	public func foreach(_ handler: (gpointer) -> Void) {
		var current = self._ptr
		while current != nil {
			handler(current!.pointee.data);
			current = current?.pointee.next;
		}
	}
	
}
