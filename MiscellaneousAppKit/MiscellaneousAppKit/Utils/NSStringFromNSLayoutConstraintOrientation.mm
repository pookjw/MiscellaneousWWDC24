//
//  NSStringFromNSLayoutConstraintOrientation.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/26/25.
//

#import "NSStringFromNSLayoutConstraintOrientation.h"

NSString * NSStringFromNSLayoutConstraintOrientation(NSLayoutConstraintOrientation orientation) {
    switch (orientation) {
        case NSLayoutConstraintOrientationHorizontal:
            return @"Horizontal";
        case NSLayoutConstraintOrientationVertical:
            return @"Vertical";
        default:
            abort();
    }
}

NSLayoutConstraintOrientation NSLayoutConstraintOrientationFromString(NSString *string) {
    if ([string isEqualToString:@"Horizontal"]) {
        return NSLayoutConstraintOrientationHorizontal;
    } else if ([string isEqualToString:@"Vertical"]) {
        return NSLayoutConstraintOrientationVertical;
    } else {
        abort();
    }
}

const NSLayoutConstraintOrientation * allNSLayoutConstraintOrientations(NSUInteger * _Nullable count) {
    static const NSLayoutConstraintOrientation allOrientations[] = {
        NSLayoutConstraintOrientationHorizontal,
        NSLayoutConstraintOrientationVertical
    };
    
    if (count != NULL) {
        *count = sizeof(allOrientations) / sizeof(NSLayoutConstraintOrientation);
    }
    
    return allOrientations;
}
