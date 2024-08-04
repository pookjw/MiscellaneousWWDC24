//
//  StatusBarAlphaViewController.m
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 8/4/24.
//

#import "StatusBarAlphaViewController.h"
#import <UIKit/UIKit.h>
#import <objc/message.h>
#import <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

@implementation StatusBarAlphaViewController

+ (void)load {
    [self dynamicIsa];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [[self dynamicIsa] allocWithZone:zone];
}

+ (Class)dynamicIsa {
    static Class dynamicIsa;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class _dynamicIsa = objc_allocateClassPair(objc_lookUpClass("SPViewController"), "_StatusBarAlphaViewController", 0);
        
        IMP description = class_getMethodImplementation(self, @selector(description));
        assert(class_addMethod(_dynamicIsa, @selector(description), description, NULL));
        
        IMP loadView = class_getMethodImplementation(self, @selector(loadView));
        assert(class_addMethod(_dynamicIsa, @selector(loadView), loadView, NULL));
        
        IMP puicSliderValueChanged = class_getMethodImplementation(self, @selector(puicSliderValueChanged:));
        assert(class_addMethod(_dynamicIsa, @selector(puicSliderValueChanged:), puicSliderValueChanged, NULL));
        
        IMP puic_statusBarAlpha = class_getMethodImplementation(self, @selector(puic_statusBarAlpha));
        assert(class_addMethod(_dynamicIsa, @selector(puic_statusBarAlpha), puic_statusBarAlpha, NULL));
        
        assert(class_addIvar(_dynamicIsa, "_mpu_puic_statusBarAlpha", sizeof(CGFloat), sizeof(CGFloat), @encode(CGFloat)));
        
        //
        
        dynamicIsa = _dynamicIsa;
    });
    
    return dynamicIsa;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%s: %p>", class_getName(self.class), self];
}

- (void)loadView {
    // sliderStyle
    //  - 0 : Default
    //  - 1 : Step
    //  - 2 : Circular
    id puicSlider = reinterpret_cast<id (*)(id, SEL, NSInteger)>(objc_msgSend)([objc_lookUpClass("PUICSlider") alloc], sel_registerName("initWithSliderStyle:"), 1);
    
    reinterpret_cast<void (*)(id, SEL, float)>(objc_msgSend)(puicSlider, sel_registerName("setMinimumValue:"), 0.f);
    reinterpret_cast<void (*)(id, SEL, float)>(objc_msgSend)(puicSlider, sel_registerName("setMaximumValue:"), 1.f);
    reinterpret_cast<void (*)(id, SEL, id, SEL, NSUInteger)>(objc_msgSend)(puicSlider, sel_registerName("addTarget:action:forControlEvents:"), self, @selector(puicSliderValueChanged:), 1 << 12);
    reinterpret_cast<void (*)(id, SEL, float, BOOL)>(objc_msgSend)(puicSlider, sel_registerName("setValue:animated:"), 0.5f, NO);
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(puicSlider, sel_registerName("setDelegate:"), self);
    
    UIImage *minusImage = [UIImage systemImageNamed:@"minus"];
    id minimumValueView = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("UIImageView") alloc], sel_registerName("initWithImage:"), minusImage);
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(puicSlider, sel_registerName("setMinimumValueView:"), minimumValueView);
    [minimumValueView release];
    
    UIImage *plusImage = [UIImage systemImageNamed:@"plus"];
    id maximumValueView = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("UIImageView") alloc], sel_registerName("initWithImage:"), plusImage);
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(puicSlider, sel_registerName("setMaximumValueView:"), maximumValueView);
    [maximumValueView release];
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setView:"), puicSlider);
    [puicSlider release];
}

- (void)puicSliderValueChanged:(id)sender {
    float value = reinterpret_cast<float (*)(id, SEL)>(objc_msgSend)(sender, sel_registerName("value"));
    
    Ivar ivar = object_getInstanceVariable(self, "_mpu_puic_statusBarAlpha", NULL);
    *reinterpret_cast<CGFloat *>((reinterpret_cast<uintptr_t>(self) + ivar_getOffset(ivar))) = value;
    
    id view = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("view"));
    id window = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(view, sel_registerName("window"));
    id windowScene = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(window, sel_registerName("windowScene"));
    id statusBarManager = ((id (*)(id, SEL))objc_msgSend)(windowScene, NSSelectorFromString(@"statusBarManager"));
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(statusBarManager, NSSelectorFromString(@"_updateStatusBarAppearanceSceneSettingsWithAnimationParameters:"), nil);
}

- (CGFloat)puic_statusBarAlpha {
    CGFloat _mpu_puic_statusBarAlpha;
    object_getInstanceVariable(self, "_mpu_puic_statusBarAlpha", reinterpret_cast<void **>(&_mpu_puic_statusBarAlpha));
    NSLog(@"%lf", _mpu_puic_statusBarAlpha);
    return _mpu_puic_statusBarAlpha;
}

@end
