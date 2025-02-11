//
//  DisplayContentModeViewController.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 2/11/25.
//

#import "DisplayContentModeViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>
#include <dlfcn.h>
#include <ranges>
#include <vector>

NSString * mui_NSStringFromMRUIDisplayContentMode(NSUInteger mode) {
    static void *symbol;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        void *handle = dlopen("/System/Library/PrivateFrameworks/MRUIKit.framework/MRUIKit", RTLD_NOW);
        assert(handle != NULL);
        void *_symbol = dlsym(handle, "NSStringFromMRUIDisplayContentMode");
        assert(_symbol != NULL);
        symbol = _symbol;
    });
    
    return reinterpret_cast<id (*)(NSUInteger)>(symbol)(mode);
}

/*
 for (NSUInteger i = 0; i < NSUIntegerMax; i++) {
     if (NSString *s = mui_NSStringFromMRUIDisplayContentMode(i)) {
         NSLog(@"%@ %ld", s, i);
     }
 }
 */

/*
 Automatic 0
 Reality 1
 Media 2
 Creation 3
 Camera 4
 */

@implementation DisplayContentModeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton new];
    
    button.menu = [self _makeMenu];
    button.showsMenuAsPrimaryAction = YES;
    button.preferredMenuElementOrder = UIContextMenuConfigurationElementOrderFixed;
    
    UIButtonConfiguration *configuration = [UIButtonConfiguration tintedButtonConfiguration];
    configuration.title = @"Display Content Mode";
    button.configuration = configuration;
    
    [self.view addSubview:button];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self.view, sel_registerName("_addBoundsMatchingConstraintsForView:"), button);
    [button release];
    
    self.navigationItem.title = @"???";
}

- (UIMenu *)_makeMenu {
    __weak auto weakSelf = self;
    
    UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
        auto actionsVec = std::vector<NSUInteger> { 0, 1, 2, 3, 4 }
        | std::views::transform([weakSelf](NSUInteger number) -> UIAction * {
            UIAction *action = [UIAction actionWithTitle:mui_NSStringFromMRUIDisplayContentMode(number)
                                                   image:nil
                                              identifier:nil
                                                 handler:^(__kindof UIAction * _Nonnull action) {
                [weakSelf _requestSceneWithDisplayContentMode:number];
            }];
            
            return action;
        })
        | std::ranges::to<std::vector<UIAction *>>();
        
        NSArray<UIAction *> *actions = [[NSArray alloc] initWithObjects:actionsVec.data() count:actionsVec.size()];
        completion(actions);
        [actions release];
    }];
    
    return [UIMenu menuWithChildren:@[element]];
}

- (void)_requestSceneWithDisplayContentMode:(NSUInteger)displayContentMode {
    id sceneRequestOptions = [objc_lookUpClass("MRUISceneRequestOptions") new];
    
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(sceneRequestOptions, NSSelectorFromString(@"setInternalFrameworksScene:"), NO);
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(sceneRequestOptions, NSSelectorFromString(@"setDisableDefocusBehavior:"), NO);
    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(sceneRequestOptions, NSSelectorFromString(@"setPreferredImmersionStyle:"), 0);
    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(sceneRequestOptions, NSSelectorFromString(@"setAllowedImmersionStyles:"), 0);
    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(sceneRequestOptions, NSSelectorFromString(@"setSceneRequestIntent:"), 1005);
    
    id specification = [objc_lookUpClass("MRUISharedApplicationFullscreenSceneSpecification_SwiftUI") new];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(sceneRequestOptions, NSSelectorFromString(@"setSpecification:"), specification);
    [specification release];
    
    id initialClientSettings = [objc_lookUpClass("MRUIMutableImmersiveSceneClientSettings") new];
    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(initialClientSettings, NSSelectorFromString(@"setPreferredImmersionStyle:"), 0);
    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(initialClientSettings, NSSelectorFromString(@"setAllowedImmersionStyles:"), 0);
    
    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(initialClientSettings, sel_registerName("setPreferredDisplayContentMode:"), displayContentMode);
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(sceneRequestOptions, sel_registerName("setInitialClientSettings:"), initialClientSettings);
    [initialClientSettings release];
    
    NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:@"VolumetricWorldAlignmentBehavior"];
    
    reinterpret_cast<void (*)(id, SEL, id, id, id)>(objc_msgSend)(UIApplication.sharedApplication,
                                                                  NSSelectorFromString(@"mrui_requestSceneWithUserActivity:requestOptions:completionHandler:"),
                                                                  userActivity,
                                                                  sceneRequestOptions,
                                                                  ^(NSError * _Nullable error) {
        assert(error == nil);
    });
    
    [sceneRequestOptions release];
    [userActivity release];
}

@end
