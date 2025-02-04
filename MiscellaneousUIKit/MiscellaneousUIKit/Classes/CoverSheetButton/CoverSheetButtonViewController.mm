//
//  CoverSheetButtonViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 2/4/25.
//

#import "CoverSheetButtonViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface CoverSheetButtonViewController ()

@end

@implementation CoverSheetButtonViewController

- (void)loadView {
    [NSUserDefaults.standardUserDefaults setBool:YES forKey:@"_UIClickInteractionDisableForce"];
    
    NSURL *url = [NSBundle.mainBundle URLForResource:@"beer" withExtension:@"jpg"];
    assert(url != nil);
    UIImage *image = [UIImage imageWithContentsOfFile:url.path];
    assert(image != nil);
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.userInteractionEnabled = YES;
    
    self.view = imageView;
    
    //
    
    __kindof UIControl *leftButton = [objc_lookUpClass("UICoverSheetButton") new];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(leftButton, sel_registerName("setImage:"), [UIImage systemImageNamed:@"flashlight.off.fill"]);
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(leftButton, sel_registerName("setSelectedImage:"), [UIImage systemImageNamed:@"flashlight.off.fill"]);
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(leftButton, sel_registerName("setBackgroundEffectViewGroupName:"), @"_UIKitesterCoverSheetButtonGroup");
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(leftButton, sel_registerName("setSelected:"), YES);
//    [leftButton sizeToFit];
    leftButton.transform = CGAffineTransformMakeTranslation(20., 0.);
    
    //
    
    __kindof UIControl *rightButton = [objc_lookUpClass("UICoverSheetButton") new];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(rightButton, sel_registerName("setImage:"), [UIImage systemImageNamed:@"flashlight.off.fill"]);
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(rightButton, sel_registerName("setSelectedImage:"), [UIImage systemImageNamed:@"flashlight.off.fill"]);
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(rightButton, sel_registerName("setBackgroundEffectViewGroupName:"), @"_UIKitesterCoverSheetButtonGroup");
//    [rightButton sizeToFit];
    rightButton.transform = CGAffineTransformMakeTranslation(-20., 0.);
    
    //
    
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[leftButton, rightButton]];
    [leftButton release];
    [rightButton release];
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.alignment = UIStackViewAlignmentFill;
    stackView.distribution = UIStackViewDistributionFillEqually;
    
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [imageView addSubview:stackView];
    [NSLayoutConstraint activateConstraints:@[
        [stackView.centerXAnchor constraintEqualToAnchor:imageView.centerXAnchor],
        [stackView.centerYAnchor constraintEqualToAnchor:imageView.centerYAnchor],
        [stackView.widthAnchor constraintEqualToConstant:200.],
        [stackView.heightAnchor constraintEqualToConstant:100.]
    ]];
    [stackView release];
    
    //
    
    [imageView release];
}

@end
