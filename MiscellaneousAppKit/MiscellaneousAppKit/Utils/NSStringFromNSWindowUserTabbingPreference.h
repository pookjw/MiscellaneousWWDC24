//
//  NSStringFromNSWindowUserTabbingPreference.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/20/25.
//

#import <Cocoa/Cocoa.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MA_EXTERN NSString * NSStringFromNSWindowUserTabbingPreference(NSWindowUserTabbingPreference preference);
MA_EXTERN NSWindowUserTabbingPreference NSWindowUserTabbingPreferenceFromString(NSString *string);
MA_EXTERN const NSWindowUserTabbingPreference * allNSWindowUserTabbingPreferences(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END
