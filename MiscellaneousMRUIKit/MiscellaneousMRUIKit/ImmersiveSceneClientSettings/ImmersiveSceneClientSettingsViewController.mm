//
//  ImmersiveSceneClientSettingsViewController.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 7/3/24.
//

#import "ImmersiveSceneClientSettingsViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface ImmersiveSceneClientSettingsViewController ()
@property (retain, readonly, nonatomic) UIStackView *stackView;
@property (retain, readonly, nonatomic) UIButton *requestSceneButton;
@property (retain, readonly, nonatomic) UILabel *amountOfImmersionLabel;
@property (retain, readonly, nonatomic) UIStepper *maximumAmountOfImmersionStepper;
@end

@implementation ImmersiveSceneClientSettingsViewController
@synthesize stackView = _stackView;
@synthesize requestSceneButton = _requestSceneButton;
@synthesize maximumAmountOfImmersionStepper = _maximumAmountOfImmersionStepper;
@synthesize amountOfImmersionLabel = _amountOfImmersionLabel;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [NSNotificationCenter.defaultCenter addObserver:self
                                               selector:@selector(receivedSceneWillConnectNotificaiton:)
                                                   name:UISceneWillConnectNotification
                                                 object:nil];
        
        [NSNotificationCenter.defaultCenter addObserver:self
                                               selector:@selector(receivedSceneDidDisconnectNotificaiton:)
                                                   name:UISceneDidDisconnectNotification
                                                 object:nil];
    }
    
    return self;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
    
    [_stackView release];
    [_requestSceneButton release];
    [_maximumAmountOfImmersionStepper release];
    [_amountOfImmersionLabel release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.stackView;
}

- (UIStackView *)stackView {
    if (auto stackView = _stackView) return stackView;
    
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[
        self.requestSceneButton,
        self.maximumAmountOfImmersionStepper,
        self.amountOfImmersionLabel
    ]];
    
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.distribution = UIStackViewDistributionFill;
    
    _stackView = stackView;
    return [stackView autorelease];
}

- (UIButton *)requestSceneButton {
    if (auto requestSceneButton = _requestSceneButton) return requestSceneButton;
    
    UIButtonConfiguration *configuration = [UIButtonConfiguration plainButtonConfiguration];
    
    configuration.title = @"Request Scene";
    
    UIButton *requestSceneButton = [UIButton buttonWithConfiguration:configuration primaryAction:nil];
    
    [requestSceneButton addTarget:self action:@selector(requestSceneButtonDidTrigger:) forControlEvents:UIControlEventPrimaryActionTriggered];
    
    _requestSceneButton = [requestSceneButton retain];
    return requestSceneButton;
}

- (UIStepper *)maximumAmountOfImmersionStepper {
    if (auto maximumAmountOfImmersionStepper = _maximumAmountOfImmersionStepper) return maximumAmountOfImmersionStepper;
    
    UIStepper *maximumAmountOfImmersionStepper = [UIStepper new];
    
    maximumAmountOfImmersionStepper.stepValue = 0.1;
    maximumAmountOfImmersionStepper.maximumValue = 1.0;
    maximumAmountOfImmersionStepper.enabled = NO;
    [maximumAmountOfImmersionStepper addTarget:self action:@selector(maximumAmountOfImmersionStepperDidTrigger:) forControlEvents:UIControlEventPrimaryActionTriggered];
    
    _maximumAmountOfImmersionStepper = [maximumAmountOfImmersionStepper retain];
    return [maximumAmountOfImmersionStepper autorelease];
}

- (UILabel *)amountOfImmersionLabel {
    if (auto amountOfImmersionLabel = _amountOfImmersionLabel) return amountOfImmersionLabel;
    
    UILabel *amountOfImmersionLabel = [UILabel new];
    
    amountOfImmersionLabel.textAlignment = NSTextAlignmentCenter;
    amountOfImmersionLabel.backgroundColor = UIColor.blackColor;
    amountOfImmersionLabel.textColor = UIColor.whiteColor;
    
    _amountOfImmersionLabel = [amountOfImmersionLabel retain];
    return [amountOfImmersionLabel autorelease];
}

- (void)requestSceneButtonDidTrigger:(UIButton *)sender {
    id sceneRequestOptions = [objc_lookUpClass("MRUISceneRequestOptions") new];
    
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(sceneRequestOptions, NSSelectorFromString(@"setInternalFrameworksScene:"), NO);
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(sceneRequestOptions, NSSelectorFromString(@"setDisableDefocusBehavior:"), NO);
    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(sceneRequestOptions, NSSelectorFromString(@"setPreferredImmersionStyle:"), 4);
    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(sceneRequestOptions, NSSelectorFromString(@"setAllowedImmersionStyles:"), 4);
    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(sceneRequestOptions, NSSelectorFromString(@"setSceneRequestIntent:"), 1003);
    
    id specification = [objc_lookUpClass("MRUISharedApplicationFullscreenSceneSpecification_SwiftUI") new];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(sceneRequestOptions, NSSelectorFromString(@"setSpecification:"), specification);
    [specification release];
    
    id initialClientSettings = [objc_lookUpClass("MRUIMutableImmersiveSceneClientSettings") new];
    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(initialClientSettings, NSSelectorFromString(@"setPreferredImmersionStyle:"), 4);
    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(initialClientSettings, NSSelectorFromString(@"setAllowedImmersionStyles:"), 4);
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(initialClientSettings, sel_registerName("setMinimumAmountOfImmersion:"), @0.1);
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(initialClientSettings, sel_registerName("setMaximumAmountOfImmersion:"), @1.0);
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(initialClientSettings, sel_registerName("setInitialAmountOfImmersion:"), @0.1);
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(initialClientSettings, sel_registerName("setAmbientBrightness:"), @0.1);
    
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
}

- (void)maximumAmountOfImmersionStepperDidTrigger:(UIStepper *)sender {
    // FBSScene
    id fbsScene = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(sender.window.windowScene, sel_registerName("_scene"));
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(fbsScene, sel_registerName("updateUIClientSettingsWithBlock:"), ^(id /* (MRUIMutableSharedApplicationSceneClientSettings *) */ mutableSettings, Class resultClass) {
        id otherSettings = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(mutableSettings, sel_registerName("otherSettings"));
        reinterpret_cast<void (*)(id, SEL, id, NSUInteger)>(objc_msgSend)(otherSettings, sel_registerName("setObject:forSetting:"), @(sender.value), 0xbbd);
    });
}

- (void)receivedSceneWillConnectNotificaiton:(NSNotification *)notification {
    __kindof UIScene *scene = notification.object;
    if (scene == nil) return;
    if (![scene isKindOfClass:UIWindowScene.class]) return;
    if (scene.session.role != UISceneSessionRoleImmersiveSpaceApplication) return;
    
    self.maximumAmountOfImmersionStepper.enabled = YES;
    
    // FBScene
    id fbsScene = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(scene, sel_registerName("_scene"));
    
    // MRUIImmersiveSceneClientSettings
    id clientSettings = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(fbsScene, sel_registerName("clientSettings"));
    [self updateMaximumAmountOfImmersionStepperWithClientSettings:clientSettings];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(receivedDidChangeImmersionStateNotification:)
                                               name:@"_MRUISceneDidChangeImmersionStateNotification"
                                             object:scene];
    
    [self updateAmountOfImmersionLabelWithWindowScene:static_cast<UIWindowScene *>(scene)];
}

- (void)receivedSceneDidDisconnectNotificaiton:(NSNotification *)notification {
    __kindof UIScene *scene = notification.object;
    if (scene == nil) return;
    if (![scene isKindOfClass:UIWindowScene.class]) return;
    if (scene.session.role != UISceneSessionRoleImmersiveSpaceApplication) return;
    
    self.maximumAmountOfImmersionStepper.enabled = NO;
    
    [NSNotificationCenter.defaultCenter removeObserver:self
                                                  name:@"_MRUISceneDidChangeImmersionStateNotification"
                                                object:scene];
}

- (void)receivedDidChangeImmersionStateNotification:(NSNotification *)notification {
    UIWindowScene *windowScene = static_cast<UIWindowScene *>(notification.object);
    
    [self updateAmountOfImmersionLabelWithWindowScene:windowScene];
}

- (void)updateMaximumAmountOfImmersionStepperWithClientSettings:(id)clientSettings {
    NSNumber *minimumAmountOfImmersion = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(clientSettings, sel_registerName("minimumAmountOfImmersion"));
    NSNumber *maximumAmountOfImmersion = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(clientSettings, sel_registerName("maximumAmountOfImmersion"));
    
    UIStepper *maximumAmountOfImmersionStepper = self.maximumAmountOfImmersionStepper;
    maximumAmountOfImmersionStepper.minimumValue = minimumAmountOfImmersion.doubleValue;
    maximumAmountOfImmersionStepper.value = maximumAmountOfImmersion.doubleValue;
}

- (void)updateAmountOfImmersionLabelWithWindowScene:(UIWindowScene *)windowScene {
    // MRUIImmersionState
    id _immersionState = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(windowScene, sel_registerName("_immersionState"));
    
    double amountOfImmersion = reinterpret_cast<double (*)(id, SEL)>(objc_msgSend)(_immersionState, sel_registerName("amountOfImmersion"));
    
    self.amountOfImmersionLabel.text = [NSString stringWithFormat:@"%lf", amountOfImmersion];
}

@end
