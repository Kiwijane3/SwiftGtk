//
//  Stack.swift
//  GtkMvc
//
//  Created by Jane Fraser on 21/10/20.
//

import Foundation
import GLibObject
import Gtk

public enum StackChildProperty: String, PropertyNameProtocol {
	case iconName = "iConcon-name"
	case name = "name"
	case needsAttention = "needs-attention"
	case position = "position"
	case title = "title"
}

public extension StackProtocol {
	
	public func setIconName(_ iconName: String?, for child: WidgetProtocol) {
		self.set(child: WidgetRef(child.widget_ptr), property: StackChildProperty.iconName, value: iconName);
	}
	
	public func setPosition(_ position: Int, for child: WidgetProtocol) {
		self.set(child: WidgetRef(child.widget_ptr), property: StackChildProperty.position, value: position);
	}
	
	public func setTitle(_ title: String?, for child: WidgetProtocol) {
		self.set(child: WidgetRef(child.widget_ptr), property: StackChildProperty.title, value: title);
	}
	
	public func setName(_ name: String?, for child: WidgetProtocol) {
		self.set(child: WidgetRef(child.widget_ptr), property: StackChildProperty.name, value: name);
	}
	
}
