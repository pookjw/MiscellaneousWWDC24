//
//  StatusBarItemViewController.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 8/4/24.
//

#import "StatusBarItemViewController.h"
#import <UIKit/UIKit.h>
#import <objc/message.h>
#import <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

@implementation StatusBarItemViewController

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
        Class _isa = objc_allocateClassPair(objc_lookUpClass("SPViewController"), "_StatusBarItemViewController", 0);
        
        IMP respondsToSelector = class_getMethodImplementation(self, @selector(respondsToSelector:));
        assert(class_addMethod(_isa, @selector(respondsToSelector:), respondsToSelector, NULL));
        
        IMP viewDidLoad = class_getMethodImplementation(self, @selector(viewDidLoad));
        assert(class_addMethod(_isa, @selector(viewDidLoad), viewDidLoad, NULL));
        
        IMP puic_applicationStatusBarItem = class_getMethodImplementation(self, @selector(puic_applicationStatusBarItem));
        assert(class_addMethod(_isa, @selector(puic_applicationStatusBarItem), puic_applicationStatusBarItem, NULL));
        
        assert(class_addIvar(_isa, "_mpu_preferredStatusBarPlacement", sizeof(NSInteger), sizeof(NSInteger), @encode(NSInteger)));
        
        objc_registerClassPair(_isa);
        
        isa = _isa;
    });
    
    return isa;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    objc_super superInfo = { self, [self class] };
    BOOL responds = reinterpret_cast<BOOL (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
    
    if (!responds) {
        NSLog(@"%s", sel_getName(aSelector));
    }
    
    return responds;
}

- (void)viewDidLoad {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
    
    id navigationItem = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("navigationItem"));
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(navigationItem, sel_registerName("setTitle:"), @"Test");
}

- (id)puic_applicationStatusBarItem {
    id applicationStatusBarItem = [objc_lookUpClass("PUICApplicationStatusBarItem") new];
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(applicationStatusBarItem, sel_registerName("setTitle:"), @"Foo");
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(applicationStatusBarItem, sel_registerName("setTitleColor:"), UIColor.whiteColor);
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(applicationStatusBarItem, sel_registerName("setOwningViewController:"), self);

    
    return [applicationStatusBarItem autorelease];
}

@end
