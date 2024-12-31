//
//  TabBarPresenterViewController.mm
//  MiscellaneousStark
//
//  Created by Jinwoo Kim on 1/1/25.
//

#import "TabBarPresenterViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface TabBarPresenterViewController ()

@end

@implementation TabBarPresenterViewController

- (void)loadView {
    UIButtonConfiguration *configuration = [UIButtonConfiguration plainButtonConfiguration];
    configuration.title = @"Present";
    
    UIButton *button = [UIButton buttonWithConfiguration:configuration primaryAction:nil];
    [button addTarget:self action:@selector(_didTriggerButton:) forControlEvents:UIControlEventPrimaryActionTriggered];
    
    self.view = button;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.systemBackgroundColor;
}

- (void)_didTriggerButton:(UIButton *)sender {
    UITab *ornageTab = [[UITab alloc] initWithTitle:@"Orange" image:[UIImage systemImageNamed:@"arrow.down.document.fill"] identifier:@"Orange" viewControllerProvider:^UIViewController * _Nonnull(__kindof UITab * _Nonnull tab) {
        UIViewController *viewController = [UIViewController new];
        viewController.view.backgroundColor = UIColor.systemOrangeColor;
        return [viewController autorelease];
    }];
    
    UITab *greenTab = [[UITab alloc] initWithTitle:@"Green" image:[UIImage systemImageNamed:@"arrow.down.document.fill"] identifier:@"Green" viewControllerProvider:^UIViewController * _Nonnull(__kindof UITab * _Nonnull tab) {
        UIViewController *viewController = [UIViewController new];
        viewController.view.backgroundColor = UIColor.systemGreenColor;
        return [viewController autorelease];
    }];
    greenTab.badgeValue = @"Badge";
    
    UITab *dismissTab = [[UITab alloc] initWithTitle:@"Dismiss" image:[UIImage systemImageNamed:@"books.vertical.fill"] identifier:@"Dismiss" viewControllerProvider:^UIViewController * _Nonnull(__kindof UITab * _Nonnull) {
        UIViewController *viewController = [UIViewController new];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeClose primaryAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
            UIViewController *_viewControllerForAncestor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(action.sender, sel_registerName("_viewControllerForAncestor"));
            [_viewControllerForAncestor dismissViewControllerAnimated:YES completion:nil];
        }]];
        
        viewController.view = button;
        
        return [viewController autorelease];
    }];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] initWithTabs:@[ornageTab, greenTab, dismissTab]];
    [ornageTab release];
    [greenTab release];
    [dismissTab release];
    
    [self presentViewController:tabBarController animated:YES completion:nil];
    [tabBarController release];
}

@end
