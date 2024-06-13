//
//  ListEnvironmentCollectionViewController.m
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/11/24.
//

#import "ListEnvironmentCollectionViewController.h"
#import "ListEnvironmentContentConfiguration.h"
#import <objc/message.h>
#import <objc/runtime.h>

__attribute__((objc_direct_members))
@interface ListEnvironmentCollectionViewController ()
@property (retain, readonly, nonatomic) UICollectionViewCellRegistration *cellRegistration;
@end

@implementation ListEnvironmentCollectionViewController
@synthesize cellRegistration = _cellRegistration;

- (instancetype)init {
    UICollectionLayoutListConfiguration *listConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearanceGrouped];
    UIListSeparatorConfiguration *separatorConfiguration = [listConfiguration.separatorConfiguration copy];
    separatorConfiguration.color = UIColor.systemPinkColor;
    listConfiguration.separatorConfiguration = separatorConfiguration;
    [separatorConfiguration release];
    
    UICollectionViewCompositionalLayout *collectionViewLayout = [UICollectionViewCompositionalLayout layoutWithListConfiguration:listConfiguration];
    [listConfiguration release];
    
    if (self = [super initWithCollectionViewLayout:collectionViewLayout]) {
        [self commonInit_ListEnvironmentCollectionViewController];
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

- (void)commonInit_ListEnvironmentCollectionViewController __attribute__((objc_direct)) {
    UINavigationItem *navigationItem = self.navigationItem;
    
    navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    
    UIBarButtonItem *toggleBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"pencil.tip"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleBarButtonItemDidTrigger:)];
    
    navigationItem.rightBarButtonItem = toggleBarButtonItem;
    [toggleBarButtonItem release];
}

- (void)toggleBarButtonItemDidTrigger:(UIBarButtonItem *)sender {
    UICollectionViewCompositionalLayout *collectionViewLayout = (UICollectionViewCompositionalLayout *)self.collectionView.collectionViewLayout;
    
    UICollectionViewLayoutAttributes *firstLayoutAttributes = [collectionViewLayout layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    
    id /* _UICollectionLayoutListAttributes */ _listAttributes = nil;
    object_getInstanceVariable(firstLayoutAttributes, "_listAttributes", (void **)&_listAttributes);
    
    UICollectionLayoutListAppearance _appearanceStyle;
    object_getInstanceVariable(_listAttributes, "_appearanceStyle", (void **)&_appearanceStyle);
    
    UICollectionLayoutListAppearance newAppearance;
    
    switch (_appearanceStyle) {
        case UICollectionLayoutListAppearanceGrouped:
            newAppearance = UICollectionLayoutListAppearanceInsetGrouped;
            break;
        case UICollectionLayoutListAppearanceInsetGrouped:
            newAppearance = UICollectionLayoutListAppearanceGrouped;
            break;
        default:
            return;
    }
    
    UICollectionLayoutListConfiguration *listConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:newAppearance];
    
    UIListSeparatorConfiguration *separatorConfiguration = [listConfiguration.separatorConfiguration copy];
    separatorConfiguration.color = UIColor.systemPinkColor;
    listConfiguration.separatorConfiguration = separatorConfiguration;
    [separatorConfiguration release];
    
    UICollectionViewCompositionalLayout *newCollectionViewLayout = [UICollectionViewCompositionalLayout layoutWithListConfiguration:listConfiguration];
    [listConfiguration release];
    
    self.collectionView.collectionViewLayout = newCollectionViewLayout;
}

- (UICollectionViewCellRegistration *)cellRegistration {
    if (auto cellRegistration = _cellRegistration) return cellRegistration;
    
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:UICollectionViewCell.class configurationHandler:^(__kindof UICollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id  _Nonnull item) {
        ListEnvironmentContentConfiguration *contentConfiguration = [[ListEnvironmentContentConfiguration alloc] initWithIndexPath:indexPath];
        cell.contentConfiguration = contentConfiguration;
        [contentConfiguration release];
    }];
    
    _cellRegistration = [cellRegistration retain];
    return cellRegistration;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueConfiguredReusableCellWithRegistration:self.cellRegistration forIndexPath:indexPath item:[NSNull null]];
}

@end
