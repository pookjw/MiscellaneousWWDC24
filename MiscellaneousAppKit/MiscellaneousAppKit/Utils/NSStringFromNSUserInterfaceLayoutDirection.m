//
//  NSStringFromNSUserInterfaceLayoutDirection.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/20/25.
//

#import "NSStringFromNSUserInterfaceLayoutDirection.h"

NSString * NSStringFromNSUserInterfaceLayoutDirection(NSUserInterfaceLayoutDirection direction) {
    switch (direction) {
        case NSUserInterfaceLayoutDirectionLeftToRight:
            return @"Left To Right";
        case NSUserInterfaceLayoutDirectionRightToLeft:
            return @"Right To Left";
        default:
            abort();
    }
}

NSUserInterfaceLayoutDirection NSUserInterfaceLayoutDirectionFromString(NSString *string) {
    if ([string isEqualToString:@"Left To Right"]) {
        return NSUserInterfaceLayoutDirectionLeftToRight;
    } else if ([string isEqualToString:@"Right To Left"]) {
        return NSUserInterfaceLayoutDirectionRightToLeft;
    } else {
        abort();
    }
}

NSUserInterfaceLayoutDirection * allNSUserInterfaceLayoutDirections(NSUInteger * _Nullable count) {
    static NSUserInterfaceLayoutDirection allDirections[] = {
        NSUserInterfaceLayoutDirectionLeftToRight,
        NSUserInterfaceLayoutDirectionRightToLeft
    };

    if (count != NULL) {
        *count = sizeof(allDirections) / sizeof(NSUserInterfaceLayoutDirection);
    }

    return allDirections;
}
