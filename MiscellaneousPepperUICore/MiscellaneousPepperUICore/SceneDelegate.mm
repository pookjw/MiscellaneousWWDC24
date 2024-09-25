//
//  SceneDelegate.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 8/1/24.
//

#import "SceneDelegate.h"
#import "ClassListViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

@interface SceneDelegate ()
@end

@implementation SceneDelegate

+ (void)load {
    [self dynamisIsa];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [[self dynamisIsa] allocWithZone:zone];
}

+ (Class)dynamisIsa {
    static Class dynamicIsa;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class _dynamicIsa = objc_allocateClassPair(objc_lookUpClass("UIResponder"), "_SceneDelegate", 0);
        
        IMP dealloc = class_getMethodImplementation(self, @selector(dealloc));
        assert(class_addMethod(_dynamicIsa, @selector(dealloc), dealloc, NULL));
        
        IMP description = class_getMethodImplementation(self, @selector(description));
        assert(class_addMethod(_dynamicIsa, @selector(description), description, NULL));
        
        
        IMP scene_willConnectToSession = class_getMethodImplementation(self, @selector(scene:willConnectToSession:options:));
        assert(class_addMethod(_dynamicIsa, @selector(scene:willConnectToSession:options:), scene_willConnectToSession, NULL));
        
        assert(class_addProtocol(_dynamicIsa, NSProtocolFromString(@"UIWindowSceneDelegate")));
        
        objc_registerClassPair(_dynamicIsa);
        
        dynamicIsa = _dynamicIsa;
    });
    
    return dynamicIsa;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"
- (void)dealloc {
    id _window;
    object_getInstanceVariable(self, "_window", reinterpret_cast<void **>(&_window));
    
    [_window release];
    
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
}
#pragma clang diagnostic pop

- (NSString *)description {
    return [NSString stringWithFormat:@"<%s: %p>", class_getName(self.class), self];
}

- (void)scene:(id)scene willConnectToSession:(id)session options:(id)connectionOptions {
    id window = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("UIWindow") alloc], sel_registerName("initWithWindowScene:"), scene);
    
    // -[SPHostingViewController initWithInterfaceDescription:bundle:stringsFileName:]
    id rootViewController = reinterpret_cast<id (*)(id, SEL, id, id, id)>(objc_msgSend)([objc_lookUpClass("SPHostingViewController") alloc], sel_registerName("initWithInterfaceDescription:bundle:stringsFileName:"), nil, nil, nil);
    
    ClassListViewController *classListViewController = [ClassListViewController new];
    id navigationController = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("PUICNavigationController") alloc], sel_registerName("initWithRootViewController:"), classListViewController);
    [classListViewController release];
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(rootViewController, sel_registerName("addChildViewController:"), navigationController);
    id navigationView = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(navigationController, sel_registerName("view"));
    id rootView = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(rootViewController, sel_registerName("view"));
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(rootView, sel_registerName("addSubview:"), navigationView);
    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(navigationView, sel_registerName("setAutoresizingMask:"), (1 << 1) ^ (1 << 4));
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(navigationController, sel_registerName("didMoveToParentViewController:"), rootViewController);
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(window, sel_registerName("setRootViewController:"), rootViewController);
    [rootViewController release];
    
    object_setInstanceVariable(self, "_window", [window retain]);
    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(window, sel_registerName("makeKeyAndVisible"));
    [window release];
}

@end
