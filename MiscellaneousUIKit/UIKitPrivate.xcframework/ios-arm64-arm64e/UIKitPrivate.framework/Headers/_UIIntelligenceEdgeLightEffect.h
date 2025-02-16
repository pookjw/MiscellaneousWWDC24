#import <UIKit/UIKit.h>
#import <UIKitPrivate/_UIVisualEffectTransitionDirection.h>

NS_HEADER_AUDIT_BEGIN(nullability, sendability)

API_AVAILABLE(ios(18.0), visionos(2.0))
@interface _UIIntelligenceEdgeLightEffect : UIVisualEffect
@property (nonatomic) _UIVisualEffectTransitionDirection activationTransitionDirection;
@property (nonatomic) _UIVisualEffectTransitionDirection deactivationTransitionDirection;
- (NSInteger)_expectedUsage;
- (BOOL)_needsUpdateForTransitionFromEnvironment:(id)arg1 toEnvironment:(id)arg2 usage:(NSInteger)usage;
- (void)_updateEffectDescriptor:(id)arg1 forEnvironment:(id)arg2 usage:(NSInteger)usage;
@end

NS_HEADER_AUDIT_END(nullability, sendability)
