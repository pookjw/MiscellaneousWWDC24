//
//  TabBarAppearanceViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 7/10/24.
//

#import "TabBarAppearanceViewController.h"

@interface TabBarAppearanceViewController ()
@property (retain, readonly, nonatomic) UIViewController *redViewController;
@property (retain, readonly, nonatomic) UIViewController *orangeViewController;
@property (retain, readonly, nonatomic) UIViewController *yellowViewController;
@property (retain, readonly, nonatomic) UIViewController *greenViewController;
@property (retain, readonly, nonatomic) UIViewController *blueViewController;
@property (retain, readonly, nonatomic) UIViewController *purpleViewController;
@property (retain, readonly, nonatomic) UIViewController *pinkViewController;
@property (retain, readonly, nonatomic) UIViewController *grayViewController;
@property (retain, readonly, nonatomic) UIViewController *cyanViewController;
@end

@implementation TabBarAppearanceViewController
@synthesize redViewController = _redViewController;
@synthesize orangeViewController = _orangeViewController;
@synthesize yellowViewController = _yellowViewController;
@synthesize greenViewController = _greenViewController;
@synthesize blueViewController = _blueViewController;
@synthesize purpleViewController = _purpleViewController;
@synthesize pinkViewController = _pinkViewController;
@synthesize grayViewController = _grayViewController;
@synthesize cyanViewController = _cyanViewController;

- (void)dealloc {
    [_redViewController release];
    [_orangeViewController release];
    [_yellowViewController release];
    [_greenViewController release];
    [_blueViewController release];
    [_purpleViewController release];
    [_pinkViewController release];
    [_grayViewController release];
    [_cyanViewController release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureAppearance];
    
    self.viewControllers = @[
        self.redViewController,
        self.orangeViewController,
        self.yellowViewController,
        self.greenViewController,
        self.blueViewController,
        self.purpleViewController,
        self.pinkViewController,
        self.cyanViewController,
        self.grayViewController
    ];
    
//    self.customizableViewControllers = @[];
    
    UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneBarButtonItemDidTrigger:)];
    self.navigationItem.leftBarButtonItem = doneBarButtonItem;
    [doneBarButtonItem release];
}

- (void)configureAppearance {
    UITabBarAppearance *barAppearance = [UITabBarAppearance new];
    
    UITabBarItemAppearance *inlineLayoutAppearance = [[UITabBarItemAppearance alloc] initWithStyle:UITabBarItemAppearanceStyleInline];
    UITabBarItemAppearance *stackedLayoutAppearance = [[UITabBarItemAppearance alloc] initWithStyle:UITabBarItemAppearanceStyleStacked];
    UITabBarItemAppearance *compactInlineLayoutAppearance = [[UITabBarItemAppearance alloc] initWithStyle:UITabBarItemAppearanceStyleCompactInline];
    
    inlineLayoutAppearance.normal.titleTextAttributes = @{NSForegroundColorAttributeName: UIColor.systemRedColor};
    stackedLayoutAppearance.normal.titleTextAttributes = @{NSForegroundColorAttributeName: UIColor.systemRedColor};
    compactInlineLayoutAppearance.normal.titleTextAttributes = @{NSForegroundColorAttributeName: UIColor.systemRedColor};
    
    stackedLayoutAppearance.selected.titlePositionAdjustment = UIOffsetMake(0., -5.);
    stackedLayoutAppearance.selected.badgeBackgroundColor = UIColor.systemCyanColor;
    stackedLayoutAppearance.selected.titleTextAttributes = @{NSForegroundColorAttributeName: UIColor.systemMintColor};
    stackedLayoutAppearance.selected.iconColor = UIColor.systemPurpleColor;
    stackedLayoutAppearance.selected.badgePositionAdjustment = UIOffsetMake(-20., 0.);
    stackedLayoutAppearance.selected.badgeTitlePositionAdjustment = UIOffsetMake(-20., 0.);
    stackedLayoutAppearance.focused.iconColor = UIColor.blackColor;
    stackedLayoutAppearance.disabled.titleTextAttributes = @{NSForegroundColorAttributeName: UIColor.systemPurpleColor};
    
    barAppearance.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemChromeMaterial];
//    appearance.stackedItemSpacing = 0.;
    barAppearance.inlineLayoutAppearance = inlineLayoutAppearance;
    barAppearance.stackedLayoutAppearance = stackedLayoutAppearance;
    barAppearance.compactInlineLayoutAppearance = compactInlineLayoutAppearance;
    
//    [self.tabBar setOverrideUserInterfaceStyle:UIUserInterfaceStyleDark];
    self.tabBar.standardAppearance = barAppearance;
    self.tabBar.scrollEdgeAppearance = barAppearance;
    
    [barAppearance release];
    [inlineLayoutAppearance release];
    [stackedLayoutAppearance release];
    [compactInlineLayoutAppearance release];
}

- (void)doneBarButtonItemDidTrigger:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIViewController *)redViewController {
    if (auto redViewController = _redViewController) return redViewController;
    
    UIViewController *redViewController = [UIViewController new];
    redViewController.view.backgroundColor = UIColor.systemRedColor;
    redViewController.tabBarItem.title = @"Red";
    redViewController.tabBarItem.image = [UIImage systemImageNamed:@"1.circle.fill"];
    
    _redViewController = [redViewController retain];
    return [redViewController autorelease];
}

- (UIViewController *)orangeViewController {
    if (auto orangeViewController = _orangeViewController) return orangeViewController;
    
    UIViewController *orangeViewController = [UIViewController new];
    orangeViewController.view.backgroundColor = UIColor.systemOrangeColor;
    orangeViewController.tabBarItem.title = @"Orange";
    orangeViewController.tabBarItem.image = [UIImage systemImageNamed:@"2.circle.fill"];
    orangeViewController.tabBarItem.badgeValue = @"123";
    orangeViewController.tabBarItem.badgeColor = UIColor.systemBrownColor;
    
    _orangeViewController = [orangeViewController retain];
    return [orangeViewController autorelease];
}

- (UIViewController *)yellowViewController {
    if (auto yellowViewController = _yellowViewController) return yellowViewController;
    
    UIViewController *yellowViewController = [UIViewController new];
    yellowViewController.view.backgroundColor = UIColor.systemYellowColor;
    yellowViewController.tabBarItem.title = @"Yellow";
    yellowViewController.tabBarItem.image = [UIImage systemImageNamed:@"3.circle.fill"];
    yellowViewController.tabBarItem.enabled = NO;
    
    _yellowViewController = [yellowViewController retain];
    return [yellowViewController autorelease];
}

- (UIViewController *)greenViewController {
    if (auto greenViewController = _greenViewController) return greenViewController;
    
    UIViewController *greenViewController = [UIViewController new];
    greenViewController.view.backgroundColor = UIColor.systemGreenColor;
    greenViewController.tabBarItem.title = @"Green";
    greenViewController.tabBarItem.image = [UIImage systemImageNamed:@"4.circle.fill"];
    
    _greenViewController = [greenViewController retain];
    return [greenViewController autorelease];
}

- (UIViewController *)blueViewController {
    if (auto blueViewController = _blueViewController) return blueViewController;
    
    UIViewController *blueViewController = [UIViewController new];
    blueViewController.view.backgroundColor = UIColor.systemBlueColor;
    blueViewController.tabBarItem.title = @"Blue";
    blueViewController.tabBarItem.image = [UIImage systemImageNamed:@"5.circle.fill"];
    
    _blueViewController = [blueViewController retain];
    return [blueViewController autorelease];
}

- (UIViewController *)purpleViewController {
    if (auto purpleViewController = _purpleViewController) return purpleViewController;
    
    UIViewController *purpleViewController = [UIViewController new];
    purpleViewController.view.backgroundColor = UIColor.systemPurpleColor;
    purpleViewController.tabBarItem.title = @"Purple";
    purpleViewController.tabBarItem.image = [UIImage systemImageNamed:@"6.circle.fill"];
    
    _purpleViewController = [purpleViewController retain];
    return [purpleViewController autorelease];
}

- (UIViewController *)pinkViewController {
    if (auto pinkViewController = _pinkViewController) return pinkViewController;
    
    UIViewController *pinkViewController = [UIViewController new];
    pinkViewController.view.backgroundColor = UIColor.systemPinkColor;
    pinkViewController.tabBarItem.title = @"Pink";
    pinkViewController.tabBarItem.image = [UIImage systemImageNamed:@"7.circle.fill"];
    
    _pinkViewController = [pinkViewController retain];
    return [pinkViewController autorelease];
}

- (UIViewController *)cyanViewController {
    if (auto cyanViewController = _cyanViewController) return cyanViewController;
    
    UIViewController *cyanViewController = [UIViewController new];
    cyanViewController.view.backgroundColor = UIColor.systemTealColor;
    cyanViewController.tabBarItem.title = @"Cyan";
    cyanViewController.tabBarItem.image = [UIImage systemImageNamed:@"8.circle.fill"];
    
    _cyanViewController = [cyanViewController retain];
    return [cyanViewController autorelease];
}

- (UIViewController *)grayViewController {
    if (auto grayViewController = _grayViewController) return grayViewController;
    
    UIViewController *grayViewController = [UIViewController new];
    grayViewController.view.backgroundColor = UIColor.systemGrayColor;
    grayViewController.tabBarItem.title = @"Gray";
    grayViewController.tabBarItem.image = [UIImage systemImageNamed:@"9.circle.fill"];
    
    _grayViewController = [grayViewController retain];
    return [grayViewController autorelease];
}

@end
