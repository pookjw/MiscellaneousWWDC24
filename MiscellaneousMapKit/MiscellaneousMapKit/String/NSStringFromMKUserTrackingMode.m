//
//  NSStringFromMKUserTrackingMode.m
//  MiscellaneousMapKit
//
//  Created by Jinwoo Kim on 4/13/25.
//

#import "NSStringFromMKUserTrackingMode.h"

NSString * NSStringFromMKUserTrackingMode(MKUserTrackingMode mode) {
    switch (mode) {
        case MKUserTrackingModeNone:
            return @"None";
        case MKUserTrackingModeFollow:
            return @"Follow";
        case MKUserTrackingModeFollowWithHeading:
            return @"Follow With Heading";
        default:
            abort();
    }
}

MKUserTrackingMode MKUserTrackingModeFromString(NSString *string) {
    if ([string isEqualToString:@"None"]) {
        return MKUserTrackingModeNone;
    } else if ([string isEqualToString:@"Follow"]) {
        return MKUserTrackingModeFollow;
    } else if ([string isEqualToString:@"Follow With Heading"]) {
        return MKUserTrackingModeFollowWithHeading;
    } else {
        abort();
    }
}

const MKUserTrackingMode * allMKUserTrackingModes(NSUInteger * _Nullable count) {
    static const MKUserTrackingMode allModes[] = {
        MKUserTrackingModeNone,
        MKUserTrackingModeFollow,
        MKUserTrackingModeFollowWithHeading
    };
    
    if (count != NULL) {
        *count = sizeof(allModes) / sizeof(MKUserTrackingMode);
    }
    
    return allModes;
}
