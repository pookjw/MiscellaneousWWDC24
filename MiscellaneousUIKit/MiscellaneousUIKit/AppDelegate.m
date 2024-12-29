//
//  AppDelegate.m
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/11/24.
//

#import "AppDelegate.h"
#import "SceneDelegate.h"
#import "OrangeSceneDelegate.h"
#import <TargetConditionals.h>
#import <CarPlay/CarPlay.h>
#import "CarPlaySceneDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSURL *scCacheURL = [[NSFileManager.defaultManager URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask].firstObject URLByAppendingPathComponent:@"Saved Application State" isDirectory:YES];
    [NSFileManager.defaultManager removeItemAtURL:scCacheURL error:NULL];
    
    return YES;
}

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    UISceneConfiguration *configuration = [connectingSceneSession.configuration copy];
    
    if ([configuration.role isEqualToString:CPTemplateApplicationSceneSessionRoleApplication]) {
        configuration.delegateClass = CarPlaySceneDelegate.class;
        return [configuration autorelease];
    }
    
    NSUserActivity * _Nullable userActivity = options.userActivities.allObjects.firstObject;
    NSString * _Nullable activityType = userActivity.activityType;
    
    if ([activityType isEqualToString:@"Orange"]) {
        configuration.delegateClass = OrangeSceneDelegate.class;
    } else {
        configuration.delegateClass = SceneDelegate.class;
    }
    
    return [configuration autorelease];
}

@end
