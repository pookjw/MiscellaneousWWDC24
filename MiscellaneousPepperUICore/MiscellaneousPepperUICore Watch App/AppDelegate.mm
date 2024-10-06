//
//  AppDelegate.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 8/1/24.
//

#import "AppDelegate.h"
#import "SceneDelegate.h"
#import <objc/message.h>
#import <objc/runtime.h>

OBJC_EXPORT id _Nullable objc_msgSend_noarg(id _Nullable self, SEL _Nonnull _cmd);
OBJC_EXPORT id objc_msgSendSuper2(void);

__attribute__((objc_direct_members))
@interface AppDelegate ()
@property (retain, nonatomic) id extensionConnection;
@end

@implementation AppDelegate

+ (void)load {
    [self dynamisIsa];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [[self dynamisIsa] allocWithZone:zone];
}

+ (BOOL)conformsToProtocol:(Protocol *)protocol {
    return [[self dynamisIsa] conformsToProtocol:protocol];
}

+ (Class)dynamisIsa {
    static Class dynamicIsa;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class _dynamicIsa = objc_allocateClassPair(objc_lookUpClass("UIResponder"), "_AppDelegate", 0);
        
        Protocol *UIApplicationDelegate = NSProtocolFromString(@"UIApplicationDelegate");
        assert(UIApplicationDelegate != nullptr);
        assert(class_addProtocol(_dynamicIsa, UIApplicationDelegate));
        
        Protocol *SPExtensionConnectionDelegate = NSProtocolFromString(@"SPExtensionConnectionDelegate");
        assert(SPExtensionConnectionDelegate != nullptr);
        assert(class_addProtocol(_dynamicIsa, SPExtensionConnectionDelegate));
        
        IMP dealloc = class_getMethodImplementation(self, @selector(dealloc));
        assert(class_addMethod(_dynamicIsa, @selector(dealloc), dealloc, NULL));
        
        IMP respondsToSelector = class_getMethodImplementation(self, @selector(respondsToSelector:));
        assert(class_addMethod(_dynamicIsa, @selector(respondsToSelector:), respondsToSelector, NULL));
        
        IMP application_didFinishLaunchingWithOptions = class_getMethodImplementation(self, @selector(application:didFinishLaunchingWithOptions:));
        assert(class_addMethod(_dynamicIsa, @selector(application:didFinishLaunchingWithOptions:), application_didFinishLaunchingWithOptions, NULL));
        
        IMP application_configurationForConnectingSceneSession_options = class_getMethodImplementation(self, @selector(application:configurationForConnectingSceneSession:options:));
        assert(class_addMethod(_dynamicIsa, @selector(application:configurationForConnectingSceneSession:options:), application_configurationForConnectingSceneSession_options, NULL));
        
        IMP application_supportedInterfaceOrientationsForWindow = class_getMethodImplementation(self, @selector(application:supportedInterfaceOrientationsForWindow:));
        assert(class_addMethod(_dynamicIsa, @selector(application:supportedInterfaceOrientationsForWindow:), application_supportedInterfaceOrientationsForWindow, NULL));
        
        IMP didReceiveNonClockKitEvent = class_getMethodImplementation(self, @selector(didReceiveNonClockKitEvent));
        assert(class_addMethod(_dynamicIsa, @selector(didReceiveNonClockKitEvent), didReceiveNonClockKitEvent, NULL));
        
        IMP window = class_getMethodImplementation(self, @selector(window));
        assert(class_addMethod(_dynamicIsa, @selector(window), window, NULL));
        
        IMP extendLaunchTest = class_getMethodImplementation(self, @selector(extendLaunchTest));
        assert(class_addMethod(_dynamicIsa, @selector(extendLaunchTest), extendLaunchTest, NULL));
        
        IMP applicationWillSuspend = class_getMethodImplementation(self, @selector(applicationWillSuspend:));
        assert(class_addMethod(_dynamicIsa, @selector(applicationWillSuspend:), applicationWillSuspend, NULL));
        
        IMP handleWatchActions_completion = class_getMethodImplementation(self, @selector(handleWatchActions:completion:));
        assert(class_addMethod(_dynamicIsa, @selector(handleWatchActions:completion:), handleWatchActions_completion, NULL));
        
        IMP handleBackgroundTasks = class_getMethodImplementation(self, @selector(handleBackgroundTasks:));
        assert(class_addMethod(_dynamicIsa, @selector(handleBackgroundTasks:), handleBackgroundTasks, NULL));
        
        IMP extensionConnection_directXPCSetupDidFailWithError = class_getMethodImplementation(self, @selector(extensionConnection:directXPCSetupDidFailWithError:));
        assert(class_addMethod(_dynamicIsa, @selector(extensionConnection:directXPCSetupDidFailWithError:), extensionConnection_directXPCSetupDidFailWithError, NULL));
        
        IMP extensionConnectionApplicationDidEndSuspendedLaunch = class_getMethodImplementation(self, @selector(extensionConnectionApplicationDidEndSuspendedLaunch:));
        assert(class_addMethod(_dynamicIsa, @selector(extensionConnectionApplicationDidEndSuspendedLaunch:), extensionConnectionApplicationDidEndSuspendedLaunch, NULL));
        
        IMP launchedSuspendedNotInDock = class_getMethodImplementation(self, @selector(launchedSuspendedNotInDock));
        assert(class_addMethod(_dynamicIsa, @selector(launchedSuspendedNotInDock), launchedSuspendedNotInDock, NULL));
        
        IMP setLaunchedSuspendedNotInDock = class_getMethodImplementation(self, @selector(setLaunchedSuspendedNotInDock:));
        assert(class_addMethod(_dynamicIsa, @selector(setLaunchedSuspendedNotInDock:), setLaunchedSuspendedNotInDock, NULL));
        
        assert(class_addIvar(_dynamicIsa, "_extensionConnection", sizeof(id), sizeof(id), @encode(id)));
        assert(class_addIvar(_dynamicIsa, "_launchedSuspendedNotInDock", sizeof(BOOL), sizeof(BOOL), @encode(BOOL)));
        
        objc_registerClassPair(_dynamicIsa);
        
        dynamicIsa = _dynamicIsa;
    });
    
    return dynamicIsa;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"
- (void)dealloc {
    id _extensionConnection;
    assert(object_getInstanceVariable(self, "_extensionConnection", reinterpret_cast<void **>(&_extensionConnection)) != nullptr);
    [_extensionConnection release];
    
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
}
#pragma clang diagnostic pop

- (BOOL)respondsToSelector:(SEL)aSelector {
    objc_super superInfo = { self, [self class] };
    BOOL responds = reinterpret_cast<BOOL (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
    
    if (!responds) {
        NSLog(@"%@: %s", NSStringFromClass(self.class), sel_getName(aSelector));
    }
    
    return responds;
}

- (BOOL)application:(id)application didFinishLaunchingWithOptions:(NSDictionary<NSString *, id> *)launchOptions {
    id bundleRecordForCurrentProcess = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("LSBundleRecord"), sel_registerName("bundleRecordForCurrentProcess"));
    id bundleIdentifier = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(bundleRecordForCurrentProcess, sel_registerName("bundleIdentifier"));
    
    id extensionConnection = [objc_lookUpClass("SPExtensionConnection") new];
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(extensionConnection, sel_registerName("setDelegate:"), self);
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(extensionConnection, sel_registerName("setInSuspendedLaunch:"), YES);
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(extensionConnection, sel_registerName("setUpNativeAppWithServerIdentifer:"), bundleIdentifier);
    
    self.extensionConnection = extensionConnection;
    [extensionConnection release];
    
    //
    
    NSURL *scCacheURL = [[NSFileManager.defaultManager URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask].firstObject URLByAppendingPathComponent:@"Saved Application State" isDirectory:YES];
    [NSFileManager.defaultManager removeItemAtURL:scCacheURL error:NULL];
    
    return YES;
}

- (id)application:(id)application configurationForConnectingSceneSession:(id)connectingSceneSession options:(id)options {
    // UISceneConfiguration *
    id oldConfiguration = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend_noarg)(connectingSceneSession, sel_registerName("configuration"));
    id newConfiguration = [oldConfiguration copy];
    
    reinterpret_cast<void (*)(id, SEL, Class)>(objc_msgSend)(newConfiguration, sel_registerName("setDelegateClass:"), [SceneDelegate dynamisIsa]);
    
    return [newConfiguration autorelease];
}

// Not Called
- (NSUInteger)application:(id)application supportedInterfaceOrientationsForWindow:(id)window {
    return 30;
}

#warning -[SPExtensionConnection interfaceViewControllerDidAppear:]도 해줘야 하나?

- (void)didReceiveNonClockKitEvent {
    id bundleRecordForCurrentProcess = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("LSBundleRecord"), sel_registerName("bundleRecordForCurrentProcess"));
    id bundleIdentifier = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(bundleRecordForCurrentProcess, sel_registerName("bundleIdentifier"));
    id extensionConnection = self.extensionConnection;
    assert(extensionConnection != nullptr);
    
    reinterpret_cast<void (*)(id, SEL, id, id)>(objc_msgSend)(extensionConnection, sel_registerName("connectWithIdentifier:completion:"), bundleIdentifier, ^{
        NSLog(@"completion");
    });
    
//    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(extensionConnection, sel_registerName("connectWithIdentifier:"), bundleIdentifier);
}

- (id)window {
    return nil;
}

- (id)extendLaunchTest {
    return reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self.extensionConnection, sel_registerName("extendLaunchTest"));
}

- (void)applicationWillSuspend:(id)application {
    
}

- (void)handleWatchActions:(NSSet/* <PUICInitializeSessionServiceAction *> */ *)watchActions completion:(void (^)())completion {
    completion();
}

- (BOOL)launchedSuspendedNotInDock {
    BOOL result;
    assert(object_getInstanceVariable(self, "_launchedSuspendedNotInDock", reinterpret_cast<void **>(&result)) != nullptr);
    return result;
}

- (void)setLaunchedSuspendedNotInDock:(BOOL)arg1 {
    assert(object_setInstanceVariable(self, "_launchedSuspendedNotInDock", reinterpret_cast<void *>(arg1)) != nullptr);
}

- (id)extensionConnection {
    id _extensionConnection;
    assert(object_getInstanceVariable(self, "_extensionConnection", reinterpret_cast<void **>(&_extensionConnection)) != nullptr);
    
    return _extensionConnection;
}

- (void)setExtensionConnection:(id)extensionConnection {
    id _extensionConnection;
    assert(object_getInstanceVariable(self, "_extensionConnection", reinterpret_cast<void **>(&_extensionConnection)) != nullptr);
    [_extensionConnection release];
    
    assert(object_setInstanceVariable(self, "_extensionConnection", reinterpret_cast<void *>([extensionConnection retain])) != nullptr);
}

- (void)extensionConnection:(id)extensionConnection directXPCSetupDidFailWithError:(NSError *)error {
    abort();
}

- (void)extensionConnectionApplicationDidEndSuspendedLaunch:(id)extensionConnection {
    
}

@end
