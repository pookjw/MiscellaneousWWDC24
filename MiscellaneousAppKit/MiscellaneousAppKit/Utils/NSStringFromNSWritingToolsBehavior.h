//
//  NSStringFromNSWritingToolsBehavior.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/23/25.
//

#import <Cocoa/Cocoa.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MA_EXTERN NSString * NSStringFromNSWritingToolsBehavior(NSWritingToolsBehavior behavior);
MA_EXTERN NSWritingToolsBehavior NSWritingToolsBehaviorFromString(NSString *string);
MA_EXTERN const NSWritingToolsBehavior * allNSWritingToolsBehaviors(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END
