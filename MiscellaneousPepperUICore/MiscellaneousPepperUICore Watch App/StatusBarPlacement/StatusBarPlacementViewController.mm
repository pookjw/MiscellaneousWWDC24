//
//  StatusBarPlacementViewController.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 8/4/24.
//

#import "StatusBarPlacementViewController.h"
#import <UIKit/UIKit.h>
#import <objc/message.h>
#import <objc/runtime.h>
#include <dlfcn.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

@implementation StatusBarPlacementViewController

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
        Class _isa = objc_allocateClassPair(objc_lookUpClass("SPViewController"), "_StatusBarPlacementViewController", 0);
        
        IMP respondsToSelector = class_getMethodImplementation(self, @selector(respondsToSelector:));
        assert(class_addMethod(_isa, @selector(respondsToSelector:), respondsToSelector, NULL));
        
        IMP loadView = class_getMethodImplementation(self, @selector(loadView));
        assert(class_addMethod(_isa, @selector(loadView), loadView, NULL));
        
        IMP viewDidLoad = class_getMethodImplementation(self, @selector(viewDidLoad));
        assert(class_addMethod(_isa, @selector(viewDidLoad), viewDidLoad, NULL));
        
        IMP puic_statusBarPlacement = class_getMethodImplementation(self, @selector(puic_statusBarPlacement));
        assert(class_addMethod(_isa, @selector(puic_statusBarPlacement), puic_statusBarPlacement, NULL));
        
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

- (void)loadView {
    __weak auto weakSelf = self;
    
    id primaryAction = reinterpret_cast<id (*)(Class, SEL, id, id, id, id)>(objc_msgSend)(objc_lookUpClass("UIAction"), sel_registerName("actionWithTitle:image:identifier:handler:"), @"Toggle", nil, nil, ^(id) {
        [weakSelf toggle];
    });
    
    id button = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("UIButton"), sel_registerName("systemButtonWithPrimaryAction:"), primaryAction);
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setView:"), button);
}

- (void)viewDidLoad {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
    
    [self updateTitle];
}

- (void)toggle __attribute__((objc_direct)) {
    NSInteger _mpu_preferredStatusBarPlacement;
    object_getInstanceVariable(self, "_mpu_preferredStatusBarPlacement", reinterpret_cast<void **>(&_mpu_preferredStatusBarPlacement));
    
    _mpu_preferredStatusBarPlacement ^= 1;
    
    object_setInstanceVariable(self, "_mpu_preferredStatusBarPlacement", reinterpret_cast<void *>(_mpu_preferredStatusBarPlacement));
    
    id view = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("view"));
    id window = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(view, sel_registerName("window"));
    id windowScene = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(window, sel_registerName("windowScene"));
    id statusBarManager = ((id (*)(id, SEL))objc_msgSend)(windowScene, NSSelectorFromString(@"statusBarManager"));
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(statusBarManager, NSSelectorFromString(@"_updateStatusBarAppearanceSceneSettingsWithAnimationParameters:"), nil);
    
    [self updateTitle];
}

- (NSInteger)puic_statusBarPlacement {
    NSInteger _mpu_preferredStatusBarPlacement;
    object_getInstanceVariable(self, "_mpu_preferredStatusBarPlacement", reinterpret_cast<void **>(&_mpu_preferredStatusBarPlacement));
    return _mpu_preferredStatusBarPlacement;
}

- (void)updateTitle __attribute__((objc_direct)) {
    void *handle = dlopen("/System/Library/PrivateFrameworks/PepperUICore.framework/PepperUICore", RTLD_NOW);
    void *symbol = dlsym(handle, "NSStringFromPUICStatusBarPlacement");
    
    id navigationItem = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("navigationItem"));
    
    NSInteger _mpu_preferredStatusBarPlacement;
    object_getInstanceVariable(self, "_mpu_preferredStatusBarPlacement", reinterpret_cast<void **>(&_mpu_preferredStatusBarPlacement));
    
    NSString *title = reinterpret_cast<id (*)(NSInteger)>(symbol)(_mpu_preferredStatusBarPlacement);
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(navigationItem, sel_registerName("setTitle:"), title);
}

@end
