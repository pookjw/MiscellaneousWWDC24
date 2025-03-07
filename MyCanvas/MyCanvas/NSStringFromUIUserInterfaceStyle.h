//
//  NSStringFromUIUserInterfaceStyle.h
//  MyCanvas
//
//  Created by Jinwoo Kim on 3/7/25.
//

#import <UIKit/UIKit.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MC_EXTERN NSString * NSStringFromUIUserInterfaceStyle(UIUserInterfaceStyle style);
MC_EXTERN UIUserInterfaceStyle UIUserInterfaceStyleFromString(NSString *string);
MC_EXTERN const UIUserInterfaceStyle * allUIUserInterfaceStyles(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END
