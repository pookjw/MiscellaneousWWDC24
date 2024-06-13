//
//  ContentHuggingElementsViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/13/24.
//

#import "ContentHuggingElementsViewController.h"

@interface ContentHuggingElementsViewController ()
@property (retain, readonly, nonatomic) UICollectionViewCellRegistration *cellRegistration;
@property (retain, readonly, nonatomic) UICollectionViewSupplementaryRegistration *headerSupplementaryRegistration;
@property (retain, readonly, nonatomic) UICollectionViewSupplementaryRegistration *footerSupplementaryRegistration;
@end

@implementation ContentHuggingElementsViewController
@synthesize cellRegistration = _cellRegistration;
@synthesize headerSupplementaryRegistration = _headerSupplementaryRegistration;
@synthesize footerSupplementaryRegistration = _footerSupplementaryRegistration;

- (instancetype)init {
    UICollectionLayoutListConfiguration *listConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearanceInsetGrouped];
    listConfiguration.headerMode = UICollectionLayoutListHeaderModeSupplementary;
    listConfiguration.footerMode = UICollectionLayoutListFooterModeSupplementary;
    
    listConfiguration.contentHuggingElements = UICollectionLayoutListContentHuggingElementsSupplementaryHeader;
//    listConfiguration.contentHuggingElements = UICollectionLayoutListContentHuggingElementsNone;
    
    UICollectionViewCompositionalLayout *collectionViewLayout = [UICollectionViewCompositionalLayout layoutWithListConfiguration:listConfiguration];
    
    [listConfiguration release];
    
    self = [super initWithCollectionViewLayout:collectionViewLayout];
    
    return self;
}

- (void)dealloc {
    [_cellRegistration release];
    [_headerSupplementaryRegistration release];
    [_footerSupplementaryRegistration release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self cellRegistration];
    [self headerSupplementaryRegistration];
    [self footerSupplementaryRegistration];
}

- (UICollectionViewCellRegistration *)cellRegistration {
    if (auto cellRegistration = _cellRegistration) return cellRegistration;
    
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:UICollectionViewListCell.class configurationHandler:^(__kindof UICollectionViewListCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id  _Nonnull item) {
        UIListContentConfiguration *contentConfiguration = [cell defaultContentConfiguration];
        contentConfiguration.text = indexPath.description;
        cell.contentConfiguration = contentConfiguration;
    }];
    
    _cellRegistration = [cellRegistration retain];
    return cellRegistration;
}

- (UICollectionViewSupplementaryRegistration *)headerSupplementaryRegistration {
    if (auto headerSupplementaryRegistration = _headerSupplementaryRegistration) return headerSupplementaryRegistration;
    
    UICollectionViewSupplementaryRegistration *headerSupplementaryRegistration = [UICollectionViewSupplementaryRegistration registrationWithSupplementaryClass:UICollectionViewListCell.class elementKind:UICollectionElementKindSectionHeader configurationHandler:^(__kindof UICollectionViewListCell * _Nonnull supplementaryView, NSString * _Nonnull elementKind, NSIndexPath * _Nonnull indexPath) {
        UIListContentConfiguration *contentConfiguration = [supplementaryView defaultContentConfiguration];
        contentConfiguration.text = @"Test";
        contentConfiguration.textProperties.numberOfLines = 1;
        supplementaryView.contentConfiguration = contentConfiguration;
        
        UIBackgroundConfiguration *backgroundConfiguration = [UIBackgroundConfiguration clearConfiguration];
        backgroundConfiguration.backgroundColor = UIColor.systemPinkColor;
        supplementaryView.backgroundConfiguration = backgroundConfiguration;
    }];
    
    _headerSupplementaryRegistration = [headerSupplementaryRegistration retain];
    return headerSupplementaryRegistration;
}

- (UICollectionViewSupplementaryRegistration *)footerSupplementaryRegistration {
    if (auto footerSupplementaryRegistration = _footerSupplementaryRegistration) return footerSupplementaryRegistration;
    
    UICollectionViewSupplementaryRegistration *footerSupplementaryRegistration = [UICollectionViewSupplementaryRegistration registrationWithSupplementaryClass:UICollectionViewListCell.class elementKind:UICollectionElementKindSectionFooter configurationHandler:^(__kindof UICollectionViewListCell * _Nonnull supplementaryView, NSString * _Nonnull elementKind, NSIndexPath * _Nonnull indexPath) {
        UIListContentConfiguration *contentConfiguration = [supplementaryView defaultContentConfiguration];
        contentConfiguration.text = @"Test";
        contentConfiguration.textProperties.numberOfLines = 1;
        supplementaryView.contentConfiguration = contentConfiguration;
        
        UIBackgroundConfiguration *backgroundConfiguration = [UIBackgroundConfiguration clearConfiguration];
        backgroundConfiguration.backgroundColor = UIColor.systemPinkColor;
        supplementaryView.backgroundConfiguration = backgroundConfiguration;
    }];
    
    _footerSupplementaryRegistration = [footerSupplementaryRegistration retain];
    return footerSupplementaryRegistration;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueConfiguredReusableCellWithRegistration:self.cellRegistration forIndexPath:indexPath item:[NSNull null]];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        return [collectionView dequeueConfiguredReusableSupplementaryViewWithRegistration:self.headerSupplementaryRegistration forIndexPath:indexPath];
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        return [collectionView dequeueConfiguredReusableSupplementaryViewWithRegistration:self.footerSupplementaryRegistration forIndexPath:indexPath];
    } else {
        abort();
    }
}

@end
