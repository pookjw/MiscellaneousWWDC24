//
//  SceneSizeRestrictionsViewController.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 2/10/25.
//

#import "SceneSizeRestrictionsViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface SceneSizeRestrictionsViewController ()
@end

@implementation SceneSizeRestrictionsViewController

- (void)loadView {
    UIButton *button = [UIButton new];
    
    UIButtonConfiguration *configuration = [UIButtonConfiguration tintedButtonConfiguration];
    configuration.title = @"Request Volumetric Window";
    button.configuration = configuration;
    
    [button addTarget:self action:@selector(_didButtonTriggered:) forControlEvents:UIControlEventPrimaryActionTriggered];
    
    self.view = button;
    [button release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _didButtonTriggered:nil];
}

- (void)_didButtonTriggered:(UIButton *)sender {
    UISceneSessionActivationRequest *request = [UISceneSessionActivationRequest requestWithRole:UIWindowSceneSessionRoleVolumetricApplication];
    
    NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:@"SceneSizeRestrictions"];
    request.userActivity = userActivity;
    [userActivity release];
    
    __kindof UIWindowSceneActivationRequestOptions *options = [objc_lookUpClass("_UIVolumetricWindowSceneActivationRequestOptions") new];
    
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(options, sel_registerName("_setInternal:"), YES);
    
    request.options = options;
    [options release];
    
    [UIApplication.sharedApplication activateSceneSessionForRequest:request errorHandler:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

@end
