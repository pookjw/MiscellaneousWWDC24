//
//  NSStringFromNSWindowNumberListOptions.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/13/25.
//

#import <Cocoa/Cocoa.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MA_EXTERN NSString * NSStringFromNSWindowNumberListOptions(NSWindowNumberListOptions options);
MA_EXTERN NSWindowNumberListOptions NSWindowNumberListOptionsFromString(NSString *string);
MA_EXTERN NSWindowNumberListOptions * allNSWindowNumberListOptions(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END
