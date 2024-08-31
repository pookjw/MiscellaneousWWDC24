//
//  ToggleImmersiveStylesViewController.m
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 8/29/24.
//

#import "ToggleImmersiveStylesViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import <dlfcn.h>

// https://x.com/_silgen_name/status/1829078091219783966

@interface ToggleImmersiveStylesViewController ()
@property (retain, readonly, nonatomic) UIStackView *stackView;
@property (retain, readonly, nonatomic) UIButton *toggleImmersiveSceneVisibilityButton;
@property (retain, readonly, nonatomic) UIButton *toggleImmsersiveSceneStyleButton;
@property (assign, nonatomic) NSUInteger immersionStyle;
@end

@implementation ToggleImmersiveStylesViewController
@synthesize stackView = _stackView;
@synthesize toggleImmersiveSceneVisibilityButton = _toggleImmersiveSceneVisibilityButton;
@synthesize toggleImmsersiveSceneStyleButton = _toggleImmsersiveSceneStyleButton;

- (void)dealloc {
    [_stackView release];
    [_toggleImmersiveSceneVisibilityButton release];
    [_toggleImmsersiveSceneStyleButton release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.stackView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didReceiveSceneWillConnectNotification:) name:UISceneWillConnectNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didReceiveSceneDidDisconnectNotification:) name:UISceneDidDisconnectNotification object:nil];
    
    [self updateToggleImmersiveSceneVisibilityButton];
}

- (UIStackView *)stackView {
    if (auto stackView = _stackView) return stackView;
    
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[
        self.toggleImmersiveSceneVisibilityButton,
        self.toggleImmsersiveSceneStyleButton
    ]];
    
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.distribution = UIStackViewDistributionFillProportionally;
    stackView.alignment = UIStackViewAlignmentFill;
    
    _stackView = [stackView retain];
    return [stackView autorelease];
}

- (UIButton *)toggleImmersiveSceneVisibilityButton {
    if (auto toggleImmersiveSceneVisibilityButton = _toggleImmersiveSceneVisibilityButton) return toggleImmersiveSceneVisibilityButton;
    
    UIButton *toggleImmersiveSceneVisibilityButton = [UIButton new];
    
    [toggleImmersiveSceneVisibilityButton addTarget:self action:@selector(didTriggerToggleImmersiveSceneVisibilityButton:) forControlEvents:UIControlEventPrimaryActionTriggered];
    
    _toggleImmersiveSceneVisibilityButton = [toggleImmersiveSceneVisibilityButton retain];
    return [toggleImmersiveSceneVisibilityButton autorelease];
}

- (UIButton *)toggleImmsersiveSceneStyleButton {
    if (auto toggleImmsersiveSceneStyleButton = _toggleImmsersiveSceneStyleButton) return toggleImmsersiveSceneStyleButton;
    
    UIButton *toggleImmsersiveSceneStyleButton = [UIButton new];
    
    [toggleImmsersiveSceneStyleButton addTarget:self action:@selector(didTriggerToggleImmsersiveSceneStyleButton:) forControlEvents:UIControlEventPrimaryActionTriggered];
    
    _toggleImmsersiveSceneStyleButton = [toggleImmsersiveSceneStyleButton retain];
    return [toggleImmsersiveSceneStyleButton autorelease];
}

- (void)didTriggerToggleImmersiveSceneVisibilityButton:(UIButton *)sender {
    if (auto connectedImmsersiveScene = self.connectedImmsersiveScene) {
        [UIApplication.sharedApplication requestSceneSessionDestruction:connectedImmsersiveScene.session options:nil errorHandler:^(NSError * _Nonnull error) {
            
        }];
    } else {
        [self requestSceneWithPreferredImmersionStyle:2];
    }
}

- (void)didTriggerToggleImmsersiveSceneStyleButton:(UIButton *)sender {
    if (self.immersionStyle == 2) {
        [self updateSceneWithPreferredImmersionStyle:8];
    } else {
        [self updateSceneWithPreferredImmersionStyle:2];
    }
}

- (void)didReceiveSceneWillConnectNotification:(NSNotification *)notification {
    [self updateToggleImmersiveSceneVisibilityButton];
}

- (void)didReceiveSceneDidDisconnectNotification:(NSNotification *)notification {
    [self updateToggleImmersiveSceneVisibilityButton];
}

- (void)updateToggleImmersiveSceneVisibilityButton {
    UIButtonConfiguration *configuration = [UIButtonConfiguration plainButtonConfiguration];
    
    configuration.title = (self.connectedImmsersiveScene == nil) ? @"Show" : @"Hide";
    
    self.toggleImmersiveSceneVisibilityButton.configuration = configuration;
}

- (void)requestSceneWithPreferredImmersionStyle:(NSUInteger)preferredImmersionStyle {
    id options = [objc_lookUpClass("MRUISceneRequestOptions") new];
    
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(options, NSSelectorFromString(@"setInternalFrameworksScene:"), NO);
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(options, NSSelectorFromString(@"setDisableDefocusBehavior:"), NO);
    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(options, NSSelectorFromString(@"setPreferredImmersionStyle:"), preferredImmersionStyle);
    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(options, NSSelectorFromString(@"setAllowedImmersionStyles:"), 10);
    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(options, NSSelectorFromString(@"setSceneRequestIntent:"), 1002);
    
    id specification = [objc_lookUpClass("CPImmersiveSceneSpecification_SwiftUI") new];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(options, NSSelectorFromString(@"setSpecification:"), specification);
    [specification release];
    
    //
    
    id initialClientSettings = [objc_lookUpClass("MRUIMutableImmersiveSceneClientSettings") new];
    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(initialClientSettings, NSSelectorFromString(@"setPreferredImmersionStyle:"), preferredImmersionStyle);
    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(initialClientSettings, NSSelectorFromString(@"setAllowedImmersionStyles:"), 10);
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(options, sel_registerName("setInitialClientSettings:"), initialClientSettings);
    [initialClientSettings release];
    
    //
    
    NSUserActivity * userActivity = [[NSUserActivity alloc] initWithActivityType:@"ToggleImmersiveStyles"];
    
    reinterpret_cast<void (*)(id, SEL, id, id, id)>(objc_msgSend)(UIApplication.sharedApplication,
                                                                  NSSelectorFromString(@"mrui_requestSceneWithUserActivity:requestOptions:completionHandler:"),
                                                                  userActivity,
                                                                  options,
                                                                  ^(NSError * _Nullable error) {
        
    });
    
    [userActivity release];
    [options release];
    
    self.immersionStyle = preferredImmersionStyle;
}

- (void)updateSceneWithPreferredImmersionStyle:(NSUInteger)preferredImmersionStyle {
    auto connectedImmsersiveScene = self.connectedImmsersiveScene;
    if (connectedImmsersiveScene == nil) return;
    
    id fbsScene = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(connectedImmsersiveScene, sel_registerName("_scene"));
    NSString *identifier = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(fbsScene, sel_registerName("identifier"));
    
    id options = [objc_lookUpClass("MRUISceneRequestOptions") new];
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(options, sel_registerName("setSubstitutingSceneSessionIdentifier:"), identifier);
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(options, NSSelectorFromString(@"setInternalFrameworksScene:"), NO);
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(options, NSSelectorFromString(@"setDisableDefocusBehavior:"), NO);
    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(options, NSSelectorFromString(@"setPreferredImmersionStyle:"), preferredImmersionStyle);
    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(options, NSSelectorFromString(@"setAllowedImmersionStyles:"), 10);
    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(options, NSSelectorFromString(@"setSceneRequestIntent:"), 1001);
    
    id specification = [objc_lookUpClass("CPImmersiveSceneSpecification_SwiftUI") new];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(options, NSSelectorFromString(@"setSpecification:"), specification);
    [specification release];
    
    //
    
    id initialClientSettings = [objc_lookUpClass("MRUIMutableImmersiveSceneClientSettings") new];
    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(initialClientSettings, NSSelectorFromString(@"setPreferredImmersionStyle:"), preferredImmersionStyle);
    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(initialClientSettings, NSSelectorFromString(@"setAllowedImmersionStyles:"), 10);
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(options, sel_registerName("setInitialClientSettings:"), initialClientSettings);
    [initialClientSettings release];
    
    //
    
    reinterpret_cast<void (*)(id, SEL, id, id, id)>(objc_msgSend)(UIApplication.sharedApplication,
                                                                  NSSelectorFromString(@"mrui_requestSceneWithUserActivity:requestOptions:completionHandler:"),
                                                                  nil,
                                                                  options,
                                                                  ^(NSError * _Nullable error) {
        
    });
    
    [options release];
    
    self.immersionStyle = preferredImmersionStyle;
}

- (__kindof UIWindowScene *)connectedImmsersiveScene {
    for (__kindof UIWindowScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if (![scene isKindOfClass:UIWindowScene.class]) continue;
        if (![scene.session.role isEqualToString:UISceneSessionRoleImmersiveSpaceApplication]) continue;
        
        return scene;
    }
    
    return nil;
}

- (void)setImmersionStyle:(NSUInteger)immersionStyle {
    _immersionStyle = immersionStyle;
    
    UIButtonConfiguration *configuration = [UIButtonConfiguration plainButtonConfiguration];
    
    NSString *string;
    
    void *handle = dlopen("/System/Library/PrivateFrameworks/MRUIKit.framework/MRUIKit", RTLD_NOW);
    void *symbol = dlsym(handle, "_NSStringFromMRUIImmersionStyle");
    if (immersionStyle == 2) {
        string = reinterpret_cast<id (*)(NSUInteger)>(symbol)(8);
    } else {
        string = reinterpret_cast<id (*)(NSUInteger)>(symbol)(2);
    }
    
    configuration.title = [NSString stringWithFormat:@"Switch to %@", string];
    
    self.toggleImmsersiveSceneStyleButton.configuration = configuration;
}

@end
