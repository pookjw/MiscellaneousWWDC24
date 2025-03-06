//
//  NSStringFromPKCanvasViewDrawingPolicy.h
//  MyCanvas
//
//  Created by Jinwoo Kim on 3/6/25.
//

#import <PencilKit/PencilKit.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MC_EXTERN NSString * NSStringFromPKCanvasViewDrawingPolicy(PKCanvasViewDrawingPolicy policy);
MC_EXTERN PKCanvasViewDrawingPolicy PKCanvasViewDrawingPolicyFromString(NSString *string);
MC_EXTERN const PKCanvasViewDrawingPolicy * allPKCanvasViewDrawingPolicies(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END

