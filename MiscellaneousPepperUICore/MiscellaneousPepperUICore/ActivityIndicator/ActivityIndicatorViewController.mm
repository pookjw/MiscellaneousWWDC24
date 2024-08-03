//
//  ActivityIndicatorViewController.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 8/3/24.
//

#import "ActivityIndicatorViewController.h"
#import <UIKit/UIKit.h>
#import <objc/message.h>
#import <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

@implementation ActivityIndicatorViewController

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
        Class _dynamicIsa = objc_allocateClassPair(objc_lookUpClass("SPViewController"), "_ActivityIndicatorViewController", 0);
        
        IMP description = class_getMethodImplementation(self, @selector(description));
        assert(class_addMethod(_dynamicIsa, @selector(description), description, NULL));
        
        IMP respondsToSelector = class_getMethodImplementation(self, @selector(respondsToSelector:));
        assert(class_addMethod(_dynamicIsa, @selector(respondsToSelector:), respondsToSelector, NULL));
        
        IMP loadView = class_getMethodImplementation(self, @selector(loadView));
        assert(class_addMethod(_dynamicIsa, @selector(loadView), loadView, NULL));
        
        IMP activityIndicatorViewDidAnimateIn = class_getMethodImplementation(self, @selector(activityIndicatorViewDidAnimateIn:));
        assert(class_addMethod(_dynamicIsa, @selector(activityIndicatorViewDidAnimateIn:), activityIndicatorViewDidAnimateIn, NULL));
        
        IMP activityIndicatorViewDidAnimateOut = class_getMethodImplementation(self, @selector(activityIndicatorViewDidAnimateOut:));
        assert(class_addMethod(_dynamicIsa, @selector(activityIndicatorViewDidAnimateOut:), activityIndicatorViewDidAnimateOut, NULL));
        
        IMP activityIndicatorViewWillAnimateIn_duration = class_getMethodImplementation(self, @selector(activityIndicatorViewWillAnimateIn:duration:));
        assert(class_addMethod(_dynamicIsa, @selector(activityIndicatorViewWillAnimateIn:duration:), activityIndicatorViewWillAnimateIn_duration, NULL));
        
        IMP activityIndicatorViewWillAnimateOut_duration = class_getMethodImplementation(self, @selector(activityIndicatorViewWillAnimateOut:duration:));
        assert(class_addMethod(_dynamicIsa, @selector(activityIndicatorViewWillAnimateOut:duration:), activityIndicatorViewWillAnimateOut_duration, NULL));
        
        //
        
        assert(class_addProtocol(_dynamicIsa, NSProtocolFromString(@"PUICActivityIndicatorViewDelegate")));
        
        dynamicIsa = _dynamicIsa;
    });
    
    return dynamicIsa;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%s: %p>", class_getName(self.class), self];
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
    //  - 0 : Large
    //  - 1 : Medium
    //  - 2 : Small
    id activityIndicatorView = reinterpret_cast<id (*)(id, SEL, NSInteger)>(objc_msgSend)([objc_lookUpClass("PUICActivityIndicatorView") alloc], sel_registerName("initWithActivityIndicatorStyle:"), 0);
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(activityIndicatorView, sel_registerName("setDelegate:"), self);
    reinterpret_cast<void (*)(id, SEL, BOOL, BOOL)>(objc_msgSend)(activityIndicatorView, sel_registerName("setAnimating:skipBeginOrEndAnimations:"), YES, YES);
//    reinterpret_cast<void (*)(id, SEL, CGFloat)>(objc_msgSend)(activityIndicatorView, sel_registerName("setSpinUpProgress:"), 0.4);
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setView:"), activityIndicatorView);
    [activityIndicatorView release];
}

- (void)activityIndicatorViewDidAnimateIn:(id)activityIndicator {
    NSLog(@"%s", __func__);
}

- (void)activityIndicatorViewDidAnimateOut:(id)activityIndicator {
    NSLog(@"%s", __func__);
}

- (void)activityIndicatorViewWillAnimateIn:(id)activityIndicator duration:(NSTimeInterval)duration {
    NSLog(@"%s", __func__);
}

- (void)activityIndicatorViewWillAnimateOut:(id)activityIndicator duration:(NSTimeInterval)duration {
    NSLog(@"%s", __func__);
}

@end
