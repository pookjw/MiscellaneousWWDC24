//
//  NSStringFromNSWindowTabbingMode.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/20/25.
//

#import "NSStringFromNSWindowTabbingMode.h"

NSString * NSStringFromNSWindowTabbingMode(NSWindowTabbingMode mode) {
    switch (mode) {
        case NSWindowTabbingModeAutomatic:
            return @"Automatic";
        case NSWindowTabbingModePreferred:
            return @"Preferred";
        case NSWindowTabbingModeDisallowed:
            return @"Disallowed";
        default:
            abort();
    }
}

NSWindowTabbingMode NSWindowTabbingModeFromString(NSString *string) {
    if ([string isEqualToString:@"Automatic"]) {
        return NSWindowTabbingModeAutomatic;
    } else if ([string isEqualToString:@"Preferred"]) {
        return NSWindowTabbingModePreferred;
    } else if ([string isEqualToString:@"Disallowed"]) {
        return NSWindowTabbingModeDisallowed;
    } else {
        abort();
    }
}

NSWindowTabbingMode * allNSWindowTabbingModes(NSUInteger * _Nullable count) {
    static NSWindowTabbingMode allModes[] = {
        NSWindowTabbingModeAutomatic,
        NSWindowTabbingModePreferred,
        NSWindowTabbingModeDisallowed
    };
    
    if (count != NULL) {
        *count = sizeof(allModes) / sizeof(NSWindowTabbingMode);
    }
    
    return allModes;
}
