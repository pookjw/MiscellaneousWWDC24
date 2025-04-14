//
//  SceneDelegate.m
//  MiscellaneousMapKit
//
//  Created by Jinwoo Kim on 4/13/25.
//

#import "SceneDelegate.h"
#import "MapViewController.h"

@implementation SceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    UIWindow *window = [[UIWindow alloc] initWithWindowScene:(UIWindowScene *)scene];
    MapViewController *viewController = [MapViewController new];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [viewController release];
    window.rootViewController = navigationController;
    [navigationController release];
    self.window = window;
    [window makeKeyAndVisible];
    [window release];
}

@end
