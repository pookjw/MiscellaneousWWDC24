//
//  ARKitDemoViewController.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 2/24/25.
//

#import "ARKitDemoViewController.h"
#import "ARStereoPropertiesViewController.h"

@interface ARKitDemoViewController ()
@property (retain, readonly, nonatomic, getter=_cellRegistration) UICollectionViewCellRegistration *cellRegistration;
@property (readonly, nonatomic, getter=_classes) NSArray<Class> *classes;
@end

@implementation ARKitDemoViewController
@synthesize cellRegistration = _cellRegistration;

- (NSArray<Class> *)_classes {
    return @[
        [ARStereoPropertiesViewController class]
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
    [_cellRegistration release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _cellRegistration];
    
    __kindof UIViewController *viewController = [ARStereoPropertiesViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (UICollectionViewCellRegistration *)_cellRegistration {
    if (auto cellRegistration = _cellRegistration) return cellRegistration;
    
    NSArray<Class> *classes = self.classes;
    
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:UICollectionViewListCell.class configurationHandler:^(__kindof UICollectionViewListCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id  _Nonnull item) {
        UIListContentConfiguration *contentConfiguration = [cell defaultContentConfiguration];
        contentConfiguration.text = NSStringFromClass(classes[indexPath.item]);
        cell.contentConfiguration = contentConfiguration;
        
        UICellAccessoryDisclosureIndicator *indicator = [UICellAccessoryDisclosureIndicator new];
        cell.accessories = @[indicator];
        [indicator release];
    }];
    
    _cellRegistration = [cellRegistration retain];
    return cellRegistration;
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
    Class viewControllerClass = self.classes[indexPath.item];
    __kindof UIViewController *viewController = [viewControllerClass new];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

@end
