//
//  NSStringFromNSEventModifierFlags.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/17/25.
//

#import <Cocoa/Cocoa.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MA_EXTERN NSString * NSStringFromNSEventModifierFlags(NSEventModifierFlags flags);
MA_EXTERN NSEventModifierFlags NSEventModifierFlagsFromString(NSString *string);
MA_EXTERN const NSEventModifierFlags * allNSEventModifierFlags(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END
