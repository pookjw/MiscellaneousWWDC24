//
//  NSStringNSWindowSharingType.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/13/25.
//

#import <Cocoa/Cocoa.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MA_EXTERN NSString * NSStringFromNSWindowSharingType(NSWindowSharingType sharingType);
MA_EXTERN NSWindowSharingType NSWindowSharingTypeFromString(NSString *string);
MA_EXTERN NSWindowSharingType * allNSWindowSharingTypes(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END
