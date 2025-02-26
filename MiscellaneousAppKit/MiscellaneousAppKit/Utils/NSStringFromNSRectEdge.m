//
//  NSStringFromNSRectEdge.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/12/25.
//

#import "NSStringFromNSRectEdge.h"

NSString * NSStringFromNSRectEdge(NSRectEdge edge) {
    switch (edge) {
        case NSRectEdgeMinX:
            return @"Min X";
        case NSRectEdgeMinY:
            return @"Min Y";
        case NSRectEdgeMaxX:
            return @"Max X";
        case NSRectEdgeMaxY:
            return @"Max Y";
        default:
            abort();
    }
}

NSRectEdge NSRectEdgeFromString(NSString *string) {
    if ([string isEqualToString:@"Min X"]) {
        return NSRectEdgeMinX;
    } else if ([string isEqualToString:@"Min Y"]) {
        return NSRectEdgeMinY;
    } else if ([string isEqualToString:@"Max X"]) {
        return NSRectEdgeMaxX;
    } else if ([string isEqualToString:@"Max Y"]) {
        return NSRectEdgeMaxY;
    } else {
        abort();
    }
}

const NSRectEdge * allNSRectEdges(NSUInteger * _Nullable count) {
    static const NSRectEdge allEdges[] = {
        NSRectEdgeMinX,
        NSRectEdgeMinY,
        NSRectEdgeMaxX,
        NSRectEdgeMaxY
    };
    
    if (count != NULL) {
        *count = sizeof(allEdges) / sizeof(NSRectEdge);
    }
    
    return allEdges;
}
