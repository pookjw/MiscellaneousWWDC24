//
//  NSStringNSWindowSharingType.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/13/25.
//

#import "NSStringNSWindowSharingType.h"

NSString * NSStringFromNSWindowSharingType(NSWindowSharingType sharingType) {
    switch (sharingType) {
        case NSWindowSharingNone:
            return @"(None)";
        case NSWindowSharingReadOnly:
            return @"Read Only";
        case NSWindowSharingReadWrite:
            return @"Read Write";
        default:
            abort();
    }
}

NSWindowSharingType NSWindowSharingTypeFromString(NSString *string) {
    if ([string isEqualToString:@"(None)"]) {
        return NSWindowSharingNone;
    } else if ([string isEqualToString:@"Read Only"]) {
        return NSWindowSharingReadOnly;
    } else if ([string isEqualToString:@"Read Write"]) {
        return NSWindowSharingReadWrite;
    } else {
        abort();
    }
}

NSWindowSharingType * allNSWindowSharingTypes(NSUInteger * _Nullable count) {
    static NSWindowSharingType allTypes[] = {
        NSWindowSharingNone,
        NSWindowSharingReadOnly,
        NSWindowSharingReadWrite
    };
    
    if (count != NULL) {
        *count = sizeof(allTypes) / sizeof(NSWindowSharingType);
    }
    
    return allTypes;
}
