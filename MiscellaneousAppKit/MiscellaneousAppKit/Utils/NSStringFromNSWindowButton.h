//
//  NSStringFromNSWindowButton.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/19/25.
//

#import <Cocoa/Cocoa.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MA_EXTERN NSString * NSStringFromNSWindowButton(NSWindowButton button);
MA_EXTERN NSWindowButton NSWindowButtonFromString(NSString *string);
MA_EXTERN const NSWindowButton * allNSWindowButtons(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END

