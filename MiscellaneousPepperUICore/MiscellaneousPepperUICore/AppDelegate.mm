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

@implementation AppDelegate

+ (void)load {
    assert(class_addProtocol(self, NSProtocolFromString(@"UIApplicationDelegate")));
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
    
    reinterpret_cast<void (*)(id, SEL, Class)>(objc_msgSend)(newConfiguration, sel_registerName("setDelegateClass:"), SceneDelegate.class);
    
    return [newConfiguration autorelease];
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

@end
