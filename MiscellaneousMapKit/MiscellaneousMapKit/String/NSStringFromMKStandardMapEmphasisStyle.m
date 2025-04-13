//
//  NSStringFromMKStandardMapEmphasisStyle.m
//  MiscellaneousMapKit
//
//  Created by Jinwoo Kim on 4/14/25.
//

#import "NSStringFromMKStandardMapEmphasisStyle.h"

NSString * NSStringFromMKStandardMapEmphasisStyle(MKStandardMapEmphasisStyle style) {
    switch (style) {
        case MKStandardMapEmphasisStyleDefault:
            return @"Default";
        case MKStandardMapEmphasisStyleMuted:
            return @"Muted";
        default:
            abort();
    }
}

MKStandardMapEmphasisStyle MKStandardMapEmphasisStyleFromString(NSString *string) {
    if ([string isEqualToString:@"Default"]) {
        return MKStandardMapEmphasisStyleDefault;
    } else if ([string isEqualToString:@"Muted"]) {
        return MKStandardMapEmphasisStyleMuted;
    } else {
        abort();
    }
}

const MKStandardMapEmphasisStyle * allMKStandardMapEmphasisStyles(NSUInteger * _Nullable count) {
    static const MKStandardMapEmphasisStyle allStyles[] = {
        MKStandardMapEmphasisStyleDefault,
        MKStandardMapEmphasisStyleMuted
    };
    
    if (count != NULL) {
        *count = sizeof(allStyles) / sizeof(MKStandardMapEmphasisStyle);
    }
    
    return allStyles;
}
