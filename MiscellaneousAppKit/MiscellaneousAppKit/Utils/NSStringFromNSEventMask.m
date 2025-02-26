//
//  NSStringFromNSEventMask.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/20/25.
//

#import "NSStringFromNSEventMask.h"

NSString * NSStringFromNSEventMask(NSEventMask mask) {
    if (mask == NSEventMaskAny) {
        return @"Any";
    }
    
    NSMutableArray<NSString *> *strings = [NSMutableArray new];
    
    if (mask & NSEventMaskLeftMouseDown) {
        [strings addObject:@"Left Mouse Down"];
    }
    if (mask & NSEventMaskLeftMouseUp) {
        [strings addObject:@"Left Mouse Up"];
    }
    if (mask & NSEventMaskRightMouseDown) {
        [strings addObject:@"Right Mouse Down"];
    }
    if (mask & NSEventMaskRightMouseUp) {
        [strings addObject:@"Right Mouse Up"];
    }
    if (mask & NSEventMaskMouseMoved) {
        [strings addObject:@"Mouse Moved"];
    }
    if (mask & NSEventMaskLeftMouseDragged) {
        [strings addObject:@"Left Mouse Dragged"];
    }
    if (mask & NSEventMaskRightMouseDragged) {
        [strings addObject:@"Right Mouse Dragged"];
    }
    if (mask & NSEventMaskMouseEntered) {
        [strings addObject:@"Mouse Entered"];
    }
    if (mask & NSEventMaskMouseExited) {
        [strings addObject:@"Mouse Exited"];
    }
    if (mask & NSEventMaskKeyDown) {
        [strings addObject:@"Key Down"];
    }
    if (mask & NSEventMaskKeyUp) {
        [strings addObject:@"Key Up"];
    }
    if (mask & NSEventMaskFlagsChanged) {
        [strings addObject:@"Flags Changed"];
    }
    if (mask & NSEventMaskAppKitDefined) {
        [strings addObject:@"AppKit Defined"];
    }
    if (mask & NSEventMaskSystemDefined) {
        [strings addObject:@"System Defined"];
    }
    if (mask & NSEventMaskApplicationDefined) {
        [strings addObject:@"Application Defined"];
    }
    if (mask & NSEventMaskPeriodic) {
        [strings addObject:@"Periodic"];
    }
    if (mask & NSEventMaskCursorUpdate) {
        [strings addObject:@"Cursor Update"];
    }
    if (mask & NSEventMaskScrollWheel) {
        [strings addObject:@"Scroll Wheel"];
    }
    if (mask & NSEventMaskTabletPoint) {
        [strings addObject:@"Tablet Point"];
    }
    if (mask & NSEventMaskTabletProximity) {
        [strings addObject:@"Tablet Proximity"];
    }
    if (mask & NSEventMaskOtherMouseDown) {
        [strings addObject:@"Other Mouse Down"];
    }
    if (mask & NSEventMaskOtherMouseUp) {
        [strings addObject:@"Other Mouse Up"];
    }
    if (mask & NSEventMaskOtherMouseDragged) {
        [strings addObject:@"Other Mouse Dragged"];
    }
    if (mask & NSEventMaskGesture) {
        [strings addObject:@"Gesture"];
    }
    if (mask & NSEventMaskMagnify) {
        [strings addObject:@"Magnify"];
    }
    if (mask & NSEventMaskSwipe) {
        [strings addObject:@"Swipe"];
    }
    if (mask & NSEventMaskRotate) {
        [strings addObject:@"Rotate"];
    }
    if (mask & NSEventMaskBeginGesture) {
        [strings addObject:@"Begin Gesture"];
    }
    if (mask & NSEventMaskEndGesture) {
        [strings addObject:@"End Gesture"];
    }
    if (mask & NSEventMaskSmartMagnify) {
        [strings addObject:@"Smart Magnify"];
    }
    if (mask & NSEventMaskPressure) {
        [strings addObject:@"Pressure"];
    }
    if (mask & NSEventMaskDirectTouch) {
        [strings addObject:@"Direct Touch"];
    }
    if (mask & NSEventMaskChangeMode) {
        [strings addObject:@"Change Mode"];
    }
    
    NSString *result = [strings componentsJoinedByString:@", "];
    [strings release];
    return result;
}

NSEventMask NSEventMaskFromString(NSString *string) {
    if ([string isEqualToString:@"Any"]) {
        return NSEventMaskAny;
    }
    
    NSEventMask mask = 0;
    NSArray<NSString *> *components = [string componentsSeparatedByString:@", "];
    for (NSString *component in components) {
        if ([component isEqualToString:@"Left Mouse Down"]) {
            mask |= NSEventMaskLeftMouseDown;
        } else if ([component isEqualToString:@"Left Mouse Up"]) {
            mask |= NSEventMaskLeftMouseUp;
        } else if ([component isEqualToString:@"Right Mouse Down"]) {
            mask |= NSEventMaskRightMouseDown;
        } else if ([component isEqualToString:@"Right Mouse Up"]) {
            mask |= NSEventMaskRightMouseUp;
        } else if ([component isEqualToString:@"Mouse Moved"]) {
            mask |= NSEventMaskMouseMoved;
        } else if ([component isEqualToString:@"Left Mouse Dragged"]) {
            mask |= NSEventMaskLeftMouseDragged;
        } else if ([component isEqualToString:@"Right Mouse Dragged"]) {
            mask |= NSEventMaskRightMouseDragged;
        } else if ([component isEqualToString:@"Mouse Entered"]) {
            mask |= NSEventMaskMouseEntered;
        } else if ([component isEqualToString:@"Mouse Exited"]) {
            mask |= NSEventMaskMouseExited;
        } else if ([component isEqualToString:@"Key Down"]) {
            mask |= NSEventMaskKeyDown;
        } else if ([component isEqualToString:@"Key Up"]) {
            mask |= NSEventMaskKeyUp;
        } else if ([component isEqualToString:@"Flags Changed"]) {
            mask |= NSEventMaskFlagsChanged;
        } else if ([component isEqualToString:@"AppKit Defined"]) {
            mask |= NSEventMaskAppKitDefined;
        } else if ([component isEqualToString:@"System Defined"]) {
            mask |= NSEventMaskSystemDefined;
        } else if ([component isEqualToString:@"Application Defined"]) {
            mask |= NSEventMaskApplicationDefined;
        } else if ([component isEqualToString:@"Periodic"]) {
            mask |= NSEventMaskPeriodic;
        } else if ([component isEqualToString:@"Cursor Update"]) {
            mask |= NSEventMaskCursorUpdate;
        } else if ([component isEqualToString:@"Scroll Wheel"]) {
            mask |= NSEventMaskScrollWheel;
        } else if ([component isEqualToString:@"Tablet Point"]) {
            mask |= NSEventMaskTabletPoint;
        } else if ([component isEqualToString:@"Tablet Proximity"]) {
            mask |= NSEventMaskTabletProximity;
        } else if ([component isEqualToString:@"Other Mouse Down"]) {
            mask |= NSEventMaskOtherMouseDown;
        } else if ([component isEqualToString:@"Other Mouse Up"]) {
            mask |= NSEventMaskOtherMouseUp;
        } else if ([component isEqualToString:@"Other Mouse Dragged"]) {
            mask |= NSEventMaskOtherMouseDragged;
        } else if ([component isEqualToString:@"Gesture"]) {
            mask |= NSEventMaskGesture;
        } else if ([component isEqualToString:@"Magnify"]) {
            mask |= NSEventMaskMagnify;
        } else if ([component isEqualToString:@"Swipe"]) {
            mask |= NSEventMaskSwipe;
        } else if ([component isEqualToString:@"Rotate"]) {
            mask |= NSEventMaskRotate;
        } else if ([component isEqualToString:@"Begin Gesture"]) {
            mask |= NSEventMaskBeginGesture;
        } else if ([component isEqualToString:@"End Gesture"]) {
            mask |= NSEventMaskEndGesture;
        } else if ([component isEqualToString:@"Smart Magnify"]) {
            mask |= NSEventMaskSmartMagnify;
        } else if ([component isEqualToString:@"Pressure"]) {
            mask |= NSEventMaskPressure;
        } else if ([component isEqualToString:@"Direct Touch"]) {
            mask |= NSEventMaskDirectTouch;
        } else if ([component isEqualToString:@"Change Mode"]) {
            mask |= NSEventMaskChangeMode;
        } else {
            abort();
        }
    }
    
    return mask;
}

const NSEventMask * allNSEventMasks(NSUInteger * _Nullable count) {
    static const NSEventMask allMasks[] = {
        NSEventMaskLeftMouseDown,
        NSEventMaskLeftMouseUp,
        NSEventMaskRightMouseDown,
        NSEventMaskRightMouseUp,
        NSEventMaskMouseMoved,
        NSEventMaskLeftMouseDragged,
        NSEventMaskRightMouseDragged,
        NSEventMaskMouseEntered,
        NSEventMaskMouseExited,
        NSEventMaskKeyDown,
        NSEventMaskKeyUp,
        NSEventMaskFlagsChanged,
        NSEventMaskAppKitDefined,
        NSEventMaskSystemDefined,
        NSEventMaskApplicationDefined,
        NSEventMaskPeriodic,
        NSEventMaskCursorUpdate,
        NSEventMaskScrollWheel,
        NSEventMaskTabletPoint,
        NSEventMaskTabletProximity,
        NSEventMaskOtherMouseDown,
        NSEventMaskOtherMouseUp,
        NSEventMaskOtherMouseDragged,
        NSEventMaskGesture,
        NSEventMaskMagnify,
        NSEventMaskSwipe,
        NSEventMaskRotate,
        NSEventMaskBeginGesture,
        NSEventMaskEndGesture,
        NSEventMaskSmartMagnify,
        NSEventMaskPressure,
        NSEventMaskDirectTouch,
        NSEventMaskChangeMode,
        NSEventMaskAny
    };
    
    if (count != NULL) {
        *count = sizeof(allMasks) / sizeof(NSEventMask);
    }
    
    return allMasks;
}
