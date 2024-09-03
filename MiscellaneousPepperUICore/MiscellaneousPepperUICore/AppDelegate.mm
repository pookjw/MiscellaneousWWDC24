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

@implementation AppDelegate

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
        Class _dynamicIsa = objc_allocateClassPair(objc_lookUpClass("UIResponder"), "_AppDelegate", 0);
        
        IMP dealloc = class_getMethodImplementation(self, @selector(dealloc));
        assert(class_addMethod(_dynamicIsa, @selector(dealloc), dealloc, NULL));
        
        IMP description = class_getMethodImplementation(self, @selector(description));
        assert(class_addMethod(_dynamicIsa, @selector(description), description, NULL));
        
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
        
        assert(class_addProtocol(_dynamicIsa, NSProtocolFromString(@"UIApplicationDelegate")));
        
        dynamicIsa = _dynamicIsa;
    });
    
    return dynamicIsa;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"
- (void)dealloc {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
}
#pragma clang diagnostic pop

- (NSString *)description {
    return [NSString stringWithFormat:@"<%s: %p>", class_getName(self.class), self];
}

- (BOOL)application:(id)application didFinishLaunchingWithOptions:(NSDictionary<NSString *, id> *)launchOptions {
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

- (void)didReceiveNonClockKitEvent {
    
}

- (id)window {
    return nil;
}

- (id)extendLaunchTest {
    return nil;
}

- (void)applicationWillSuspend:(id)application {
    
}

- (void)handleWatchActions:(NSSet/* <PUICInitializeSessionServiceAction *> */ *)watchActions completion:(void (^)())completion {
    completion();
}

@end
