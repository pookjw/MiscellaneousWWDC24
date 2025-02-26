//
//  NSStringFromNSWindowAnimationBehavior.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/21/25.
//

#import <Cocoa/Cocoa.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MA_EXTERN NSString * NSStringFromNSWindowAnimationBehavior(NSWindowAnimationBehavior behavior);
MA_EXTERN NSWindowAnimationBehavior NSWindowAnimationBehaviorFromString(NSString *string);
MA_EXTERN const NSWindowAnimationBehavior * allNSWindowAnimationBehaviors(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END
