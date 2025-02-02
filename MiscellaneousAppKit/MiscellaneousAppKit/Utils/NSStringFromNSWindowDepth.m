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
            abort();
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
        abort();
    }
}

NSWindowDepth *allNSWindowDepths(NSUInteger * _Nullable count) {
    static NSWindowDepth allDepths[] = {
        NSWindowDepthOnehundredtwentyeightBitRGB,
        NSWindowDepthSixtyfourBitRGB,
        NSWindowDepthTwentyfourBitRGB
    };
    
    if (count != NULL) {
        *count = sizeof(allDepths) / sizeof(NSWindowDepth);
    }
    
    return allDepths;
}
