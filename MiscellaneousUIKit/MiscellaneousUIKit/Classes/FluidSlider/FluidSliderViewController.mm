//
//  FluidSliderViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 2/5/25.
//

#import "FluidSliderViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface FluidSliderViewController ()

@end

@implementation FluidSliderViewController

+ (void)load {
    if (Protocol *_UISliderFluidInteractionDelegate = NSProtocolFromString(@"_UISliderFluidInteractionDelegate")) {
        assert(class_addProtocol(self, _UISliderFluidInteractionDelegate));
    }
}

- (void)loadView {
    UISlider *slider = [UISlider new];
    slider.backgroundColor = UIColor.systemBackgroundColor;
    
    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(slider, sel_registerName("_setSliderStyle:"), 0x6e);
    
    NSObject<NSCopying> *configuration = [objc_lookUpClass("_UISliderFluidConfiguration") new];
    
    UIImageView *minimumImageView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"sun.min"]];
    [minimumImageView sizeToFit];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(configuration, sel_registerName("setMinimumValueView:"), minimumImageView);
    [minimumImageView release];
    
    UIImageView *maximumImageView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"sun.max"]];
    [maximumImageView sizeToFit];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(configuration, sel_registerName("setMaximumValueView:"), maximumImageView);
    [maximumImageView release];
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(configuration, sel_registerName("setDelegate:"), self);
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(slider, sel_registerName("_setSliderConfiguration:"), configuration);
    [configuration release];
    
    self.view = slider;
    [slider release];
}

- (void)_sliderValueChanged:(__kindof UISlider *)sender {
    NSLog(@"%@", sender);
}


#pragma mark - Delegate

- (void)_sliderFluidInteractionWillEnd:(id)arg1 {
    NSLog(@"%s", sel_getName(_cmd));
}

- (void)_sliderFluidInteractionWillBegin:(id)arg1 withLocation:(struct CGPoint)arg2 {
    NSLog(@"%s", sel_getName(_cmd));
}

- (void)_sliderFluidInteractionWillContinue:(id)arg1 withLocation:(struct CGPoint)arg2 {
    NSLog(@"%s", sel_getName(_cmd));
}

- (void)_sliderFluidInteractionWillExtend:(id)arg1 insets:(struct UIEdgeInsets)arg2 {
    NSLog(@"%s", sel_getName(_cmd));
}

- (BOOL)_slider:(id)arg1 shouldBeginDragAtPoint:(struct CGPoint)arg2 {
    NSLog(@"%s", sel_getName(_cmd));
    return YES;
}

- (void)_sliderFluidInteractionDidEnd:(id)arg1 {
    NSLog(@"%s", sel_getName(_cmd));
}

@end
