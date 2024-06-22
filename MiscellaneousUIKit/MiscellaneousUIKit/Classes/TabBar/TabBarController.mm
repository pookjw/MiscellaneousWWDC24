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

// _UITabContainerView _UITabBarControllerVisualStyle_Pad
namespace mu_UITabBarControllerVisualStyle_Pad {
    namespace _isTabBarHidden {
        BOOL (*original)(id, SEL);
        BOOL custom(id, SEL) {
            return NO;
        }
        void swizzle() {
            Method method = class_getInstanceMethod(objc_lookUpClass("_UITabBarControllerVisualStyle_Pad"), sel_registerName("wantsDefaultTabBar"));
            original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
            method_setImplementation(method, reinterpret_cast<IMP>(custom));
        }
    }
}

@interface TabBarController ()
@end

@implementation TabBarController

+ (void)load {
    mu_UITabBarControllerVisualStyle_Pad::_isTabBarHidden::swizzle();
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        PinkViewController *pinkViewController = [PinkViewController new];
        CyanViewController *cyanViewController = [CyanViewController new];
        OrangeViewController *orangeViewController = [OrangeViewController new];
        
        [self setViewControllers:@[pinkViewController, cyanViewController, orangeViewController]];
        
        [pinkViewController release];
        [cyanViewController release];
        [orangeViewController release];
        
        UINavigationItem *navigationItem = self.navigationItem;
        UIBarButtonItem *dismissBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(dismissBarButtonItemDidTrigger:)];
        navigationItem.rightBarButtonItem = dismissBarButtonItem;
        [dismissBarButtonItem release];
        
//        self.mode = UITabBarControllerModeTabSidebar;
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
