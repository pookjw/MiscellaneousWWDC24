#import <UIKit/UIKit.h>

NS_HEADER_AUDIT_BEGIN(nullability, sendability)

API_AVAILABLE(ios(18.0), visionos(2.0))
@interface _UIIntelligenceEdgeLightEffect : UIVisualEffect
@property (nonatomic) NSUInteger activationTransitionDirection;
@property (nonatomic) NSUInteger deactivationTransitionDirection;
- (NSInteger)_expectedUsage;
- (BOOL)_needsUpdateForTransitionFromEnvironment:(id)arg1 toEnvironment:(id)arg2 usage:(NSInteger)usage;
- (void)_updateEffectDescriptor:(id)arg1 forEnvironment:(id)arg2 usage:(NSInteger)usage;
- (id) initWithLightSource:(id)arg1 radius:(double)arg2 region:(unsigned long)arg3;
@end

NS_HEADER_AUDIT_END(nullability, sendability)
