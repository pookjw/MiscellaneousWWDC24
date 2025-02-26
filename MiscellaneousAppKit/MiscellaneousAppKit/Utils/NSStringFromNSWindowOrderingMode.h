//
//  NSStringFromNSWindowOrderingMode.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/19/25.
//

#import <Cocoa/Cocoa.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MA_EXTERN NSString * NSStringFromNSWindowOrderingMode(NSWindowOrderingMode mode);
MA_EXTERN NSWindowOrderingMode NSWindowOrderingModeFromString(NSString *string);
MA_EXTERN const NSWindowOrderingMode * allNSWindowOrderingModes(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END
