//
//  NSStringFromNSWritingToolsBehavior.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/23/25.
//

#import "NSStringFromNSWritingToolsBehavior.h"

NSString * NSStringFromNSWritingToolsBehavior(NSWritingToolsBehavior behavior) {
    switch (behavior) {
        case NSWritingToolsBehaviorNone:
            return @"None";
        case NSWritingToolsBehaviorDefault:
            return @"Default";
        case NSWritingToolsBehaviorComplete:
            return @"Complete";
        case NSWritingToolsBehaviorLimited:
            return @"Limited";
        default:
            abort();
    }
}

NSWritingToolsBehavior NSWritingToolsBehaviorFromString(NSString *string) {
    if ([string isEqualToString:@"None"]) {
        return NSWritingToolsBehaviorNone;
    } else if ([string isEqualToString:@"Default"]) {
        return NSWritingToolsBehaviorDefault;
    } else if ([string isEqualToString:@"Complete"]) {
        return NSWritingToolsBehaviorComplete;
    } else if ([string isEqualToString:@"Limited"]) {
        return NSWritingToolsBehaviorLimited;
    } else {
        abort();
    }
}

NSWritingToolsBehavior * allNSWritingToolsBehaviors(NSUInteger * _Nullable count) {
    static NSWritingToolsBehavior allBehaviors[] = {
        NSWritingToolsBehaviorNone,
        NSWritingToolsBehaviorDefault,
        NSWritingToolsBehaviorComplete,
        NSWritingToolsBehaviorLimited
    };
    
    if (count != NULL) {
        *count = sizeof(allBehaviors) / sizeof(NSWritingToolsBehavior);
    }
    
    return allBehaviors;
}
