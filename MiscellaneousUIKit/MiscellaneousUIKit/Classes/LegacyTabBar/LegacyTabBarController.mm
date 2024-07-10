//
//  LegacyTabBarController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 7/10/24.
//

#import "LegacyTabBarController.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface LegacyTabBarController ()
@property (retain, readonly, nonatomic) UITab *redTab;
@property (retain, readonly, nonatomic) UITab *orangeTab;
@property (retain, readonly, nonatomic) UITab *yellowTab;
@property (retain, readonly, nonatomic) UITab *greenTab;
@property (retain, readonly, nonatomic) UITab *blueTab;
@property (retain, readonly, nonatomic) UITab *purpleTab;
@property (retain, readonly, nonatomic) UITab *pinkTab;
@property (retain, readonly, nonatomic) UITab *grayTab;
@property (retain, readonly, nonatomic) UITab *cyanTab;
@end

@implementation LegacyTabBarController
@synthesize redTab = _redTab;
@synthesize orangeTab = _orangeTab;
@synthesize yellowTab = _yellowTab;
@synthesize greenTab = _greenTab;
@synthesize blueTab = _blueTab;
@synthesize purpleTab = _purpleTab;
@synthesize pinkTab = _pinkTab;
@synthesize grayTab = _grayTab;
@synthesize cyanTab = _cyanTab;

- (void)dealloc {
    [_redTab release];
    [_orangeTab release];
    [_yellowTab release];
    [_greenTab release];
    [_blueTab release];
    [_purpleTab release];
    [_pinkTab release];
    [_grayTab release];
    [_cyanTab release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabs = @[
        self.redTab,
        self.orangeTab,
        self.yellowTab,
        self.greenTab,
        self.blueTab,
        self.purpleTab,
        self.pinkTab,
        self.grayTab,
        self.cyanTab
    ];
    
    self.mode = UITabBarControllerModeTabBar;
    self.customizationIdentifier = @"LegacyTabBarController";
    
    UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneBarButtonItemDidTrigger:)];
    
    UIBarButtonItem *resetBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reset" style:UIBarButtonItemStylePlain target:self action:@selector(resetBarButtonItemDidTrigger:)];
    self.navigationItem.leftBarButtonItems = @[doneBarButtonItem, resetBarButtonItem];
    [doneBarButtonItem release];
    [resetBarButtonItem release];
}

- (void)doneBarButtonItemDidTrigger:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)resetBarButtonItemDidTrigger:(UIBarButtonItem *)sender {
    id store = ((id (*)(Class, SEL, id))objc_msgSend)(objc_lookUpClass("_UITabCustomizationStore"), sel_registerName("customizationStoreWithPersistenceIdentifier:"), self.customizationIdentifier);
    ((void (*)(id, SEL))objc_msgSend)(store, sel_registerName("reset"));
}

- (UITab *)redTab {
    if (auto redTab = _redTab) return redTab;
    
    UITab *redTab = [[UITab alloc] initWithTitle:@"Red" image:[UIImage systemImageNamed:@"1.circle.fill"] identifier:@"red" viewControllerProvider:^UIViewController * _Nonnull(__kindof UITab * _Nonnull) {
        UIViewController *viewController = [UIViewController new];
        viewController.view.backgroundColor = UIColor.systemRedColor;
        return [viewController autorelease];
    }];
    
    redTab.allowsHiding = YES;
    
    _redTab = [redTab retain];
    return [redTab autorelease];
}

- (UITab *)orangeTab {
    if (auto orangeTab = _orangeTab) return orangeTab;
    
    UITab *orangeTab = [[UITab alloc] initWithTitle:@"Orange" image:[UIImage systemImageNamed:@"2.circle.fill"] identifier:@"orange" viewControllerProvider:^UIViewController * _Nonnull(__kindof UITab * _Nonnull) {
        UIViewController *viewController = [UIViewController new];
        viewController.view.backgroundColor = UIColor.systemOrangeColor;
        return [viewController autorelease];
    }];
    
    orangeTab.allowsHiding = YES;
    
    _orangeTab = [orangeTab retain];
    return [orangeTab autorelease];
}

- (UITab *)yellowTab {
    if (auto yellowTab = _yellowTab) return yellowTab;
    
    UITab *yellowTab = [[UITab alloc] initWithTitle:@"Yellow" image:[UIImage systemImageNamed:@"3.circle.fill"] identifier:@"yellow" viewControllerProvider:^UIViewController * _Nonnull(__kindof UITab * _Nonnull) {
        UIViewController *viewController = [UIViewController new];
        viewController.view.backgroundColor = UIColor.systemYellowColor;
        return [viewController autorelease];
    }];
    
    yellowTab.allowsHiding = YES;
    
    _yellowTab = [yellowTab retain];
    return [yellowTab autorelease];
}

- (UITab *)greenTab {
    if (auto greenTab = _greenTab) return greenTab;
    
    UITab *greenTab = [[UITab alloc] initWithTitle:@"Green" image:[UIImage systemImageNamed:@"4.circle.fill"] identifier:@"green" viewControllerProvider:^UIViewController * _Nonnull(__kindof UITab * _Nonnull) {
        UIViewController *viewController = [UIViewController new];
        viewController.view.backgroundColor = UIColor.systemGreenColor;
        return [viewController autorelease];
    }];
    
    greenTab.allowsHiding = YES;
    
    _greenTab = [greenTab retain];
    return [greenTab autorelease];
}

- (UITab *)blueTab {
    if (auto blueTab = _blueTab) return blueTab;
    
    UITab *blueTab = [[UITab alloc] initWithTitle:@"Blue" image:[UIImage systemImageNamed:@"5.circle.fill"] identifier:@"blue" viewControllerProvider:^UIViewController * _Nonnull(__kindof UITab * _Nonnull) {
        UIViewController *viewController = [UIViewController new];
        viewController.view.backgroundColor = UIColor.systemBlueColor;
        return [viewController autorelease];
    }];
    
    blueTab.allowsHiding = YES;
    
    _blueTab = [blueTab retain];
    return [blueTab autorelease];
}

- (UITab *)purpleTab {
    if (auto purpleTab = _purpleTab) return purpleTab;
    
    UITab *purpleTab = [[UITab alloc] initWithTitle:@"Purple" image:[UIImage systemImageNamed:@"6.circle.fill"] identifier:@"purple" viewControllerProvider:^UIViewController * _Nonnull(__kindof UITab * _Nonnull) {
        UIViewController *viewController = [UIViewController new];
        viewController.view.backgroundColor = UIColor.systemPurpleColor;
        return [viewController autorelease];
    }];
    
    purpleTab.allowsHiding = YES;
    
    _purpleTab = [purpleTab retain];
    return [purpleTab autorelease];
}

- (UITab *)pinkTab {
    if (auto pinkTab = _pinkTab) return pinkTab;
    
    UITab *pinkTab = [[UITab alloc] initWithTitle:@"Pink" image:[UIImage systemImageNamed:@"7.circle.fill"] identifier:@"pink" viewControllerProvider:^UIViewController * _Nonnull(__kindof UITab * _Nonnull) {
        UIViewController *viewController = [UIViewController new];
        viewController.view.backgroundColor = UIColor.systemPinkColor;
        return [viewController autorelease];
    }];
    
    pinkTab.allowsHiding = YES;
    
    _pinkTab = [pinkTab retain];
    return [pinkTab autorelease];
}

- (UITab *)grayTab {
    if (auto grayTab = _grayTab) return grayTab;
    
    UITab *grayTab = [[UITab alloc] initWithTitle:@"Gray" image:[UIImage systemImageNamed:@"7.circle.fill"] identifier:@"gray" viewControllerProvider:^UIViewController * _Nonnull(__kindof UITab * _Nonnull) {
        UIViewController *viewController = [UIViewController new];
        viewController.view.backgroundColor = UIColor.systemGrayColor;
        return [viewController autorelease];
    }];
    
    grayTab.allowsHiding = YES;
    
    _grayTab = [grayTab retain];
    return [grayTab autorelease];
}

- (UITab *)cyanTab {
    if (auto cyanTab = _cyanTab) return cyanTab;
    
    UITab *cyanTab = [[UITab alloc] initWithTitle:@"Cyan" image:[UIImage systemImageNamed:@"8.circle.fill"] identifier:@"cyan" viewControllerProvider:^UIViewController * _Nonnull(__kindof UITab * _Nonnull) {
        UIViewController *viewController = [UIViewController new];
        viewController.view.backgroundColor = UIColor.systemCyanColor;
        return [viewController autorelease];
    }];
    
    cyanTab.allowsHiding = YES;
    
    _cyanTab = [cyanTab retain];
    return [cyanTab autorelease];
}

@end
