// /////////////////////////////////////////////////////////////////////////////
//
// COPYRIGHT
//    Copyright (c) 2023 Wacom Co., Ltd.
//    All rights reserved
//
// /////////////////////////////////////////////////////////////////////////////

#import "WindowController.h"
#import "AppController.h"

@interface WindowController ()
{
    AppController *theApp;
}

@end

@implementation WindowController

// /////////////////////////////////////////////////////////////////////////////

- (void)windowDidLoad
{
	[super windowDidLoad];
}

// /////////////////////////////////////////////////////////////////////////////

- (BOOL)canBecomeKeyWindow
{
	 return YES;
}

// /////////////////////////////////////////////////////////////////////////////

- (BOOL)canBecomeMainWindow
{
	 return YES;
}

// /////////////////////////////////////////////////////////////////////////////

- (void)windowDidBecomeMain:(NSNotification *)notification
{
	[NSEvent setMouseCoalescingEnabled:NO];
    [super window].acceptsMouseMovedEvents = YES;
	theApp = (AppController *)[NSApp delegate];
}

// /////////////////////////////////////////////////////////////////////////////

- (void)windowDidBecomeKey:(NSNotification *)notification
{
	[NSEvent setMouseCoalescingEnabled:NO];
}

// /////////////////////////////////////////////////////////////////////////////

- (void)windowDidResignMain:(NSNotification *)notification
{
	[NSEvent setMouseCoalescingEnabled:YES];
}

// /////////////////////////////////////////////////////////////////////////////

- (void)windowDidResignKey:(NSNotification *)notification
{
	[NSEvent setMouseCoalescingEnabled:YES];
}

// /////////////////////////////////////////////////////////////////////////////

- (void) setMouseDownValues:(NSEvent *)theEvent
{
    [mMouseDownLocationXField        setFloatValue:[theEvent locationInWindow].x];
    [mMouseDownLocationYField        setFloatValue:[theEvent locationInWindow].y];
    [mMouseDownModifiersField        setStringValue:[NSString stringWithFormat:@"0x%08lx", (long)[theEvent modifierFlags]]];
    [mMouseDownIsTabletEventField    setStringValue:[self isTabletPointEvent:theEvent] ? @"YES" : @"NO"];
    [self checkSubTypes:theEvent];

}

// /////////////////////////////////////////////////////////////////////////////

-(void) setMouseUpValues:(NSEvent *)theEvent
{
    [mMouseUpLocationXField            setFloatValue:[theEvent locationInWindow].x];
    [mMouseUpLocationYField            setFloatValue:[theEvent locationInWindow].y];
    [mMouseUpModifiersField        setStringValue:[NSString stringWithFormat:@"0x%08lx", (long)[theEvent modifierFlags]]];
    [mMouseUpIsTabletEventField    setStringValue:[self isTabletPointEvent:theEvent] ? @"YES" : @"NO"];
    [self checkSubTypes:theEvent];

}

// /////////////////////////////////////////////////////////////////////////////

- (void) setMouseDragValues:(NSEvent *)theEvent
{
    [mMouseDragLocationXField        setFloatValue:[theEvent locationInWindow].x];
    [mMouseDragLocationYField        setFloatValue:[theEvent locationInWindow].y];
    [mMouseDragDeltaXField            setFloatValue:[theEvent deltaX]];
    [mMouseDragDeltaYField            setFloatValue:[theEvent deltaY]];
    [mMouseDragModifiersField        setStringValue:[NSString stringWithFormat:@"0x%08lx", (long)[theEvent modifierFlags]]];
    [mMouseDragIsTabletEventField    setStringValue:[self isTabletPointEvent:theEvent] ? @"YES" : @"NO"];
    [self checkSubTypes:theEvent];
}

// /////////////////////////////////////////////////////////////////////////////

-(void) setMouseMoveValues:(NSEvent *)theEvent
{
    [mMouseMoveLocationXField        setFloatValue:[theEvent locationInWindow].x];
    [mMouseMoveLocationYField        setFloatValue:[theEvent locationInWindow].y];
    [mMouseMoveDeltaXField            setFloatValue:[theEvent deltaX]];
    [mMouseMoveDeltaYField            setFloatValue:[theEvent deltaY]];
    [mMouseMoveModifiersField        setStringValue:[NSString stringWithFormat:@"0x%08lx", (long)[theEvent modifierFlags]]];
    [mMouseMoveIsTabletEventField    setStringValue: [self isTabletPointEvent:theEvent] ? @"YES" : @"NO"];
    [self checkSubTypes:theEvent];
}

// /////////////////////////////////////////////////////////////////////////////

- (void) setTabletPointEventValues:(NSEvent *)theEvent
{
    [mAbsoluteXField                    setIntValue:(int)[theEvent absoluteX]];
    [mAbsoluteYField                    setIntValue:(int)[theEvent absoluteY]];
    [mAbsoluteZField                    setIntValue:(int)[theEvent absoluteZ]];
    
    [mPressureField                    setFloatValue:[theEvent pressure]];
    [mTangentialPressureField        setFloatValue:[theEvent tangentialPressure]];
    
    [mTiltXField                        setFloatValue:[theEvent tilt].x];
    [mTiltYField                        setFloatValue:[theEvent tilt].y];
    [mRotationField                    setFloatValue:[theEvent rotation]];
    [mDeviceIDField                    setIntValue:(int)[theEvent deviceID]];
    [self checkSubTypes:theEvent];

}

// /////////////////////////////////////////////////////////////////////////////

-(void) checkSubTypes:(NSEvent*) theEvent
{
    switch ([theEvent subtype])
    {
        case NSEventSubtypeTabletPoint:
        {
            break;
        }
        case NSEventSubtypeTabletProximity:
        {
            theApp.lastUsedTablet = [theEvent systemTabletID];
            [mTransducerSerialNumberField    setStringValue:[NSString stringWithFormat:@"0x%lX", (unsigned long)[theEvent pointingDeviceSerialNumber]]];
            NSString *penName = [theApp nameOfPen:[theEvent pointingDeviceSerialNumber]];
            if (penName)
            {
                [mTransducerNameField setStringValue:penName];
            }
            [mDeviceIDField                    setIntValue:(int)[theEvent deviceID]];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Event handlers -

// /////////////////////////////////////////////////////////////////////////////

- (void)mouseMoved:(NSEvent *)theEvent
{
    [self setMouseMoveValues:theEvent];
}

// /////////////////////////////////////////////////////////////////////////////

- (void)mouseDown:(NSEvent *)theEvent
{
    NSLog(@"\n");
    NSLog(@"--- mouseDown ---\n");
    [self setMouseDownValues:theEvent];
}

// /////////////////////////////////////////////////////////////////////////////

- (void)rightMouseDown:(NSEvent *)theEvent
{
    NSLog(@"\n");
    NSLog(@"--- Right mouseDown ---\n");
    [self setMouseDownValues:theEvent];
}

// /////////////////////////////////////////////////////////////////////////////

- (void)otherMouseDown:(NSEvent *)theEvent
{
    NSLog(@"\n");
    NSLog(@"--- Other mouseDown ---\n");
    [self setMouseDownValues:theEvent];
}

// /////////////////////////////////////////////////////////////////////////////

- (void)mouseUp:(NSEvent *)theEvent
{
    NSLog(@"\n");
    NSLog(@"--- mouseUp ---\n");
    [self setMouseUpValues:theEvent];
}

// /////////////////////////////////////////////////////////////////////////////

- (void)rightMouseUp:(NSEvent *)theEvent
{
    NSLog(@"\n");
    NSLog(@"--- Right mouseUp ---\n");
    [self setMouseUpValues:theEvent];
}

// /////////////////////////////////////////////////////////////////////////////

- (void)otherMouseUp:(NSEvent *)theEvent
{
    NSLog(@"\n");
    NSLog(@"--- Other mouseUp ---\n");
    [self setMouseUpValues:theEvent];
}

// /////////////////////////////////////////////////////////////////////////////

- (void)mouseDragged:(NSEvent *)theEvent
{
    NSLog(@"\n");
    NSLog(@"--- mouseDragged ---\n");
    [self setMouseDragValues: theEvent];
}

// /////////////////////////////////////////////////////////////////////////////

- (void)rightMouseDragged:(NSEvent *)theEvent
{
    NSLog(@"\n");
    NSLog(@"--- Right mouseDragged ---\n");
    [self setMouseDragValues:theEvent];
}

// /////////////////////////////////////////////////////////////////////////////

- (void)otherMouseDragged:(NSEvent *)theEvent
{
    NSLog(@"\n");
    NSLog(@"--- Other mouseDragged ---\n");
    [self setMouseDragValues:theEvent];
}

// /////////////////////////////////////////////////////////////////////////////

- (BOOL) isTabletPointEvent:(NSEvent *) theEvent
{
    BOOL isMouseEvent = NO;
    if (theEvent.type == NSEventTypeMouseMoved
         || theEvent.type == NSEventTypeLeftMouseDragged
         || theEvent.type == NSEventTypeRightMouseDragged
         || theEvent.type == NSEventTypeOtherMouseDragged
        
         || theEvent.type == NSEventTypeLeftMouseDown
         || theEvent.type == NSEventTypeRightMouseDown
         || theEvent.type == NSEventTypeOtherMouseDown
        
         || theEvent.type == NSEventTypeLeftMouseUp
         || theEvent.type == NSEventTypeRightMouseUp
         || theEvent.type == NSEventTypeOtherMouseUp)
    {
        isMouseEvent = YES;
    }

    if ((theEvent.type == NSEventTypeTabletPoint) ||
        (isMouseEvent == YES &&    theEvent.subtype == NSEventSubtypeTabletPoint))
    {
        [self setTabletPointEventValues:theEvent];
        return YES;
    }
    return NO;
}

@end
