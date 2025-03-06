//
//  NSStringFromPKCanvasViewDrawingPolicy.m
//  MyCanvas
//
//  Created by Jinwoo Kim on 3/6/25.
//

#import "NSStringFromPKCanvasViewDrawingPolicy.h"

NSString * NSStringFromPKCanvasViewDrawingPolicy(PKCanvasViewDrawingPolicy policy) {
    switch (policy) {
        case PKCanvasViewDrawingPolicyDefault:
            return @"Default";
        case PKCanvasViewDrawingPolicyAnyInput:
            return @"Any Input";
        case PKCanvasViewDrawingPolicyPencilOnly:
            return @"Pencil Only";
        default:
            abort();
    }
}

PKCanvasViewDrawingPolicy PKCanvasViewDrawingPolicyFromString(NSString *string) {
    if ([string isEqualToString:@"Default"]) {
        return PKCanvasViewDrawingPolicyDefault;
    } else if ([string isEqualToString:@"Any Input"]) {
        return PKCanvasViewDrawingPolicyAnyInput;
    } else if ([string isEqualToString:@"Pencil Only"]) {
        return PKCanvasViewDrawingPolicyPencilOnly;
    } else {
        abort();
    }
}

const PKCanvasViewDrawingPolicy * allPKCanvasViewDrawingPolicies(NSUInteger * _Nullable count) {
    static const PKCanvasViewDrawingPolicy allPolicies[] = {
        PKCanvasViewDrawingPolicyDefault,
        PKCanvasViewDrawingPolicyAnyInput,
        PKCanvasViewDrawingPolicyPencilOnly
    };
    
    if (count != NULL) {
        *count = sizeof(allPolicies) / sizeof(PKCanvasViewDrawingPolicy);
    }
    
    return allPolicies;
}
