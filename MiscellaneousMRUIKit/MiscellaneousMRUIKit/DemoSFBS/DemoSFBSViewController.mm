//
//  DemoSFBSViewController.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 8/31/24.
//

#import "DemoSFBSViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface DemoSFBSViewController ()
@property (retain, readonly, nonatomic) UICollectionViewCellRegistration *cellRegistration;
@property (retain, readonly, nonatomic) UICollectionViewSupplementaryRegistration *headerRegistration;
@end

@implementation DemoSFBSViewController
@synthesize cellRegistration = _cellRegistration;
@synthesize headerRegistration = _headerRegistration;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    UICollectionLayoutListConfiguration *listConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearanceInsetGrouped];
    listConfiguration.headerMode = UICollectionLayoutListHeaderModeSupplementary;
    
    UICollectionViewCompositionalLayout *collectionViewLayout = [UICollectionViewCompositionalLayout layoutWithListConfiguration:listConfiguration];
    [listConfiguration release];
    
    if (self = [super initWithCollectionViewLayout:collectionViewLayout]) {
        [self cellRegistration];
        [self headerRegistration];
    }
    
    return self;
}

- (void)dealloc {
    [_cellRegistration release];
    [_headerRegistration release];
    [super dealloc];
}

- (UICollectionViewCellRegistration *)cellRegistration {
    if (auto cellRegistration = _cellRegistration) return cellRegistration;
    
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:UICollectionViewListCell.class configurationHandler:^(__kindof UICollectionViewListCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, NSString * _Nonnull item) {
        UIListContentConfiguration *contentConfiguration = [cell defaultContentConfiguration];
        contentConfiguration.text = item;
        
        cell.contentConfiguration = contentConfiguration;
    }];
    
    _cellRegistration = [cellRegistration retain];
    return cellRegistration;
}

- (UICollectionViewSupplementaryRegistration *)headerRegistration {
    if (auto headerRegistration = _headerRegistration) return headerRegistration;
    
    NSArray<Class> *serviceClasses = [self serviceClasses];
    
    UICollectionViewSupplementaryRegistration *headerRegistration = [UICollectionViewSupplementaryRegistration registrationWithSupplementaryClass:UICollectionViewListCell.class elementKind:UICollectionElementKindSectionHeader configurationHandler:^(__kindof UICollectionViewListCell * _Nonnull supplementaryView, NSString * _Nonnull elementKind, NSIndexPath * _Nonnull indexPath) {
        UIListContentConfiguration *contentConfiguration = [supplementaryView defaultContentConfiguration];
        contentConfiguration.text = NSStringFromClass(serviceClasses[indexPath.section]);
        supplementaryView.contentConfiguration = contentConfiguration;
    }];
    
    _headerRegistration = [headerRegistration retain];
    return headerRegistration;
}

- (NSArray<Class> *)serviceClasses {
    return @[
        objc_lookUpClass("SFBSPlacementService")
    ];
}

- (NSArray<NSString *> *)selectorNamesForServiceClass:(Class)serviceClass {
    if (serviceClass == objc_lookUpClass("SFBSPlacementService")) {
        return @[
            @"repositionSceneWithIdentifier:placementPosition:animationSettings:completion:"
        ];
    } else {
        abort();
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self serviceClasses].count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self selectorNamesForServiceClass:[self serviceClasses][section]].count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *selectorString = [self selectorNamesForServiceClass:[self serviceClasses][indexPath.section]][indexPath.item];
    return [collectionView dequeueConfiguredReusableCellWithRegistration:_cellRegistration forIndexPath:indexPath item:selectorString];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        return [collectionView dequeueConfiguredReusableSupplementaryViewWithRegistration:_headerRegistration forIndexPath:indexPath];
    } else {
        abort();
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    NSString *selectorString = [self selectorNamesForServiceClass:[self serviceClasses][indexPath.section]][indexPath.item];
    
    if ([selectorString isEqualToString:@"repositionSceneWithIdentifier:placementPosition:animationSettings:completion:"]) {
        id service = [objc_lookUpClass("SFBSPlacementService") new];
        
        id fbsScene = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self.view.window.windowScene, sel_registerName("_scene"));
        NSString *identifier = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(fbsScene, sel_registerName("identifier"));
        
        reinterpret_cast<void (*)(id, SEL, id, id, id, id)>(objc_msgSend)(service, sel_registerName("repositionSceneWithIdentifier:placementPosition:animationSettings:completion:"), identifier, nil, nil, ^(NSError * _Nullable error) {
            [service release];
            assert(error == nil);
        });
    } else {
        abort();
    }
}

@end
