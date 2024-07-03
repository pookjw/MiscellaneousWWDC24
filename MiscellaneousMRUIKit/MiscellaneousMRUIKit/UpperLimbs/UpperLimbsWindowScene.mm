//
//  UpperLimbsWindowScene.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 7/3/24.
//

#import "UpperLimbsWindowScene.h"

@implementation UpperLimbsWindowScene

- (void)dealloc {
    [_window release];
    [super dealloc];
}

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    UIWindow *window = [[UIWindow alloc] initWithWindowScene:static_cast<UIWindowScene *>(scene)];
    
    UIViewController *rootViewController = [UIViewController new];
    rootViewController.view.backgroundColor = UIColor.systemOrangeColor;
    
    window.rootViewController = rootViewController;
    [rootViewController release];
    
    self.window = window;
    [window makeKeyAndVisible];
    [window release];
}


@end
