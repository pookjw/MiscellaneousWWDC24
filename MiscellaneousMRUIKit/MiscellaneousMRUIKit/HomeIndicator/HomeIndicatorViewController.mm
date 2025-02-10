//
//  HomeIndicatorViewController.m
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 6/30/24.
//

#import "HomeIndicatorViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface HomeIndicatorViewController () {
    BOOL _mu_prefersHomeIndicatorAutoHidden;
}
@property (retain, nonatomic) UIButton *button;
@end

@implementation HomeIndicatorViewController

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
    
    UIAction *primaryAction = [UIAction actionWithTitle:@"Toggle" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        HomeIndicatorViewController *viewController = reinterpret_cast<HomeIndicatorViewController * (*)(id, SEL)>(objc_msgSend)(action.sender, sel_registerName("_viewControllerForAncestor"));
        
        viewController->_mu_prefersHomeIndicatorAutoHidden = !viewController->_mu_prefersHomeIndicatorAutoHidden;
        [viewController setNeedsUpdateOfHomeIndicatorAutoHidden];
    }];
    
    UIButton *button = [UIButton systemButtonWithPrimaryAction:primaryAction];
    
    _button = [button retain];
    return button;
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return _mu_prefersHomeIndicatorAutoHidden;
}

@end
