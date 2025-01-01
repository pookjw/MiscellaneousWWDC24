//
//  CollectionViewController.mm
//  MiscellaneousStark
//
//  Created by Jinwoo Kim on 1/1/25.
//

#import "CollectionViewController.h"
#import "TabBarPresenterViewController.h"
#import "NavigationItemViewController.h"
#import "MenuPresenterViewController.h"
#import "TextViewController.h"
#import "SearchControllerViewController.h"
#import "AlertPresenterViewController.h"
#import "ActionSheetPresenterViewController.h"

#warning TODO /System/Library/PrivateFrameworks/CarPlaySupport.framework/CarPlaySupport

@interface CollectionViewController ()
@property (class, nonatomic, readonly) NSArray<Class> *_classes;
@property (retain, nonatomic, readonly) UICollectionViewCellRegistration *_cellRegistration;
@end

@implementation CollectionViewController
@synthesize _cellRegistration = __cellRegistration;

+ (NSArray<Class> *)_classes {
    return @[
        [ActionSheetPresenterViewController class],
        [AlertPresenterViewController class],
        [SearchControllerViewController class],
        [TextViewController class],
        [MenuPresenterViewController class],
        [NavigationItemViewController class],
        [TabBarPresenterViewController class]
    ];
}

- (instancetype)init {
    UICollectionLayoutListConfiguration *listConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearanceInsetGrouped];
    UICollectionViewCompositionalLayout *collectionViewLayout = [UICollectionViewCompositionalLayout layoutWithListConfiguration:listConfiguration];
    [listConfiguration release];
    
    self = [super initWithCollectionViewLayout:collectionViewLayout];
    
    return self;
}

- (void)dealloc {
    [__cellRegistration release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _cellRegistration];
    
    self.navigationItem.title = NSProcessInfo.processInfo.processName;
    
    Class _class = [CollectionViewController _classes][0];
    __kindof UIViewController *viewController = [_class new];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (UICollectionViewCellRegistration *)_cellRegistration {
    if (auto cellRegistration = __cellRegistration) return cellRegistration;
    
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:[UICollectionViewListCell class] configurationHandler:^(UICollectionViewListCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, Class _Nonnull item) {
        UIListContentConfiguration *contentConfiguration = [cell defaultContentConfiguration];
        contentConfiguration.text = NSStringFromClass(item);
        cell.contentConfiguration = contentConfiguration;
        
        UICellAccessoryDisclosureIndicator *indicator = [[UICellAccessoryDisclosureIndicator alloc] init];
        cell.accessories = @[indicator];
        [indicator release];
    }];
    
    __cellRegistration = [cellRegistration retain];
    return cellRegistration;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [CollectionViewController _classes].count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueConfiguredReusableCellWithRegistration:self._cellRegistration forIndexPath:indexPath item:[CollectionViewController _classes][indexPath.item]];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Class _class = [CollectionViewController _classes][indexPath.item];
    __kindof UIViewController *viewController = [_class new];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

@end
