//
//  VolumetricWorldAlignmentBehaviorWindowScene.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 6/29/24.
//

#import "VolumetricWorldAlignmentBehaviorWindowScene.h"

@implementation VolumetricWorldAlignmentBehaviorWindowScene

- (void)dealloc {
    [_window release];
    [super dealloc];
}

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    UIWindow *window = [[UIWindow alloc] initWithWindowScene:(UIWindowScene *)scene];
    
    UIViewController *rootViewController = [UIViewController new];
    rootViewController.view.backgroundColor = UIColor.systemGreenColor;
    
    window.rootViewController = rootViewController;
    [rootViewController release];
    
    self.window = window;
    [window makeKeyAndVisible];
    [window release];
}

@end
