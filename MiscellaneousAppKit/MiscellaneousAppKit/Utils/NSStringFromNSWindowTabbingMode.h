//
//  NSStringFromNSWindowTabbingMode.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/20/25.
//

#import <Cocoa/Cocoa.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MA_EXTERN NSString * NSStringFromNSWindowTabbingMode(NSWindowTabbingMode mode);
MA_EXTERN NSWindowTabbingMode NSWindowTabbingModeFromString(NSString *string);
MA_EXTERN const NSWindowTabbingMode * allNSWindowTabbingModes(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END
