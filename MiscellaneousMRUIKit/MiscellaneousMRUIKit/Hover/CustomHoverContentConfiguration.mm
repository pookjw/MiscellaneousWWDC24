//
//  CustomHoverContentConfiguration.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 2/9/25.
//

#import "CustomHoverContentConfiguration.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface CustomHoverContentView : UIView <UIContentView>
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithConfiguration:(CustomHoverContentConfiguration *)configuration;
@end

@implementation CustomHoverContentConfiguration

- (id)copyWithZone:(struct _NSZone *)zone {
    return [self retain];
}

- (__kindof UIView<UIContentView> *)makeContentView {
    return [[[CustomHoverContentView alloc] initWithConfiguration:self] autorelease];
}

- (instancetype)updatedConfigurationForState:(id<UIConfigurationState>)state {
    return self;
}

@end

@interface CustomHoverContentView ()
@property (retain, nonatomic, readonly, getter=_label) UILabel *label;
@end

@implementation CustomHoverContentView
@synthesize configuration = _configuration;
@synthesize label = _label;

- (instancetype)initWithConfiguration:(CustomHoverContentConfiguration *)configuration {
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
        
        UIHoverGestureRecognizer *gestureRecognizer = [[UIHoverGestureRecognizer alloc] initWithTarget:self action:@selector(_didHover:)];
        [self addGestureRecognizer:gestureRecognizer];
        [self _didHover:gestureRecognizer];
        [gestureRecognizer release];
    }
    
    return self;
}

- (void)dealloc {
    [_configuration release];
    [_label release];
    [super dealloc];
}

- (void)_didHover:(UIHoverGestureRecognizer *)sender {
//    CGFloat altitudeAngle = sender.altitudeAngle;
//    CGVector azimuthUnitVector = [sender azimuthUnitVectorInView:self];
//    CGFloat rollAngle = sender.rollAngle;
//    CGFloat zOffset = sender.zOffset;
//    NSSet<__kindof UIEvent *> *_activeEvents = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(sender, sel_registerName("_activeEvents"));
//    NSSet<UITouch *> *_allActiveTouches = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(sender, sel_registerName("_allActiveTouches"));
//    NSLog(@"%lf %@ %lf %lf", altitudeAngle, NSStringFromCGVector(azimuthUnitVector), rollAngle, zOffset);
    
    CGPoint location = [sender locationInView:self];
    
    switch (sender.state) {
        case UIGestureRecognizerStatePossible:
            self.label.text = [NSString stringWithFormat:@"Possible %@", NSStringFromCGPoint(location)];
            break;
        case UIGestureRecognizerStateBegan:
            self.label.text = [NSString stringWithFormat:@"Began %@", NSStringFromCGPoint(location)];
            break;
        case UIGestureRecognizerStateChanged:
            self.label.text = [NSString stringWithFormat:@"Changed %@", NSStringFromCGPoint(location)];
            break;
        case UIGestureRecognizerStateEnded:
            self.label.text = [NSString stringWithFormat:@"Ended %@", NSStringFromCGPoint(location)];
            break;
        case UIGestureRecognizerStateCancelled:
            self.label.text = [NSString stringWithFormat:@"Cancelled %@", NSStringFromCGPoint(location)];
            break;
        case UIGestureRecognizerStateFailed:
            self.label.text = [NSString stringWithFormat:@"Failed %@", NSStringFromCGPoint(location)];
            break;
        default:
            break;
    }
}

- (BOOL)supportsConfiguration:(id<UIContentConfiguration>)configuration {
    return [configuration isKindOfClass:[CustomHoverContentConfiguration class]];
}

- (UILabel *)_label {
    if (auto label = _label) return label;
    
    UILabel *label = [UILabel new];
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleExtraLargeTitle];
    label.textColor = UIColor.labelColor;
    label.numberOfLines = 0;
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.001;
    
    _label = label;
    return label;
}

@end
