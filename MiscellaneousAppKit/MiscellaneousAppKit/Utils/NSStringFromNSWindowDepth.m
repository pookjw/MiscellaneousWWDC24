//
//  NSStringFromNSWindowDepth.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/2/25.
//

#import "NSStringFromNSWindowDepth.h"

NSString * NSStringFromNSWindowDepth(NSWindowDepth windowDepth) {
    switch (windowDepth) {
        case 0:
            return @"0";
        case NSWindowDepthOnehundredtwentyeightBitRGB:
            return @"OnehundredtwentyeightBitRGB";
        case NSWindowDepthSixtyfourBitRGB:
            return @"SixtyfourBitRGB";
        case NSWindowDepthTwentyfourBitRGB:
            return @"TwentyfourBitRGB";
        default:
            return @(windowDepth).stringValue;
    }
}

NSWindowDepth NSWindowDepthFromString(NSString *string) {
    if ([string isEqualToString:@"0"]) {
        return 0;
    } else if ([string isEqualToString:@"OnehundredtwentyeightBitRGB"]) {
        return NSWindowDepthOnehundredtwentyeightBitRGB;
    } else if ([string isEqualToString:@"SixtyfourBitRGB"]) {
        return NSWindowDepthSixtyfourBitRGB;
    } else if ([string isEqualToString:@"TwentyfourBitRGB"]) {
        return NSWindowDepthTwentyfourBitRGB;
    } else {
        NSInteger integer = string.integerValue;
        return (NSWindowDepth)integer;
    }
}

const NSWindowDepth *allNSWindowDepths(NSUInteger * _Nullable count) {
    static const NSWindowDepth *allDepths;
    static NSUInteger _count;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        allDepths = NSAvailableWindowDepths();
        
        NSUInteger __count = 0;
        while (allDepths[__count] != 0) {
            __count++;
        }
        
        _count = __count;
    });
    
    if (count != NULL) {
        *count = _count;
    }
    
    return allDepths;
}
