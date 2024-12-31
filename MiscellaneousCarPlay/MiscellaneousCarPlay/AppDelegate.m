//
//  AppDelegate.m
//  MiscellaneousCarPlay
//
//  Created by Jinwoo Kim on 12/31/24.
//

#import "AppDelegate.h"
#import "SceneDelegate.h"
#import "CarPlaySceneDelegate.h"
#import "SecondaryCarPlaySceneDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    UISceneConfiguration *configuration = [connectingSceneSession.configuration copy];
    
    if ([configuration.role isEqualToString:CPTemplateApplicationSceneSessionRoleApplication]) {
        configuration.delegateClass = CarPlaySceneDelegate.class;
        return [configuration autorelease];
    } else if ([configuration.role isEqualToString:CPTemplateApplicationDashboardSceneSessionRoleApplication]) {
        configuration.delegateClass = SecondaryCarPlaySceneDelegate.class;
        configuration.sceneClass = CPTemplateApplicationDashboardScene.class;
        return [configuration autorelease];
    } else if ([configuration.role isEqualToString:CPTemplateApplicationInstrumentClusterSceneSessionRoleApplication]) {
        configuration.delegateClass = SecondaryCarPlaySceneDelegate.class;
        configuration.sceneClass = CPTemplateApplicationInstrumentClusterScene.class;
        return [configuration autorelease];
    } else if ([configuration.role isEqualToString:UIWindowSceneSessionRoleApplication]) {
        configuration.delegateClass = SceneDelegate.class;
        configuration.storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:NSBundle.mainBundle];
        return [configuration autorelease];
    } else {
        abort();
    }
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
