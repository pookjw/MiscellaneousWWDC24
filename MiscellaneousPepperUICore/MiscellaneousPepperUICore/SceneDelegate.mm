//
//  SceneDelegate.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 8/1/24.
//

#import "SceneDelegate.h"
#import "ClassListViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface SceneDelegate ()
@property (strong, nonatomic) id window;
@end

@implementation SceneDelegate

+ (void)load {
    assert(class_addProtocol(self, NSProtocolFromString(@"UISceneDelegate")));
}

- (void)dealloc {
    [_window release];
    [super dealloc];
}

- (void)scene:(id)scene willConnectToSession:(id)session options:(id)connectionOptions {
    id window = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("UIWindow") alloc], sel_registerName("initWithWindowScene:"), scene);
    
    ClassListViewController *rootViewController = [ClassListViewController new];
    id navigationController = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("PUICNavigationController") alloc], sel_registerName("initWithRootViewController:"), rootViewController);
    [rootViewController release];
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(window, sel_registerName("setRootViewController:"), navigationController);
    [navigationController release];
    
    self.window = window;
    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(window, sel_registerName("makeKeyAndVisible"));
    [window release];
}

@end
