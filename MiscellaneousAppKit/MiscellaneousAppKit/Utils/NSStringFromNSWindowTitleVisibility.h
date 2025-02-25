//
//  NSStringFromNSWindowTitleVisibility.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/25/25.
//

#import <Cocoa/Cocoa.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MA_EXTERN NSString * NSStringFromNSWindowTitleVisibility(NSWindowTitleVisibility visibility);
MA_EXTERN NSWindowTitleVisibility NSWindowTitleVisibilityFromString(NSString *string);
MA_EXTERN NSWindowTitleVisibility * allNSWindowTitleVisibilities(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END
