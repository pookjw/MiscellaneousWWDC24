#import <UIKit/UIKit.h>
#import <UIKitPrivate/_UIVisualEffectTransitionDirection.h>
#import <UIKitPrivate/_UIIntelligenceLightSourceDescriptor.h>

NS_HEADER_AUDIT_BEGIN(nullability, sendability)

API_AVAILABLE(ios(18.0), visionos(2.0))
@interface _UIIntelligenceContentLightEffect : UIVisualEffect
@property (nonatomic) _UIVisualEffectTransitionDirection activationTransitionDirection;
@property (nonatomic) _UIVisualEffectTransitionDirection deactivationTransitionDirection;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithLightSource:(_UIIntelligenceLightSourceDescriptor *)source;
- (instancetype)initWithLightSource:(_UIIntelligenceLightSourceDescriptor *)source blurStyle:(UIBlurEffectStyle)blurStyle;
- (instancetype)initWithLightSource:(_UIIntelligenceLightSourceDescriptor *)source lightMaterial:(NSString *)lightMaterial darkMaterial:(NSString *)darkMaterial bundle:(NSBundle *)bundle;
@end

NS_HEADER_AUDIT_END(nullability, sendability)
