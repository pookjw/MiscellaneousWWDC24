//
//  ExpandableCollectionViewController.m
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 1/11/25.
//

#import "ExpandableCollectionViewController.h"
#import "ExpandableCollectionViewCell.h"

/*
 -[_UIDiffableDataSourceSectionController _configureCell:forItem:inSnapshot:]
 */

@interface ExpandableCollectionViewController ()
@property (retain, nonatomic, readonly) UICollectionView *_collectionView;
@property (retain, nonatomic, readonly) UICollectionViewDiffableDataSource<NSNumber *, NSNumber *> *_dataSource;
@property (retain, nonatomic, readonly) UICollectionViewCellRegistration *_cellRegistration;
@end

@implementation ExpandableCollectionViewController
@synthesize _collectionView = __collectionView;
@synthesize _dataSource = __dataSource;
@synthesize _cellRegistration = __cellRegistration;

- (void)dealloc {
    [__collectionView release];
    [__dataSource release];
    [__cellRegistration release];
    [super dealloc];
}

- (void)loadView {
    self.view = self._collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSDiffableDataSourceSnapshot<NSNumber *, NSNumber *> *snapshot = [NSDiffableDataSourceSnapshot new];
//    [snapshot appendSectionsWithIdentifiers:@[@0, @1, @2]];
//    [snapshot appendItemsWithIdentifiers:@[@0, @1, @2] intoSectionWithIdentifier:@0];
//    [snapshot appendItemsWithIdentifiers:@[@3, @4, @5] intoSectionWithIdentifier:@1];
//    [snapshot appendItemsWithIdentifiers:@[@6, @7, @8] intoSectionWithIdentifier:@2];
//    
//    [self._dataSource applySnapshot:snapshot animatingDifferences:YES];
//    [snapshot release];
    
    NSDiffableDataSourceSectionSnapshot<NSNumber *> *sectionSnapshot = [NSDiffableDataSourceSectionSnapshot new];
    [sectionSnapshot appendItems:@[@0]];
    [sectionSnapshot appendItems:@[@1, @2, @3] intoParentItem:@0];
    [sectionSnapshot appendItems:@[@4, @5, @6] intoParentItem:@3];
    [sectionSnapshot appendItems:@[@7, @8, @9] intoParentItem:@6];
    
    [self._dataSource applySnapshot:sectionSnapshot toSection:@0 animatingDifferences:YES];
    [sectionSnapshot release];
}

- (UICollectionView *)_collectionView {
    if (auto collectionView = __collectionView) return collectionView;
    
    UICollectionViewCompositionalLayoutConfiguration *configuration = [UICollectionViewCompositionalLayoutConfiguration new];
    
    UICollectionViewCompositionalLayout *collectionViewLayout = [[UICollectionViewCompositionalLayout alloc] initWithSectionProvider:^NSCollectionLayoutSection * _Nullable(NSInteger sectionIndex, id<NSCollectionLayoutEnvironment>  _Nonnull layoutEnvironment) {
        NSCollectionLayoutSize *itemSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension absoluteDimension:100.]
                                                                          heightDimension:[NSCollectionLayoutDimension absoluteDimension:100.]];
        
        NSCollectionLayoutItem *item = [NSCollectionLayoutItem itemWithLayoutSize:itemSize supplementaryItems:@[]];
        
        NSCollectionLayoutSize *groupSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.]
                                                                           heightDimension:[NSCollectionLayoutDimension absoluteDimension:100.]];
        
        NSCollectionLayoutGroup *group = [NSCollectionLayoutGroup horizontalGroupWithLayoutSize:groupSize subitems:@[item]];
        
        NSCollectionLayoutSection *section = [NSCollectionLayoutSection sectionWithGroup:group];
        return section;
    }
                                                                                                                       configuration:configuration];
    [configuration release];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectNull collectionViewLayout:collectionViewLayout];
    [collectionViewLayout release];
    
    __collectionView = [collectionView retain];
    return [collectionView autorelease];
}

- (UICollectionViewDiffableDataSource<NSNumber *, NSNumber *> *)_dataSource {
    if (auto dataSource = __dataSource) return dataSource;
    
    UICollectionViewCellRegistration *cellRegistration = self._cellRegistration;
    
    UICollectionViewDiffableDataSource<NSNumber *, NSNumber *> *dataSource = [[UICollectionViewDiffableDataSource alloc] initWithCollectionView:self._collectionView cellProvider:^UICollectionViewCell * _Nullable(UICollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, id  _Nonnull itemIdentifier) {
        return [collectionView dequeueConfiguredReusableCellWithRegistration:cellRegistration forIndexPath:indexPath item:itemIdentifier];
    }];
    
    __dataSource = [dataSource retain];
    return [dataSource autorelease];
}

- (UICollectionViewCellRegistration *)_cellRegistration {
    if (auto cellRegistration = __cellRegistration) return cellRegistration;
    
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:[ExpandableCollectionViewCell class] configurationHandler:^(ExpandableCollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, NSNumber * _Nonnull item) {
        cell.label.text = item.stringValue;
    }];
    
    __cellRegistration = [cellRegistration retain];
    return cellRegistration;
}

@end
