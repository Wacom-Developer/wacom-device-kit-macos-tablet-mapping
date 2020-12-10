# Getting Started

## Test Environment
The Tablet Mapping sample project requires Xcode 10 or higher.

## Install the Wacom tablet driver and verify tablet operation
To test the application, a Wacom tablet driver must be installed and a supported Wacom tablet must be attached. All Wacom tablets supported by the Wacom driver are supported by this API. Get the driver that supports your device at: https://www.wacom.com/support/product-support/drivers.  

Once the driver has installed and you have rebooted your system, check your tablet driver installation by doing the following:

1. Attach a Wacom tablet.
1. Open Wacom Tablet in the System Preferences to determine if your tablet is recognized by the driver.
1. Use a tablet pen to see if you can move the system cursor.
1. If all of the above checks out, proceed to the next section to build/run the sample application.

## Build/run the sample application
To build the sample application:

1. Open the TabletControls.xcodeproj file in Xcode 10 or newer.
2. Select TabletControls in the files list and then select the Tablet Mapping target.
3. Change the bundle identifier and signing settings as appropriate for your development.
4. Press Xcode's Build and Run button.
5. Once running, use a tablet pen and observe the mouse and tablet events update.
5. Select Fun and then Constrain to Window from the menu. Use a tablet pen to observe the tablet mapping has changed to the area of the sample application's window.

<a name="dri-see-also"></a>
## See Also  

The Driver Interface Request developer documentation has complete API details:

[Driver Request Interface - Basics](https://developer-docs.wacom.com/intuos-cintiq-business-tablets/docs/dri-basics)

[Driver Request Interface - Reference](https://developer-docs.wacom.com/intuos-cintiq-business-tablets/docs/dri-reference)

[Driver Request Interface - FAQs](https://developer-docs.wacom.com/intuos-cintiq-business-tablets/docs/dri-faqs)


## Where to get help
If you have questions about the sample application or any of the setup process, please visit our Support page at: https://developer.wacom.com/developer-dashboard/support.