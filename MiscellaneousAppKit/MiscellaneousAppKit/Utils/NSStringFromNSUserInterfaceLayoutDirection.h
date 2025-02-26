//
//  NSStringFromNSUserInterfaceLayoutDirection.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/20/25.
//

#import <Cocoa/Cocoa.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MA_EXTERN NSString * NSStringFromNSUserInterfaceLayoutDirection(NSUserInterfaceLayoutDirection direction);
MA_EXTERN NSUserInterfaceLayoutDirection NSUserInterfaceLayoutDirectionFromString(NSString *string);
MA_EXTERN const NSUserInterfaceLayoutDirection * allNSUserInterfaceLayoutDirections(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END
