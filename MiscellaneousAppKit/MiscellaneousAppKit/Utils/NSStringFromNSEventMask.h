//
//  NSStringFromNSEventMask.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/20/25.
//

#import <Cocoa/Cocoa.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MA_EXTERN NSString * NSStringFromNSEventMask(NSEventMask mask);
MA_EXTERN NSEventMask NSEventMaskFromString(NSString *string);
MA_EXTERN const NSEventMask * allNSEventMasks(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END
