//
//  JitterAnimationViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/23/24.
//

#import "JitterAnimationViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface JitterAnimationViewController ()

@end

@implementation JitterAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    
    UIView *pinkView = [UIView new];
    pinkView.backgroundColor = UIColor.systemPinkColor;
    pinkView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [pinkView.layer addAnimation:((id (*)(Class, SEL, CGFloat))objc_msgSend)(objc_lookUpClass("_UIFloatingTabBarItemView"), sel_registerName("_jitterRotationAnimationWithStrength:"), 1.) forKey:@"RotationJitterAnimation"];
    [pinkView.layer addAnimation:((id (*)(Class, SEL, CGFloat))objc_msgSend)(objc_lookUpClass("_UIFloatingTabBarItemView"), sel_registerName("_jitterXTranslationAnimationWithStrength:"), 1.) forKey:@"XTranslationJitterAnimation"];
    [pinkView.layer addAnimation:((id (*)(Class, SEL, CGFloat))objc_msgSend)(objc_lookUpClass("_UIFloatingTabBarItemView"), sel_registerName("_jitterYTranslationAnimationWithStrength:"), 1.) forKey:@"YTranslationJitterAnimation"];
    
    [self.view addSubview:pinkView];
    [NSLayoutConstraint activateConstraints:@[
        [pinkView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:0.5],
        [pinkView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:0.5],
        [pinkView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [pinkView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor]
    ]];
    [pinkView release];
}

@end
