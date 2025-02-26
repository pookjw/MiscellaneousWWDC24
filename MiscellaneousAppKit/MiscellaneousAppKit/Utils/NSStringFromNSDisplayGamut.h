//
//  NSStringFromNSDisplayGamut.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/27/25.
//

#import <Cocoa/Cocoa.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MA_EXTERN NSString * NSStringFromNSDisplayGamut(NSDisplayGamut gamut);
MA_EXTERN NSDisplayGamut NSDisplayGamutFromString(NSString *string);
MA_EXTERN const NSDisplayGamut * allNSDisplayGamuts(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END

