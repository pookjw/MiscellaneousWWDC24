//
//  NSStringFromNSPasteboardAccessBehavior.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/23/25.
//

#import "NSStringFromNSPasteboardAccessBehavior.h"

NSString * NSStringFromNSPasteboardAccessBehavior(NSPasteboardAccessBehavior behavior) {
    switch (behavior) {
        case NSPasteboardAccessBehaviorDefault:
            return @"Default";
        case NSPasteboardAccessBehaviorAsk:
            return @"Ask";
        case NSPasteboardAccessBehaviorAlwaysAllow:
            return @"Always Allow";
        case NSPasteboardAccessBehaviorAlwaysDeny:
            return @"Always Deny";
        default:
            abort();
    }
}

NSPasteboardAccessBehavior NSPasteboardAccessBehaviorFromString(NSString *string) {
    if ([string isEqualToString:@"Default"]) {
        return NSPasteboardAccessBehaviorDefault;
    } else if ([string isEqualToString:@"Ask"]) {
        return NSPasteboardAccessBehaviorAsk;
    } else if ([string isEqualToString:@"Always Allow"]) {
        return NSPasteboardAccessBehaviorAlwaysAllow;
    } else if ([string isEqualToString:@"Always Deny"]) {
        return NSPasteboardAccessBehaviorAlwaysDeny;
    } else {
        abort();
    }
}

const NSPasteboardAccessBehavior * allNSPasteboardAccessBehaviors(NSUInteger * _Nullable count) {
    static const NSPasteboardAccessBehavior allBehaviors[] = {
        NSPasteboardAccessBehaviorDefault,
        NSPasteboardAccessBehaviorAsk,
        NSPasteboardAccessBehaviorAlwaysAllow,
        NSPasteboardAccessBehaviorAlwaysDeny
    };

    if (count != NULL) {
        *count = sizeof(allBehaviors) / sizeof(NSPasteboardAccessBehavior);
    }
    
    return allBehaviors;
}
