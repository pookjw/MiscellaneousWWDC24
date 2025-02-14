//
//  NSStringFromNSModalResponse.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/14/25.
//

#import "NSStringFromNSModalResponse.h"

NSString * NSStringFromNSModalResponse(NSModalResponse response) {
    switch (response) {
        case 0:
            return @"Normal";
        case NSModalResponseStop:
            return @"Stop";
        case NSModalResponseAbort:
            return @"Abort";
        case NSModalResponseContinue:
            return @"Continue";
        default:
            abort();
    }
}

NSModalResponse NSModalResponseFromString(NSString *string) {
    if ([string isEqualToString:@"Normal"]) {
        return 0;
    } else if ([string isEqualToString:@"Stop"]) {
        return NSModalResponseStop;
    } else if ([string isEqualToString:@"Abort"]) {
        return NSModalResponseAbort;
    } else if ([string isEqualToString:@"Continue"]) {
        return NSModalResponseContinue;
    } else {
        abort();
    }
}
