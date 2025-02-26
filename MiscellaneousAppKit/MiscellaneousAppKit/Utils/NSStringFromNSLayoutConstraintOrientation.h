//
//  NSStringFromNSLayoutConstraintOrientation.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/26/25.
//

#import <Cocoa/Cocoa.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MA_EXTERN NSString * NSStringFromNSLayoutConstraintOrientation(NSLayoutConstraintOrientation orientation);
MA_EXTERN NSLayoutConstraintOrientation NSLayoutConstraintOrientationFromString(NSString *string);
MA_EXTERN NSLayoutConstraintOrientation * allNSLayoutConstraintOrientations(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END
