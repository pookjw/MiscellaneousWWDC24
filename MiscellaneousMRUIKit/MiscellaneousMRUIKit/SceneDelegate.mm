//
//  SceneDelegate.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 6/29/24.
//

#import "SceneDelegate.h"
#import "ClassListViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface SceneDelegate () {
    id _ornamentStatusRegistration;
}
@end

@implementation SceneDelegate

- (void)dealloc {
    [_window release];
    [super dealloc];
}

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    UIWindow *window = [[UIWindow alloc] initWithWindowScene:(UIWindowScene *)scene];
    
    _ornamentStatusRegistration = [[window registerForTraitChanges:@[objc_lookUpClass("MRUITraitOrnamentStatus")] withHandler:^(__kindof id<UITraitEnvironment>  _Nonnull traitEnvironment, UITraitCollection * _Nonnull previousCollection) {
        NSLog(@"%@", traitEnvironment);
    }] retain];
    
    ClassListViewController *classListViewController = [ClassListViewController new];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:classListViewController];
    [classListViewController release];
    
    window.rootViewController = navigationController;
    [navigationController release];
    
    self.window = window;
    [window makeKeyAndVisible];
    [window release];
}

@end
