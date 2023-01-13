///////////////////////////////////////////////////////////////////////////////
//
// DESCRIPTION
//
// This Window Controller is being used to capture Mouse Moves
// using the method acceptsMouseMovedEvents.
//
// COPYRIGHT
//    Copyright (c) 2023 Wacom Co., Ltd.
//    All rights reserved
//
///////////////////////////////////////////////////////////////////////////////

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface WindowController : NSWindowController <NSWindowDelegate>
{
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
}

@end

NS_ASSUME_NONNULL_END
