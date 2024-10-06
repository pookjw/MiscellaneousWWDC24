//
//  SceneDelegate.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 8/1/24.
//

#import "SceneDelegate.h"
#import "ClassListViewController.h"
#import "AppDelegate.h"
#import <objc/message.h>
#import <objc/runtime.h>
#include <dlfcn.h>

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
        
        IMP scene_willConnectToSession = class_getMethodImplementation(self, @selector(scene:willConnectToSession:options:));
        assert(class_addMethod(_dynamicIsa, @selector(scene:willConnectToSession:options:), scene_willConnectToSession, NULL));
        
        IMP sceneDidBecomeActive = class_getMethodImplementation(self, @selector(sceneDidBecomeActive:));
        assert(class_addMethod(_dynamicIsa, @selector(sceneDidBecomeActive:), sceneDidBecomeActive, NULL));
        
        IMP sceneWillEnterForeground = class_getMethodImplementation(self, @selector(sceneWillEnterForeground:));
        assert(class_addMethod(_dynamicIsa, @selector(sceneWillEnterForeground:), sceneWillEnterForeground, NULL));
        
        IMP sceneDidEnterBackground = class_getMethodImplementation(self, @selector(sceneDidEnterBackground:));
        assert(class_addMethod(_dynamicIsa, @selector(sceneDidEnterBackground:), sceneDidEnterBackground, NULL));
        
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

- (void)scene:(id)scene willConnectToSession:(id)session options:(id)connectionOptions {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        id application = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("SPApplication"), sel_registerName("sharedSPApplication"));
        auto delegate = reinterpret_cast<AppDelegate * (*)(id, SEL)>(objc_msgSend)(application, sel_registerName("delegate"));
        
        id extensionConnection = delegate.extensionConnection;
        assert(extensionConnection != nullptr);
        
        id companionLogger = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("SPCompanionLogger"), sel_registerName("sharedInstance"));
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(companionLogger, sel_registerName("setExtensionConnection:"), extensionConnection);
        reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(extensionConnection, sel_registerName("didFinishLaunching:"), YES);
        
        //
        
        NSString *clientIdentifier = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(extensionConnection, sel_registerName("clientIdentifier"));
        id inProcessRemoteInterface = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(extensionConnection, sel_registerName("inProcessRemoteInterface"));
        
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(inProcessRemoteInterface, sel_registerName("setAppClientIdentifier:"), clientIdentifier);
        reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(inProcessRemoteInterface, sel_registerName("performDidFinishLaunchingCompletions"));
    });
    
    //
    
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

- (void)sceneDidBecomeActive:(id)scene {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        id application = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("SPApplication"), sel_registerName("sharedSPApplication"));
        auto delegate = reinterpret_cast<AppDelegate * (*)(id, SEL)>(objc_msgSend)(application, sel_registerName("delegate"));
        
        id extensionConnection = delegate.extensionConnection;
        assert(extensionConnection != nullptr);
        
        id inProcessRemoteInterface = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(extensionConnection, sel_registerName("inProcessRemoteInterface"));
        
        reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(extensionConnection, sel_registerName("didActivate"));
        
        void *handle = dlopen("/usr/lib/system/libxpc.dylib", RTLD_NOW);
        void *symbol = dlsym(handle, "os_transaction_create");
        assert(symbol != nullptr);
        
        NSString *name = [NSString stringWithFormat:@"appActive-%@", [NSUUID UUID].UUIDString];
        static id transaction = reinterpret_cast<id (*)(const char *)>(symbol)([name cStringUsingEncoding:NSUTF8StringEncoding]);
        
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(inProcessRemoteInterface, sel_registerName("performAfterApplicationDidFinishLaunching:"), ^{
            
        });
    });
}

- (void)sceneWillEnterForeground:(id)scene {
    id application = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("SPApplication"), sel_registerName("sharedSPApplication"));
    auto delegate = reinterpret_cast<AppDelegate * (*)(id, SEL)>(objc_msgSend)(application, sel_registerName("delegate"));
    
    id extensionConnection = delegate.extensionConnection;
    assert(extensionConnection != nullptr);
    
    id inProcessRemoteInterface = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(extensionConnection, sel_registerName("inProcessRemoteInterface"));
    
    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(extensionConnection, sel_registerName("appWillEnterForeground"));
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(inProcessRemoteInterface, sel_registerName("setAfterWillEnterForeground:"), YES);
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(inProcessRemoteInterface, sel_registerName("performAfterApplicationDidFinishLaunching:"), ^{
        
    });
}

- (void)sceneDidEnterBackground:(id)scene {
    id application = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("SPApplication"), sel_registerName("sharedSPApplication"));
    auto delegate = reinterpret_cast<AppDelegate * (*)(id, SEL)>(objc_msgSend)(application, sel_registerName("delegate"));
    
    id extensionConnection = delegate.extensionConnection;
    assert(extensionConnection != nullptr);
    
    id inProcessRemoteInterface = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(extensionConnection, sel_registerName("inProcessRemoteInterface"));
    
    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(extensionConnection, sel_registerName("appWillEnterForeground"));
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(inProcessRemoteInterface, sel_registerName("setAfterWillEnterForeground:"), NO);
}

@end
