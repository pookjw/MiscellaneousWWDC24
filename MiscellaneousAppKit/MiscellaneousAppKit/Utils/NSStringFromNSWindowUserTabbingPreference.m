//
//  NSStringFromNSWindowUserTabbingPreference.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/20/25.
//

#import "NSStringFromNSWindowUserTabbingPreference.h"

NSString * NSStringFromNSWindowUserTabbingPreference(NSWindowUserTabbingPreference preference) {
    switch (preference) {
        case NSWindowUserTabbingPreferenceManual:
            return @"Manual";
        case NSWindowUserTabbingPreferenceAlways:
            return @"Always";
        case NSWindowUserTabbingPreferenceInFullScreen:
            return @"In Full Screen";
        default:
            abort();
    }
}

NSWindowUserTabbingPreference NSWindowUserTabbingPreferenceFromString(NSString *string) {
    if ([string isEqualToString:@"Manual"]) {
        return NSWindowUserTabbingPreferenceManual;
    } else if ([string isEqualToString:@"Always"]) {
        return NSWindowUserTabbingPreferenceAlways;
    } else if ([string isEqualToString:@"In Full Screen"]) {
        return NSWindowUserTabbingPreferenceInFullScreen;
    } else {
        abort();
    }
}

NSWindowUserTabbingPreference * allNSWindowUserTabbingPreferences(NSUInteger * _Nullable count) {
    static NSWindowUserTabbingPreference allPreferences[] = {
        NSWindowUserTabbingPreferenceManual,
        NSWindowUserTabbingPreferenceAlways,
        NSWindowUserTabbingPreferenceInFullScreen
    };
    
    if (count != NULL) {
        *count = sizeof(allPreferences) / sizeof(NSWindowUserTabbingPreference);
    }
    
    return allPreferences;
}
