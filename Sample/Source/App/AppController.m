// /////////////////////////////////////////////////////////////////////////////
//
// DESCRIPTION
//		Logs mouse and tablet events.
//
//		Also demonstrates various mapping tricks which may be performed by sending
//		Apple Events to the Wacom driver. These features are available in the
//		application's Fun menu.
//
//		When an application wishes to customize driver settings, it must open a
//		"context" in the driver to contain its custom settings. That context is then
//		active whenever the application is frontmost.
//
// COPYRIGHT
//    Copyright (c) 2010 - 2023 Wacom Co., Ltd.
//    All rights reserved
//
// /////////////////////////////////////////////////////////////////////////////

#import "AppController.h"
#import "WacomTabletDriver.h"

@implementation AppController

@synthesize lastUsedTablet;

// /////////////////////////////////////////////////////////////////////////////
// Initialize this object.

- (id) init
{
	self = [super init];
	
	lastUsedTablet   = 0;
	mContextID        = 0; // 0 is an invalid context number.
	mTabletOfContext  = 0;
	mMovesCursor      = YES;
	
	return self;
}

#pragma mark - ACTIONS -

// /////////////////////////////////////////////////////////////////////////////
// Tells the Wacom driver to turn cursor movement on or off.

- (IBAction) toggleMovesCursor:(id)sender_I
{
	[self makeContextForCurrentTablet];
	
	// Set the Attribute in the driver.
	
	NSAppleEventDescriptor  *routingDesc   = [WacomTabletDriver routingTableForContext:mContextID];
	Boolean                 newMovesCursor = !mMovesCursor; // Invert current value.
	
	[WacomTabletDriver setBytes:&newMovesCursor
								ofSize:sizeof(Boolean)
								ofType:typeBoolean
						forAttribute:pContextMovesSystemCursor
						routingTable:routingDesc];
						
	mMovesCursor = newMovesCursor;
}

// /////////////////////////////////////////////////////////////////////////////
// Keeps the mouse cursor inside the application window.

- (IBAction) toggleConstrainToWindow:(id)sender_I
{
	[self makeContextForCurrentTablet];
	
	// Flip flag to new state
	mConstrainedToWindow = !mConstrainedToWindow;
	
	if (mConstrainedToWindow == YES)
	{
		[self setPortionOfScreen:[mWindow frame]];
	}
	else
	{
		[self setPortionOfScreen:[self desktopRect]];
	}
}

// /////////////////////////////////////////////////////////////////////////////
// The tablet portion is set to the left half of the tablet.

- (IBAction) toggleConstrainToLeftHalfOfTablet:(id)sender_I
{
	[self makeContextForCurrentTablet];
	
	// Flip flag to new state.
	mUsingLeftHalfOfTablet = !mUsingLeftHalfOfTablet;
	
	if (mUsingLeftHalfOfTablet == YES)
	{
		LongRect                leftHalfRect      = {0};
		NSAppleEventDescriptor  *routingDesc      = [WacomTabletDriver routingTableForContext:mContextID];
		NSAppleEventDescriptor  *tabletAreaDesc   = nil;
		
		tabletAreaDesc = [WacomTabletDriver dataForAttribute:pMapTabletArea ofType:typeLongRectangle routingTable:routingDesc];
		[[tabletAreaDesc data] getBytes:&mFullTabletArea length:sizeof(mFullTabletArea)];
		
		leftHalfRect.left		= mFullTabletArea.left;
		leftHalfRect.top		= mFullTabletArea.top;
		leftHalfRect.right 	= mFullTabletArea.right/2;
		leftHalfRect.bottom	= mFullTabletArea.bottom;
		
		[WacomTabletDriver setBytes:&leftHalfRect
									ofSize:sizeof(LongRect)
									ofType:typeLongRectangle
							forAttribute:pContextMapTabletInputArea
							routingTable:routingDesc];
	}
	else
	{
		NSAppleEventDescriptor  *routingDesc      = [WacomTabletDriver routingTableForContext:mContextID];
		
		[WacomTabletDriver setBytes:&mFullTabletArea
									ofSize:sizeof(LongRect)
									ofType:typeLongRectangle
							forAttribute:pContextMapTabletInputArea
							routingTable:routingDesc];
	}
}

// /////////////////////////////////////////////////////////////////////////////
// Tells the Wacom driver to partion the tablet into two separate
//	contexts, each one of which will represent the full screen.

- (IBAction) toggleSplitTablet:(id)sender_I
{
	[self makeContextForCurrentTablet];
	
	// Toggle Split flag and set value.
	mSplitTablet = !mSplitTablet;
	if (mSplitTablet == YES)
	{
		LongRect                leftHalfRect      = {0};
		LongRect                rightHalfRect     = {0};
		NSAppleEventDescriptor  *routingDesc      = nil;
		NSAppleEventDescriptor  *routing2Desc     = nil;
		NSAppleEventDescriptor  *tabletAreaDesc   = nil;
		
		// Two active areas will require two contexts instead of the usual one.
		mContext2ID    = [WacomTabletDriver createContextForTablet:(UInt32)lastUsedTablet type:pContextTypeDefault];
		routingDesc    = [WacomTabletDriver routingTableForContext:mContextID];
		routing2Desc   = [WacomTabletDriver routingTableForContext:mContext2ID];
		
		// Get the current (full) area.
		tabletAreaDesc = [WacomTabletDriver dataForAttribute:pMapTabletArea ofType:typeLongRectangle routingTable:routingDesc];
		[[tabletAreaDesc data] getBytes:&mFullTabletArea length:sizeof(mFullTabletArea)];
		
		// Divide the full area and assign one half to each context.
		leftHalfRect.left		= mFullTabletArea.left;
		leftHalfRect.top		= mFullTabletArea.top;
		leftHalfRect.right 	= mFullTabletArea.right/2;
		leftHalfRect.bottom	= mFullTabletArea.bottom;
		
		rightHalfRect.left	= mFullTabletArea.right/2;
		rightHalfRect.top		= mFullTabletArea.top;
		rightHalfRect.right  = mFullTabletArea.right;
		rightHalfRect.bottom = mFullTabletArea.bottom;
		
		[WacomTabletDriver setBytes:&leftHalfRect
									ofSize:sizeof(LongRect)
									ofType:typeLongRectangle
							forAttribute:pContextMapTabletInputArea
							routingTable:routingDesc];
		
		[WacomTabletDriver setBytes:&rightHalfRect
									ofSize:sizeof(LongRect)
									ofType:typeLongRectangle
							forAttribute:pContextMapTabletInputArea
							routingTable:routing2Desc];
	}
	else
	{
		// Restore the full area.
		NSAppleEventDescriptor  *routingDesc      = [WacomTabletDriver routingTableForContext:mContextID];

		[WacomTabletDriver setBytes:&mFullTabletArea
									ofSize:sizeof(LongRect)
									ofType:typeLongRectangle
							forAttribute:pContextMapTabletInputArea
							routingTable:routingDesc];
		
		// Only one context is necessary now; discard the other.
		[WacomTabletDriver destroyContext:mContext2ID];
		mContext2ID = 0;
	}

}

// /////////////////////////////////////////////////////////////////////////////
// The values returned for -[NSEvent absoluteX] and -[NSEvent
//	absoluteY] aren't what they claim to be. This method fixes that.

- (IBAction) useRealAbsoluteCoordinates:(id)sender_I
{
	// For an application which has not opened a context to the Wacom driver, the 
	// values of absoluteX/Y are numbers used internally by the driver which are 
	// not useful to Mac OS applications. 
	//
	// When you create a context of pContextTypeDefault, the driver stops 
	// returning its internal numbers for *most* tablets, and starts returning 
	// the expected values. 
	[self makeContextForCurrentTablet];
	
	// Creating a context is not enough for integrated display tablets (like 
	// Cintiqs), which will still return the internal numbers by default. 
	//
	// To force display tablets to *also* use absolute coordinates, you must 
	// explicitly tell the tablet to map to the full desktop. 
	//
	// Note:	Display tablets don't actually support custom portion-of-screen 
	//			settings. Passing the desktop rect here actually serves as a special 
	//			flag to enable corrected absoluteXY mapping. You should ONLY pass 
	//			the full desktop rect, which Cintiqs will interpret specially. 
	//			Passing any other value is undefined. 
	[self setPortionOfScreen:[self desktopRect]];
	
	// You now have numbers which are calculated by transforming the tablet input 
	// area into the tablet output area. So to retrieve the ranges for 
	// absoluteX/Y, you must request the tablet's output area. 
	NSAppleEventDescriptor  *routingDesc      = [WacomTabletDriver routingTableForContext:mContextID];
	NSAppleEventDescriptor  *outputAreaDesc   = nil;
	LongRect                outputArea        = {0};
	
	outputAreaDesc = [WacomTabletDriver dataForAttribute:pContextMapTabletOutputArea
																 ofType:typeLongRectangle
														 routingTable:routingDesc];
	[[outputAreaDesc data] getBytes:&outputArea length:sizeof(outputArea)];
	
	// And there you have it. The numbers from absoluteX and absoluteY should 
	// fall within outputArea, with (outputArea.left, outputArea.top) 
	// corresponding to the upper-left corner of the tablet, and 
	// (outputArea.right, outputArea.bottom) corresponding to the rightmost point 
	// on the tablet. 
	NSLog(@"output area : l=%d, t=%d   r=%d, b=%d", outputArea.left, outputArea.top, outputArea.right, outputArea.bottom);
	
	// The values fall within this range as long as the context persists.
}

#pragma mark - DELEGATES -

// /////////////////////////////////////////////////////////////////////////////
// Contexts should be destroyed, otherwise they will live on in the
//	driver unnecessarily.

- (void) applicationWillTerminate:(NSNotification *)notification_I
{
	if (mContextID != 0)
	{
		[WacomTabletDriver destroyContext:mContextID];
	}
	
	if (mContext2ID != 0)
	{
		[WacomTabletDriver destroyContext:mContext2ID];
	}
}

// /////////////////////////////////////////////////////////////////////////////
// Keep the checkmarks up-to-date on the Fun menu items.

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem_I
{
	SEL action = [menuItem_I action];

	if (action == @selector(toggleMovesCursor:))
	{
		[menuItem_I setState:(mMovesCursor ? NSOnState : NSOffState)];
	}
	
	if (action == @selector(toggleConstrainToWindow:))
	{
		[menuItem_I setState:(mConstrainedToWindow ? NSOnState : NSOffState)];
	}
	
	if (action == @selector(toggleConstrainToLeftHalfOfTablet:))
	{
		[menuItem_I setState:(mUsingLeftHalfOfTablet ? NSOnState : NSOffState)];
	}
	
	if (action == @selector(toggleSplitTablet:))
	{
		[menuItem_I setState:(mSplitTablet ? NSOnState : NSOffState)];
	}
	
	// Menus are always enabled.
	return YES;
}

// /////////////////////////////////////////////////////////////////////////////
// When constraining the cursor to the window, we need to update the
//	portion-of-screen as the window moves. The Wacom driver doesn't
//	track a window, it just maps a coordinate area on the desktop. So
//	whenever the window moves, the driver has to be told to update
//	its screen rect.

- (void) windowDidMove:(NSNotification *)window_I
{
	if (mConstrainedToWindow)
	{
		[self setPortionOfScreen:[mWindow frame]];
	}
}

#pragma mark - UTILITIES -

// /////////////////////////////////////////////////////////////////////////////
// Returns the union of all screen rectangles.

- (NSRect) desktopRect
{
	NSRect         desktop           = NSZeroRect;
	NSEnumerator   *screenIterator   = [[NSScreen screens] objectEnumerator];
	NSScreen       *screen           = NULL;
	
	// Make the menu window (and the menu control!) cover the entire desktop.
	// This allows us to track clicks "outside" the menu.
	while ((screen = [screenIterator nextObject]))
	{
		desktop = NSUnionRect(desktop, [screen frame]);
	}
	
	return desktop;
}

// /////////////////////////////////////////////////////////////////////////////
// Updates the Wacom driver context to be associated with the
//	current tablet, discarding the old context if necessary.

- (void) makeContextForCurrentTablet
{
	// If we changed tablets since creating the context, we need to start over.
	if (lastUsedTablet != mTabletOfContext)
	{
		[WacomTabletDriver destroyContext:mContextID];
		mContextID = 0;
		
		[WacomTabletDriver destroyContext:mContext2ID];
		mContext2ID = 0;
	}
	
	// If no context, create one.
	if (mContextID == 0)
	{
		mContextID        = [WacomTabletDriver createContextForTablet:(UInt32)lastUsedTablet type:pContextTypeDefault];
		mTabletOfContext  = (UInt32)lastUsedTablet;
	}
}

// /////////////////////////////////////////////////////////////////////////////
// Returns the display name of the pen with the given serial number.
// This method will ONLY return an answer when the pen was the last
//	used transducer of its type. Consequently, you should ONLY call
//	this method immediately after receiving a proximity event.

- (NSString *) nameOfPen:(NSUInteger)serialNumber_I
{
	UInt32                  transducerCount   = [WacomTabletDriver transducerCountForTablet:(UInt32)lastUsedTablet];
	NSAppleEventDescriptor  *routingTable     = nil;
	NSAppleEventDescriptor	*nameDesc			= nil;
	NSAppleEventDescriptor	*serialNumberDesc	= nil;
	UInt32                  counter           = 0;
	NSString						*name					= nil;
	
	// Search the transducers for the matching serial number.
	for (counter = 1; counter <= transducerCount && name == nil; ++counter)
	{
		// Retrieve pen info. 
		// Note:	Transducer data is not available through a context. We access the 
		//			data directly from the tablet. 
		routingTable      = [WacomTabletDriver routingTableForTablet:(UInt32)lastUsedTablet transducer:counter];
		nameDesc          = [WacomTabletDriver dataForAttribute:pName ofType:typeUTF8Text routingTable:routingTable];
		serialNumberDesc  = [WacomTabletDriver dataForAttribute:pSerialNumber ofType:typeUInt32 routingTable:routingTable];
		
		if ((UInt32)[serialNumberDesc int32Value] == serialNumber_I)
		{
			name = [nameDesc stringValue];
		}
	}
	
	return name;
}

// /////////////////////////////////////////////////////////////////////////////
// Sets the portion of the desktop the current tablet context maps to.

- (void) setPortionOfScreen:(NSRect)screenPortion_I
{
	if (mContextID != 0)
	{
		NSRect rectPrimary = [NSScreen screens][0].frame;
		NSAppleEventDescriptor  *routingDesc   = [WacomTabletDriver routingTableForContext:mContextID];
		Rect                    screenArea     = {0};
		
		// Convert Cocoa rect to old QuickDraw rect.
		screenArea.left	= NSMinX(screenPortion_I);
		screenArea.top		= NSMaxY(rectPrimary) - NSMaxY(screenPortion_I) + 1;
		screenArea.right  = NSMaxX(screenPortion_I);
		screenArea.bottom = NSMaxY(rectPrimary) - NSMinY(screenPortion_I) + 1;
		
		[WacomTabletDriver setBytes:&screenArea
									ofSize:sizeof(Rect)
									ofType:typeQDRectangle
							forAttribute:pContextMapScreenArea
							routingTable:routingDesc];
	}
}

@end
