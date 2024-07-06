//
//  AppDelegate.m
//  VoluemKeyPad
//
//  Created by Jinwoo Kim on 7/6/24.
//

#import "AppDelegate.h"
#import "SceneDelegate.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    UISceneConfiguration *configration = [connectingSceneSession.configuration copy];
    configration.delegateClass = SceneDelegate.class;
    return [configration autorelease];
}

@end
