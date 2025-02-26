//
//  NSStringFromNSWindowToolbarStyle.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/20/25.
//

#import <Cocoa/Cocoa.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MA_EXTERN NSString * NSStringFromNSWindowToolbarStyle(NSWindowToolbarStyle style);
MA_EXTERN NSWindowToolbarStyle NSWindowToolbarStyleFromString(NSString *string);
MA_EXTERN const NSWindowToolbarStyle * allNSWindowToolbarStyles(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END
