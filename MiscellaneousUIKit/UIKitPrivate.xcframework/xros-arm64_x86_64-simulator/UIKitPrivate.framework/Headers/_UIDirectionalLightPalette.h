#import <UIKit/UIKit.h>

NS_HEADER_AUDIT_BEGIN(nullability, sendability)

API_AVAILABLE(ios(18.0), visionos(2.0))
@interface _UIDirectionalLightPalette : NSObject
@property (class, nonatomic, readonly) _UIDirectionalLightPalette* pondering;
@property (class, nonatomic, readonly) _UIDirectionalLightPalette* replaceBuildOut;
@property (class, nonatomic, readonly) _UIDirectionalLightPalette* replaceBuildIn;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithColors:(NSArray<UIColor *> *)colors;
- (instancetype)initWithColors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations;
@end

NS_HEADER_AUDIT_END(nullability, sendability)
