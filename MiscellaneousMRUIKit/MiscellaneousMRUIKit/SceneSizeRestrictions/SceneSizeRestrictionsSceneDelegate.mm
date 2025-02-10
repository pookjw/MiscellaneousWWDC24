//
//  SceneSizeRestrictionsSceneDelegate.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 2/10/25.
//

#import "SceneSizeRestrictionsSceneDelegate.h"
#import "MiscellaneousMRUIKit-Swift.h"
#import "SceneSizeRestrictionsConfigurationViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import "SPGeometry.h"

@implementation SceneSizeRestrictionsSceneDelegate

- (void)dealloc {
    [_window release];
    [super dealloc];
}

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    UIWindow *window = [[UIWindow alloc] initWithWindowScene:(UIWindowScene *)scene];
    
#if MUI_PRIVATE
    UIViewController *rootViewController = MiscellaneousMRUIKit_Private::newRealityBoxViewHostingController();
#else
    UIViewController *rootViewController = MiscellaneousMRUIKit::newRealityBoxViewHostingController();
#endif
    
    SceneSizeRestrictionsConfigurationViewController *configurationViewController = [SceneSizeRestrictionsConfigurationViewController new];
    id ornament = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("MRUIPlatterOrnament") alloc], sel_registerName("initWithViewController:"), configurationViewController);
    [configurationViewController release];
    reinterpret_cast<void (*)(id, SEL, CGSize)>(objc_msgSend)(ornament, sel_registerName("setPreferredContentSize:"), CGSizeMake(400., 400.));
    
    {
        id position = reinterpret_cast<id (*)(id, SEL, SPPoint3D)>(objc_msgSend)([objc_lookUpClass("MRUIPlatterOrnamentRelativePosition") alloc], sel_registerName("initWithAnchorPoint:"), SPPoint3DMake(1., 0.5, 1.));
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(ornament, sel_registerName("setPosition:"), position);
        [position release];
    }
    
    reinterpret_cast<void (*)(id, SEL, SPPoint3D)>(objc_msgSend)(ornament, sel_registerName("setAnchorPosition:"), SPPoint3DMake(0., 200., 0.));
    
    id mrui_ornamentsItem = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(rootViewController, sel_registerName("mrui_ornamentsItem"));
    NSArray *_allOrnaments = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(mrui_ornamentsItem, sel_registerName("_allOrnaments"));
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(mrui_ornamentsItem, sel_registerName("_setAllOrnaments:"), [_allOrnaments arrayByAddingObject:ornament]);
    [ornament release];
    
    window.rootViewController = rootViewController;
    [rootViewController release];
    
    self.window = window;
    [window makeKeyAndVisible];
    [window release];
}

@end
