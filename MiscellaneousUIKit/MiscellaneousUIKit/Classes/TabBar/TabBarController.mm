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

FOUNDATION_EXPORT NSString * NSStringFromBOOL(BOOL);

namespace _UIFloatingTabBarItemView {
namespace _updateFontAndColors {
void (*original)(id, SEL);
void custom(__kindof UIView *self, SEL _cmd) {
    original(self, _cmd);
    
    UILabel *titleLabel = ((id (*)(id, SEL))objc_msgSend)(self, sel_registerName("titleLabel"));
    UIImageView *imageView = ((id (*)(id, SEL))objc_msgSend)(self, sel_registerName("imageView"));
    
    titleLabel.font = [UIFont italicSystemFontOfSize:20.0];
    imageView.backgroundColor = UIColor.systemPinkColor;
}
void swizzle() {
    Method method = class_getInstanceMethod(objc_lookUpClass("_UIFloatingTabBarItemView"), sel_registerName("_updateFontAndColors"));
    original = (decltype(original))method_getImplementation(method);
    method_setImplementation(method, (IMP)custom);
}
}
}

@interface TabBarController () <UITabBarControllerDelegate, UITabBarControllerSidebarDelegate>
@end

@implementation TabBarController

+ (void)load {
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"com.apple.UIKit"];
    [userDefaults setObject:@YES forKey:@"UseFloatingTabBar"];
    [userDefaults release];
    
    _UIFloatingTabBarItemView::_updateFontAndColors::swizzle();
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.delegate = self;
        
        PinkViewController *pinkViewController = [PinkViewController new];
        CyanViewController *cyanViewController = [CyanViewController new];
        OrangeViewController *orangeViewController = [OrangeViewController new];
        
        UITab *pinkTab = [[UITab alloc] initWithTitle:@"Pink" image:[UIImage systemImageNamed:@"1.circle"] identifier:@"Pink" viewControllerProvider:^UIViewController * _Nonnull(__kindof UITab * _Nonnull) {
            return [[PinkViewController new] autorelease];
        }];
        
        pinkTab.allowsHiding = NO;
        
        UITab *cyanTab = [[UITab alloc] initWithTitle:@"Cyan" image:[UIImage systemImageNamed:@"2.circle"] identifier:@"Cyan" viewControllerProvider:^UIViewController * _Nonnull(__kindof UITab * _Nonnull) {
            return [[CyanViewController new] autorelease];
        }];
        
        UITab *orangeTab = [[UITab alloc] initWithTitle:@"Orange" image:[UIImage systemImageNamed:@"3.circle"] identifier:@"Orange" viewControllerProvider:^UIViewController * _Nonnull(__kindof UITab * _Nonnull) {
//            return [[OrangeViewController new] autorelease];
            return orangeViewController;
        }];
        
        orangeTab.preferredPlacement = UITabPlacementPinned;
        
        UITab *redTab = [[UITab alloc] initWithTitle:@"Red" image:nil identifier:@"Red" viewControllerProvider:^UIViewController * _Nonnull(__kindof UITab * _Nonnull) {
            UIViewController *redViewController = [UIViewController new];
            redViewController.view.backgroundColor = UIColor.systemRedColor;
            return [redViewController autorelease];
        }];
        
        UITab *greenTab = [[UITab alloc] initWithTitle:@"Green" image:[UIImage systemImageNamed:@"lasso.badge.sparkles"] identifier:@"Green" viewControllerProvider:^UIViewController * _Nonnull(__kindof UITab * _Nonnull) {
            UIViewController *greenViewController = [UIViewController new];
            greenViewController.view.backgroundColor = UIColor.systemGreenColor;
            return [greenViewController autorelease];
        }];
        greenTab.badgeValue = @"Badge!";
        
        UITab *yellowTab = [[UITab alloc] initWithTitle:@"Yellow" image:nil identifier:@"Yello" viewControllerProvider:^UIViewController * _Nonnull(__kindof UITab * _Nonnull) {
            UIViewController *yellowViewController = [UIViewController new];
            yellowViewController.view.backgroundColor = UIColor.systemYellowColor;
            return [yellowViewController autorelease];
        }];
        
        UITabGroup *subTabGroup = [[UITabGroup alloc] initWithTitle:@"Subgroup" image:nil identifier:@"Subgroup" children:@[yellowTab] viewControllerProvider:^UIViewController * _Nonnull(__kindof UITab * _Nonnull) {
            UIViewController *grayViewController = [UIViewController new];
            grayViewController.view.backgroundColor = UIColor.systemGrayColor;
            return [grayViewController autorelease];
        }];
        
        [yellowTab release];
        
        UITabGroup *tabGroup = [[UITabGroup alloc] initWithTitle:@"Group" image:[UIImage systemImageNamed:@"scribble.variable"] identifier:@"Group" children:@[redTab, greenTab, subTabGroup] viewControllerProvider:^UIViewController * _Nonnull(__kindof UITab * _Nonnull) {
            UIViewController *purpleViewController = [UIViewController new];
            purpleViewController.view.backgroundColor = UIColor.systemPurpleColor;
            return [purpleViewController autorelease];
        }];
        
        tabGroup.selectedChild = redTab;
        
        [redTab release];
        [greenTab release];
        [subTabGroup release];
        
        tabGroup.sidebarAppearance = UITabGroupSidebarAppearanceRootSection;
        tabGroup.allowsReordering = YES;
        tabGroup.sidebarActions = @[
            [UIAction actionWithTitle:@"First Action" image:[UIImage systemImageNamed:@"1.circle"] identifier:@"firstAction" handler:^(__kindof UIAction * _Nonnull action) {
                NSLog(@"first");
            }],
            [UIAction actionWithTitle:@"Second Action" image:[UIImage systemImageNamed:@"2.circle"] identifier:@"secondAction" handler:^(__kindof UIAction * _Nonnull action) {
                NSLog(@"second");
            }]
        ];
        
        tabGroup.defaultChildIdentifier = @"Green";
//        tabGroup.displayOrderIdentifiers = @[
//            @"firstAction",
//            @"Green",
//            @"secondAction",
//            @"Red"
//        ];
        
//        UINavigationController *groupNavigationController = [UINavigationController new];
//        tabGroup.managingNavigationController = groupNavigationController;
//        [groupNavigationController release];
        
        UISearchTab *searchTab = [[UISearchTab alloc] initWithViewControllerProvider:^UIViewController * _Nonnull(__kindof UITab * _Nonnull) {
            UIViewController *purpleViewController = [UIViewController new];
            purpleViewController.view.backgroundColor = UIColor.systemPurpleColor;
            return [purpleViewController autorelease];
        }];
        
        [self setTabs:@[pinkTab, cyanTab, orangeTab, tabGroup, searchTab]];
        
        [pinkTab release];
        [cyanTab release];
        [orangeTab release];
        [tabGroup release];
        [searchTab release];
        
//        [self setViewControllers:@[pinkViewController, cyanViewController, orangeViewController] animated:NO];
//        [self setSelectedViewController:orangeViewController];
        
        [pinkViewController release];
        [cyanViewController release];
        [orangeViewController release];
        
        UINavigationItem *navigationItem = self.navigationItem;
        navigationItem.title = @"TabBar";
        
        UIBarButtonItem *dismissBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(dismissBarButtonItemDidTrigger:)];
        navigationItem.leftBarButtonItem = dismissBarButtonItem;
        [dismissBarButtonItem release];
        
        UIBarButtonItem *resetBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reset" style:UIBarButtonItemStylePlain target:self action:@selector(resetBarButtonItemDidTrigger:)];
        
        UIBarButtonItem *resetAllBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reset All" style:UIBarButtonItemStylePlain target:self action:@selector(resetAllBarButtonItemDidTrigger:)];
        
        UIBarButtonItem *presentPopoverBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Popover" style:UIBarButtonItemStylePlain target:self action:@selector(presentPopoverBarButtonItemDidTrigger:)];
        
        navigationItem.rightBarButtonItems = @[resetBarButtonItem, resetAllBarButtonItem, presentPopoverBarButtonItem];
        
        [resetBarButtonItem release];
        [resetAllBarButtonItem release];
        [presentPopoverBarButtonItem release];
        
        self.mode = UITabBarControllerModeTabSidebar;
//        self.mode = (UITabBarControllerMode)3;
        
        self.customizationIdentifier = @"Test";
        
        //
        
        UITabBarControllerSidebar *sidebar = self.sidebar;
        
        sidebar.delegate = self;
        
        UILabel *bottomBarView = [UILabel new];
        bottomBarView.text = @"bottomBarView";
        bottomBarView.textColor = UIColor.systemBlueColor;
        bottomBarView.backgroundColor = UIColor.systemGrayColor;
        bottomBarView.textAlignment = NSTextAlignmentCenter;
        sidebar.bottomBarView = bottomBarView;
        [bottomBarView release];
        
        UIListContentConfiguration *headerContentConfiguration = [UIListContentConfiguration headerConfiguration];
        headerContentConfiguration.text = @"Header";
        sidebar.headerContentConfiguration = headerContentConfiguration;
        
        UIListContentConfiguration *footerContentConfiguration = [UIListContentConfiguration headerConfiguration];
        footerContentConfiguration.text = @"Footer";
        sidebar.footerContentConfiguration = footerContentConfiguration;
        
        //
        
        __kindof UIView *_sidebarView = ((id (*)(id, SEL))objc_msgSend)(self.sidebar, sel_registerName("_sidebarView"));
        UINavigationItem *sidebarNavigationItem = ((id (*)(id, SEL))objc_msgSend)(_sidebarView, sel_registerName("navigationItem"));
        sidebarNavigationItem.title = @"Sidebar!!";
        UIBarButtonItem *editBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Hello" style:UIBarButtonItemStylePlain target:self action:@selector(editBarButtonItemDidTrigger:)];
        sidebarNavigationItem.leftBarButtonItems = [sidebarNavigationItem.leftBarButtonItems arrayByAddingObject:editBarButtonItem];
        [editBarButtonItem release];
        
        //
        
        // _UITabBarControllerVisualStyle_Pad
        id _visualStyle;
        object_getInstanceVariable(self, "_visualStyle", (void **)&_visualStyle);
        
        // _UITabContainerView
        __kindof UIView *tabContainerView = ((id (*)(id, SEL))objc_msgSend)(_visualStyle, sel_registerName("tabContainerView"));
        
        // _UIFloatingTabBar
        __kindof UIView *floatingTabBar = ((id (*)(id, SEL))objc_msgSend)(tabContainerView, sel_registerName("floatingTabBar"));
        
        // _UIFloatingTabBarSelectionContainerView
        __kindof UIView *selectionContainerView = ((id (*)(id, SEL))objc_msgSend)(floatingTabBar, sel_registerName("selectionContainerView"));
        
        selectionContainerView.backgroundColor = UIColor.systemMintColor;
        
        UIView *selectionView = ((id (*)(id, SEL))objc_msgSend)(selectionContainerView, sel_registerName("selectionView"));
        selectionView.backgroundColor = UIColor.systemBrownColor;
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

- (void)resetBarButtonItemDidTrigger:(UIBarButtonItem *)sender {
    id store = ((id (*)(Class, SEL, id))objc_msgSend)(objc_lookUpClass("_UITabCustomizationStore"), sel_registerName("customizationStoreWithPersistenceIdentifier:"), self.customizationIdentifier);
    ((void (*)(id, SEL))objc_msgSend)(store, sel_registerName("reset"));
}

- (void)resetAllBarButtonItemDidTrigger:(UIBarButtonItem *)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    id data = [userDefaults valueForKey:@"com.apple.UIKit.UITabCustomization"];
    NSLog(@"%@", data);
    
//    [userDefaults setObject:nil forKey:@"com.apple.UIKit.UITabCustomization"];
}

- (void)editBarButtonItemDidTrigger:(UIBarButtonItem *)sender {
    id _tabModel;
    object_getInstanceVariable(self, "_tabModel", (void **)&_tabModel);
    
    self.editing = YES;
//    ((void (*)(id, SEL, BOOL))objc_msgSend)(_tabModel, sel_registerName("setEditing:"), YES);
//    ((void (*)(id, SEL, BOOL))objc_msgSend)(_tabModel, sel_registerName("setEditable:"), NO);
}

- (void)presentPopoverBarButtonItemDidTrigger:(UIBarButtonItem *)sender {
    UIViewController *viewController = [UIViewController new];
    viewController.modalPresentationStyle = UIModalPresentationPopover;
    viewController.popoverPresentationController.sourceItem = self.selectedTab;
    
    [self presentViewController:viewController animated:YES completion:nil];
    [viewController release];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectTab:(UITab *)tab previousTab:(UITab *)prevTab {
    NSLog(@"%s, %@", __func__, tab);
}

- (void)tabBarController:(UITabBarController *)tabBarController displayOrderDidChangeForGroup:(UITabGroup *)group {
    NSLog(@"%s, %@", __func__, group);
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectTab:(UITab *)tab {
    return YES;
}

- (void)tabBarControllerWillBeginEditing:(UITabBarController *)tabBarController {
    
}

- (void)tabBarController:(UITabBarController *)tabBarController sidebarVisibilityDidChange:(UITabBarControllerSidebar *)sidebar {
    NSLog(@"%s %@", __func__, NSStringFromBOOL(sidebar.isHidden));
}

- (UITabSidebarItem *)tabBarController:(UITabBarController *)tabBarController sidebar:(UITabBarControllerSidebar *)sidebar itemForRequest:(UITabSidebarItemRequest *)request {
    UITabSidebarItem *item = [UITabSidebarItem itemFromRequest:request];
    
    UIBackgroundConfiguration *backgroundConfiguration = [UIBackgroundConfiguration clearConfiguration];
    backgroundConfiguration.backgroundColor = [UIColor.systemOrangeColor colorWithAlphaComponent:0.5];
    
    UIListContentConfiguration *contentConfiguration = (UIListContentConfiguration *)[item.contentConfiguration copyWithZone:NULL];
    
    contentConfiguration.textProperties.font = [UIFont systemFontOfSize:30.0 weight:UIFontWeightHeavy];
    contentConfiguration.textProperties.color = UIColor.systemPinkColor;
    
    contentConfiguration.secondaryText = @"Secondary!";
    contentConfiguration.secondaryTextProperties.color = UIColor.systemGreenColor;
    
    item.contentConfiguration = contentConfiguration;
    [contentConfiguration release];
    
    item.backgroundConfiguration = backgroundConfiguration;
    
    return item;
}

- (UIContextMenuConfiguration *)tabBarController:(UITabBarController *)tabBarController sidebar:(UITabBarControllerSidebar *)sidebar contextMenuConfigurationForTab:(__kindof UITab *)tab {
    UIContextMenuConfiguration *contextMenuConfiguration = [UIContextMenuConfiguration configurationWithIdentifier:nil
                                                                                                   previewProvider:nil
                                                                                                    actionProvider:^UIMenu * _Nullable(NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
        NSMutableArray<UIMenuElement *> *children = [suggestedActions mutableCopy];
        
        UIAction *action = [UIAction actionWithTitle:@"Hello" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            
        }];
        
        [children addObject:action];
        
        UIMenu *menu = [UIMenu menuWithChildren:children];
        [children release];
        
        return menu;
    }];
    
    return contextMenuConfiguration;
}

- (UISwipeActionsConfiguration *)tabBarController:(UITabBarController *)tabBarController sidebar:(UITabBarControllerSidebar *)sidebar leadingSwipeActionsConfigurationForTab:(__kindof UITab *)tab {
    UIContextualAction *helloAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"Hello" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        NSLog(@"Hello!");
        completionHandler(YES);
    }];
    
    UISwipeActionsConfiguration *swipeActionsConfiguration = [UISwipeActionsConfiguration configurationWithActions:@[helloAction]];
    
    swipeActionsConfiguration.performsFirstActionWithFullSwipe = YES;
    return swipeActionsConfiguration;
}

- (UISwipeActionsConfiguration *)tabBarController:(UITabBarController *)tabBarController sidebar:(UITabBarControllerSidebar *)sidebar trailingSwipeActionsConfigurationForTab:(__kindof UITab *)tab {
    UIContextualAction *helloAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"Hello" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        NSLog(@"Hello!");
        completionHandler(YES);
    }];
    
    UISwipeActionsConfiguration *swipeActionsConfiguration = [UISwipeActionsConfiguration configurationWithActions:@[helloAction]];
    
    swipeActionsConfiguration.performsFirstActionWithFullSwipe = YES;
    return swipeActionsConfiguration;
}

@end
