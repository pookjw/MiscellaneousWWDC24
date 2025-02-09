//
//  HoverContentConfiguration.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 2/9/25.
//

#import "HoverContentConfiguration.h"

@interface HoverContentView : UIView <UIContentView>
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithConfiguration:(HoverContentConfiguration *)configuration;
@end

@interface HoverContentConfiguration ()
@property (copy, nonatomic, readonly, getter=_title) NSString *title;
@property (copy, nonatomic, readonly, getter=_hoverStyle) UIHoverStyle *hoverStyle;
@end

@implementation HoverContentConfiguration

- (instancetype)initWithTitle:(NSString *)title hoverStyle:(UIHoverStyle *)hoverStyle {
    if (self = [super init]) {
        _title = [title copy];
        _hoverStyle = [hoverStyle copy];
    }
    
    return self;
}

- (void)dealloc {
    [_title release];
    [_hoverStyle release];
    [super dealloc];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [self retain];
}

- (nonnull __kindof UIView<UIContentView> *)makeContentView { 
    return [[[HoverContentView alloc] initWithConfiguration:self] autorelease];
}

- (nonnull instancetype)updatedConfigurationForState:(nonnull id<UIConfigurationState>)state { 
    return self;
}

@end

@interface HoverContentView ()
@property (retain, nonatomic, readonly, getter=_label) UILabel *label;
@end

@implementation HoverContentView
@synthesize configuration = _configuration;
@synthesize label = _label;

- (instancetype)initWithConfiguration:(HoverContentConfiguration *)configuration {
    if (self = [super initWithFrame:CGRectNull]) {
        self.configuration = configuration;
        
        // 이게 있어야 Hover가 됨. 기본이 YES이긴 하지만
        self.userInteractionEnabled = YES;
        
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
    }
    
    return self;
}

- (void)dealloc {
    [_configuration release];
    [_label release];
    [super dealloc];
}

- (void)setConfiguration:(id<UIContentConfiguration>)configuration {
    [_configuration release];
    _configuration = [configuration copyWithZone:NULL];
    
    self.label.text = static_cast<HoverContentConfiguration *>(configuration).title;
    self.hoverStyle = static_cast<HoverContentConfiguration *>(configuration).hoverStyle;
}

- (BOOL)supportsConfiguration:(id<UIContentConfiguration>)configuration {
    return [configuration isKindOfClass:[HoverContentConfiguration class]];
}

- (UILabel *)_label {
    if (auto label = _label) return label;
    
    UILabel *label = [UILabel new];
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
