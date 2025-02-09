//
//  ClassListViewController.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 6/29/24.
//

#import "ClassListViewController.h"
#import "LaunchPlacementParametersViewController.h"
#import "VolumetricWorldAlignmentBehaviorViewController.h"
#import "DefaultWorldScalingViewController.h"
#import "HomeIndicatorViewController.h"
#import "ViewpointAzimuthViewController.h"
#import "WorldTrackingCapabilitiesViewController.h"
#import "ImmersiveSceneClientSettingsViewController.h"
#import "UpperLimbsViewController.h"
#import "VolumeBaseplateVisibilityViewController.h"
#import "WorldTrackingCapabilitiesViewController.h"
#import "ToggleImmersiveStylesViewController.h"
#import "DemoSFBSViewController.h"
#import "WebXRViewController.h"
#import "SWSViewController.h"
#import "OrnamentViewController.h"
#import "MetersPerPointViewController.h"
#import "FeedbackGeneratorViewController.h"
#import "HoverViewController.h"

@interface ClassListViewController ()
@property (retain, readonly, nonatomic) UICollectionViewCellRegistration *cellRegistration;
@property (readonly, nonatomic) NSArray<Class> *classes;
@end

@implementation ClassListViewController
@synthesize cellRegistration = _cellRegistration;

- (instancetype)init {
    UICollectionLayoutListConfiguration *listConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearanceInsetGrouped];
    UICollectionViewCompositionalLayout *collectionViewLayout = [UICollectionViewCompositionalLayout layoutWithListConfiguration:listConfiguration];
    [listConfiguration release];
    
    if (self = [super initWithCollectionViewLayout:collectionViewLayout]) {
        UINavigationItem *navigationItem = self.navigationItem;
        
        navigationItem.title = @"MiscellaneousMRUIKit";
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
    
    __kindof UIViewController *viewController = [[self classes][0] new];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (UICollectionViewCellRegistration *)cellRegistration {
    if (auto cellRegistration = _cellRegistration) return cellRegistration;
    
    NSArray<Class> *classes = self.classes;
    
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:UICollectionViewListCell.class configurationHandler:^(__kindof UICollectionViewListCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id  _Nonnull item) {
        UIListContentConfiguration *contentConfiguration = [cell defaultContentConfiguration];
        contentConfiguration.text = NSStringFromClass(classes[indexPath.item]);
        cell.contentConfiguration = contentConfiguration;
        
        UICellAccessoryDisclosureIndicator *indicator = [UICellAccessoryDisclosureIndicator new];
        cell.accessories = @[indicator];
        [indicator release];
        
        cell.hoverStyle = nil;
    }];
    
    _cellRegistration = [cellRegistration retain];
    return cellRegistration;
}

- (NSArray<Class> *)classes {
    return @[
        HoverViewController.class,
        FeedbackGeneratorViewController.class,
        MetersPerPointViewController.class,
        OrnamentViewController.class,
        SWSViewController.class,
        WebXRViewController.class,
        DemoSFBSViewController.class,
        ToggleImmersiveStylesViewController.class,
        WorldTrackingCapabilitiesViewController.class,
        LaunchPlacementParametersViewController.class,
        VolumetricWorldAlignmentBehaviorViewController.class,
        DefaultWorldScalingViewController.class,
        HomeIndicatorViewController.class,
        ViewpointAzimuthViewController.class,
        WorldTrackingCapabilitiesViewController.class,
        ImmersiveSceneClientSettingsViewController.class,
        UpperLimbsViewController.class,
        VolumeBaseplateVisibilityViewController.class
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
    Class viewControllerClass = self.classes[indexPath.item];
    __kindof UIViewController *viewController = [viewControllerClass new];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

@end
