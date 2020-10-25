//
//  WindowController.swift
//  GtkMvc
//
//  Created by Jane Fraser on 19/10/20.
//

import Foundation
import Gtk

public class WindowController: HeaderController {
	
	public var application: Application;
	
	public var hasHeaderbar: Bool = true;
	
	public var window: WindowProtocol {
		get {
			return widget as! WindowProtocol;
		}
	}
	
	public init(application: Application) {
		self.application = application;
		super.init();
	}
	
	public override func loadWidget() {
		widget = ApplicationWindow(application: application);
		// Install the headerbar if needed.
		if hasHeaderbar {
			window.set(titlebar: headerBar);
		}
		widgetDidLoad();
	}
	
	public override func show(_ controller: WidgetController) {
		addChild(controller);
		window.add(widget: WidgetRef(controller.widget.widget_ptr));
		window.showAll();
		controller.installedIn(self);
		mainUpdated();
	}
	
	
	/// WindowController allows controllers to be shown over each other and dismissed, but will not dismiss its only child.
	public override func dismissMainChild() -> Bool {
		if children.count > 1 {
			let removedController = children.popLast()!;
			removedController.removeFromParent();
			let mainController = children.last!;
			window.add(widget: WidgetRef(mainController.widget.widget_ptr));
			mainController.installedIn(self);
			window.showAll();
			return true;
		} else {
			return false;
		}
	}
	
}
