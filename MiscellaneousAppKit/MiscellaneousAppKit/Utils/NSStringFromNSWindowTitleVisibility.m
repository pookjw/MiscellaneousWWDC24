//
//  NSStringFromNSWindowTitleVisibility.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/25/25.
//

#import "NSStringFromNSWindowTitleVisibility.h"

NSString * NSStringFromNSWindowTitleVisibility(NSWindowTitleVisibility visibility) {
    switch (visibility) {
        case NSWindowTitleVisible:
            return @"Visible";
        case NSWindowTitleHidden:
            return @"Hidden";
        default:
            abort();
    }
}

NSWindowTitleVisibility NSWindowTitleVisibilityFromString(NSString *string) {
    if ([string isEqualToString:@"Visible"]) {
        return NSWindowTitleVisible;
    } else if ([string isEqualToString:@"Hidden"]) {
        return NSWindowTitleHidden;
    } else {
        abort();
    }
}

NSWindowTitleVisibility * allNSWindowTitleVisibilities(NSUInteger * _Nullable count) {
    static NSWindowTitleVisibility allVisibilities[] = {
        NSWindowTitleVisible,
        NSWindowTitleHidden
    };
    
    if (count != NULL) {
        *count = sizeof(allVisibilities) / sizeof(NSWindowTitleVisibility);
    }
    
    return allVisibilities;
}
