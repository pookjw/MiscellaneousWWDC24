//
//  NSStringFromMKMapElevationStyle.h
//  MiscellaneousMapKit
//
//  Created by Jinwoo Kim on 4/13/25.
//

#import <MapKit/MapKit.h>
#import "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MM_EXTERN NSString * NSStringFromMKMapElevationStyle(MKMapElevationStyle style);
MM_EXTERN MKMapElevationStyle MKMapElevationStyleFromString(NSString *string);
MM_EXTERN const MKMapElevationStyle * allMKMapElevationStyles(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END
