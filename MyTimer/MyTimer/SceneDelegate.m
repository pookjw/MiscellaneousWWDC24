//
//  SceneDelegate.m
//  MyTimer
//
//  Created by Jinwoo Kim on 7/29/24.
//

#import "SceneDelegate.h"
#import "OdometerTesterViewController.h"

@implementation SceneDelegate

- (void)dealloc {
    [_window release];
    [super dealloc];
}

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    UIWindow *window = [[UIWindow alloc] initWithWindowScene:(UIWindowScene *)scene];
    
    OdometerTesterViewController *timerViewController = [OdometerTesterViewController new];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:timerViewController];
    [timerViewController release];
    
    window.rootViewController = navigationController;
    [navigationController release];
    
    self.window = window;
    [window makeKeyAndVisible];
    [window release];
}

@end
