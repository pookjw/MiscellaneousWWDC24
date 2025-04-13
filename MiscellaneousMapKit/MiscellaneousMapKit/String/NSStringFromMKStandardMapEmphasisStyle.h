//
//  NSStringFromMKStandardMapEmphasisStyle.h
//  MiscellaneousMapKit
//
//  Created by Jinwoo Kim on 4/14/25.
//

#import <MapKit/MapKit.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MM_EXTERN NSString * NSStringFromMKStandardMapEmphasisStyle(MKStandardMapEmphasisStyle style);
MM_EXTERN MKStandardMapEmphasisStyle MKStandardMapEmphasisStyleFromString(NSString *string);
MM_EXTERN const MKStandardMapEmphasisStyle * allMKStandardMapEmphasisStyles(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END
