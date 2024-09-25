//
//  CompositionPresenterViewController.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 8/4/24.
//

#import "CompositionPresenterViewController.h"
#import <UIKit/UIKit.h>
#import <objc/message.h>
#import <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

@implementation CompositionPresenterViewController

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
        Class _dynamicIsa = objc_allocateClassPair(objc_lookUpClass("SPViewController"), "_QuickboardCompositionPresenterViewController", 0);
        
        IMP respondsToSelector = class_getMethodImplementation(self, @selector(respondsToSelector:));
        assert(class_addMethod(_dynamicIsa, @selector(respondsToSelector:), respondsToSelector, NULL));
        
        IMP loadView = class_getMethodImplementation(self, @selector(loadView));
        assert(class_addMethod(_dynamicIsa, @selector(loadView), loadView, NULL));
        
        IMP composeControllerCancelled = class_getMethodImplementation(self, @selector(composeControllerCancelled:));
        assert(class_addMethod(_dynamicIsa, @selector(composeControllerCancelled:), composeControllerCancelled, NULL));
        
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
    __weak auto weakSelf = self;
    
    id primaryAction = reinterpret_cast<id (*)(Class, SEL, id, id, id, id)>(objc_msgSend)(objc_lookUpClass("UIAction"), sel_registerName("actionWithTitle:image:identifier:handler:"), @"Present", nil, nil, ^(id) {
        [weakSelf presetViewController];
    });
    
    id button = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("UIButton"), sel_registerName("systemButtonWithPrimaryAction:"), primaryAction);
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setView:"), button);
}

- (void)presetViewController __attribute__((objc_direct)) {
    id quickboardCompositionViewController = [objc_lookUpClass("PUICQuickboardCompositionViewController") new];
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(quickboardCompositionViewController, sel_registerName("setDelegate:"), self);
    
    reinterpret_cast<void (*)(id, SEL, id, BOOL, id)>(objc_msgSend)(self, sel_registerName("presentViewController:animated:completion:"), quickboardCompositionViewController, YES, nil);
    
    [quickboardCompositionViewController release];
}

- (void)composeControllerCancelled:(id)composeController {
    reinterpret_cast<void (*)(id, SEL, BOOL, id)>(objc_msgSend)(composeController, sel_registerName("dismissViewControllerAnimated:completion:"), YES, nil);
}

@end
