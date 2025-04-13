//
//  NSStringFromMKMapElevationStyle.m
//  MiscellaneousMapKit
//
//  Created by Jinwoo Kim on 4/13/25.
//

#import "NSStringFromMKMapElevationStyle.h"

NSString * NSStringFromMKMapElevationStyle(MKMapElevationStyle style) {
    switch (style) {
        case MKMapElevationStyleFlat:
            return @"Flat";
        case MKMapElevationStyleRealistic:
            return @"Realistic";
        default:
            abort();
    }
}

MKMapElevationStyle MKMapElevationStyleFromString(NSString *string) {
    if ([string isEqualToString:@"Flat"]) {
        return MKMapElevationStyleFlat;
    } else if ([string isEqualToString:@"Realistic"]) {
        return MKMapElevationStyleRealistic;
    } else {
        abort();
    }
}

const MKMapElevationStyle * allMKMapElevationStyles(NSUInteger * _Nullable count) {
    static const MKMapElevationStyle allStyles[] = {
        MKMapElevationStyleFlat,
        MKMapElevationStyleRealistic
    };
    
    if (count != NULL) {
        *count = sizeof(allStyles) / sizeof(MKMapElevationStyle);
    }
    
    return allStyles;
}
