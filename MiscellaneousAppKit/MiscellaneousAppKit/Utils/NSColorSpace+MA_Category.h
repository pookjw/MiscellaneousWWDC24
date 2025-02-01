//
//  NSColorSpace+MA_Category.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/2/25.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSColorSpace (MA_Category)
+ (NSArray<NSColorSpace *> *)ma_allColorSpaces;
@end

NS_ASSUME_NONNULL_END
