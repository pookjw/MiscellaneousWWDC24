//
//  NSStringFromNSWindowDepth.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/2/25.
//

#import <Cocoa/Cocoa.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MA_EXTERN NSString * NSStringFromNSWindowDepth(NSWindowDepth windowDepth);
MA_EXTERN NSWindowDepth NSWindowDepthFromString(NSString *string);
MA_EXTERN const NSWindowDepth *allNSWindowDepths(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END
