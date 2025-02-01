//
//  WindowDemoViewController.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 1/31/25.
//

#import "WindowDemoViewController.h"
#import "ConfigurationView.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface WindowDemoViewController () <ConfigurationViewDelegate>
@property (retain, nonatomic, readonly, getter=_configurationView) ConfigurationView *configurationView;
@end

@implementation WindowDemoViewController
@synthesize configurationView = _configurationView;

- (void)dealloc {
    [_configurationView release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.configurationView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDiffableDataSourceSnapshot *snapshot = [NSDiffableDataSourceSnapshot new];
    [snapshot appendSectionsWithIdentifiers:@[[NSNull null]]];
    
    ConfigurationItemModel *itemModel_1 = [[ConfigurationItemModel alloc] initWithType:ConfigurationItemModelTypeSwitch identifier:@"Test 1" label:@"Test 1" valueResolver:^NSObject<NSCopying> * _Nonnull(ConfigurationItemModel * _Nonnull) {
        return @(YES);
    }];
    ConfigurationItemModel *itemModel_2 = [[ConfigurationItemModel alloc] initWithType:ConfigurationItemModelTypeSwitch identifier:@"Test 2" label:@"Test 3\n3\n3\n3\n3" valueResolver:^NSObject<NSCopying> * _Nonnull(ConfigurationItemModel * _Nonnull) {
        return @(YES);
    }];
    ConfigurationItemModel *itemModel_3 = [[ConfigurationItemModel alloc] initWithType:ConfigurationItemModelTypeSwitch identifier:@"Test 3" label:@"Test 3" valueResolver:^NSObject<NSCopying> * _Nonnull(ConfigurationItemModel * _Nonnull) {
        return @(YES);
    }];
    ConfigurationItemModel<NSNumber *> *itemModel_4 = [[ConfigurationItemModel alloc] initWithType:ConfigurationItemModelTypeSwitch
                                                                                        identifier:@"Test 4"
                                                                                     labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return static_cast<NSNumber *>(value).stringValue;
    }
                                                                                     valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return @(YES);
    }];
    ConfigurationItemModel<NSNumber *> *itemModel_5 = [[ConfigurationItemModel alloc] initWithType:ConfigurationItemModelTypeSlider
                                                                                        identifier:@"Test 5"
                                                                                     labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return @"Title";
    }
                                                                                     valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationSliderDescription descriptionWithSliderValue:0.75 minimumValue:0. maximumValue:1.];
    }];
    [snapshot appendItemsWithIdentifiers:@[itemModel_1, itemModel_2, itemModel_3, itemModel_4, itemModel_5] intoSectionWithIdentifier:[NSNull null]];
    [itemModel_1 release];
    [itemModel_2 release];
    [itemModel_3 release];
    [itemModel_4 release];
    [itemModel_5 release];
    
    [self.configurationView.dataSource applySnapshot:snapshot animatingDifferences:YES];
    [snapshot release];
}

- (ConfigurationView *)_configurationView {
    if (auto configurationView = _configurationView) return configurationView;
    
    ConfigurationView *configurationView = [ConfigurationView new];
    configurationView.delegate = self;
    
    _configurationView = configurationView;
    return configurationView;
}

- (void)didTriggerReloadButtonWithConfigurationView:(ConfigurationView *)configurationView {
    
}

- (BOOL)configurationView:(ConfigurationView *)configurationView didTriggerActionWithItemModel:(ConfigurationItemModel *)itemModel newValue:(nonnull id<NSCopying>)newValue {
    return YES;
}

@end
