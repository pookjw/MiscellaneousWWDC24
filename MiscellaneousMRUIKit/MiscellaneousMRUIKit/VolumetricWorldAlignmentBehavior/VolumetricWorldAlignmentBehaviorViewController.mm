//
//  VolumetricWorldAlignmentBehaviorViewController.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 6/29/24.
//

#import "VolumetricWorldAlignmentBehaviorViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface VolumetricWorldAlignmentBehaviorViewController ()
@property (retain, nonatomic) UIButton *button;
@end

@implementation VolumetricWorldAlignmentBehaviorViewController
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
        
        NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:@"VolumetricWorldAlignmentBehavior"];
        request.userActivity = userActivity;
        [userActivity release];
        
        __kindof UIWindowSceneActivationRequestOptions *options = [objc_lookUpClass("_UIVolumetricWindowSceneActivationRequestOptions") new];
        
        // 0 : automatic, 1 : adaptive, 2 : gravityAligned
        reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(options, sel_registerName("_setWorldAlignmentBehavior:"), 2);
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
