//
//  VolumeBaseplateVisibilitySceneDelegate.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 7/26/24.
//

#import "VolumeBaseplateVisibilitySceneDelegate.h"
#import <objc/message.h>
#import <objc/runtime.h>

@implementation VolumeBaseplateVisibilitySceneDelegate

- (void)dealloc {
    [_window release];
    [super dealloc];
}

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    UIWindow *window = [[UIWindow alloc] initWithWindowScene:(UIWindowScene *)scene];
    
    UIViewController *rootViewController = [UIViewController new];
    rootViewController.view.backgroundColor = UIColor.systemCyanColor;
    
    window.rootViewController = rootViewController;
    [rootViewController release];
    
    // 0 : automatic, 1 : visible, 2 : hidden
    ((void (*)(id, SEL, id, id))objc_msgSend)(rootViewController.view, sel_registerName("setValue:forPreferenceKey:"), @(2), objc_lookUpClass("MRUIVolumeBaseplateVisibilityPreferenceKey"));
    
    self.window = window;
    [window makeKeyAndVisible];
    [window release];
}

@end
