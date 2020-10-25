//
//  NavigationController.swift
//  GtkMvc
//
//  Created by Jane Fraser on 20/10/20.
//

import Foundation
import Gtk

public class NavigationController: WidgetController {
	
	public var stack: StackProtocol {
		get {
			return widget as! StackProtocol;
		}
	}
	
	public override var mainChild: WidgetController? {
		get {
			return children.last;
		}
	}
	
	public var mainIndex: Int {
		get {
			return children.count - 1;
		}
	}
	
	public var navigationHeaderSupplier: NavigationHeaderSupplier!;
	
	public override var headerbarSupplier: HeaderbarSupplier {
		get {
			return navigationHeaderSupplier;
		}
	}
	
	public init(withRoot rootController: WidgetController) {
		super.init();
		addChild(rootController);
		navigationHeaderSupplier = NavigationHeaderSupplier(for: self);
	}
	
	public override func loadWidget() {
		widget = Stack();
		for i in 0..<children.count {
			stack.addNamed(child: WidgetRef(children[i].widget.widget_ptr), name: "\(i)");
		}
		if mainIndex >= 0 {
			stack.setVisibleChildFull(name: "\(mainIndex)", transition: .none);
		}
		navigationHeaderSupplier.itemUpdated();
	}
	
	public override func show(_ controller: WidgetController) {
		push(controller);
	}
	
	public override func dismissMainChild() -> Bool {
		if children.count > 1 {
			pop();
			return true;
		} else {
			return false;
		}
	}
	
	public func push(_ controller: WidgetController) {
		addChild(controller);
		stack.addNamed(child: WidgetRef(mainChild!.widget.widget_ptr), name: "\(mainIndex)");
		stack.setVisibleChildFull(name: "\(mainIndex)", transition: .overLeft);
		mainChild?.installedIn(self);
		stack.showAll();
		mainUpdated();
	}
	
	public func pop() {
		if children.count > 1 {
			// Animate the transition.
			stack.setVisibleChildFull(name: "\(mainIndex - 1)", transition: .underRight);
			let removedController = children.popLast()!;
			stack.remove(widget: WidgetRef(removedController.widget.widget_ptr));
			removedController.removeFromParent();
			mainChild?.installedIn(self);
			stack.showAll();
			mainUpdated();
		}
	}
	
	public func setRoot(_ controller: WidgetController) {
		if !children.isEmpty {
			let oldRoot = children.remove(at: 0);
			stack.remove(widget: WidgetRef(oldRoot.widget.widget_ptr));
			oldRoot.removeFromParent();
		}
		addChild(controller);
		stack.addNamed(child: WidgetRef(mainChild?.widget.widget_ptr), name: "\(mainIndex)");
		stack.setVisibleChildFull(name: "\(mainIndex)", transition: .none);
		stack.showAll();
		mainUpdated();
	}
	
	public override func mainUpdated() {
		navigationHeaderSupplier.itemUpdated();
		parent?.mainUpdated();
	}
	
}

/// The NavigationHeaderSupplier wraps the HeaderBarItem of the NavigationController's main child in order to provide a back button.
public class NavigationHeaderSupplier: HeaderbarSupplier {
	
	public unowned var navigationController: NavigationController;
	
	public var item: HeaderbarItem?;
	
	public let backButtonItem: BarButtonItem;
	
	public var showsBackButton: Bool {
		get {
			if let item = item {
				return navigationController.children.count > 1 && item.showsBackButton;
			} else {
				return false
			}
		}
	}
	
	public var title: String? {
		get {
			return item?.title;
		}
	}
	
	public var subtitle: String? {
		get {
			return item?.subtitle;
		}
	}
	
	public var titleView: Widget? {
		get {
			return item?.titleView;
		}
	}
	
	public var startItemCount: Int {
		if let item = item {
			if showsBackButton {
				return item.startItemCount + 1;
			} else {
				return item.startItemCount
			}
		} else {
			return 0;
		}
	}
	
	public var endItemCount: Int {
		item?.endItemCount ?? 0;
	}
	
	public var onUpdate: ((HeaderField) -> Void)?
	
	public init(for navigationController: NavigationController) {
		self.navigationController = navigationController;
		backButtonItem = BarButtonItem();
		backButtonItem.onClick = { [weak self] (_) in
			self?.navigationController.pop();
		}
	}
	
	public func itemUpdated() {
		item?.onUpdate = nil;
		item = navigationController.mainChild?.headerbarItem;
		item?.onUpdate = { [weak self] (field) in
			switch field {
			case .showsBackButton:
				self?.onUpdate?(.startItems);
			default:
				self?.onUpdate?(field);
			}
		}
		// Set the back button item to display the title of the second to last view controller, which will be navigated to on back.
		if navigationController.children.count > 1 {
			let backController = navigationController.children[navigationController.children.count - 1];
			backButtonItem.title = backController.headerbarItem.title;
		} else {
			backButtonItem.title = nil;
		}
	}
	
	public func startItem(at index: Int) -> BarItem {
		if showsBackButton {
			if index == 0 {
				return backButtonItem;
			} else {
				return item!.startItem(at: index - 1);
			}
		} else {
			return item!.startItem(at: index);
		}
	}
	
	public func endItem(at index: Int) -> BarItem {
		return item!.endItem(at: index);
	}
	
}
