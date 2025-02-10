//
//  HoverEffectLayerContentConfiguration.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 2/10/25.
//

#import "HoverEffectLayerContentConfiguration.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface HoverEffectLayerContentView : UIView <UIContentView>
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithConfiguration:(HoverEffectLayerContentConfiguration *)configuration;
@end

@implementation HoverEffectLayerContentConfiguration

- (id)copyWithZone:(struct _NSZone *)zone {
    return [self retain];
}

- (__kindof UIView<UIContentView> *)makeContentView {
    return [[[HoverEffectLayerContentView alloc] initWithConfiguration:self] autorelease];
}

- (instancetype)updatedConfigurationForState:(id<UIConfigurationState>)state {
    return self;
}

@end

@interface HoverEffectLayerContentView ()
@property (retain, nonatomic, readonly, getter=_hoverEffectLayer) UIHoverEffectLayer *hoverEffectLayer;
@property (retain, nonatomic, readonly, getter=_label) UILabel *label;
@end

@implementation HoverEffectLayerContentView
@synthesize configuration = _configuration;
@synthesize hoverEffectLayer = _hoverEffectLayer;
@synthesize label = _label;

- (instancetype)initWithConfiguration:(HoverEffectLayerContentConfiguration *)configuration {
    if (self = [super init]) {
        UILabel *label = self.label;
        label.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:label];
        [NSLayoutConstraint activateConstraints:@[
            [label.topAnchor constraintGreaterThanOrEqualToAnchor:self.topAnchor],
            [label.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.leadingAnchor],
            [label.trailingAnchor constraintLessThanOrEqualToAnchor:self.trailingAnchor],
            [label.bottomAnchor constraintLessThanOrEqualToAnchor:self.bottomAnchor],
            [label.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
            [label.centerYAnchor constraintEqualToAnchor:self.centerYAnchor]
        ]];
        
        [self.layer addSublayer:self.hoverEffectLayer];
        self.hoverEffectLayer.frame = self.layer.bounds;
        self.configuration = configuration;
    }
    
    return self;
}

- (void)dealloc {
    [_configuration release];
    [_hoverEffectLayer release];
    [_label release];
    [super dealloc];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.hoverEffectLayer.frame = self.layer.bounds;
}

- (void)setConfiguration:(id<UIContentConfiguration>)configuration {
    [_configuration release];
    _configuration = [configuration copyWithZone:NULL];
}

- (UIHoverEffectLayer *)_hoverEffectLayer {
    if (auto hoverEffectLayer = _hoverEffectLayer) return hoverEffectLayer;
    
    UIHoverEffectLayer *hoverEffectLayer = [[UIHoverEffectLayer alloc] initWithContainerView:self style:[UIHoverStyle styleWithEffect:[UIHoverHighlightEffect effect] shape:[UIShape circleShape]]];
    
    NSArray<__kindof CALayer *> *overlaySublayers;
    assert(object_getInstanceVariable(hoverEffectLayer, "overlaySublayers", reinterpret_cast<void **>(&overlaySublayers)) != NULL);
    
    for (__kindof CALayer *sublayer in overlaySublayers) {
        if (![sublayer isKindOfClass:objc_lookUpClass("_UIGlowEffectLayer")]) continue;
        
        reinterpret_cast<void (*)(id, SEL, CGColorRef)>(objc_msgSend)(sublayer, sel_registerName("setTintColor:"), UIColor.redColor.CGColor);
        
        // 둘이 같은듯? 서서히 effect가 사라지는 효과
//        reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(sublayer, sel_registerName("setAutoFadeEnabled:"), YES);
//        reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(sublayer, sel_registerName("setContentRenderingHints:"), 1 << 0);
        
        // ???
//        reinterpret_cast<void (*)(id, SEL, CGFloat, NSUInteger)>(objc_msgSend)(sublayer, sel_registerName("setBrightnessMultiplier:forInputTypes:"), 3., 1);
        
        break;
    }
    
    _hoverEffectLayer = hoverEffectLayer;
    return hoverEffectLayer;
}

- (UILabel *)_label {
    if (auto label = _label) return label;
    
    UILabel *label = [UILabel new];
    label.text = @"UIHoverEffectLayer";
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleExtraLargeTitle];
    label.textColor = UIColor.labelColor;
    label.numberOfLines = 0;
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.001;
    label.textAlignment = NSTextAlignmentCenter;
    
    _label = label;
    return label;
}

@end
