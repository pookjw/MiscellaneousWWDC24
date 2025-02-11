//
//  VisualFidelityViewController.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 2/11/25.
//

#import "VisualFidelityViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>
#include <dlfcn.h>
#include <ranges>
#include <vector>

OBJC_EXPORT id objc_msgSendSuper2(void); /* objc_super superInfo = { self, [self class] }; */

NSString * mui_NSStringFromMRUIVisualFidelity(NSUInteger fidelity) {
    static void *symbol;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        void *handle = dlopen("/System/Library/PrivateFrameworks/MRUIKit.framework/MRUIKit", RTLD_NOW);
        assert(handle != NULL);
        void *_symbol = dlsym(handle, "NSStringFromMRUIVisualFidelity");
        assert(_symbol != NULL);
        symbol = _symbol;
    });
    
    return reinterpret_cast<id (*)(NSUInteger)>(symbol)(fidelity);
}
/*
 for (NSUInteger i = 0; i < NSUIntegerMax; i++) {
     if (NSString *s = mui_NSStringFromMRUIVisualFidelity(i)) {
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

@implementation VisualFidelityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton new];
    
    button.menu = [self _makeMenu];
    button.showsMenuAsPrimaryAction = YES;
    button.preferredMenuElementOrder = UIContextMenuConfigurationElementOrderFixed;
    
    UIButtonConfiguration *configuration = [UIButtonConfiguration tintedButtonConfiguration];
    configuration.title = @"Request Volumetric Window";
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
            UIAction *action = [UIAction actionWithTitle:mui_NSStringFromMRUIVisualFidelity(number)
                                                   image:nil
                                              identifier:nil
                                                 handler:^(__kindof UIAction * _Nonnull action) {
                [weakSelf _requestSceneWithVisualFidelity:number];
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

- (void)_requestSceneWithVisualFidelity:(NSUInteger)visualFidelity {
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
    
    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(initialClientSettings, sel_registerName("setPreferredVisualFidelity:"), visualFidelity);
    
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
