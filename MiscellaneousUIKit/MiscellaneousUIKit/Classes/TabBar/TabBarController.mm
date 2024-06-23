//
//  TabBarController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/20/24.
//

#import "TabBarController.h"
#import "PinkViewController.h"
#import "CyanViewController.h"
#import "OrangeViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>


@interface TabBarController ()
@end

@implementation TabBarController

+ (void)load {
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"com.apple.UIKit"];
    [userDefaults setObject:@YES forKey:@"UseFloatingTabBar"];
    [userDefaults release];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        PinkViewController *pinkViewController = [PinkViewController new];
        CyanViewController *cyanViewController = [CyanViewController new];
        OrangeViewController *orangeViewController = [OrangeViewController new];
        
        UITab *pinkTab = [[UITab alloc] initWithTitle:@"Pink" image:[UIImage systemImageNamed:@"1.circle"] identifier:@"Pink" viewControllerProvider:^UIViewController * _Nonnull(__kindof UITab * _Nonnull) {
            return [[PinkViewController new] autorelease];
        }];
        UITab *cyanTab = [[UITab alloc] initWithTitle:@"Cyan" image:[UIImage systemImageNamed:@"2.circle"] identifier:@"Cyan" viewControllerProvider:^UIViewController * _Nonnull(__kindof UITab * _Nonnull) {
            return [[CyanViewController new] autorelease];
        }];
        UITab *orangeTab = [[UITab alloc] initWithTitle:@"Orange" image:[UIImage systemImageNamed:@"3.circle"] identifier:@"Orange" viewControllerProvider:^UIViewController * _Nonnull(__kindof UITab * _Nonnull) {
//            return [[OrangeViewController new] autorelease];
            return orangeViewController;
        }];
        
        [self setTabs:@[pinkTab, cyanTab, orangeTab]];
        
        [pinkTab release];
        [cyanTab release];
        [orangeTab release];
        
//        [self setSelectedViewController:orangeViewController];
        
        [pinkViewController release];
        [cyanViewController release];
        [orangeViewController release];
        
        UINavigationItem *navigationItem = self.navigationItem;
        UIBarButtonItem *dismissBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(dismissBarButtonItemDidTrigger:)];
        navigationItem.rightBarButtonItem = dismissBarButtonItem;
        [dismissBarButtonItem release];
        
        self.mode = UITabBarControllerModeTabSidebar;
//        self.mode = (UITabBarControllerMode)3;
    }
    
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)dismissBarButtonItemDidTrigger:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
