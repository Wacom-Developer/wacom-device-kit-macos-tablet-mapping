///////////////////////////////////////////////////////////////////////////////
//
// DESCRIPTION
//    Tablet Events Only Cocoa.
//
// COPYRIGHT
//    Copyright (c) 2010 - 2023 Wacom Co., Ltd.
//    All rights reserved
//
///////////////////////////////////////////////////////////////////////////////

#pragma once

#import <Cocoa/Cocoa.h>
#import "TabletAEDictionary.h"
#import "WindowController.h"

@interface AppController : NSObject <NSApplicationDelegate>
{
	IBOutlet NSWindow		*mWindow;
	IBOutlet WindowController *mWindowCtr;
	
	UInt32	mContextID;
	UInt32	mTabletOfContext;
	BOOL		mMovesCursor;
	BOOL		mConstrainedToWindow;
	BOOL		mUsingLeftHalfOfTablet;
	
	UInt32	mContext2ID;
	BOOL		mSplitTablet;
	LongRect mFullTabletArea;
	
}

@property (nonatomic)IBInspectable NSUInteger lastUsedTablet;

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

- (NSString *) nameOfPen:(NSUInteger)serialNumber_I;

@end
