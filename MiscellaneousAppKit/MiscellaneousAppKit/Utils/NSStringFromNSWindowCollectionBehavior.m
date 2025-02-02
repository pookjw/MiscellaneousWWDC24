//
//  NSStringFromNSWindowCollectionBehavior.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/2/25.
//

#import "NSStringFromNSWindowCollectionBehavior.h"

NSString * NSStringFromNSWindowCollectionBehavior(NSWindowCollectionBehavior collectionBehavior) {
    if (collectionBehavior == NSWindowCollectionBehaviorDefault) {
        return @"Default";
    }
    
    NSMutableArray<NSString *> *strings = [NSMutableArray new];
    
    if (collectionBehavior & NSWindowCollectionBehaviorCanJoinAllSpaces) {
        [strings addObject:@"CanJoinAllSpaces"];
    }
    if (collectionBehavior & NSWindowCollectionBehaviorMoveToActiveSpace) {
        [strings addObject:@"MoveToActiveSpace"];
    }
    if (collectionBehavior & NSWindowCollectionBehaviorManaged) {
        [strings addObject:@"Managed"];
    }
    if (collectionBehavior & NSWindowCollectionBehaviorTransient) {
        [strings addObject:@"Transient"];
    }
    if (collectionBehavior & NSWindowCollectionBehaviorStationary) {
        [strings addObject:@"Stationary"];
    }
    if (collectionBehavior & NSWindowCollectionBehaviorParticipatesInCycle) {
        [strings addObject:@"ParticipatesInCycle"];
    }
    if (collectionBehavior & NSWindowCollectionBehaviorIgnoresCycle) {
        [strings addObject:@"IgnoresCycle"];
    }
    if (collectionBehavior & NSWindowCollectionBehaviorFullScreenPrimary) {
        [strings addObject:@"FullScreenPrimary"];
    }
    if (collectionBehavior & NSWindowCollectionBehaviorFullScreenAuxiliary) {
        [strings addObject:@"FullScreenAuxiliary"];
    }
    if (collectionBehavior & NSWindowCollectionBehaviorFullScreenNone) {
        [strings addObject:@"FullScreenNone"];
    }
    if (collectionBehavior & NSWindowCollectionBehaviorFullScreenAllowsTiling) {
        [strings addObject:@"FullScreenAllowsTiling"];
    }
    if (collectionBehavior & NSWindowCollectionBehaviorFullScreenDisallowsTiling) {
        [strings addObject:@"FullScreenDisallowsTiling"];
    }
    if (collectionBehavior & NSWindowCollectionBehaviorPrimary) {
        [strings addObject:@"Primary"];
    }
    if (collectionBehavior & NSWindowCollectionBehaviorAuxiliary) {
        [strings addObject:@"Auxiliary"];
    }
    if (collectionBehavior & NSWindowCollectionBehaviorCanJoinAllApplications) {
        [strings addObject:@"CanJoinAllApplications"];
    }
    
    NSString *string = [strings componentsJoinedByString:@", "];
    [strings release];
    
    return string;
}

NSWindowCollectionBehavior NSWindowCollectionBehaviorFromString(NSString *string) {
    if ([string isEqualToString:@"Default"]) {
        return NSWindowCollectionBehaviorDefault;
    }
    
    NSArray<NSString *> *components = [string componentsSeparatedByString:@", "];
    NSWindowCollectionBehavior result = 0;
    
    for (NSString *component in components) {
        if ([component isEqualToString:@"CanJoinAllSpaces"]) {
            result |= NSWindowCollectionBehaviorCanJoinAllSpaces;
        } else if ([component isEqualToString:@"MoveToActiveSpace"]) {
            result |= NSWindowCollectionBehaviorMoveToActiveSpace;
        } else if ([component isEqualToString:@"Managed"]) {
            result |= NSWindowCollectionBehaviorManaged;
        } else if ([component isEqualToString:@"Transient"]) {
            result |= NSWindowCollectionBehaviorTransient;
        } else if ([component isEqualToString:@"Stationary"]) {
            result |= NSWindowCollectionBehaviorStationary;
        } else if ([component isEqualToString:@"ParticipatesInCycle"]) {
            result |= NSWindowCollectionBehaviorParticipatesInCycle;
        } else if ([component isEqualToString:@"IgnoresCycle"]) {
            result |= NSWindowCollectionBehaviorIgnoresCycle;
        } else if ([component isEqualToString:@"FullScreenPrimary"]) {
            result |= NSWindowCollectionBehaviorFullScreenPrimary;
        } else if ([component isEqualToString:@"FullScreenAuxiliary"]) {
            result |= NSWindowCollectionBehaviorFullScreenAuxiliary;
        } else if ([component isEqualToString:@"FullScreenNone"]) {
            result |= NSWindowCollectionBehaviorFullScreenNone;
        } else if ([component isEqualToString:@"FullScreenAllowsTiling"]) {
            result |= NSWindowCollectionBehaviorFullScreenAllowsTiling;
        } else if ([component isEqualToString:@"FullScreenDisallowsTiling"]) {
            result |= NSWindowCollectionBehaviorFullScreenDisallowsTiling;
        } else if ([component isEqualToString:@"Primary"]) {
            result |= NSWindowCollectionBehaviorPrimary;
        } else if ([component isEqualToString:@"Auxiliary"]) {
            result |= NSWindowCollectionBehaviorAuxiliary;
        } else if ([component isEqualToString:@"CanJoinAllApplications"]) {
            result |= NSWindowCollectionBehaviorCanJoinAllApplications;
        } else {
            abort();
        }
    }
    
    return result;
}

NSWindowCollectionBehavior *allNSWindowCollectionBehaviors(NSUInteger * _Nullable count) {
    static NSWindowCollectionBehavior collectionBehaviors[] = {
        NSWindowCollectionBehaviorDefault,
        NSWindowCollectionBehaviorCanJoinAllSpaces,
        NSWindowCollectionBehaviorMoveToActiveSpace,
        NSWindowCollectionBehaviorManaged,
        NSWindowCollectionBehaviorTransient,
        NSWindowCollectionBehaviorStationary,
        NSWindowCollectionBehaviorParticipatesInCycle,
        NSWindowCollectionBehaviorIgnoresCycle,
        NSWindowCollectionBehaviorFullScreenPrimary,
        NSWindowCollectionBehaviorFullScreenAuxiliary,
        NSWindowCollectionBehaviorFullScreenNone,
        NSWindowCollectionBehaviorFullScreenAllowsTiling,
        NSWindowCollectionBehaviorFullScreenDisallowsTiling,
        NSWindowCollectionBehaviorPrimary,
        NSWindowCollectionBehaviorAuxiliary,
        NSWindowCollectionBehaviorCanJoinAllApplications
    };
    
    if (count != NULL) {
        *count = sizeof(collectionBehaviors) / sizeof(NSWindowCollectionBehavior);
    }
    
    return collectionBehaviors;
}
