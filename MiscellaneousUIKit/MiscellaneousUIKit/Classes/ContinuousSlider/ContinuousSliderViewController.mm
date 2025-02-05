//
//  ContinuousSliderViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 2/5/25.
//

#import "ContinuousSliderViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>
#include <dlfcn.h>

@interface ContinuousSliderViewController ()
@property (retain, nonatomic, getter=_slider, setter=_setSlider:) __kindof UIControl *slider;
@property (retain, nonatomic, getter=_packageView, setter=_setPackageView:) __kindof UIView *packageView;
@end

@implementation ContinuousSliderViewController

+ (void)load {
    assert(dlopen("/System/Library/PrivateFrameworks/ControlCenterUIKit.framework/ControlCenterUIKit", RTLD_NOW) != NULL);
}

- (void)dealloc {
    [_slider release];
    [_packageView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view = self.view;
    view.backgroundColor = UIColor.systemBackgroundColor;
    
    __kindof UIControl *slider = [objc_lookUpClass("CCUIContinuousSliderView") new];
    
    reinterpret_cast<void (*)(id, SEL, CGFloat)>(objc_msgSend)(slider, sel_registerName("setContinuousSliderCornerRadius:"), 20.);
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(slider, sel_registerName("setValueVisible:"), YES);
//    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(slider, sel_registerName("setName:"), @"Name");
//    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(slider, sel_registerName("setGlyphImage:"), [UIImage systemImageNamed:@"sun.min"]);
    
    // /System/Library/ControlCenter/Bundles/DisplayModule.bundle/Brightness.ca
    id packageDescription = reinterpret_cast<id (*)(Class, SEL, id, id)>(objc_msgSend)(objc_lookUpClass("CCUICAPackageDescription"), sel_registerName("descriptionForPackageNamed:inBundle:"), @"Brightness", NSBundle.mainBundle);
    assert(packageDescription != nil);
    
    __kindof UIView *packageView = [objc_lookUpClass("CCUICAPackageView") new];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(packageView, sel_registerName("setPackageDescription:"), packageDescription);
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(packageView, sel_registerName("ccui_applyGlyphTintColor:"), UIColor.systemPinkColor);
//    reinterpret_cast<void (*)(id, SEL, CGFloat)>(objc_msgSend)(packageView, sel_registerName("ccui_setCompensationAlpha:"), 1.);
    
    UIView *glyphContainerView = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(slider, sel_registerName("glyphContainerView"));
    [glyphContainerView addSubview:packageView];
    packageView.frame = glyphContainerView.bounds;
    packageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [glyphContainerView addSubview:packageView];
    
    self.packageView = packageView;
    [packageView release];
    
    UIView *valueIndicatorClippingView = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(slider, sel_registerName("valueIndicatorClippingView"));
    UILabel *label = [UILabel new];
    label.text = @"Test";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = UIColor.systemBlueColor;
    [valueIndicatorClippingView addSubview:label];
    [label sizeToFit];
    label.frame = valueIndicatorClippingView.bounds;
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [label release];
    
    [slider addTarget:self action:@selector(_didChangeSliderValue:) forControlEvents:UIControlEventValueChanged];
    slider.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:slider];
    [NSLayoutConstraint activateConstraints:@[
        [slider.centerXAnchor constraintEqualToAnchor:view.centerXAnchor],
        [slider.centerYAnchor constraintEqualToAnchor:view.centerYAnchor],
        [slider.widthAnchor constraintEqualToConstant:100.],
        [slider.heightAnchor constraintEqualToConstant:200.]
    ]];
    
    //
    
    UIBarButtonItem *axisBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Axis" style:UIBarButtonItemStylePlain target:self action:@selector(_didTriggerAxisBarButtonItem:)];
    self.navigationItem.rightBarButtonItem = axisBarButtonItem;
    [axisBarButtonItem release];
    
    //
    
    self.slider = slider;
    [slider release];
}

- (void)_didTriggerAxisBarButtonItem:(UIBarButtonItem *)sender {
    NSUInteger axis = reinterpret_cast<NSUInteger (*)(id, SEL)>(objc_msgSend)(self.slider, sel_registerName("axis"));
    
    if (axis == 2) {
        reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(self.slider, sel_registerName("setAxis:"), 1);
    } else {
        reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(self.slider, sel_registerName("setAxis:"), 2);
    }
}

- (void)_didChangeSliderValue:(__kindof UIControl *)sender {
    float value = reinterpret_cast<float (*)(id, SEL)>(objc_msgSend)(sender, sel_registerName("value"));
    NSLog(@"%lf", value);
    
    if (value <= (1.f / 3.f)) {
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self.packageView, sel_registerName("setStateName:"), @"min");
    } else if (value <= (2.f / 3.f)) {
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self.packageView, sel_registerName("setStateName:"), @"mid");
    } else {
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self.packageView, sel_registerName("setStateName:"), @"max");
    }
}

@end
