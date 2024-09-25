//
//  AlwaysOnViewController.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 8/4/24.
//

#import "AlwaysOnViewController.h"
#import "EffectiveVisibilityView.h"
#import <UIKit/UIKit.h>
#import <objc/message.h>
#import <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

// https://developer.apple.com/documentation/watchos-apps/designing-your-app-for-the-always-on-state/

@implementation AlwaysOnViewController

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
        Class _dynamicIsa = objc_allocateClassPair(objc_lookUpClass("SPViewController"), "_AlwaysOnViewController", 0);
        
        IMP dealloc = class_getMethodImplementation(self, @selector(dealloc));
        assert(class_addMethod(_dynamicIsa, @selector(dealloc), dealloc, NULL));
        
        IMP description = class_getMethodImplementation(self, @selector(description));
        assert(class_addMethod(_dynamicIsa, @selector(description), description, NULL));
        
        IMP loadView = class_getMethodImplementation(self, @selector(loadView));
        assert(class_addMethod(_dynamicIsa, @selector(loadView), loadView, NULL));
        
        IMP viewDidLoad = class_getMethodImplementation(self, @selector(viewDidLoad));
        assert(class_addMethod(_dynamicIsa, @selector(viewDidLoad), viewDidLoad, NULL));
        
        IMP didReceiveEffectiveVisibilityDidChangeNotification = class_getMethodImplementation(self, @selector(didReceiveEffectiveVisibilityDidChangeNotification:));
        assert(class_addMethod(_dynamicIsa, @selector(didReceiveEffectiveVisibilityDidChangeNotification:), didReceiveEffectiveVisibilityDidChangeNotification, NULL));
        
        IMP didReceiveEnvironmentFrontmostScreenOffDidChangeNotification = class_getMethodImplementation(self, @selector(didReceiveEnvironmentFrontmostScreenOffDidChangeNotification:));
        assert(class_addMethod(_dynamicIsa, @selector(didReceiveEnvironmentFrontmostScreenOffDidChangeNotification:), didReceiveEnvironmentFrontmostScreenOffDidChangeNotification, NULL));
        
        IMP puic_didEnterAlwaysOn = class_getMethodImplementation(self, @selector(puic_didEnterAlwaysOn));
        assert(class_addMethod(_dynamicIsa, @selector(puic_didEnterAlwaysOn), puic_didEnterAlwaysOn, NULL));
        
        IMP puic_didExitAlwaysOn = class_getMethodImplementation(self, @selector(puic_didExitAlwaysOn));
        assert(class_addMethod(_dynamicIsa, @selector(puic_didExitAlwaysOn), puic_didExitAlwaysOn, NULL));
        
        IMP puic_willEnterAlwaysOn = class_getMethodImplementation(self, @selector(puic_willEnterAlwaysOn));
        assert(class_addMethod(_dynamicIsa, @selector(puic_willEnterAlwaysOn), puic_willEnterAlwaysOn, NULL));
        
        IMP puic_willExitAlwaysOn = class_getMethodImplementation(self, @selector(puic_willExitAlwaysOn));
        assert(class_addMethod(_dynamicIsa, @selector(puic_willExitAlwaysOn), puic_willExitAlwaysOn, NULL));
        
        assert(class_addIvar(_dynamicIsa, "_label", sizeof(id), sizeof(id), @encode(id)));
        
        //
        
        objc_registerClassPair(_dynamicIsa);
        
        dynamicIsa = _dynamicIsa;
    });
    
    return dynamicIsa;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"
- (void)dealloc {
    id _label;
    object_getInstanceVariable(self, "_label", reinterpret_cast<void **>(&_label));
    [_label release];
    
    [NSNotificationCenter.defaultCenter removeObserver:self name:@"PUICApplicationEffectiveVisibilityDidChangeNotification" object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:@"PUICApplicationEnvironmentFrontmostScreenOffDidChangeNotification" object:nil];
    
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
}
#pragma clang diagnostic pop

- (NSString *)description {
    return [NSString stringWithFormat:@"<%s: %p>", class_getName(self.class), self];
}

- (void)loadView {
    id view = [EffectiveVisibilityView new];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setView:"), view);
    [view release];
}

- (void)viewDidLoad {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
    
    //
    
    BOOL _alwaysOnSupported = reinterpret_cast<BOOL (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("_UIBacklightEnvironment"), sel_registerName("_alwaysOnSupported"));
    
    // PUICApplicationSupportsAlwaysOn 또는 WKSupportsAlwaysOnDisplay (둘 중 하나만 1이면 됨)
    assert(_alwaysOnSupported);
    
    //
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(didReceiveEffectiveVisibilityDidChangeNotification:)
                                               name:@"PUICApplicationEffectiveVisibilityDidChangeNotification"
                                             object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(didReceiveEnvironmentFrontmostScreenOffDidChangeNotification:)
                                               name:@"PUICApplicationEnvironmentFrontmostScreenOffDidChangeNotification"
                                             object:nil];
}


- (void)didReceiveEffectiveVisibilityDidChangeNotification:(NSNotification *)notification {
    id sharedPUICApplication = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("PUICApplication"), sel_registerName("sharedPUICApplication"));
    NSUInteger puic_effectiveVisibility = reinterpret_cast<NSUInteger (*)(id, SEL)>(objc_msgSend)(sharedPUICApplication, sel_registerName("puic_effectiveVisibility"));
    NSLog(@"%ld", puic_effectiveVisibility);
}

- (void)didReceiveEnvironmentFrontmostScreenOffDidChangeNotification:(NSNotification *)notification {
    NSLog(@"%@", notification);
}

- (void)puic_didEnterAlwaysOn {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
}

- (void)puic_didExitAlwaysOn {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
}

- (void)puic_willEnterAlwaysOn {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
}

- (void)puic_willExitAlwaysOn {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
}

@end
