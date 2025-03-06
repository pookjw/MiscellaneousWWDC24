//
//  PreferencesViewController.mm
//  MyCanvas
//
//  Created by Jinwoo Kim on 3/6/25.
//

#import "PreferencesViewController.h"
#import "PreferencesSectionModel.h"
#import "PreferencesItemModel.h"
#import <MyCanvasData/MyCanvasData.h>

__attribute__((objc_direct_members))
@interface PreferencesViewController () <UICollectionViewDelegate>
@property (retain, nonatomic, readonly, getter=_collectionView) UICollectionView *collectionView;
@property (retain, nonatomic, readonly, getter=_cellRegistration) UICollectionViewCellRegistration *cellRegistration;
@property (retain, nonatomic, readonly, getter=_dataSource) UICollectionViewDiffableDataSource<PreferencesSectionModel *, PreferencesItemModel *> *dataSource;
@property (retain, nonatomic, readonly, getter=_doneBarButtonItem) UIBarButtonItem *doneBarButtonItem;
@end

@implementation PreferencesViewController
@synthesize collectionView = _collectionView;
@synthesize cellRegistration = _cellRegistration;
@synthesize dataSource = _dataSource;
@synthesize doneBarButtonItem = _doneBarButtonItem;

- (void)dealloc {
    [_collectionView release];
    [_cellRegistration release];
    [_dataSource release];
    [_doneBarButtonItem release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _loadDataSource];
    
    UINavigationItem *navigationItem = self.navigationItem;
    navigationItem.title = @"Preferences";
    navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    navigationItem.rightBarButtonItem = self.doneBarButtonItem;
}

- (UICollectionView *)_collectionView {
    if (auto collectionView = _collectionView) return collectionView;
    
    UICollectionLayoutListConfiguration *listConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearanceInsetGrouped];
    UICollectionViewCompositionalLayout *collectionViewLayout = [UICollectionViewCompositionalLayout layoutWithListConfiguration:listConfiguration];
    [listConfiguration release];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectNull collectionViewLayout:collectionViewLayout];
    collectionView.delegate = self;
    
    _collectionView = collectionView;
    return collectionView;
}

- (UICollectionViewCellRegistration *)_cellRegistration {
    if (auto cellRegistration = _cellRegistration) return cellRegistration;
    
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:[UICollectionViewListCell class] configurationHandler:^(UICollectionViewListCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, PreferencesItemModel * _Nonnull item) {
        UIListContentConfiguration *contentConfiguration = [cell defaultContentConfiguration];
        
        switch (item.type) {
            case PreferencesItemModelTypeDestoryAndExit:
                contentConfiguration.text = @"Destory And Exit";
                contentConfiguration.textProperties.color = UIColor.systemRedColor;
                contentConfiguration.image = [UIImage systemImageNamed:@"xmark"];
                contentConfiguration.imageProperties.tintColor = UIColor.systemRedColor;
                break;
            default:
                abort();
        }
        
        cell.contentConfiguration = contentConfiguration;
    }];
    
    _cellRegistration = [cellRegistration retain];
    return cellRegistration;
}

- (UICollectionViewDiffableDataSource<PreferencesSectionModel *,PreferencesItemModel *> *)_dataSource {
    if (auto dataSource = _dataSource) return dataSource;
    
    UICollectionViewCellRegistration *cellRegistration = self.cellRegistration;
    
    UICollectionViewDiffableDataSource<PreferencesSectionModel *, PreferencesItemModel *> *dataSource = [[UICollectionViewDiffableDataSource alloc] initWithCollectionView:self.collectionView cellProvider:^UICollectionViewCell * _Nullable(UICollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, id  _Nonnull itemIdentifier) {
        return [collectionView dequeueConfiguredReusableCellWithRegistration:cellRegistration forIndexPath:indexPath item:itemIdentifier];
    }];
    
    _dataSource = dataSource;
    return dataSource;
}

- (UIBarButtonItem *)_doneBarButtonItem {
    if (auto doneBarButtonItem = _doneBarButtonItem) return doneBarButtonItem;
    
    UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(_didTriggerDoneBarButtonItem:)];
    
    _doneBarButtonItem = doneBarButtonItem;
    return doneBarButtonItem;
}

- (void)_loadDataSource __attribute__((objc_direct)) {
    NSDiffableDataSourceSnapshot<PreferencesSectionModel *, PreferencesItemModel *> *snapshot = [NSDiffableDataSourceSnapshot new];
    
    PreferencesSectionModel *coreDataSectionModel = [[PreferencesSectionModel alloc] initWithType:PreferencesSectionModelTypeCoreData];
    [snapshot appendSectionsWithIdentifiers:@[coreDataSectionModel]];
    
    PreferencesItemModel *destoryAndExitItemModel = [[PreferencesItemModel alloc] initWithType:PreferencesItemModelTypeDestoryAndExit valueResolver:nil];
    [snapshot appendItemsWithIdentifiers:@[destoryAndExitItemModel] intoSectionWithIdentifier:coreDataSectionModel];
    [destoryAndExitItemModel release];
    [coreDataSectionModel release];
    
    [self.dataSource applySnapshot:snapshot animatingDifferences:YES];
    [snapshot release];
}

- (void)_didTriggerDoneBarButtonItem:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PreferencesItemModel *itemModel = [self.dataSource itemIdentifierForIndexPath:indexPath];
    assert(itemModel != nil);
    
    switch (itemModel.type) {
        case PreferencesItemModelTypeDestoryAndExit:
            [MCCoreDataStack.sharedInstance destoryAndExit];
            break;
        default:
            abort();
    }
}

@end
