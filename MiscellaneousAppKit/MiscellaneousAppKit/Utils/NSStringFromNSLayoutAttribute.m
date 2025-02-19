//
//  NSStringFromNSLayoutAttribute.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/20/25.
//

#import "NSStringFromNSLayoutAttribute.h"

NSString * NSStringFromNSLayoutAttribute(NSLayoutAttribute attribute) {
    switch (attribute) {
        case NSLayoutAttributeNotAnAttribute:
            return @"Not An Attribute";
        case NSLayoutAttributeLeft:
            return @"Left";
        case NSLayoutAttributeRight:
            return @"Right";
        case NSLayoutAttributeTop:
            return @"Top";
        case NSLayoutAttributeBottom:
            return @"Bottom";
        case NSLayoutAttributeLeading:
            return @"Leading";
        case NSLayoutAttributeTrailing:
            return @"Trailing";
        case NSLayoutAttributeWidth:
            return @"Width";
        case NSLayoutAttributeHeight:
            return @"Height";
        case NSLayoutAttributeCenterX:
            return @"Center X";
        case NSLayoutAttributeCenterY:
            return @"Center Y";
        case NSLayoutAttributeLastBaseline:
            return @"Last Baseline";
        case NSLayoutAttributeFirstBaseline:
            return @"First Baseline";
        default:
            abort();
    }
}

NSLayoutAttribute NSLayoutAttributeFromString(NSString *string) {
    if ([string isEqualToString:@"Not An Attribute"]) {
        return NSLayoutAttributeNotAnAttribute;
    } else if ([string isEqualToString:@"Left"]) {
        return NSLayoutAttributeLeft;
    } else if ([string isEqualToString:@"Right"]) {
        return NSLayoutAttributeRight;
    } else if ([string isEqualToString:@"Top"]) {
        return NSLayoutAttributeTop;
    } else if ([string isEqualToString:@"Bottom"]) {
        return NSLayoutAttributeBottom;
    } else if ([string isEqualToString:@"Leading"]) {
        return NSLayoutAttributeLeading;
    } else if ([string isEqualToString:@"Trailing"]) {
        return NSLayoutAttributeTrailing;
    } else if ([string isEqualToString:@"Width"]) {
        return NSLayoutAttributeWidth;
    } else if ([string isEqualToString:@"Height"]) {
        return NSLayoutAttributeHeight;
    } else if ([string isEqualToString:@"Center X"]) {
        return NSLayoutAttributeCenterX;
    } else if ([string isEqualToString:@"Center Y"]) {
        return NSLayoutAttributeCenterY;
    } else if ([string isEqualToString:@"Last Baseline"]) {
        return NSLayoutAttributeLastBaseline;
    } else if ([string isEqualToString:@"First Baseline"]) {
        return NSLayoutAttributeFirstBaseline;
    } else {
        abort();
    }
}

NSLayoutAttribute * allNSLayoutAttributes(NSUInteger * _Nullable count) {
    static NSLayoutAttribute allAttributes[] = {
        NSLayoutAttributeNotAnAttribute,
        NSLayoutAttributeLeft,
        NSLayoutAttributeRight,
        NSLayoutAttributeTop,
        NSLayoutAttributeBottom,
        NSLayoutAttributeLeading,
        NSLayoutAttributeTrailing,
        NSLayoutAttributeWidth,
        NSLayoutAttributeHeight,
        NSLayoutAttributeCenterX,
        NSLayoutAttributeCenterY,
        NSLayoutAttributeLastBaseline,
        NSLayoutAttributeFirstBaseline
    };
    
    if (count != NULL) {
        *count = sizeof(allAttributes) / sizeof(NSLayoutAttribute);
    }
    
    return allAttributes;
}
