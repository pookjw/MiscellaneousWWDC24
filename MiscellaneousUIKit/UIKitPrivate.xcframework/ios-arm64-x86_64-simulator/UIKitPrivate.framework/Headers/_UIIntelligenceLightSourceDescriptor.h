#import <UIKitPrivate/_UIIntelligenceLightSourceView.h>

NS_HEADER_AUDIT_BEGIN(nullability, sendability)

API_AVAILABLE(ios(18.0), visionos(2.0))
@interface _UIIntelligenceLightSourceDescriptor : NSObject <NSCopying>
@property (readonly, nonatomic) NSString *identifier;
+ (id)directionalLightWithConfiguration:(id)arg1; // TODO
+ (id)livingLightWithPalette:(id)arg1; // TODO
+ (id)livingLightWithPalette:(id)arg1 seed:(unsigned int)arg2; // TODO
+ (_UIIntelligenceLightSourceDescriptor *)sharedLight;
+ (_UIIntelligenceLightSourceDescriptor *)sharedReactiveLight;
+ (_UIIntelligenceLightSourceDescriptor *)sharedReactiveShimmeringLight;
+ (_UIIntelligenceLightSourceDescriptor *)sharedShimmeringLight;
- (_UIIntelligenceLightSourceView *)_createLightSourceViewWithFrame:(CGRect)frame NS_SWIFT_UI_ACTOR;
- (_UIIntelligenceLightSourceDescriptor *)descriptorWithModificationID:(id)arg1 modifier:(id /* block */)modifier; // TODO
- (instancetype)initWithIdentifier:(id)arg1 lightSourceViewProvider:(id /* block */)arg2; // TODO
@end

NS_HEADER_AUDIT_END(nullability, sendability)
