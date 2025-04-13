//
//  NSStringFromMKUserTrackingMode.h
//  MiscellaneousMapKit
//
//  Created by Jinwoo Kim on 4/13/25.
//

#import <MapKit/MapKit.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MM_EXTERN NSString * NSStringFromMKUserTrackingMode(MKUserTrackingMode mode);
MM_EXTERN MKUserTrackingMode MKUserTrackingModeFromString(NSString *string);
MM_EXTERN const MKUserTrackingMode * allMKUserTrackingModes(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END
