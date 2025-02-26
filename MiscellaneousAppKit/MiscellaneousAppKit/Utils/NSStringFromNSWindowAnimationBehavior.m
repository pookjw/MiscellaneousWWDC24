//
//  NSStringFromNSWindowAnimationBehavior.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/21/25.
//

#import "NSStringFromNSWindowAnimationBehavior.h"

NSString * NSStringFromNSWindowAnimationBehavior(NSWindowAnimationBehavior behavior) {
    switch (behavior) {
        case NSWindowAnimationBehaviorDefault:
            return @"Default";
        case NSWindowAnimationBehaviorNone:
            return @"None";
        case NSWindowAnimationBehaviorDocumentWindow:
            return @"Document Window";
        case NSWindowAnimationBehaviorUtilityWindow:
            return @"Utility Window";
        case NSWindowAnimationBehaviorAlertPanel:
            return @"Alert Panel";
        default:
            abort();
    }
}

NSWindowAnimationBehavior NSWindowAnimationBehaviorFromString(NSString *string) {
    if ([string isEqualToString:@"Default"]) {
        return NSWindowAnimationBehaviorDefault;
    } else if ([string isEqualToString:@"None"]) {
        return NSWindowAnimationBehaviorNone;
    } else if ([string isEqualToString:@"Document Window"]) {
        return NSWindowAnimationBehaviorDocumentWindow;
    } else if ([string isEqualToString:@"Utility Window"]) {
        return NSWindowAnimationBehaviorUtilityWindow;
    } else if ([string isEqualToString:@"Alert Panel"]) {
        return NSWindowAnimationBehaviorAlertPanel;
    } else {
        abort();
    }
}

const NSWindowAnimationBehavior * allNSWindowAnimationBehaviors(NSUInteger * _Nullable count) {
    static const NSWindowAnimationBehavior allBehaviors[] = {
        NSWindowAnimationBehaviorDefault,
        NSWindowAnimationBehaviorNone,
        NSWindowAnimationBehaviorDocumentWindow,
        NSWindowAnimationBehaviorUtilityWindow,
        NSWindowAnimationBehaviorAlertPanel
    };
    
    if (count != NULL) {
        *count = sizeof(allBehaviors) / sizeof(NSWindowAnimationBehavior);
    }
    
    return allBehaviors;
}
