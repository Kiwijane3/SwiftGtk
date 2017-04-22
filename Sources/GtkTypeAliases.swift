import CGtk

// Private structs not exported but needed for public pointers
public typealias GtkArrowAccessiblePrivate = _GtkArrowAccessiblePrivate
public typealias GtkBooleanCellAccessiblePrivate = _GtkBooleanCellAccessiblePrivate
public typealias GtkButtonAccessiblePrivate = _GtkButtonAccessiblePrivate
public typealias GtkCellAccessibleParent = _GtkCellAccessibleParent
public typealias GtkCellAccessiblePrivate = _GtkCellAccessiblePrivate
public typealias GtkCheckMenuItemAccessiblePrivate = _GtkCheckMenuItemAccessiblePrivate
public typealias GtkComboBoxAccessible = _GtkComboBoxAccessible
public typealias GtkComboBoxAccessibleClass = _GtkComboBoxAccessibleClass
public typealias GtkComboBoxAccessiblePrivate = _GtkComboBoxAccessiblePrivate
public typealias GtkContainerAccessiblePrivate = _GtkContainerAccessiblePrivate
public typealias GtkContainerCellAccessible = _GtkContainerCellAccessible
public typealias GtkContainerCellAccessibleClass = _GtkContainerCellAccessibleClass
public typealias GtkContainerCellAccessiblePrivate = _GtkContainerCellAccessiblePrivate
public typealias GtkEntryAccessible = _GtkEntryAccessible
public typealias GtkEntryAccessibleClass = _GtkEntryAccessibleClass
public typealias GtkEntryAccessiblePrivate = _GtkEntryAccessiblePrivate
public typealias GtkEntryIconAccessible = _GtkEntryIconAccessible
public typealias GtkExpanderAccessible = _GtkExpanderAccessible
public typealias GtkExpanderAccessibleClass = _GtkExpanderAccessibleClass
public typealias GtkExpanderAccessiblePrivate = _GtkExpanderAccessiblePrivate
public typealias GtkFlowBoxAccessible = _GtkFlowBoxAccessible
public typealias GtkFlowBoxAccessibleClass = _GtkFlowBoxAccessibleClass
public typealias GtkFlowBoxAccessiblePrivate = _GtkFlowBoxAccessiblePrivate
public typealias GtkFlowBoxChildAccessible = _GtkFlowBoxChildAccessible
public typealias GtkFlowBoxChildAccessibleClass = _GtkFlowBoxChildAccessibleClass
public typealias GtkFrameAccessible = _GtkFrameAccessible
public typealias GtkFrameAccessibleClass = _GtkFrameAccessibleClass
public typealias GtkFrameAccessiblePrivate = _GtkFrameAccessiblePrivate
public typealias GtkIconViewAccessible = _GtkIconViewAccessible
public typealias GtkIconViewAccessibleClass = _GtkIconViewAccessibleClass
public typealias GtkIconViewAccessiblePrivate = _GtkIconViewAccessiblePrivate
public typealias GtkImageAccessible = _GtkImageAccessible
public typealias GtkImageAccessibleClass = _GtkImageAccessibleClass
public typealias GtkImageAccessiblePrivate = _GtkImageAccessiblePrivate
public typealias GtkImageCellAccessible = _GtkImageCellAccessible
public typealias GtkImageCellAccessibleClass = _GtkImageCellAccessibleClass
public typealias GtkImageCellAccessiblePrivate = _GtkImageCellAccessiblePrivate
public typealias GtkLabelAccessible = _GtkLabelAccessible
public typealias GtkLabelAccessibleClass = _GtkLabelAccessibleClass
public typealias GtkLabelAccessiblePrivate = _GtkLabelAccessiblePrivate
public typealias GtkLevelBarAccessible = _GtkLevelBarAccessible
public typealias GtkLevelBarAccessibleClass = _GtkLevelBarAccessibleClass
public typealias GtkLevelBarAccessiblePrivate = _GtkLevelBarAccessiblePrivate
public typealias GtkLinkButtonAccessible = _GtkLinkButtonAccessible
public typealias GtkLinkButtonAccessibleClass = _GtkLinkButtonAccessibleClass
public typealias GtkLinkButtonAccessiblePrivate = _GtkLinkButtonAccessiblePrivate
public typealias GtkListBoxAccessible = _GtkListBoxAccessible
public typealias GtkListBoxAccessibleClass = _GtkListBoxAccessibleClass
public typealias GtkListBoxAccessiblePrivate = _GtkListBoxAccessiblePrivate
public typealias GtkListBoxRowAccessible = _GtkListBoxRowAccessible
public typealias GtkListBoxRowAccessibleClass = _GtkListBoxRowAccessibleClass
public typealias GtkLockButtonAccessible = _GtkLockButtonAccessible
public typealias GtkLockButtonAccessibleClass = _GtkLockButtonAccessibleClass
public typealias GtkLockButtonAccessiblePrivate = _GtkLockButtonAccessiblePrivate
public typealias GtkMenuAccessible = _GtkMenuAccessible
public typealias GtkMenuAccessibleClass = _GtkMenuAccessibleClass
public typealias GtkMenuAccessiblePrivate = _GtkMenuAccessiblePrivate
public typealias GtkMenuButtonAccessible = _GtkMenuButtonAccessible
public typealias GtkMenuButtonAccessibleClass = _GtkMenuButtonAccessibleClass
public typealias GtkMenuButtonAccessiblePrivate = _GtkMenuButtonAccessiblePrivate
public typealias GtkMenuItemAccessiblePrivate = _GtkMenuItemAccessiblePrivate
public typealias GtkMenuShellAccessible = _GtkMenuShellAccessible
public typealias GtkMenuShellAccessibleClass = _GtkMenuShellAccessibleClass
public typealias GtkMenuShellAccessiblePrivate = _GtkMenuShellAccessiblePrivate
public typealias GtkNotebookAccessible = _GtkNotebookAccessible
public typealias GtkNotebookAccessibleClass = _GtkNotebookAccessibleClass
public typealias GtkNotebookAccessiblePrivate = _GtkNotebookAccessiblePrivate
public typealias GtkNotebookPageAccessible = _GtkNotebookPageAccessible
public typealias GtkNotebookPageAccessibleClass = _GtkNotebookPageAccessibleClass
public typealias GtkNotebookPageAccessiblePrivate = _GtkNotebookPageAccessiblePrivate
public typealias GtkPanedAccessible = _GtkPanedAccessible
public typealias GtkPanedAccessibleClass = _GtkPanedAccessibleClass
public typealias GtkPanedAccessiblePrivate = _GtkPanedAccessiblePrivate
public typealias GtkPopoverAccessible = _GtkPopoverAccessible
public typealias GtkPopoverAccessibleClass = _GtkPopoverAccessibleClass
public typealias GtkProgressBarAccessible = _GtkProgressBarAccessible
public typealias GtkProgressBarAccessibleClass = _GtkProgressBarAccessibleClass
public typealias GtkProgressBarAccessiblePrivate = _GtkProgressBarAccessiblePrivate
public typealias GtkRadioButtonAccessible = _GtkRadioButtonAccessible
public typealias GtkRadioButtonAccessibleClass = _GtkRadioButtonAccessibleClass
public typealias GtkRadioButtonAccessiblePrivate = _GtkRadioButtonAccessiblePrivate
public typealias GtkRadioMenuItemAccessible = _GtkRadioMenuItemAccessible
public typealias GtkRadioMenuItemAccessibleClass = _GtkRadioMenuItemAccessibleClass
public typealias GtkRadioMenuItemAccessiblePrivate = _GtkRadioMenuItemAccessiblePrivate
public typealias GtkRangeAccessible = _GtkRangeAccessible
public typealias GtkRangeAccessibleClass = _GtkRangeAccessibleClass
public typealias GtkRangeAccessiblePrivate = _GtkRangeAccessiblePrivate
public typealias GtkRendererCellAccessiblePrivate = _GtkRendererCellAccessiblePrivate
public typealias GtkScaleAccessible = _GtkScaleAccessible
public typealias GtkScaleAccessibleClass = _GtkScaleAccessibleClass
public typealias GtkScaleAccessiblePrivate = _GtkScaleAccessiblePrivate
public typealias GtkScaleButtonAccessible = _GtkScaleButtonAccessible
public typealias GtkScaleButtonAccessibleClass = _GtkScaleButtonAccessibleClass
public typealias GtkScaleButtonAccessiblePrivate = _GtkScaleButtonAccessiblePrivate
public typealias GtkScrolledWindowAccessible = _GtkScrolledWindowAccessible
public typealias GtkScrolledWindowAccessibleClass = _GtkScrolledWindowAccessibleClass
public typealias GtkScrolledWindowAccessiblePrivate = _GtkScrolledWindowAccessiblePrivate
public typealias GtkSpinButtonAccessible = _GtkSpinButtonAccessible
public typealias GtkSpinButtonAccessibleClass = _GtkSpinButtonAccessibleClass
public typealias GtkSpinButtonAccessiblePrivate = _GtkSpinButtonAccessiblePrivate
public typealias GtkSpinnerAccessible = _GtkSpinnerAccessible
public typealias GtkSpinnerAccessibleClass = _GtkSpinnerAccessibleClass
public typealias GtkSpinnerAccessiblePrivate = _GtkSpinnerAccessiblePrivate
public typealias GtkStatusbarAccessible = _GtkStatusbarAccessible
public typealias GtkStatusbarAccessibleClass = _GtkStatusbarAccessibleClass
public typealias GtkStatusbarAccessiblePrivate = _GtkStatusbarAccessiblePrivate
public typealias GtkSwitchAccessible = _GtkSwitchAccessible
public typealias GtkSwitchAccessibleClass = _GtkSwitchAccessibleClass
public typealias GtkSwitchAccessiblePrivate = _GtkSwitchAccessiblePrivate
public typealias GtkTextCellAccessible = _GtkTextCellAccessible
public typealias GtkTextCellAccessibleClass = _GtkTextCellAccessibleClass
public typealias GtkTextCellAccessiblePrivate = _GtkTextCellAccessiblePrivate
public typealias GtkTextViewAccessible = _GtkTextViewAccessible
public typealias GtkTextViewAccessibleClass = _GtkTextViewAccessibleClass
public typealias GtkTextViewAccessiblePrivate = _GtkTextViewAccessiblePrivate
public typealias GtkThemingEnginePrivate = _GtkThemingEnginePrivate
public typealias GtkToggleButtonAccessible = _GtkToggleButtonAccessible
public typealias GtkToggleButtonAccessibleClass = _GtkToggleButtonAccessibleClass
public typealias GtkToggleButtonAccessiblePrivate = _GtkToggleButtonAccessiblePrivate
public typealias GtkToplevelAccessible = _GtkToplevelAccessible
public typealias GtkToplevelAccessibleClass = _GtkToplevelAccessibleClass
public typealias GtkToplevelAccessiblePrivate = _GtkToplevelAccessiblePrivate
public typealias GtkTreeViewAccessible = _GtkTreeViewAccessible
public typealias GtkTreeViewAccessibleClass = _GtkTreeViewAccessibleClass
public typealias GtkTreeViewAccessiblePrivate = _GtkTreeViewAccessiblePrivate
public typealias GtkWidgetAccessiblePrivate = _GtkWidgetAccessiblePrivate
public typealias GtkWindowAccessible = _GtkWindowAccessible
public typealias GtkWindowAccessibleClass = _GtkWindowAccessibleClass
public typealias GtkWindowAccessiblePrivate = _GtkWindowAccessiblePrivate

public typealias GtkCallback = @convention(c) (UnsafeMutablePointer<_GtkWidget>?, UnsafeMutableRawPointer?) -> ()

