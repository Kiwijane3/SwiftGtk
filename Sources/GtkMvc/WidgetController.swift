//
//  WidgetController.swift
//  Atk
//
//  Created by Jane Fraser on 19/10/20.
//

import Foundation
import Gtk
import CGtk

public class WidgetController {
	
	public init() {
		
	}
	
	// MARK: Widgets
	
	private var _widget: WidgetProtocol?;
	
	/// The root widget for the controller.
	public var widget: WidgetProtocol {
		get {
			if let _widget = _widget {
				return _widget;
			} else {
				loadWidget();
				return _widget!;
			}
		}
		set {
			_widget = newValue;
		}
	}
	
	/// Returns whether the widget has been loaded into the controller.
	public var isWidgetLoaded: Bool {
		get {
			return _widget != nil;
		}
	}
	
	/// Loads the widget for the the controller
	public func loadWidget() {
		widget = Grid();
	}
	
	/// Called once the widget has been loaded. This can be used to perform additional setup after loading the widget, particularly when it is automated, such as when the widget is laoded from Glade.
	public func widgetDidLoad() {
		// NOOP
	}
	
	/// Loads the widget if it has been previously loaded.
	public final func loadWidgetIfNeeded() {
		if !isWidgetLoaded {
			loadWidget();
		}
	}
	
	public final func root<T: Widget>(as type: T.Type) -> T! {
		loadWidgetIfNeeded();
		return T.init(retainingRaw: widget.ptr);
	}
	
	public final func subWidget<T: Widget>(named name: String, as type: T.Type) -> T! {
		loadWidgetIfNeeded();
		if widget.name == name {
			return T.init(retainingRaw: widget.ptr);
		}
		guard objectIs(widget.object_ptr, a: gtk_container_get_type()) else {
			return nil;
		}
		return ContainerRef(raw: widget.ptr).child(named: name)
	}
	
	// MARK:- Presentation
	
	/// Present the controller in a main context, such as as the current controller in a NavigationController, or in the centre controller in a PanedController.
	public func show(_ controller: WidgetController) {}
	
	/// Present the controller in a detail context, such as the left pane of a PanedController. This is a no-op for many controllers.
	public func showSecondaryViewController(_ controller: WidgetController) {}
	
	// Present the controller in a tertiary context, such as in the right pane of PanedController. This is a no-op more often than not.
	public func showTertiaryViewController(_ controller: WidgetController) {}
	
	/// Presents the controller modally, such as in a popup or popover. The display is controlled by the controller's ModalPresentation, if present; Otherwise, presentation is handled by the presenter.
	public func present(_ controller: WidgetController) {}
	
	private var _presentation: ModalPresentation?;
	
	/// The ModalPresentation used to display this controller.
	public var presentation: ModalPresentation {
		get {
			if let _presentation = _presentation {
				return _presentation;
			} else {
				let presentation = ModalPresentation();
				_presentation = presentation;
				return presentation;
			}
		}
	}
	
	/// Dismisses the currently shown/presented controller, if applicable. One controller is dismissed on each call, with modally presented controllers taking priority, followed by main children if the controller can dismiss them. If no controllers can be dismissed, then the call is propagated to the parent, so child controllers can dismiss themselves.
	public func dismiss() {
		if dismissModal() {
			return;
		}
		if dismissMainChild() {
			return;
		}
		parent?.dismiss();
	}
		
	/// Dismisses the modal controller, if there is one. Returns whether the dismissal process should be terminated; Generally, this will be true if a controller has been dismissed.
	public func dismissModal() -> Bool {
		// TODO:- Implement modal dismissal.
		return false;
	}
	
	/// Dismisses the main child, if one exists and the controller is capable of dismissing it. Returns whether the dismissal process should be terminated; Generally, this will be true if a controller has been dismissed.
	public func dismissMainChild() -> Bool {
		// By default, controllers cannot dismiss their non-modal children.
		return false;
	}
	
	// MARK:- Controller Hierarchy
	
	/// The main child of this controller. For most controllers, this is just self. For container controllers, it is the most prominent child, such as the currently displayed child of a NavigationController, or the Central child of a PanedController.
	public var mainChild: WidgetController? {
		get {
			return self;
		}
	}
	
	/// The secondary child of this controller, if any.
	public var secondaryChild: WidgetController?;
	
	/// The secondary child of this controller, if any.
	public var tertiaryChild: WidgetController?;
	
	/// The controller currently being modally presented by this controller.
	public var modallyPresented: WidgetController?;
	
	/// The direct ancestor of this controller.
	public var parent: WidgetController?;
	
	/// All of the children of this controller.
	public var children: [WidgetController] = [];
	
	/// Adds the controller as a child.
	public func addChild(_ controller: WidgetController) {
		children.append(controller);
		controller.parent = self;
	}
	
	/// Called when the controller's widget is installed in the widget of its parent.
	public func installedIn(_ controller: WidgetController) {}
	
	/// Called when the controller is removed from its parent.
	public func removeFromParent() {}
	
	/// When a container controller updates its main child, such as when a navigation controller pushes or pops a controller, it should call mainUpdated() on its parent so it can perform any updates, which should propagate it to its parents until it reaches the root controller. This method is used to propagate headerbarItem updates to window controllers.
	public func mainUpdated() {
		parent?.mainUpdated();
	}
	
	// MARK:- Items for container controllers
	
	/// The HeaderbarItem to be displayed from this controller.
	public var headerbarItem: HeaderbarItem = HeaderbarItem();
	
	/// The headerbar supplier for this controller. This is usually the headerBar item, but container controllers may supply a wrapper for their main child's item in order to their own controls, like back buttons or stack switchers.
	public var headerbarSupplier: HeaderbarSupplier {
		get {
			return headerbarItem;
		}
	}
	
	public var tabItem: TabItem = TabItem();
	
}
