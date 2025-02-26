//
//  NSStringFromNSWindowOrderingMode.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/19/25.
//

#import "NSStringFromNSWindowOrderingMode.h"

NSString * NSStringFromNSWindowOrderingMode(NSWindowOrderingMode mode) {
    switch (mode) {
        case NSWindowAbove:
            return @"Above";
        case NSWindowBelow:
            return @"Below";
        case NSWindowOut:
            return @"Out";
        default:
            abort();
    }
}

NSWindowOrderingMode NSWindowOrderingModeFromString(NSString *string) {
    if ([string isEqualToString:@"Above"]) {
        return NSWindowAbove;
    } else if ([string isEqualToString:@"Below"]) {
        return NSWindowBelow;
    } else if ([string isEqualToString:@"Out"]) {
        return NSWindowOut;
    } else {
        abort();
    }
}

const NSWindowOrderingMode * allNSWindowOrderingModes(NSUInteger * _Nullable count) {
    static const NSWindowOrderingMode allModes[] = {
        NSWindowAbove,
        NSWindowBelow,
        NSWindowOut
    };
    
    if (count != NULL) {
        *count = sizeof(allModes) / sizeof(NSWindowOrderingMode);
    }
    
    return allModes;
}
