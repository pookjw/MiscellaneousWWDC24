//
//  PrototypingMenuSliderViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 2/8/25.
//

// _UIPrototypingMenuSlider

#import "PrototypingMenuSliderViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface PrototypingMenuSliderViewController ()
@property (retain, nonatomic, readonly, getter=_slider) __kindof UISlider *slider;
@property (retain, nonatomic, readonly, getter=_imageView) UIImageView *imageView;
@property (retain, nonatomic, readonly, getter=_systemImageView) UIImageView *systemImageView;
@end

@implementation PrototypingMenuSliderViewController
@synthesize slider = _slider;
@synthesize imageView = _imageView;
@synthesize systemImageView = _systemImageView;

- (void)dealloc {
    [_slider release];
    [_imageView release];
    [_systemImageView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageView = self.imageView;
    [self.view addSubview:imageView];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self.view, sel_registerName("_addBoundsMatchingConstraintsForView:"), imageView);
    
    __kindof UISlider *slider = self.slider;
    slider.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:slider];
    [NSLayoutConstraint activateConstraints:@[
        [slider.centerYAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.centerYAnchor],
        [slider.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [slider.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor]
    ]];
    
    UIImageView *systemImageView = self.systemImageView;
    systemImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:systemImageView];
    [NSLayoutConstraint activateConstraints:@[
        [systemImageView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [systemImageView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
        [systemImageView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
    ]];
    
    //
    
    UIBarButtonItem *menuBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"line.3.horizontal"] menu:[self _makeMenu]];
    self.navigationItem.rightBarButtonItem = menuBarButtonItem;
    [menuBarButtonItem release];
}

- (__kindof UISlider *)_slider {
    if (auto slider = _slider) return slider;
    
    __kindof UISlider *slider = [objc_lookUpClass("_UIPrototypingMenuSlider") new];
    
    // https://x.com/_silgen_name/status/1888092751402778876
//    slider.continuous = YES;
    
    [slider addTarget:self action:@selector(_sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    // `-[_UIPrototypingMenuSlider setKnobPortal:]` (with nil) is called when touch up
    __kindof UIView *knobPortal = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("_UIPortalView") alloc], sel_registerName("initWithSourceView:"), self.systemImageView);
    
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(knobPortal, sel_registerName("setHidesSourceView:"), YES);
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(knobPortal, sel_registerName("setMatchesPosition:"), NO);
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(knobPortal, sel_registerName("setMatchesTransform:"), NO);
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(slider, sel_registerName("setKnobPortal:"), knobPortal);
    [knobPortal release];
    
    reinterpret_cast<void (*)(id, SEL, double)>(objc_msgSend)(slider, sel_registerName("setStepSize:"), 0.1);
    
    _slider = slider;
    return slider;
}

- (UIImageView *)_imageView {
    if (auto imageView = _imageView) return imageView;
    
    NSURL *url = [NSBundle.mainBundle URLForResource:@"beer" withExtension:@"jpg"];
    assert(url != nil);
    UIImage *image = [UIImage imageWithContentsOfFile:url.path];
    assert(image != nil);
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    _imageView = imageView;
    return imageView;
}

- (UIImageView *)_systemImageView {
    if (auto systemImageView = _systemImageView) return systemImageView;
    
    UIImageView *systemImageView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"eraser.fill"]];
    systemImageView.contentMode = UIViewContentModeScaleAspectFit;
    systemImageView.tintColor = UIColor.systemRedColor;
    systemImageView.backgroundColor = UIColor.whiteColor;
    
    _systemImageView = systemImageView;
    return systemImageView;
}

- (void)_sliderValueChanged:(__kindof UISlider *)sender {
    
}

- (UIMenu *)_makeMenu {
    __kindof UISlider *slider = self.slider;
    
    UIAction *decrementAction = [UIAction actionWithTitle:@"Decrement" image:[UIImage systemImageNamed:@"minus"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(slider, sel_registerName("decrement"));
    }];
    
    UIAction *incrementAction = [UIAction actionWithTitle:@"Increment" image:[UIImage systemImageNamed:@"plus"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(slider, sel_registerName("increment"));
    }];
    
    UIMenu *menu = [UIMenu menuWithTitle:@"" image:nil identifier:nil options:UIMenuOptionsDisplayAsPalette children:@[decrementAction, incrementAction]];
    return menu;
}

@end
