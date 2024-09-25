//
//  GradientMetalViewController.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 9/3/24.
//

#import "GradientMetalViewController.h"
#import <UIKit/UIKit.h>
#import <objc/message.h>
#import <objc/runtime.h>
#import <dlfcn.h>
#import "Renderer.h"

OBJC_EXPORT id objc_msgSendSuper2(void);

@implementation GradientMetalViewController

+ (void)load {
    assert(dlopen("/System/Library/Frameworks/MetalKit.framework/MetalKit", RTLD_NOW) != NULL);
    assert(dlopen("/System/Library/Frameworks/ModelIO.framework/ModelIO", RTLD_NOW) != NULL);
    
    [self dynamisIsa];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [[self dynamisIsa] allocWithZone:zone];
}

+ (Class)dynamisIsa {
    static Class dynamicIsa;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class _dynamicIsa = objc_allocateClassPair(objc_lookUpClass("SPViewController"), "_GradientMetalViewController", 0);
        
        IMP dealloc = class_getMethodImplementation(self, @selector(dealloc));
        assert(class_addMethod(_dynamicIsa, @selector(dealloc), dealloc, NULL));
        
        IMP loadView = class_getMethodImplementation(self, @selector(loadView));
        assert(class_addMethod(_dynamicIsa, @selector(loadView), loadView, NULL));
        
        IMP viewDidLoad = class_getMethodImplementation(self, @selector(viewDidLoad));
        assert(class_addMethod(_dynamicIsa, @selector(viewDidLoad), viewDidLoad, NULL));
        
        IMP viewWillAppear = class_getMethodImplementation(self, @selector(viewWillAppear:));
        assert(class_addMethod(_dynamicIsa, @selector(viewWillAppear:), viewWillAppear, NULL));
        
        IMP viewWillDisappear = class_getMethodImplementation(self, @selector(viewWillDisappear:));
        assert(class_addMethod(_dynamicIsa, @selector(viewWillDisappear:), viewWillDisappear, NULL));
        
        IMP prefersStatusBarHidden = class_getMethodImplementation(self, @selector(prefersStatusBarHidden));
        assert(class_addMethod(_dynamicIsa, @selector(prefersStatusBarHidden), prefersStatusBarHidden, NULL));
        
        IMP touchesBegan_withEvent = class_getMethodImplementation(self, @selector(touchesBegan:withEvent:));
        assert(class_addMethod(_dynamicIsa, @selector(touchesBegan:withEvent:), touchesBegan_withEvent, NULL));
        
        assert(class_addIvar(_dynamicIsa, "_renderer", sizeof(Renderer *), sizeof(Renderer *), @encode(Renderer *)));
        
        objc_registerClassPair(_dynamicIsa);
        
        dynamicIsa = _dynamicIsa;
    });
    
    return dynamicIsa;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"
- (void)dealloc {
    Renderer *_renderer;
    object_getInstanceVariable(self, "_renderer", reinterpret_cast<void **>(&_renderer));
    [_renderer release];
    
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
}
#pragma clang diagnostic pop

- (void)loadView {
    id mtkView = [objc_lookUpClass("MTKView") new];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setView:"), mtkView);
    [mtkView release];
}

- (void)viewDidLoad {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
    
    id view = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("view"));
    
    Renderer *renderer = [[Renderer alloc] initWithView:view];
    object_setInstanceVariable(self, "_renderer", [renderer retain]);
    [renderer release];
    
//    id navigationItem = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("navigationItem"));
//    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(navigationItem, sel_registerName("setHidesBackButton:"), YES);
}

- (void)viewWillAppear:(BOOL)animated {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL, BOOL)>(objc_msgSendSuper2)(&superInfo, _cmd, animated);
    
    id application = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("UIApplication"), sel_registerName("sharedApplication"));
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(application, sel_registerName("setDisablesSleepGesture:"), YES);
    reinterpret_cast<void (*)(id, SEL, double)>(objc_msgSend)(application, sel_registerName("setExtendedIdleTime:"), DBL_MAX);
}

- (void)viewWillDisappear:(BOOL)animated {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL, BOOL)>(objc_msgSendSuper2)(&superInfo, _cmd, animated);
    
    id application = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("UIApplication"), sel_registerName("sharedApplication"));
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(application, sel_registerName("setDisablesSleepGesture:"), NO);
    reinterpret_cast<void (*)(id, SEL, double)>(objc_msgSend)(application, sel_registerName("setExtendedIdleTime:"), 0.);
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(id)event {
    Renderer *renderer;
    object_getInstanceVariable(self, "_renderer", reinterpret_cast<void **>(&renderer));
    renderer.showGrid ^= 1;
    
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL, id, id)>(objc_msgSendSuper2)(&superInfo, _cmd, touches, event);
}

@end
