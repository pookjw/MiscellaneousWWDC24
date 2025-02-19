//
//  NSStringFromNSLayoutAttribute.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/20/25.
//

#import <Cocoa/Cocoa.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MA_EXTERN NSString * NSStringFromNSLayoutAttribute(NSLayoutAttribute attribute);
MA_EXTERN NSLayoutAttribute NSLayoutAttributeFromString(NSString *string);
MA_EXTERN NSLayoutAttribute * allNSLayoutAttributes(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END
