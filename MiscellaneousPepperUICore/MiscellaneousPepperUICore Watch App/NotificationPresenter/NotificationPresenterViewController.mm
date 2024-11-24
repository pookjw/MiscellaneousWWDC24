//
//  NotificationPresenterViewController.m
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 8/6/24.
//

#import "NotificationPresenterViewController.h"
#import <UIKit/UIKit.h>
#import <objc/message.h>
#import <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

// PUICNotificationWindowSceneDelegate

@implementation NotificationPresenterViewController

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
        Class _isa = objc_allocateClassPair(objc_lookUpClass("SPViewController"), "_NotificationPresenterViewController", 0);
        
        IMP loadView = class_getMethodImplementation(self, @selector(loadView));
        assert(class_addMethod(_isa, @selector(loadView), loadView, NULL));
        
        //
        
        objc_registerClassPair(_isa);
        
        isa = _isa;
    });
    
    return isa;
}

- (void)loadView {
    __weak auto weakSelf = self;
    
    id primaryAction = reinterpret_cast<id (*)(Class, SEL, id, id, id, id)>(objc_msgSend)(objc_lookUpClass("UIAction"), sel_registerName("actionWithTitle:image:identifier:handler:"), @"Open", nil, nil, ^(id) {
        [weakSelf open];
    });
    
    id button = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("UIButton"), sel_registerName("systemButtonWithPrimaryAction:"), primaryAction);
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setView:"), button);
}

- (void)open __attribute__((objc_direct)) {
    id sceneRequestOptions = [objc_lookUpClass("UISceneRequestOptions") new];
    
    id specification = [objc_lookUpClass("PUICNotificationSceneSpecification") new];
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(sceneRequestOptions, sel_registerName("setSpecification:"), specification);
    [specification release];
    
    id workspace = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("FBSWorkspace"), sel_registerName("_sharedWorkspaceIfExists"));
    id defaultShellEndpoint = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(workspace, sel_registerName("defaultShellEndpoint"));
    
    // 안 됨...
    /*
     <FBSWorkspaceScenesClient:0x600002c0a180 com.apple.frontboard.systemappservices> scene request failed to return scene with error response : <NSError: 0x600000c75d10; domain: FBSWorkspaceErrorDomain; code: 2 ("Denied"); "the host has not configured a workspace delegate for this process">
     */
    reinterpret_cast<void (*)(id, SEL, id, id, id)>(objc_msgSend)(workspace, sel_registerName("requestSceneFromEndpoint:withOptions:completion:"), defaultShellEndpoint, sceneRequestOptions, ^(id fbsScene, NSError * _Nullable error) {
        assert(error == nil);
    });
    
    [sceneRequestOptions release];
}

@end
