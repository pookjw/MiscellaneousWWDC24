//
//  NSStringFromNSWindowLevel.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/18/25.
//

#import <Cocoa/Cocoa.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MA_EXTERN NSString * NSStringFromNSWindowLevel(NSWindowLevel level);
MA_EXTERN NSWindowLevel NSWindowLevelFromString(NSString *string);
MA_EXTERN const NSWindowLevel * allNSWindowLevels(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END
