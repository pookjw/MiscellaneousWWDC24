//
//  NSStringFromUIUserInterfaceStyle.m
//  MyCanvas
//
//  Created by Jinwoo Kim on 3/7/25.
//

#import "NSStringFromUIUserInterfaceStyle.h"

NSString * NSStringFromUIUserInterfaceStyle(UIUserInterfaceStyle style) {
    switch (style) {
        case UIUserInterfaceStyleUnspecified:
            return @"Unspecified";
        case UIUserInterfaceStyleLight:
            return @"Light";
        case UIUserInterfaceStyleDark:
            return @"Dark";
        default:
            abort();
    }
}

UIUserInterfaceStyle UIUserInterfaceStyleFromString(NSString *string) {
    if ([string isEqualToString:@"Unspecified"]) {
        return UIUserInterfaceStyleUnspecified;
    } else if ([string isEqualToString:@"Light"]) {
        return UIUserInterfaceStyleLight;
    } else if ([string isEqualToString:@"Dark"]) {
        return UIUserInterfaceStyleDark;
    } else {
        abort();
    }
}

const UIUserInterfaceStyle * allUIUserInterfaceStyles(NSUInteger * _Nullable count) {
    static const UIUserInterfaceStyle allStyles[] = {
        UIUserInterfaceStyleUnspecified,
        UIUserInterfaceStyleLight,
        UIUserInterfaceStyleDark
    };
    
    if (count != NULL) {
        *count = sizeof(allStyles) / sizeof(UIUserInterfaceStyle);
    }
    
    return allStyles;
}
