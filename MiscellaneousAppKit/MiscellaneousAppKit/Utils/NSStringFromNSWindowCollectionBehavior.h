//
//  NSStringFromNSWindowCollectionBehavior.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/2/25.
//

#import <Cocoa/Cocoa.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MA_EXTERN NSString * NSStringFromNSWindowCollectionBehavior(NSWindowCollectionBehavior collectionBehavior);
MA_EXTERN NSWindowCollectionBehavior NSWindowCollectionBehaviorFromString(NSString *string);
MA_EXTERN NSWindowCollectionBehavior *allNSWindowCollectionBehaviors(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END
