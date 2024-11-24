//
//  NetworkActivityIndicatorVisibleViewController.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 8/5/24.
//

#import "NetworkActivityIndicatorVisibleViewController.h"
#import <UIKit/UIKit.h>
#import <objc/message.h>
#import <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

@implementation NetworkActivityIndicatorVisibleViewController

+ (void)load {
    [self class];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [[self class] allocWithZone:zone];
}

+ (Class)class {
    static Class isa;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class _isa = objc_allocateClassPair(objc_lookUpClass("SPViewController"), "_NetworkActivityIndicatorVisibleViewController", 0);
        
        IMP loadView = class_getMethodImplementation(self, @selector(loadView));
        assert(class_addMethod(_isa, @selector(loadView), loadView, NULL));
        
        //
        
        objc_registerClassPair(_isa);
        
        isa = _isa;
    });
    
    return isa;
}

- (void)loadView {
    __weak auto weakSelf = self;
    
    id primaryAction = reinterpret_cast<id (*)(Class, SEL, id, id, id, id)>(objc_msgSend)(objc_lookUpClass("UIAction"), sel_registerName("actionWithTitle:image:identifier:handler:"), @"Toggle", nil, nil, ^(id) {
        [weakSelf toggle];
    });
    
    id button = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("UIButton"), sel_registerName("systemButtonWithPrimaryAction:"), primaryAction);
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setView:"), button);
}

- (void)toggle __attribute__((objc_direct)) {
    id sharedPUICApplication = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("PUICApplication"), sel_registerName("sharedPUICApplication"));
    
    BOOL isNetworkActivityIndicatorVisible = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(sharedPUICApplication, sel_registerName("isNetworkActivityIndicatorVisible"));
    
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(sharedPUICApplication, sel_registerName("setNetworkActivityIndicatorVisible:"), isNetworkActivityIndicatorVisible ^ 1);
}

@end
