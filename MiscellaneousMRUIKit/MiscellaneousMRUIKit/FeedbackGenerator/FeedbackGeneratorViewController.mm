//
//  FeedbackGeneratorViewController.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 2/9/25.
//

#import "FeedbackGeneratorViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface FeedbackGeneratorViewController ()
@property (retain, nonatomic, readonly, getter=_label) UILabel *label;
@end

@implementation FeedbackGeneratorViewController
@synthesize label = _label;

- (void)dealloc {
    [_label release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *label = self.label;
    [self.view addSubview:label];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [label.centerXAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.centerXAnchor],
        [label.centerYAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.centerYAnchor]
    ]];
}

- (UILabel *)_label {
    if (auto label = _label) return label;
    
    UILabel *label = [UILabel new];
    label.text = @"Label";
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleExtraLargeTitle];
    label.hoverStyle = [UIHoverStyle styleWithEffect:[UIHoverHighlightEffect effect] shape:[UIShape capsuleShape]];
    
    _label = label;
    return label;
}

@end
