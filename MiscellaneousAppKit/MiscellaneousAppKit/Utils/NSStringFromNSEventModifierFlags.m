//
//  NSStringFromNSEventModifierFlags.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/17/25.
//

#import "NSStringFromNSEventModifierFlags.h"

NSString * NSStringFromNSEventModifierFlags(NSEventModifierFlags flags) {
    NSMutableArray<NSString *> *strings = [NSMutableArray new];
    
    if (flags & NSEventModifierFlagCapsLock) {
        [strings addObject:@"CapsLock"];
    }
    if (flags & NSEventModifierFlagShift) {
        [strings addObject:@"Shift"];
    }
    if (flags & NSEventModifierFlagControl) {
        [strings addObject:@"Control"];
    }
    if (flags & NSEventModifierFlagOption) {
        [strings addObject:@"Option"];
    }
    if (flags & NSEventModifierFlagCommand) {
        [strings addObject:@"Command"];
    }
    if (flags & NSEventModifierFlagNumericPad) {
        [strings addObject:@"NumericPad"];
    }
    if (flags & NSEventModifierFlagHelp) {
        [strings addObject:@"Help"];
    }
    if (flags & NSEventModifierFlagFunction) {
        [strings addObject:@"Function"];
    }
    if (flags & NSEventModifierFlagDeviceIndependentFlagsMask) {
        [strings addObject:@"DeviceIndependentFlagsMask"];
    }
    
    NSString *result = [strings componentsJoinedByString:@", "];
    [strings release];
    
    return result;
}

NSEventModifierFlags NSEventModifierFlagsFromString(NSString *string) {
    NSEventModifierFlags flags = 0;
    NSArray<NSString *> *components = [string componentsSeparatedByString:@", "];
    
    for (NSString *component in components) {
        if ([component isEqualToString:@"CapsLock"]) {
            flags |= NSEventModifierFlagCapsLock;
        } else if ([component isEqualToString:@"Shift"]) {
            flags |= NSEventModifierFlagShift;
        } else if ([component isEqualToString:@"Control"]) {
            flags |= NSEventModifierFlagControl;
        } else if ([component isEqualToString:@"Option"]) {
            flags |= NSEventModifierFlagOption;
        } else if ([component isEqualToString:@"Command"]) {
            flags |= NSEventModifierFlagCommand;
        } else if ([component isEqualToString:@"NumericPad"]) {
            flags |= NSEventModifierFlagNumericPad;
        } else if ([component isEqualToString:@"Help"]) {
            flags |= NSEventModifierFlagHelp;
        } else if ([component isEqualToString:@"Function"]) {
            flags |= NSEventModifierFlagFunction;
        } else if ([component isEqualToString:@"DeviceIndependentFlagsMask"]) {
            flags |= NSEventModifierFlagDeviceIndependentFlagsMask;
        } else {
            abort();
        }
    }
    
    return flags;
}

NSEventModifierFlags * allNSEventModifierFlags(NSUInteger * _Nullable count) {
    static NSEventModifierFlags allFlags[] = {
        NSEventModifierFlagCapsLock,
        NSEventModifierFlagShift,
        NSEventModifierFlagControl,
        NSEventModifierFlagOption,
        NSEventModifierFlagCommand,
        NSEventModifierFlagNumericPad,
        NSEventModifierFlagHelp,
        NSEventModifierFlagFunction,
        NSEventModifierFlagDeviceIndependentFlagsMask
    };
    
    if (count != NULL) {
        *count = sizeof(allFlags) / sizeof(NSEventModifierFlags);
    }
    
    return allFlags;
}
