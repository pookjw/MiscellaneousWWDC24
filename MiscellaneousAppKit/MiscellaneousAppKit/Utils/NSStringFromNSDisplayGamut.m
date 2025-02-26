//
//  NSStringFromNSDisplayGamut.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/27/25.
//

#import "NSStringFromNSDisplayGamut.h"

NSString * NSStringFromNSDisplayGamut(NSDisplayGamut gamut) {
    switch (gamut) {
        case NSDisplayGamutSRGB:
            return @"sRGB";
        case NSDisplayGamutP3:
            return @"P3";
        default:
            abort();
    }
}

NSDisplayGamut NSDisplayGamutFromString(NSString *string) {
    if ([string isEqualToString:@"sRGB"]) {
        return NSDisplayGamutSRGB;
    } else if ([string isEqualToString:@"P3"]) {
        return NSDisplayGamutP3;
    } else {
        abort();
    }
}

const NSDisplayGamut * allNSDisplayGamuts(NSUInteger * _Nullable count) {
    static const NSDisplayGamut allGamuts[] = {
        NSDisplayGamutSRGB,
        NSDisplayGamutP3
    };
    
    if (count != NULL) {
        *count = sizeof(allGamuts) / sizeof(NSDisplayGamut);
    }
    
    return allGamuts;
}
