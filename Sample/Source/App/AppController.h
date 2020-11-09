///////////////////////////////////////////////////////////////////////////////
//
// DESCRIPTION
//    Tablet Events Only Cocoa.
//
// COPYRIGHT
//    Copyright (c) 2010 - 2020 Wacom Co., Ltd.
//    All rights reserved
//
///////////////////////////////////////////////////////////////////////////////

#pragma once

#import <Cocoa/Cocoa.h>
#import "TabletAEDictionary.h"

@interface AppController : NSObject <NSApplicationDelegate>
{
	IBOutlet NSWindow		*mWindow;
	 
	// Mouse Move
	IBOutlet NSTextField *mMouseMoveLocationXField;
	IBOutlet NSTextField *mMouseMoveLocationYField;
	IBOutlet NSTextField *mMouseMoveDeltaXField;
	IBOutlet NSTextField *mMouseMoveDeltaYField;
	IBOutlet NSTextField *mMouseMoveModifiersField;
	IBOutlet NSTextField *mMouseMoveIsTabletEventField;

	// Mouse Down
	IBOutlet NSTextField *mMouseDownLocationXField;
	IBOutlet NSTextField *mMouseDownLocationYField;
	IBOutlet NSTextField *mMouseDownModifiersField;
	IBOutlet NSTextField *mMouseDownIsTabletEventField;

	// Mouse Drag
	IBOutlet NSTextField *mMouseDragLocationXField;
	IBOutlet NSTextField *mMouseDragLocationYField;
	IBOutlet NSTextField *mMouseDragDeltaXField;
	IBOutlet NSTextField *mMouseDragDeltaYField;
	IBOutlet NSTextField *mMouseDragModifiersField;
	IBOutlet NSTextField *mMouseDragIsTabletEventField;

	// Mouse Up
	IBOutlet NSTextField *mMouseUpLocationXField;
	IBOutlet NSTextField *mMouseUpLocationYField;
	IBOutlet NSTextField *mMouseUpModifiersField;
	IBOutlet NSTextField *mMouseUpIsTabletEventField;

	// Tablet events
	IBOutlet NSTextField *mAbsoluteXField;
	IBOutlet NSTextField *mAbsoluteYField;
	IBOutlet NSTextField *mAbsoluteZField;
	IBOutlet NSTextField *mPressureField;
	IBOutlet NSTextField *mTangentialPressureField;
	IBOutlet NSTextField *mTiltXField;
	IBOutlet NSTextField *mTiltYField;
	IBOutlet NSTextField *mRotationField;
	IBOutlet NSTextField *mDeviceIDField;
	IBOutlet NSTextField *mTransducerSerialNumberField;
	IBOutlet NSTextField *mTransducerNameField;
	
	UInt32	mLastUsedTablet;
	
	UInt32	mContextID;
	UInt32	mTabletOfContext;
	BOOL		mMovesCursor;
	BOOL		mConstrainedToWindow;
	BOOL		mUsingLeftHalfOfTablet;
	
	UInt32	mContext2ID;
	BOOL		mSplitTablet;
	LongRect mFullTabletArea;
}

// Actions
- (IBAction) toggleMovesCursor:(id)sender_I;
- (IBAction) toggleConstrainToWindow:(id)sender_I;
- (IBAction) toggleConstrainToLeftHalfOfTablet:(id)sender_I;
- (IBAction) toggleSplitTablet:(id)sender_I;
- (IBAction) useRealAbsoluteCoordinates:(id)sender_I;

// Utilities
- (NSRect) desktopRect;
- (void) makeContextForCurrentTablet;
- (void) setPortionOfScreen:(NSRect)screenPortion_I;
- (void) setValuesFromEvent:(NSEvent *)theEvent_I;

@end
