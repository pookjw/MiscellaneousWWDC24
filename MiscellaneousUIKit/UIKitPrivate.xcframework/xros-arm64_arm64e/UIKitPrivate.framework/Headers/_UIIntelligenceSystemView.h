#import <UIKit/UIKit.h>

NS_HEADER_AUDIT_BEGIN(nullability, sendability)

API_AVAILABLE(ios(18.0), visionos(2.0))
NS_SWIFT_UI_ACTOR
@interface _UIIntelligenceSystemView : UIView
- (instancetype)initWithFrame:(CGRect)frame serviceIdentity:(id /* RBSProcessIdentity * */)serviceIdentity sceneSpecification:(id /* UIApplicationSceneSpecification * */)sceneSpecification;
@end

NS_HEADER_AUDIT_END(nullability, sendability)
