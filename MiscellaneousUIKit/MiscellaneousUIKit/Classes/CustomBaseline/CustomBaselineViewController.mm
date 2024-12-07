//
//  CustomBaselineViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 9/19/24.
//

#import "CustomBaselineViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface CustomBaselineView_1 : UIView
@property (retain, nonatomic, readonly) UIView *orangeView;
@end
@implementation CustomBaselineView_1
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.systemRedColor;
        UIView *orangeView = [UIView new];
        orangeView.backgroundColor = UIColor.systemOrangeColor;
        orangeView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:orangeView];
        [NSLayoutConstraint activateConstraints:@[
            [orangeView.topAnchor constraintEqualToAnchor:self.centerYAnchor],
            [orangeView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [orangeView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
            [orangeView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
        ]];
        _orangeView = orangeView;
    }
    return self;
}
- (void)dealloc {
    [_orangeView release];
    [super dealloc];
}

//- (CGPoint)_baselineOffsetsAtSize:(CGSize)size {
//    return CGPointMake(100., 100.);
//}

- (CGSize)intrinsicContentSize {
    return self.superview.bounds.size;
}

- (BOOL)_hasBaseline {
    return YES;
}

- (UIView *)viewForFirstBaselineLayout {
    return self.orangeView;
}

- (UIView *)viewForLastBaselineLayout {
    return self.orangeView;
}

@end

@interface CustomBaselineViewController ()
@property (retain, nonatomic, readonly) UIStackView *stackView;
@property (retain, nonatomic, readonly) CustomBaselineView_1 *customBaselineView_1;
@property (retain, nonatomic, readonly) UILabel *label_1;
@end

@implementation CustomBaselineViewController
@synthesize stackView = _stackView;
@synthesize customBaselineView_1 = _customBaselineView_1;
@synthesize label_1 = _label_1;

- (void)dealloc {
    [_stackView release];
    [_customBaselineView_1 release];
    [_label_1 release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.stackView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.systemBackgroundColor;
}

- (UIStackView *)stackView {
    if (auto stackView = _stackView) return stackView;
    
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[
        self.customBaselineView_1,
        self.label_1
    ]];
    
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.distribution = UIStackViewDistributionFillEqually;
    stackView.alignment = UIStackViewAlignmentFirstBaseline;
//    stackView.alignment = UIStackViewAlignmentLastBaseline;
    
    _stackView = [stackView retain];
    return [stackView autorelease];
}

- (CustomBaselineView_1 *)customBaselineView_1 {
    if (auto customBaselineView_1 = _customBaselineView_1) return customBaselineView_1;
    
    CustomBaselineView_1 *customBaselineView_1 = [CustomBaselineView_1 new];
    
    _customBaselineView_1 = [customBaselineView_1 retain];
    return [customBaselineView_1 autorelease];
}

- (UILabel *)label_1 {
    if (auto label_1 = _label_1) return label_1;
    
    UILabel *label_1 = [UILabel new];
    label_1.numberOfLines = 0;
    label_1.backgroundColor = UIColor.systemCyanColor;
    label_1.textColor = UIColor.systemOrangeColor;
    label_1.font = [UIFont preferredFontForTextStyle:UIFontTextStyleLargeTitle];
    label_1.text = @"HelloHelloHelloHelloHelloHelloHelloHelloHello";
    
    _label_1 = [label_1 retain];
    return [label_1 autorelease];
}

@end
