//
//  MainCollectionViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/11/24.
//

#import "MainCollectionViewController.h"
#import "ListEnvironmentCollectionViewController.h"
#import "SceneActivationViewController.h"
#import "CustomDocumentViewController.h"
#import "SystemBackgroundViewController.h"
#import "ContentHuggingElementsViewController.h"
#import "CalendarViewController.h"
#import "TextViewController.h"
#import "FromTransitionViewController.h"
#import "TabBarController.h"
#import "TabBar2Controller.h"
#import "JitterAnimationViewController.h"
#import "UpdateLinkViewController.h"
#import "ProminenceViewController.h"
#import "FontPickerPresenterViewController.h"
#import "MyNavigationItemViewController.h"
#import "SymbolEffectsViewController.h"
#import "SymbolTransitionsViewController.h"
#import "LegacyTabBarController.h"
#import "LegacyTabBar2Controller.h"
#import "TabBarAppearanceViewController.h"
#import "ToolbarAppearanceViewController.h"
#import "LargeContentViewController.h"
#import "CircleProgressViewController.h"
#import "MySearchViewController.h"
#import "InputAssistantItemViewController.h"
#import "PointerInteractionViewController.h"
#import "NewLinkTextViewController.h"
#import "OldLinkTextViewController.h"
#import "WritingToolsViewController.h"
#import "ProKeyboardViewController.h"
#import "FloatingKeyboardViewController.h"
#import "SplitKeyboardViewController.h"
#import "BaselineViewController.h"
#import "CustomBaselineViewController.h"
#import "CustomViewMenuElementDynamicHeightViewController.h"
#import "ApplicationCategoryViewController.h"
#import "NewWritingToolsViewController.h"
#import "LabelWritingToolsViewController.h"
#import <objc/message.h>

__attribute__((objc_direct_members))
@interface MainCollectionViewController ()
@property (retain, readonly, nonatomic) UICollectionViewCellRegistration *cellRegistration;
@property (assign, readonly, nonatomic) NSArray<Class> *classes;
@end

@implementation MainCollectionViewController

@synthesize cellRegistration = _cellRegistration;

- (instancetype)init {
    UICollectionLayoutListConfiguration *listConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearanceInsetGrouped];
    UICollectionViewCompositionalLayout *collectionViewLayout = [UICollectionViewCompositionalLayout layoutWithListConfiguration:listConfiguration];
    [listConfiguration release];
    
    if (self = [super initWithCollectionViewLayout:collectionViewLayout]) {
        [self commonInit_MainCollectionViewController];
    }
    
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self commonInit_MainCollectionViewController];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self commonInit_MainCollectionViewController];
    }
    
    return self;
}

- (void)dealloc {
    [_cellRegistration release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self cellRegistration];
}

- (void)commonInit_MainCollectionViewController __attribute__((objc_direct)) {
    UINavigationItem *navigationItem = self.navigationItem;
    
    navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    navigationItem.title = ((id (*)(id, SEL))objc_msgSend)(UIApplication.sharedApplication, sel_registerName("_localizedApplicationName"));
}

- (UICollectionViewCellRegistration *)cellRegistration {
    if (auto cellRegistration = _cellRegistration) return cellRegistration;
    
    NSArray<Class> *classes = self.classes;
    
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:UICollectionViewListCell.class configurationHandler:^(__kindof UICollectionViewListCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id  _Nonnull item) {
        Class _class = classes[indexPath.item];
        
        UIListContentConfiguration *contentConfiguration = [cell defaultContentConfiguration];
        NSLog(@"%@", contentConfiguration);
        contentConfiguration.text = NSStringFromClass(_class);
        
        cell.contentConfiguration = contentConfiguration;
        
        UICellAccessoryDisclosureIndicator *disclosureIndicator = [UICellAccessoryDisclosureIndicator new];
        cell.accessories = @[disclosureIndicator];
        [disclosureIndicator release];
    }];
    
    _cellRegistration = [cellRegistration retain];
    return cellRegistration;
}

- (NSArray<Class> *)classes {
    return @[
        LabelWritingToolsViewController.class,
        NewWritingToolsViewController.class,
        ApplicationCategoryViewController.class,
        CustomViewMenuElementDynamicHeightViewController.class,
        CustomBaselineViewController.class,
        BaselineViewController.class,
        SplitKeyboardViewController.class,
        FloatingKeyboardViewController.class,
        ProKeyboardViewController.class,
        WritingToolsViewController.class,
        OldLinkTextViewController.class,
        NewLinkTextViewController.class,
        PointerInteractionViewController.class,
        InputAssistantItemViewController.class,
        MySearchViewController.class,
        CircleProgressViewController.class,
        LargeContentViewController.class,
        ToolbarAppearanceViewController.class,
        TabBarAppearanceViewController.class,
        LegacyTabBar2Controller.class,
        LegacyTabBarController.class,
        SymbolTransitionsViewController.class,
        SymbolEffectsViewController.class,
        MyNavigationItemViewController.class,
        FontPickerPresenterViewController.class,
        ProminenceViewController.class,
#if !TARGET_OS_MACCATALYST
        UpdateLinkViewController.class,
#endif
        JitterAnimationViewController.class,
        TabBar2Controller.class,
        TabBarController.class,
        FromTransitionViewController.class,
        TextViewController.class,
        CalendarViewController.class,
        ContentHuggingElementsViewController.class,
        SystemBackgroundViewController.class,
        CustomDocumentViewController.class,
        SceneActivationViewController.class,
        ListEnvironmentCollectionViewController.class
    ];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.classes.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueConfiguredReusableCellWithRegistration:self.cellRegistration forIndexPath:indexPath item:[NSNull null]];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Class _class = self.classes[indexPath.item];
    
    __kindof UIViewController *rootViewController = [_class new];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    [rootViewController release];
    
    if ([rootViewController isKindOfClass:UITabBarController.class] || [rootViewController isKindOfClass:MyNavigationItemViewController.class] || [rootViewController isKindOfClass:MySearchViewController.class]) {
        if (![rootViewController isKindOfClass:TabBarAppearanceViewController.class]) {
            navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
        }
    }
    
    navigationController.sheetPresentationController.prefersGrabberVisible = YES;
    
    [self presentViewController:navigationController animated:YES completion:nil];
    [navigationController release];
}

@end
