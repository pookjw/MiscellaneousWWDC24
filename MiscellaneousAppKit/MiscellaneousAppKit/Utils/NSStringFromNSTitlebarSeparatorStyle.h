//
//  NSStringFromNSTitlebarSeparatorStyle.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/20/25.
//

#import <Cocoa/Cocoa.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MA_EXTERN NSString * NSStringFromNSTitlebarSeparatorStyle(NSTitlebarSeparatorStyle style);
MA_EXTERN NSTitlebarSeparatorStyle NSTitlebarSeparatorStyleFromString(NSString *string);
MA_EXTERN const NSTitlebarSeparatorStyle * allNSTitlebarSeparatorStyles(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END

