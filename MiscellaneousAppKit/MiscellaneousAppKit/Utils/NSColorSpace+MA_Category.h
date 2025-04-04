//
//  NSColorSpace+MA_Category.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/2/25.
//

#import <Cocoa/Cocoa.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MA_EXTERN const NSColorSpaceModel * allNSColorSpaceModels(NSUInteger * _Nullable count);

@interface NSColorSpace (MA_Category)
+ (NSArray<NSColorSpace *> *)ma_allColorSpaces;
@end

NS_ASSUME_NONNULL_END
