//
//  TimeOffsetInputViewController.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 8/3/24.
//

#import "TimeOffsetInputViewController.h"
#import <UIKit/UIKit.h>
#import <objc/message.h>
#import <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

@implementation TimeOffsetInputViewController

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
        Class _dynamicIsa = objc_allocateClassPair(objc_lookUpClass("SPViewController"), "_TimeOffsetInputViewController", 0);
        
        IMP respondsToSelector = class_getMethodImplementation(self, @selector(respondsToSelector:));
        assert(class_addMethod(_dynamicIsa, @selector(respondsToSelector:), respondsToSelector, NULL));
        
        IMP loadView = class_getMethodImplementation(self, @selector(loadView));
        assert(class_addMethod(_dynamicIsa, @selector(loadView), loadView, NULL));
        
        IMP valueChanged = class_getMethodImplementation(self, @selector(valueChanged));
        assert(class_addMethod(_dynamicIsa, @selector(valueChanged), valueChanged, NULL));
        
        IMP setButtonTapped = class_getMethodImplementation(self, @selector(setButtonTapped:));
        assert(class_addMethod(_dynamicIsa, @selector(setButtonTapped:), setButtonTapped, NULL));
        
        IMP cancelButtonTapped = class_getMethodImplementation(self, @selector(cancelButtonTapped:));
        assert(class_addMethod(_dynamicIsa, @selector(cancelButtonTapped:), cancelButtonTapped, NULL));
        
        objc_registerClassPair(_dynamicIsa);
        
        dynamicIsa = _dynamicIsa;
    });
    
    return dynamicIsa;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    objc_super superInfo = { self, [self class] };
    BOOL responds = reinterpret_cast<BOOL (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
    
    if (!responds) {
        NSLog(@"%s", sel_getName(aSelector));
    }
    
    return responds;
}

- (void)loadView {
    /*
     구조
     - PUICWheelsOfTimeDialView : Dial만 있는 View
     - PUICWheelsOfTimeView : Dial과 Button이 있는 View
     - PUICTimeOffsetInputView : Dial과 Button과 Digital Crown을 통해 입력받아서 분(Minute)을 선택할 수 있는 View
     */
    id timeOffsetInputView = reinterpret_cast<id (*)(id, SEL, CGRect, id)>(objc_msgSend)([objc_lookUpClass("PUICTimeOffsetInputView") alloc], sel_registerName("initWithFrame:accentColor:"), CGRectNull, UIColor.cyanColor);
    
    //
    
    __weak id weakView = timeOffsetInputView;
    id action = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("UIAction"), sel_registerName("actionWithHandler:"), ^(id) {
        id unwrapped = weakView;
        assert(unwrapped != nil);
        
        NSTimeInterval duration = reinterpret_cast<NSTimeInterval (*)(id, SEL)>(objc_msgSend)(unwrapped, sel_registerName("duration"));
        NSLog(@"%lf", duration);
    });
    
    id primaryButton = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(timeOffsetInputView, sel_registerName("primaryButton"));
    reinterpret_cast<void (*)(id, SEL, id, NSUInteger)>(objc_msgSend)(primaryButton, sel_registerName("addAction:forControlEvents:"), action, 1 << 13);
    
    id secondaryButton = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(timeOffsetInputView, sel_registerName("secondaryButton"));
    reinterpret_cast<void (*)(id, SEL, id, NSUInteger)>(objc_msgSend)(secondaryButton, sel_registerName("addAction:forControlEvents:"), action, 1 << 13);
    
    //
    
    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(timeOffsetInputView, sel_registerName("setOffset:"), 10);
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(timeOffsetInputView, sel_registerName("setDelegate:"), self);
    
    //
    
    id dialView = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(timeOffsetInputView, sel_registerName("dialView"));
    
    //  - 0 : 0~12
    //  - 1 : 0~24
    //  - 2 : 0~60
    reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(dialView, sel_registerName("setStyle:"), 2);
    
    //
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setView:"), timeOffsetInputView);
    [timeOffsetInputView release];
}

- (void)valueChanged {
    // Not called
    NSLog(@"%s", __func__);
}

- (void)setButtonTapped:(id)timeOffsetInputView {
    NSLog(@"%s", __func__);
}

- (void)cancelButtonTapped:(id)timeOffsetInputView {
    NSLog(@"%s", __func__);
}

@end
