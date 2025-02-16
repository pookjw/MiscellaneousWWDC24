#import <UIKitPrivate/_UIIntelligenceLightSourceView.h>
#import <UIKitPrivate/_UIColorPalette.h>
#import <UIKitPrivate/_UIDirectionalLightConfiguration.h>

NS_HEADER_AUDIT_BEGIN(nullability, sendability)

API_AVAILABLE(ios(18.0), visionos(2.0))
@interface _UIIntelligenceLightSourceDescriptor : NSObject <NSCopying>
@property (readonly, nonatomic) NSString *identifier;
+ (_UIIntelligenceLightSourceDescriptor *)directionalLightWithConfiguration:(_UIDirectionalLightConfiguration *)configuration;
+ (_UIIntelligenceLightSourceDescriptor *)livingLightWithPalette:(_UIColorPalette *)palette;
+ (_UIIntelligenceLightSourceDescriptor *)livingLightWithPalette:(_UIColorPalette *)palette seed:(NSUInteger)seed;
+ (_UIIntelligenceLightSourceDescriptor *)sharedLight;
+ (_UIIntelligenceLightSourceDescriptor *)sharedReactiveLight;
+ (_UIIntelligenceLightSourceDescriptor *)sharedReactiveShimmeringLight;
+ (_UIIntelligenceLightSourceDescriptor *)sharedShimmeringLight;
- (UIView *)_createLightSourceViewWithFrame:(CGRect)frame NS_SWIFT_UI_ACTOR;
- (_UIIntelligenceLightSourceDescriptor *)descriptorWithModificationID:(NSString *)modificationID modifier:(UIView * (^)(UIView *lightSourceView))modifier;
- (instancetype)initWithIdentifier:(NSString *)identifier lightSourceViewProvider:(UIView * (^)(CGRect frame))provider;
@end

NS_HEADER_AUDIT_END(nullability, sendability)
