//
//  SwitchViewController.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 8/3/24.
//

#import "SwitchViewController.h"
#import <UIKit/UIKit.h>
#import <objc/message.h>
#import <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

@implementation SwitchViewController

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
        Class _dynamicIsa = objc_allocateClassPair(objc_lookUpClass("SPViewController"), "_SwitchViewController", 0);
        
        IMP description = class_getMethodImplementation(self, @selector(description));
        assert(class_addMethod(_dynamicIsa, @selector(description), description, NULL));
        
        IMP viewDidLoad = class_getMethodImplementation(self, @selector(viewDidLoad));
        assert(class_addMethod(_dynamicIsa, @selector(viewDidLoad), viewDidLoad, NULL));
        
        objc_registerClassPair(_dynamicIsa);
        
        dynamicIsa = _dynamicIsa;
    });
    
    return dynamicIsa;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%s: %p>", class_getName(self.class), self];
}

- (void)viewDidLoad {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
    
    // UISlider는 Visual Provider가 없어서 nil이 나옴
    id puicSwitch = [objc_lookUpClass("PUICSwitch") new];
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(puicSwitch, sel_registerName("setTranslatesAutoresizingMaskIntoConstraints:"), NO);
    
    id view = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("view"));
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(view, sel_registerName("addSubview:"), puicSwitch);
    
    id view_layoutMarginsGuide = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(view, sel_registerName("layoutMarginsGuide"));
    
    id puicSwitch_centerYAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(puicSwitch, sel_registerName("centerYAnchor"));
    id view_centerYAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(view_layoutMarginsGuide, sel_registerName("centerYAnchor"));
    
    id puicSwitch_centerXAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(puicSwitch, sel_registerName("centerXAnchor"));
    id view_centerXAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(view_layoutMarginsGuide, sel_registerName("centerXAnchor"));
    
    id centerYConstraint = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)(puicSwitch_centerYAnchor, sel_registerName("constraintEqualToAnchor:"), view_centerYAnchor);
    
    id centerXConstraint = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)(puicSwitch_centerXAnchor, sel_registerName("constraintEqualToAnchor:"), view_centerXAnchor);
    
    reinterpret_cast<void (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("NSLayoutConstraint"), sel_registerName("activateConstraints:"), @[
        centerYConstraint, centerXConstraint
    ]);
    
    [puicSwitch release];
}

@end
