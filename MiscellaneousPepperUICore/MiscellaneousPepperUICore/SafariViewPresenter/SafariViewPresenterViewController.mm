//
//  SafariViewPresenterViewController.m
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 10/4/24.
//

#import "SafariViewPresenterViewController.h"
#import <UIKit/UIKit.h>
#import <objc/message.h>
#import <objc/runtime.h>
#import <dlfcn.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

@implementation SafariViewPresenterViewController

+ (void)load {
    assert(dlopen("/System/Library/Frameworks/SafariServices.framework/SafariServices", RTLD_NOW) != nullptr);
    [self dynamicIsa];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [[self dynamicIsa] allocWithZone:zone];
}

+ (Class)dynamicIsa {
    static Class dynamicIsa;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class _dynamicIsa = objc_allocateClassPair(objc_lookUpClass("SPViewController"), "_SafariViewPresenterViewController", 0);
        
        IMP dealloc = class_getMethodImplementation(self, @selector(dealloc));
        assert(class_addMethod(_dynamicIsa, @selector(dealloc), dealloc, NULL));
        
        IMP respondsToSelector = class_getMethodImplementation(self, @selector(respondsToSelector:));
        assert(class_addMethod(_dynamicIsa, @selector(respondsToSelector:), respondsToSelector, NULL));
        
        IMP loadView = class_getMethodImplementation(self, @selector(loadView));
        assert(class_addMethod(_dynamicIsa, @selector(loadView), loadView, NULL));
        
        IMP viewDidLoad = class_getMethodImplementation(self, @selector(viewDidLoad));
        assert(class_addMethod(_dynamicIsa, @selector(viewDidLoad), viewDidLoad, NULL));
        
        Protocol *proto = NSProtocolFromString(@"SFSafariViewControllerDelegate");
        assert(proto != nullptr);
        assert(class_addProtocol(_dynamicIsa, proto));
        
        assert(class_addIvar(_dynamicIsa, "_prewarmingToken", sizeof(id), sizeof(id), @encode(id)));
        
        //
        
        objc_registerClassPair(_dynamicIsa);
        
        dynamicIsa = _dynamicIsa;
    });
    
    return dynamicIsa;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"
- (void)dealloc {
    id _prewarmingToken;
    assert(object_getInstanceVariable(self, "_prewarmingToken", reinterpret_cast<void **>(&_prewarmingToken)) != nullptr);
    [_prewarmingToken release];
    
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
    __weak auto weakSelf = self;
    
    id primaryAction = reinterpret_cast<id (*)(Class, SEL, id, id, id, id)>(objc_msgSend)(objc_lookUpClass("UIAction"), sel_registerName("actionWithTitle:image:identifier:handler:"), @"Present", nil, nil, ^(id action) {
        [weakSelf present];
    });
    
    id button = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("PUICButton"), sel_registerName("systemButtonWithPrimaryAction:"), primaryAction);
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setView:"), button);
}

- (void)viewDidLoad {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
    
    id prewarmingToken = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("SFSafariViewController"), sel_registerName("prewarmConnectionsToURLs:"), @[[self url]]);
    assert(reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(prewarmingToken, sel_registerName("isValid")));
    assert(object_setInstanceVariable(self, "_prewarmingToken", reinterpret_cast<void *>([prewarmingToken retain])) != nullptr);
}

- (NSURL *)url __attribute__((objc_direct)) {
    return [NSURL URLWithString:@"https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller?language=objc"];
}

- (void)present __attribute__((objc_direct)) {
    id configuration = [objc_lookUpClass("SFSafariViewControllerConfiguration") new];
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(configuration, sel_registerName("setEntersReaderIfAvailable:"), NO);
    // 안 됨
//    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(configuration, sel_registerName("setBarCollapsingEnabled:"), YES);
    
    id viewController = reinterpret_cast<id (*)(id, SEL, id, id)>(objc_msgSend)([objc_lookUpClass("SFSafariViewController") alloc], sel_registerName("initWithURL:configuration:"), [self url], configuration);
    [configuration release];
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(viewController, sel_registerName("setDelegate:"), self);
    
    // 안 됨
//    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(viewController, sel_registerName("setPreferredBarTintColor:"), UIColor.orangeColor);
//    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(viewController, sel_registerName("setPreferredControlTintColor:"), UIColor.orangeColor);
//    reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(viewController, sel_registerName("setDismissButtonStyle:"), 2);
    
    reinterpret_cast<void (*)(id, SEL, id, BOOL, id)>(objc_msgSend)(self, sel_registerName("presentViewController:animated:completion:"), viewController, YES, nil);
    
    [viewController release];
    
//    id view = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("view"));
//    id window = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(view, sel_registerName("window"));
//    id windowScene = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(window, sel_registerName("windowScene"));
//    reinterpret_cast<void (*)(id, SEL, id, id, id)>(objc_msgSend)(windowScene, sel_registerName("openURL:options:completionHandler:"), url, nil, ^(BOOL success) {
//        assert(success);
//    });
}

@end
