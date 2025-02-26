//
//  NSStringFromNSWindowStyleMask.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/1/25.
//

#import <Cocoa/Cocoa.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MA_EXTERN NSString * NSStringFromNSWindowStyleMask(NSWindowStyleMask styleMask);
MA_EXTERN NSWindowStyleMask NSWindowStyleMaskFromString(NSString *string);
MA_EXTERN const NSWindowStyleMask * allNSWindowStyleMasks(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END
