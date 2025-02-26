//
//  NSStringFromNSAlignmentOptions.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/24/25.
//

#import <Cocoa/Cocoa.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MA_EXTERN NSString * NSStringFromNSAlignmentOptions(NSAlignmentOptions options);
MA_EXTERN NSAlignmentOptions NSAlignmentOptionsFromString(NSString *string);
MA_EXTERN const NSAlignmentOptions * allNSAlignmentOptions(NSUInteger * _Nullable count);

MA_EXTERN NSString * NSStringFromNSStringFromNSAlignmentOptionsConvenienceCombinations(NSAlignmentOptions options);
MA_EXTERN NSAlignmentOptions NSAlignmentOptionsConvenienceCombinationsFromString(NSString *string);
MA_EXTERN const NSAlignmentOptions * allNSAlignmentOptionsConvenienceCombinations(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END

