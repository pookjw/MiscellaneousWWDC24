//
//  UpperLimbsViewController.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 7/3/24.
//

#import "UpperLimbsViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface UpperLimbsViewController ()
@property (retain, readonly, nonatomic) UIStackView *stackView;
@property (retain, readonly, nonatomic) UIButton *requestSceneButton;
@property (retain, readonly, nonatomic) UIButton *automaticUpperLimbsButton;
@property (retain, readonly, nonatomic) UIButton *showUpperLimbsButton;
@property (retain, readonly, nonatomic) UIButton *hideUpperLimbsButton;
@end

@implementation UpperLimbsViewController
@synthesize stackView = _stackView;
@synthesize requestSceneButton = _requestSceneButton;
@synthesize automaticUpperLimbsButton = _automaticUpperLimbsButton;
@synthesize showUpperLimbsButton = _showUpperLimbsButton;
@synthesize hideUpperLimbsButton = _hideUpperLimbsButton;

- (void)dealloc {
    [_stackView release];
    [_requestSceneButton release];
    [_automaticUpperLimbsButton release];
    [_showUpperLimbsButton release];
    [_hideUpperLimbsButton release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.stackView;
}

- (UIStackView *)stackView {
    if (auto stackView = _stackView) return stackView;
    
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[
        self.requestSceneButton,
        self.automaticUpperLimbsButton,
        self.showUpperLimbsButton,
        self.hideUpperLimbsButton
    ]];
    
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.alignment = UIStackViewAlignmentFill;
    stackView.distribution = UIStackViewDistributionFillEqually;
    
    _stackView = stackView;
    return [stackView autorelease];
}

- (UIButton *)requestSceneButton {
    if (auto requestSceneButton = _requestSceneButton) return requestSceneButton;
    
    UIAction *primaryAction = [UIAction actionWithTitle:@"Show Window" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        id sceneRequestOptions = [objc_lookUpClass("MRUISceneRequestOptions") new];
        
        reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(sceneRequestOptions, NSSelectorFromString(@"setInternalFrameworksScene:"), NO);
        reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(sceneRequestOptions, NSSelectorFromString(@"setDisableDefocusBehavior:"), NO);
        reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(sceneRequestOptions, NSSelectorFromString(@"setPreferredImmersionStyle:"), 8);
        reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(sceneRequestOptions, NSSelectorFromString(@"setAllowedImmersionStyles:"), 8);
        reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(sceneRequestOptions, NSSelectorFromString(@"setSceneRequestIntent:"), 1002);
        
        id specification = [objc_lookUpClass("MRUISharedApplicationFullscreenSceneSpecification_SwiftUI") new];
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(sceneRequestOptions, NSSelectorFromString(@"setSpecification:"), specification);
        [specification release];
        
        id initialClientSettings = [objc_lookUpClass("MRUIMutableImmersiveSceneClientSettings") new];
        reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(initialClientSettings, NSSelectorFromString(@"setPreferredImmersionStyle:"), 8);
        reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(initialClientSettings, NSSelectorFromString(@"setAllowedImmersionStyles:"), 8);
        
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(sceneRequestOptions, sel_registerName("setInitialClientSettings:"), initialClientSettings);
        [initialClientSettings release];
        
        NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:@"ImmersiveSceneClientSettings"];
        
        reinterpret_cast<void (*)(id, SEL, id, id, id)>(objc_msgSend)(UIApplication.sharedApplication,
                                                                      NSSelectorFromString(@"mrui_requestSceneWithUserActivity:requestOptions:completionHandler:"),
                                                                      userActivity,
                                                                      sceneRequestOptions,
                                                                      ^(NSError * _Nullable error) {
            assert(error == nil);
        });
        
        [sceneRequestOptions release];
        [userActivity release];
    }];
    
    UIButton *requestSceneButton = [UIButton systemButtonWithPrimaryAction:primaryAction];
    
    _requestSceneButton = [requestSceneButton retain];
    return requestSceneButton;
}

- (UIButton *)automaticUpperLimbsButton {
    if (auto automaticUpperLimbsButton = _automaticUpperLimbsButton) return automaticUpperLimbsButton;
    
    UIAction *primaryAction = [UIAction actionWithTitle:@"Automatic Upper Limbs" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        // MRUIStage
        id activeStage = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("MRUIStage"), sel_registerName("_activeStage"));
        
        reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(activeStage, sel_registerName("setPreferredVirtualHandsVisibility:"), 0);
    }];
    
    UIButton *automaticUpperLimbsButton = [UIButton systemButtonWithPrimaryAction:primaryAction];
    
    _automaticUpperLimbsButton = [automaticUpperLimbsButton retain];
    return automaticUpperLimbsButton;
}

- (UIButton *)showUpperLimbsButton {
    if (auto showUpperLimbsButton = _showUpperLimbsButton) return showUpperLimbsButton;
    
    UIAction *primaryAction = [UIAction actionWithTitle:@"Show Upper Limbs" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        for (__kindof UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
            if (![scene isKindOfClass:UIWindowScene.class]) continue;
            if (![scene.session.role isEqualToString:UISceneSessionRoleImmersiveSpaceApplication]) continue;
            
            UIWindowScene *windowScene = static_cast<UIWindowScene *>(scene);
            
            // FBSScene
            id fbsScene = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(windowScene, sel_registerName("_scene"));
            
            reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(fbsScene, sel_registerName("updateClientSettingsWithTransitionBlock:"), ^(id /* (MRUIMutableSharedApplicationSceneClientSettings *) */ mutableSettings, id /* (FBSSceneTransitionContext *) */ _) {
                reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(mutableSettings, sel_registerName("setPreferredVirtualHandsVisibility:"), @1);
                
                // FBSSceneTransitionContext
                id transitionContext = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("FBSSceneTransitionContext"), sel_registerName("transitionContext"));
                
                id _currentAnimationSettings = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(UIView.class, sel_registerName("_currentAnimationSettings"));
                
                reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(transitionContext, sel_registerName("setAnimationSettings:"), _currentAnimationSettings);
            });
            
            break;
        }
    }];
    
    UIButton *showUpperLimbsButton = [UIButton systemButtonWithPrimaryAction:primaryAction];
    
    _showUpperLimbsButton = [showUpperLimbsButton retain];
    return showUpperLimbsButton;
}

- (UIButton *)hideUpperLimbsButton {
    if (auto hideUpperLimbsButton = _hideUpperLimbsButton) return hideUpperLimbsButton;
    
    UIAction *primaryAction = [UIAction actionWithTitle:@"Hide Upper Limbs" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
//        for (__kindof UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
//            if (![scene isKindOfClass:UIWindowScene.class]) continue;
//            if (![scene.session.role isEqualToString:UISceneSessionRoleImmersiveSpaceApplication]) continue;
//            
//            UIWindowScene *windowScene = static_cast<UIWindowScene *>(scene);
//            UIWindow *keyWindow = windowScene.keyWindow;
//            UIView *rootView = keyWindow.rootViewController.view;
//            
//            reinterpret_cast<void (*)(id, SEL, id, id)>(objc_msgSend)(rootView, sel_registerName("setValue:forPreferenceKey:"), @2, objc_lookUpClass("MRUIUpperLimbsVisibilityPreferenceKey"));
//            
//            break;
//        }
        
        // MRUIStage
        id activeStage = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("MRUIStage"), sel_registerName("_activeStage"));
        
        reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(activeStage, sel_registerName("setPreferredVirtualHandsVisibility:"), 2);
    }];
    
    UIButton *hideUpperLimbsButton = [UIButton systemButtonWithPrimaryAction:primaryAction];
    
    _hideUpperLimbsButton = [hideUpperLimbsButton retain];
    return hideUpperLimbsButton;
}

@end
