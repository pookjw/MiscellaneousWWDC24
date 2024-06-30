//
//  AppDelegate.m
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 6/29/24.
//

#import "AppDelegate.h"
#import "SceneDelegate.h"
#import "LaunchPlacementParametersWindowScene.h"
#import "VolumetricWorldAlignmentBehaviorWindowScene.h"
#import "DefaultWorldScalingSceneDelegate.h"
#import "ViewpointAzimuthWindowScene.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    NSUserActivity * _Nullable userActivity = options.userActivities.allObjects.firstObject;
    NSString * _Nullable activityType = userActivity.activityType;
    
    UISceneConfiguration *configuration = [connectingSceneSession.configuration copy];
    
    if ([activityType isEqualToString:@"LaunchPlacementParameters"]) {
        configuration.delegateClass = LaunchPlacementParametersWindowScene.class;
    } else if ([activityType isEqualToString:@"VolumetricWorldAlignmentBehavior"]) {
        configuration.delegateClass = VolumetricWorldAlignmentBehaviorWindowScene.class;
    } else if ([activityType isEqualToString:@"DefaultWorldScaling"]) {
        configuration.delegateClass = DefaultWorldScalingSceneDelegate.class;
    } else if ([activityType isEqualToString:@"ViewpointAzimuth"]) {
        configuration.delegateClass = ViewpointAzimuthWindowScene.class;
    } else {
        configuration.delegateClass = SceneDelegate.class;
    }
    
    return [configuration autorelease];
}

@end
