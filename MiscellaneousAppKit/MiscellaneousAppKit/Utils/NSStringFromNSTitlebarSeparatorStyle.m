//
//  NSStringFromNSTitlebarSeparatorStyle.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/20/25.
//

#import "NSStringFromNSTitlebarSeparatorStyle.h"

NSString * NSStringFromNSTitlebarSeparatorStyle(NSTitlebarSeparatorStyle style) {
    switch (style) {
        case NSTitlebarSeparatorStyleAutomatic:
            return @"Automatic";
        case NSTitlebarSeparatorStyleNone:
            return @"None";
        case NSTitlebarSeparatorStyleLine:
            return @"Line";
        case NSTitlebarSeparatorStyleShadow:
            return @"Shadow";
        default:
            abort();
    }
}

NSTitlebarSeparatorStyle NSTitlebarSeparatorStyleFromString(NSString *string) {
    if ([string isEqualToString:@"Automatic"]) {
        return NSTitlebarSeparatorStyleAutomatic;
    } else if ([string isEqualToString:@"None"]) {
        return NSTitlebarSeparatorStyleNone;
    } else if ([string isEqualToString:@"Line"]) {
        return NSTitlebarSeparatorStyleLine;
    } else if ([string isEqualToString:@"Shadow"]) {
        return NSTitlebarSeparatorStyleShadow;
    } else {
        abort();
    }
}

NSTitlebarSeparatorStyle * allNSTitlebarSeparatorStyles(NSUInteger * _Nullable count) {
    static NSTitlebarSeparatorStyle allStyles[] = {
        NSTitlebarSeparatorStyleAutomatic,
        NSTitlebarSeparatorStyleNone,
        NSTitlebarSeparatorStyleLine,
        NSTitlebarSeparatorStyleShadow
    };
    
    if (count != NULL) {
        *count = sizeof(allStyles) / sizeof(NSTitlebarSeparatorStyle);
    }
    
    return allStyles;
}
