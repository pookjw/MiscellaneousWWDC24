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
    
    // -[SPHostingViewController initWithInterfaceDescription:bundle:stringsFileName:]
    id rootViewController = reinterpret_cast<id (*)(id, SEL, id, id, id)>(objc_msgSend)([objc_lookUpClass("SPHostingViewController") alloc], sel_registerName("initWithInterfaceDescription:bundle:stringsFileName:"), nil, nil, nil);
    
    ClassListViewController *classListViewController = [ClassListViewController new];
    id navigationController = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("PUICNavigationController") alloc], sel_registerName("initWithRootViewController:"), classListViewController);
    [classListViewController release];
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(rootViewController, sel_registerName("addChildViewController:"), navigationController);
    id navigationView = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(navigationController, sel_registerName("view"));
    id rootView = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(rootViewController, sel_registerName("view"));
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(rootView, sel_registerName("addSubview:"), navigationView);
    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(navigationView, sel_registerName("setAutoresizingMask:"), (1 << 1) ^ (1 << 4));
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(navigationController, sel_registerName("didMoveToParentViewController:"), rootViewController);
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(window, sel_registerName("setRootViewController:"), rootViewController);
    [rootViewController release];
    
    self.window = window;
    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(window, sel_registerName("makeKeyAndVisible"));
    [window release];
}

@end
