//
//  AXOpenSettingsViewController.m
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 1/25/25.
//

#import "AXOpenSettingsViewController.h"
#import <Accessibility/Accessibility.h>

@interface AXOpenSettingsViewController ()
@property (class, nonatomic, readonly, getter=_features) NSArray<NSNumber *> *features;
@property (retain, readonly, nonatomic, getter=_cellRegistration) UICollectionViewCellRegistration *cellRegistration;
@end

@implementation AXOpenSettingsViewController

+ (NSArray<NSNumber *> *)_features {
    return @[
        @(AXSettingsFeaturePersonalVoiceAllowAppsToRequestToUse),
        @(AXSettingsFeatureAllowAppsToAddAudioToCalls)
    ];
}

- (instancetype)init {
    UICollectionLayoutListConfiguration *listConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearanceInsetGrouped];
    UICollectionViewCompositionalLayout *collectionViewLayout = [UICollectionViewCompositionalLayout layoutWithListConfiguration:listConfiguration];
    [listConfiguration release];
    
    if (self = [super initWithCollectionViewLayout:collectionViewLayout]) {
        
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

- (UICollectionViewCellRegistration *)cellRegistration {
    if (auto cellRegistration = _cellRegistration) return cellRegistration;
    
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:UICollectionViewListCell.class configurationHandler:^(__kindof UICollectionViewListCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id  _Nonnull item) {
        UIListContentConfiguration *contentConfiguration = [cell defaultContentConfiguration];
        
        switch (AXOpenSettingsViewController.features[indexPath.item].integerValue) {
            case AXSettingsFeaturePersonalVoiceAllowAppsToRequestToUse: {
                contentConfiguration.text = @"PersonalVoiceAllowAppsToRequestToUse";
                break;
            }
            case AXSettingsFeatureAllowAppsToAddAudioToCalls: {
                contentConfiguration.text = @"AllowAppsToAddAudioToCalls";
                break;
            }
            default:
                abort();
        }
        
        cell.contentConfiguration = contentConfiguration;
        
        UICellAccessoryDisclosureIndicator *disclosureIndicator = [UICellAccessoryDisclosureIndicator new];
        cell.accessories = @[disclosureIndicator];
        [disclosureIndicator release];
    }];
    
    _cellRegistration = [cellRegistration retain];
    return cellRegistration;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return AXOpenSettingsViewController.features.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueConfiguredReusableCellWithRegistration:self.cellRegistration forIndexPath:indexPath item:[NSNull null]];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    auto feature = static_cast<AXSettingsFeature>(AXOpenSettingsViewController.features[indexPath.item].integerValue);
    AXOpenSettingsFeature(feature, ^(NSError * _Nullable error) {
        assert(error == nil);
    });
}

@end
