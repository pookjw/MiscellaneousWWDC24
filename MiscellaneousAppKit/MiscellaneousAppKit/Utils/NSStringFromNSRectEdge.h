//
//  NSStringFromNSRectEdge.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/12/25.
//

#import <Cocoa/Cocoa.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MA_EXTERN NSString * NSStringFromNSRectEdge(NSRectEdge edge);
MA_EXTERN NSRectEdge NSRectEdgeFromString(NSString *string);
MA_EXTERN NSRectEdge * allNSRectEdges(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END
