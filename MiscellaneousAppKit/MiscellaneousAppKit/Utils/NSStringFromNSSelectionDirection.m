//
//  NSStringFromNSSelectionDirection.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/21/25.
//

#import "NSStringFromNSSelectionDirection.h"

NSString * NSStringFromNSSelectionDirection(NSSelectionDirection direction) {
    switch (direction) {
        case NSDirectSelection:
            return @"Direct Selection";
        case NSSelectingNext:
            return @"Selecting Next";
        case NSSelectingPrevious:
            return @"Selecting Previous";
        default:
            abort();
    }
}

NSSelectionDirection NSSelectionDirectionFromString(NSString *string) {
    if ([string isEqualToString:@"Direct Selection"]) {
        return NSDirectSelection;
    } else if ([string isEqualToString:@"Selecting Next"]) {
        return NSSelectingNext;
    } else if ([string isEqualToString:@"Selecting Previous"]) {
        return NSSelectingPrevious;
    } else {
        abort();
    }
}

NSSelectionDirection * allNSSelectionDirections(NSUInteger * _Nullable count) {
    static NSSelectionDirection allDirections[] = {
        NSDirectSelection,
        NSSelectingNext,
        NSSelectingPrevious
    };

    if (count != NULL) {
        *count = sizeof(allDirections) / sizeof(NSSelectionDirection);
    }
    
    return allDirections;
}
