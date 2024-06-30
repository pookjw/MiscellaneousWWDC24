//
//  ViewpointAzimuthViewController.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 7/1/24.
//

#import "ViewpointAzimuthViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface ViewpointAzimuthViewController ()
@property (retain, nonatomic) UIButton *button;
@end

@implementation ViewpointAzimuthViewController

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
        
        NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:@"ViewpointAzimuth"];
        request.userActivity = userActivity;
        [userActivity release];
        
        __kindof UIWindowSceneActivationRequestOptions *options = [objc_lookUpClass("_UIVolumetricWindowSceneActivationRequestOptions") new];
        
        reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(options, sel_registerName("_setInternal:"), YES);
        
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
