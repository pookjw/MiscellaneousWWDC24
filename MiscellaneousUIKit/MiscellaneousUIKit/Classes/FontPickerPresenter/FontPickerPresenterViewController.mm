//
//  FontPickerPresenterViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/23/24.
//

#import "FontPickerPresenterViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface FontPickerPresenterViewController () <UIFontPickerViewControllerDelegate>

@end

@implementation FontPickerPresenterViewController

- (void)loadView {
    __weak auto weakSelf = self;
    
    UIAction *primaryAction = [UIAction actionWithTitle:@"Present Font Picker" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        [weakSelf presentFontPickerViewController];
    }];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectNull primaryAction:primaryAction];
    self.view = button;
    [button release];
}

- (void)presentFontPickerViewController {
    UIFontPickerViewControllerConfiguration *configuration = [UIFontPickerViewControllerConfiguration new];
    configuration.displayUsingSystemFont = YES;
    
    UIFontPickerViewController *fontPickerViewController = [[UIFontPickerViewController alloc] initWithConfiguration:configuration];
    [configuration release];
    
    fontPickerViewController.delegate = self;
    
    [self presentViewController:fontPickerViewController animated:YES completion:nil];
    [fontPickerViewController release];
}

@end
