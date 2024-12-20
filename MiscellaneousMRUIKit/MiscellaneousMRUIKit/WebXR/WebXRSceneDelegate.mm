//
//  WebXRSceneDelegate.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 12/20/24.
//

#import "WebXRSceneDelegate.h"
#import <CompositorServices/CompositorServices.h>
#import <objc/message.h>
#import <objc/runtime.h>

@implementation WebXRSceneDelegate

- (void)dealloc {
    [_window release];
    [super dealloc];
}

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(scene, NSSelectorFromString(@"setConfigurationProvider:"), self);
    
//    UIWindow *window = [[objc_lookUpClass("CPSceneLayerEventWindow") alloc] initWithWindowScene:(UIWindowScene *)scene];
//    UIViewController *rootViewController = [UIViewController new];
//    window.rootViewController = rootViewController;
//    [rootViewController release];
//    
//    self.window = window;
//    [window makeKeyAndVisible];
//    [window release];
}

@end
