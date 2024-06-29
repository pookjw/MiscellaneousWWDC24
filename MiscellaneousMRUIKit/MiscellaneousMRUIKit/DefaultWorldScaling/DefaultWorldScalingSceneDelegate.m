//
//  DefaultWorldScalingSceneDelegate.m
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 6/29/24.
//

#import "DefaultWorldScalingSceneDelegate.h"

@implementation DefaultWorldScalingSceneDelegate

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
    
    self.window = window;
    [window makeKeyAndVisible];
    [window release];
}


@end
