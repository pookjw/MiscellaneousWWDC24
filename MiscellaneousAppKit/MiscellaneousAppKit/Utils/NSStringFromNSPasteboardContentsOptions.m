//
//  NSStringFromNSPasteboardContentsOptions.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/23/25.
//

#import "NSStringFromNSPasteboardContentsOptions.h"

NSString * NSStringFromNSPasteboardContentsOptions(NSPasteboardContentsOptions options) {
    if (options == 0) {
        return @"None";
    }
    
    NSMutableArray<NSString *> *strings = [NSMutableArray new];
    
    if (options & NSPasteboardContentsCurrentHostOnly) {
        [strings addObject:@"Current Host Only"];
    }
    
    NSString *result = [strings componentsJoinedByString:@", "];
    [strings release];
    
    return result;
}

NSPasteboardContentsOptions NSPasteboardContentsOptionsFromString(NSString *string) {
    if ([string isEqualToString:@"None"]) {
        return 0;
    }
    
    NSPasteboardContentsOptions options = 0;
    NSArray<NSString *> *components = [string componentsSeparatedByString:@", "];
    for (NSString *component in components) {
        if ([component isEqualToString:@"Current Host Only"]) {
            options |= NSPasteboardContentsCurrentHostOnly;
        } else {
            abort();
        }
    }
    
    return options;
}

const NSPasteboardContentsOptions * allNSPasteboardContentsOptions(NSUInteger * _Nullable count) {
    static const NSPasteboardContentsOptions allOptions[] = {
        0,
        NSPasteboardContentsCurrentHostOnly
    };
    
    if (count != NULL) {
        *count = sizeof(allOptions) / sizeof(NSPasteboardContentsOptions);
    }
    
    return allOptions;
}
