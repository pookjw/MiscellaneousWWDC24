//
//  NSStringFromNSWindowNumberListOptions.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/13/25.
//

#import "NSStringFromNSWindowNumberListOptions.h"

NSString * NSStringFromNSWindowNumberListOptions(NSWindowNumberListOptions options) {
    NSMutableArray<NSString *> *strings = [NSMutableArray new];
    
    if (options & NSWindowNumberListAllApplications) {
        [strings addObject:@"All Applications"];
    }
    
    if (options & NSWindowNumberListAllSpaces) {
        [strings addObject:@"All Spaces"];
    }
    
    NSString *result = [strings componentsJoinedByString:@", "];
    [strings release];
    
    return result;
}

NSWindowNumberListOptions NSWindowNumberListOptionsFromString(NSString *string) {
    NSWindowNumberListOptions options = 0;
    NSArray<NSString *> *components = [string componentsSeparatedByString:@", "];
    
    for (NSString *component in components) {
        if ([component isEqualToString:@"All Applications"]) {
            options |= NSWindowNumberListAllApplications;
        } else if ([component isEqualToString:@"All Spaces"]) {
            options |= NSWindowNumberListAllSpaces;
        } else {
            abort();
        }
    }
    
    assert(options != 0);
    return options;
}

NSWindowNumberListOptions * allNSWindowNumberListOptions(NSUInteger * _Nullable count) {
    static NSWindowNumberListOptions allOptions[] = {
        NSWindowNumberListAllApplications,
        NSWindowNumberListAllSpaces
    };
    
    if (count != NULL) {
        *count = sizeof(allOptions) / sizeof(NSWindowNumberListOptions);
    }
    
    return allOptions;
}
