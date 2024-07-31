//
//  DigitalCrownViewController.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 8/1/24.
//

#import "DigitalCrownViewController.h"
#import "DigitalCrownView.h"
#import <UIKit/UIKit.h>
#import <objc/message.h>
#import <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

@implementation DigitalCrownViewController

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
        Class _dynamicIsa = objc_allocateClassPair(objc_lookUpClass("UIViewController"), "_DigitalCrownViewController", 0);
        
        IMP dealloc = class_getMethodImplementation(self, @selector(dealloc));
        assert(class_addMethod(_dynamicIsa, @selector(dealloc), dealloc, NULL));
        
        IMP respondsToSelector = class_getMethodImplementation(self, @selector(respondsToSelector:));
        assert(class_addMethod(_dynamicIsa, @selector(respondsToSelector:), respondsToSelector, NULL));
        
        IMP loadView = class_getMethodImplementation(self, @selector(loadView));
        assert(class_addMethod(_dynamicIsa, @selector(loadView), loadView, NULL));
        
        IMP viewDidLoad = class_getMethodImplementation(self, @selector(viewDidLoad));
        assert(class_addMethod(_dynamicIsa, @selector(viewDidLoad), viewDidLoad, NULL));
        
        IMP crownInputSequencerOffsetDidChange = class_getMethodImplementation(self, @selector(crownInputSequencerOffsetDidChange:));
        assert(class_addMethod(_dynamicIsa, @selector(crownInputSequencerOffsetDidChange:), crownInputSequencerOffsetDidChange, NULL));
        
        IMP isFirstResponderForSequencer = class_getMethodImplementation(self, @selector(isFirstResponderForSequencer:));
        assert(class_addMethod(_dynamicIsa, @selector(isFirstResponderForSequencer:), isFirstResponderForSequencer, NULL));
        
        assert(class_addIvar(_dynamicIsa, "_crownInputSequencer", sizeof(id), sizeof(id), @encode(id)));
        
        
        class_addProtocol(_dynamicIsa, NSProtocolFromString(@"PUICCrownInputSequencerDelegate"));
        class_addProtocol(_dynamicIsa, NSProtocolFromString(@"PUICCrownInputSequencerDetentsDataSource"));
        
        dynamicIsa = _dynamicIsa;
    });
    
    return dynamicIsa;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"
- (void)dealloc {
    id _crownInputSequencer;
    object_getInstanceVariable(self, "_crownInputSequencer", reinterpret_cast<void **>(&_crownInputSequencer));
    [_crownInputSequencer release];
    
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
}
#pragma clang diagnostic pop

- (BOOL)respondsToSelector:(SEL)aSelector {
    objc_super superInfo = { self, [self class] };
    BOOL responds = reinterpret_cast<BOOL (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
    
    if (!responds) {
        NSLog(@"%s", sel_getName(aSelector));
    }
    
    return responds;
}

- (void)loadView {
//    objc_super superInfo = { self, [self class] };
//    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
    
    DigitalCrownView *view = [DigitalCrownView new];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setView:"), view);
    [view release];
}

- (void)viewDidLoad {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
    
    id view = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("view"));
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(view, sel_registerName("setBackgroundColor:"), UIColor.cyanColor);
    
    //
    
    id crownInputSequencer = [objc_lookUpClass("PUICCrownInputSequencer") new];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(crownInputSequencer, sel_registerName("setView:"), view);
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(crownInputSequencer, sel_registerName("setContinuous:"), YES);
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(crownInputSequencer, sel_registerName("setMetricsDelegate:"), self);
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(crownInputSequencer, sel_registerName("setDelegate:"), self);
    
    object_setInstanceVariable(self, "_crownInputSequencer", [crownInputSequencer retain]);
    [crownInputSequencer release];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [view becomeFirstResponder];
        
        BOOL isFirstResponder = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(view, sel_registerName("isFirstResponder"));
        assert(isFirstResponder);
        
        id _crownInputSequencer;
        object_getInstanceVariable(self, "_crownInputSequencer", reinterpret_cast<void **>(&_crownInputSequencer));
        NSLog(@"%@", _crownInputSequencer);
        
        reinterpret_cast<double (*)(id, SEL)>(objc_msgSend)(_crownInputSequencer, sel_registerName("start"));
    });
}

- (void)crownInputSequencerOffsetDidChange:(id)crownInputSequencer {
    NSLog(@"%@", crownInputSequencer);
}

- (_Bool) isFirstResponderForSequencer:(id)arg1 {
    return YES;
}

@end
