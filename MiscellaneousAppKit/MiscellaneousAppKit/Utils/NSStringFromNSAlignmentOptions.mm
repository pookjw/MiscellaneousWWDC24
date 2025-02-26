//
//  NSStringFromNSAlignmentOptions.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/24/25.
//

#import "NSStringFromNSAlignmentOptions.h"

NSString * NSStringFromNSAlignmentOptions(NSAlignmentOptions options) {
    NSMutableArray<NSString *> *strings = [NSMutableArray new];
    
    if (options & NSAlignMinXInward)   { [strings addObject:@"Min X Inward"]; }
    if (options & NSAlignMinYInward)   { [strings addObject:@"Min Y Inward"]; }
    if (options & NSAlignMaxXInward)   { [strings addObject:@"Max X Inward"]; }
    if (options & NSAlignMaxYInward)   { [strings addObject:@"Max Y Inward"]; }
    if (options & NSAlignWidthInward)  { [strings addObject:@"Width Inward"]; }
    if (options & NSAlignHeightInward) { [strings addObject:@"Height Inward"]; }
    
    if (options & NSAlignMinXOutward)   { [strings addObject:@"Min X Outward"]; }
    if (options & NSAlignMinYOutward)   { [strings addObject:@"Min Y Outward"]; }
    if (options & NSAlignMaxXOutward)   { [strings addObject:@"Max X Outward"]; }
    if (options & NSAlignMaxYOutward)   { [strings addObject:@"Max Y Outward"]; }
    if (options & NSAlignWidthOutward)  { [strings addObject:@"Width Outward"]; }
    if (options & NSAlignHeightOutward) { [strings addObject:@"Height Outward"]; }
    
    if (options & NSAlignMinXNearest)   { [strings addObject:@"Min X Nearest"]; }
    if (options & NSAlignMinYNearest)   { [strings addObject:@"Min Y Nearest"]; }
    if (options & NSAlignMaxXNearest)   { [strings addObject:@"Max X Nearest"]; }
    if (options & NSAlignMaxYNearest)   { [strings addObject:@"Max Y Nearest"]; }
    if (options & NSAlignWidthNearest)  { [strings addObject:@"Width Nearest"]; }
    if (options & NSAlignHeightNearest) { [strings addObject:@"Height Nearest"]; }
    
    if (options & NSAlignRectFlipped) { [strings addObject:@"Rect Flipped"]; }
    
    NSString *result = [strings componentsJoinedByString:@", "];
    [strings release];
    
    return result;
}

NSAlignmentOptions NSAlignmentOptionsFromString(NSString *string) {
    NSAlignmentOptions options = 0;
    NSArray<NSString *> *components = [string componentsSeparatedByString:@", "];
    
    for (NSString *component in components) {
        if ([component isEqualToString:@"Min X Inward"]) {
            options |= NSAlignMinXInward;
        } else if ([component isEqualToString:@"Min Y Inward"]) {
            options |= NSAlignMinYInward;
        } else if ([component isEqualToString:@"Max X Inward"]) {
            options |= NSAlignMaxXInward;
        } else if ([component isEqualToString:@"Max Y Inward"]) {
            options |= NSAlignMaxYInward;
        } else if ([component isEqualToString:@"Width Inward"]) {
            options |= NSAlignWidthInward;
        } else if ([component isEqualToString:@"Height Inward"]) {
            options |= NSAlignHeightInward;
        } else if ([component isEqualToString:@"Min X Outward"]) {
            options |= NSAlignMinXOutward;
        } else if ([component isEqualToString:@"Min Y Outward"]) {
            options |= NSAlignMinYOutward;
        } else if ([component isEqualToString:@"Max X Outward"]) {
            options |= NSAlignMaxXOutward;
        } else if ([component isEqualToString:@"Max Y Outward"]) {
            options |= NSAlignMaxYOutward;
        } else if ([component isEqualToString:@"Width Outward"]) {
            options |= NSAlignWidthOutward;
        } else if ([component isEqualToString:@"Height Outward"]) {
            options |= NSAlignHeightOutward;
        } else if ([component isEqualToString:@"Min X Nearest"]) {
            options |= NSAlignMinXNearest;
        } else if ([component isEqualToString:@"Min Y Nearest"]) {
            options |= NSAlignMinYNearest;
        } else if ([component isEqualToString:@"Max X Nearest"]) {
            options |= NSAlignMaxXNearest;
        } else if ([component isEqualToString:@"Max Y Nearest"]) {
            options |= NSAlignMaxYNearest;
        } else if ([component isEqualToString:@"Width Nearest"]) {
            options |= NSAlignWidthNearest;
        } else if ([component isEqualToString:@"Height Nearest"]) {
            options |= NSAlignHeightNearest;
        } else if ([component isEqualToString:@"Rect Flipped"]) {
            options |= NSAlignRectFlipped;
        } else {
            abort();
        }
    }
    
    return options;
}

const NSAlignmentOptions * allNSAlignmentOptions(NSUInteger * _Nullable count) {
    static const NSAlignmentOptions allOptions[] = {
        NSAlignMinXInward,
        NSAlignMinYInward,
        NSAlignMaxXInward,
        NSAlignMaxYInward,
        NSAlignWidthInward,
        NSAlignHeightInward,
        NSAlignMinXOutward,
        NSAlignMinYOutward,
        NSAlignMaxXOutward,
        NSAlignMaxYOutward,
        NSAlignWidthOutward,
        NSAlignHeightOutward,
        NSAlignMinXNearest,
        NSAlignMinYNearest,
        NSAlignMaxXNearest,
        NSAlignMaxYNearest,
        NSAlignWidthNearest,
        NSAlignHeightNearest,
        NSAlignRectFlipped
    };
    
    if (count != NULL) {
        *count = sizeof(allOptions) / sizeof(NSAlignmentOptions);
    }
    
    return allOptions;
}

NSString * NSStringFromNSStringFromNSAlignmentOptionsConvenienceCombinations(NSAlignmentOptions options) {
    switch (options) {
        case NSAlignAllEdgesInward:
            return @"All Edges Inward";
        case NSAlignAllEdgesOutward:
            return @"All Edges Outward";
        case NSAlignAllEdgesNearest:
            return @"All Edges Nearest";
        default:
            abort();
    }
}

NSAlignmentOptions NSAlignmentOptionsConvenienceCombinationsFromString(NSString *string) {
    if ([string isEqualToString:@"All Edges Inward"]) {
        return NSAlignAllEdgesInward;
    } else if ([string isEqualToString:@"All Edges Outward"]) {
        return NSAlignAllEdgesOutward;
    } else if ([string isEqualToString:@"All Edges Nearest"]) {
        return NSAlignAllEdgesNearest;
    } else {
        abort();
    }
}

const NSAlignmentOptions * allNSAlignmentOptionsConvenienceCombinations(NSUInteger * _Nullable count) {
    static const NSAlignmentOptions combinations[] = {
        NSAlignAllEdgesInward,
        NSAlignAllEdgesOutward,
        NSAlignAllEdgesNearest
    };
    
    if (count != NULL) {
        *count = sizeof(combinations) / sizeof(NSAlignmentOptions);
    }
    
    return combinations;
}
