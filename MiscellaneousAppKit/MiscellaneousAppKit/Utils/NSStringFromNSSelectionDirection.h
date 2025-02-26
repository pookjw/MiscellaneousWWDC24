//
//  NSStringFromNSSelectionDirection.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/21/25.
//

#import <Cocoa/Cocoa.h>

#import <Cocoa/Cocoa.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MA_EXTERN NSString * NSStringFromNSSelectionDirection(NSSelectionDirection direction);
MA_EXTERN NSSelectionDirection NSSelectionDirectionFromString(NSString *string);
MA_EXTERN const NSSelectionDirection * allNSSelectionDirections(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END
