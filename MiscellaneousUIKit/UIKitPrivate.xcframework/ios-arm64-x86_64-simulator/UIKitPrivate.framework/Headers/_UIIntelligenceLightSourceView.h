#import <UIKit/UIKit.h>
#import <UIKitPrivate/_UIIntelligenceLightSourceConfiguration.h>

NS_HEADER_AUDIT_BEGIN(nullability, sendability)

API_AVAILABLE(ios(18.0), visionos(2.0))
NS_SWIFT_UI_ACTOR
@interface _UIIntelligenceLightSourceView : UIView
- (void)updateConfiguration:(_UIIntelligenceLightSourceConfiguration *)configuration;
- (instancetype)initWithFrame:(CGRect)frame configuration:(_UIIntelligenceLightSourceConfiguration *)configuration;
- (instancetype)initWithFrame:(CGRect)frame preferAudioReactivity:(BOOL)preferAudioReactivity;
@end

NS_HEADER_AUDIT_END(nullability, sendability)
