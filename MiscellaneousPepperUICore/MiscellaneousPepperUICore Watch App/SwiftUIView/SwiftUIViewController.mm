//
//  SwiftUIViewController.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 10/14/24.
//

#import "SwiftUIViewController.h"
#import "MiscellaneousPepperUICore_Watch_App-Swift.h"
#import <UIKit/UIKit.h>
#import <objc/message.h>
#import <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

@implementation SwiftUIViewController

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
        Class _isa = objc_allocateClassPair(objc_lookUpClass("SPViewController"), "_SwiftUIViewController", 0);
        
        IMP dealloc = class_getMethodImplementation(self, @selector(dealloc));
        assert(class_addMethod(_isa, @selector(dealloc), dealloc, NULL));
        
        IMP viewDidLoad = class_getMethodImplementation(self, @selector(viewDidLoad));
        assert(class_addMethod(_isa, @selector(viewDidLoad), viewDidLoad, NULL));
        
        //
        
        objc_registerClassPair(_isa);
        
        isa = _isa;
    });
    
    return isa;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"
- (void)dealloc {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
}
#pragma clang diagnostic pop

- (void)viewDidLoad {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
    
    NSObject *hostingController = MiscellaneousPepperUICore_Watch_App::makeHostingController();
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("addChildViewController:"), hostingController);
    
    id view = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("view"));
    CGRect viewBounds = reinterpret_cast<CGRect (*)(id, SEL)>(objc_msgSend)(view, sel_registerName("bounds"));
    
    id hostingView = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(hostingController, sel_registerName("view"));
    
    reinterpret_cast<void (*)(id, SEL, CGRect)>(objc_msgSend)(hostingView, sel_registerName("setFrame:"), viewBounds);
    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(hostingView, sel_registerName("setAutoresizingMask:"), (1 << 1) | (1 << 4));
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(view, sel_registerName("addSubview:"), hostingView);
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(hostingController, sel_registerName("didMoveToParentViewController:"), self);
    
    [hostingController release];
}

@end
