#import <UIKit/UIKit.h>
#import <UIKitPrivate/_UIKBLightEffectsBackground.h>
#import <UIKitPrivate/UIKBRenderConfig.h>

NS_HEADER_AUDIT_BEGIN(nullability, sendability)

API_AVAILABLE(ios(18.0), visionos(2.0))
NS_SWIFT_UI_ACTOR
@interface UIKeyboardLayoutGuide (LightEffects)
@property (retain, nonatomic) __kindof UIView * /* _UIKBLightEffectsBackground * */lightEffectsBackdrop;
- (void)hideLightEffectsView:(BOOL)animated;
- (__kindof UIView * /* _UIKBLightEffectsBackground * */)lightEffectsBackdrop;
- (void)removeLightEffectsView;
- (void)setLightEffectsBackdrop:(__kindof UIView * /* _UIKBLightEffectsBackground * */)lightEffectsBackdrop;
- (BOOL)updateLightEffectsRenderConfig:(UIKBRenderConfig *)config animated:(BOOL)config;
- (void)useLightEffectsBackgroundBelowView:(UIView *)view;
@end

NS_HEADER_AUDIT_END(nullability, sendability)
