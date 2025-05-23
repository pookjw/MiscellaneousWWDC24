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
#import "ImmersiveSceneClientSettingsWindowScene.h"
#import "UpperLimbsWindowScene.h"
#import "VolumeBaseplateVisibilitySceneDelegate.h"
#import "ToggleImmersiveStylesSceneDelegate.h"
#import "SceneSizeRestrictionsSceneDelegate.h"
#import <CompositorServices/CompositorServices.h>
#import <objc/runtime.h>

CP_EXTERN const UISceneSessionRole CPSceneSessionRoleImmersiveSpaceApplication;

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
    
    if ([configuration.role isEqualToString:CPSceneSessionRoleImmersiveSpaceApplication]) {
        configuration.sceneClass = objc_lookUpClass("CPImmersiveScene");
    } else if ([activityType isEqualToString:@"LaunchPlacementParameters"]) {
        configuration.delegateClass = LaunchPlacementParametersWindowScene.class;
    } else if ([activityType isEqualToString:@"VolumetricWorldAlignmentBehavior"]) {
        configuration.delegateClass = VolumetricWorldAlignmentBehaviorWindowScene.class;
    } else if ([activityType isEqualToString:@"DefaultWorldScaling"]) {
        configuration.delegateClass = DefaultWorldScalingSceneDelegate.class;
    } else if ([activityType isEqualToString:@"ViewpointAzimuth"]) {
        configuration.delegateClass = ViewpointAzimuthWindowScene.class;
    } else if ([activityType isEqualToString:@"ImmersiveSceneClientSettings"]) {
        configuration.delegateClass = ImmersiveSceneClientSettingsWindowScene.class;
    } else if ([activityType isEqualToString:@"UpperLimbs"]) {
        configuration.delegateClass = UpperLimbsWindowScene.class;
    } else if ([activityType isEqualToString:@"VolumeBaseplateVisibility"]) {
        configuration.delegateClass = VolumeBaseplateVisibilitySceneDelegate.class;
    } else if ([activityType isEqualToString:@"ToggleImmersiveStyles"]) {
        configuration.delegateClass = ToggleImmersiveStylesSceneDelegate.class;
    } else if ([activityType isEqualToString:@"SceneSizeRestrictions"]) {
        configuration.delegateClass = SceneSizeRestrictionsSceneDelegate.class;
    } else if ([activityType isEqualToString:@"ARStereoProperties"]) {
        // NOP
    } else {
        configuration.delegateClass = SceneDelegate.class;
    }
    
    return [configuration autorelease];
}

@end
