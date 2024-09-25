//
//  MyAVSlider.m
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 8/5/24.
//

#import "MyAVSlider.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

@implementation MyAVSlider

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
        Class _dynamicIsa = objc_allocateClassPair(objc_lookUpClass("AVSlider"), "_MyAVSlider", 0);
        
        IMP initWithFrame = class_getMethodImplementation(self, @selector(initWithFrame:));
        assert(class_addMethod(_dynamicIsa, @selector(initWithFrame:), initWithFrame, NULL));
        
        IMP becomeFirstResponder = class_getMethodImplementation(self, @selector(becomeFirstResponder));
        assert(class_addMethod(_dynamicIsa, @selector(becomeFirstResponder), becomeFirstResponder, NULL));
        
        IMP resignFirstResponder = class_getMethodImplementation(self, @selector(resignFirstResponder));
        assert(class_addMethod(_dynamicIsa, @selector(resignFirstResponder), resignFirstResponder, NULL));
        
        //
        
        objc_registerClassPair(_dynamicIsa);
        
        dynamicIsa = _dynamicIsa;
    });
    
    return dynamicIsa;
}

- (instancetype)initWithFrame:(CGRect)frame {
    objc_super superInfo = { self, [self class] };
    self = reinterpret_cast<id (*)(objc_super *, SEL, CGRect)>(objc_msgSendSuper2)(&superInfo, _cmd, frame);
    
    if (self) {
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setBackgroundColor:"), [UIColor clearColor]);
    }
    
    return self;
}

- (void)becomeFirstResponder {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setBackgroundColor:"), nil);
}

- (void)resignFirstResponder {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setBackgroundColor:"), [UIColor clearColor]);
}

@end
