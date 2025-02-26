//
//  NSStringFromNSWindowToolbarStyle.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/20/25.
//

#import "NSStringFromNSWindowToolbarStyle.h"

NSString * NSStringFromNSWindowToolbarStyle(NSWindowToolbarStyle style) {
    switch (style) {
        case NSWindowToolbarStyleAutomatic:
            return @"Automatic";
        case NSWindowToolbarStyleExpanded:
            return @"Expanded";
        case NSWindowToolbarStylePreference:
            return @"Preference";
        case NSWindowToolbarStyleUnified:
            return @"Unified";
        case NSWindowToolbarStyleUnifiedCompact:
            return @"Unified Compact";
        default:
            abort();
    }
}

NSWindowToolbarStyle NSWindowToolbarStyleFromString(NSString *string) {
    if ([string isEqualToString:@"Automatic"]) {
        return NSWindowToolbarStyleAutomatic;
    } else if ([string isEqualToString:@"Expanded"]) {
        return NSWindowToolbarStyleExpanded;
    } else if ([string isEqualToString:@"Preference"]) {
        return NSWindowToolbarStylePreference;
    } else if ([string isEqualToString:@"Unified"]) {
        return NSWindowToolbarStyleUnified;
    } else if ([string isEqualToString:@"Unified Compact"]) {
        return NSWindowToolbarStyleUnifiedCompact;
    } else {
        abort();
    }
}

const NSWindowToolbarStyle * allNSWindowToolbarStyles(NSUInteger * _Nullable count) {
    static const NSWindowToolbarStyle allStyles[] = {
        NSWindowToolbarStyleAutomatic,
        NSWindowToolbarStyleExpanded,
        NSWindowToolbarStylePreference,
        NSWindowToolbarStyleUnified,
        NSWindowToolbarStyleUnifiedCompact
    };
    
    if (count != NULL) {
        *count = sizeof(allStyles) / sizeof(NSWindowToolbarStyle);
    }
    
    return allStyles;
}
