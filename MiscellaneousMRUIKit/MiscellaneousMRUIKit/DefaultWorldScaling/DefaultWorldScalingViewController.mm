//
//  DefaultWorldScalingViewController.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 6/29/24.
//

#import "DefaultWorldScalingViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

// https://x.com/_silgen_name/status/1806982698474569842

@interface DefaultWorldScalingViewController ()
@property (retain, nonatomic) UIButton *button;
@end

@implementation DefaultWorldScalingViewController

@synthesize button = _button;

- (void)dealloc {
    [_button release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.button;
}

- (UIButton *)button {
    if (auto button = _button) return button;
    
    UIAction *primaryAction = [UIAction actionWithTitle:@"Show Window" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        UISceneSessionActivationRequest *request = [UISceneSessionActivationRequest requestWithRole:UIWindowSceneSessionRoleVolumetricApplication];
        
        NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:@"DefaultWorldScaling"];
        request.userActivity = userActivity;
        [userActivity release];
        
        __kindof UIWindowSceneActivationRequestOptions *options = [objc_lookUpClass("_UIVolumetricWindowSceneActivationRequestOptions") new];
        
        // 1 : automatic, 2 : dynamic
        reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(options, sel_registerName("_setPreferredDisplayZoomBehavior:"), 2);
        reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(options, sel_registerName("_setInternal:"), YES);
        
        // MRUILaunchPlacementParameters
        id mrui_placementParameters = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(options, sel_registerName("mrui_placementParameters"));
        // 0 : automatic, 1 : dynamic
        reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(mrui_placementParameters, sel_registerName("setPreferredScalingBehavior:"), 1);
        
        request.options = options;
        [options release];
        
        [UIApplication.sharedApplication activateSceneSessionForRequest:request errorHandler:^(NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
    }];
    
    UIButton *button = [UIButton systemButtonWithPrimaryAction:primaryAction];
    
    _button = [button retain];
    return button;
}

@end
