//
//  ServiceManagementDemoViewController.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/13/25.
//

#import "ServiceManagementDemoViewController.h"
#import "ConfigurationView.h"
#import <ServiceManagement/ServiceManagement.h>
#import "NSStringFromSMAppServiceStatus.h"

@interface ServiceManagementDemoViewController () <ConfigurationViewDelegate>
@property (retain, nonatomic, readonly, getter=_configurationView) ConfigurationView *configurationView;
@property (retain, nonatomic, readonly, getter=_appService) SMAppService *appService;
@end

@implementation ServiceManagementDemoViewController
@synthesize configurationView = _configurationView;
@synthesize appService = _appService;

- (void)dealloc {
    [_configurationView release];
    [_appService release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ConfigurationView *configurationView = self.configurationView;
    configurationView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    configurationView.frame = self.view.bounds;
    [self.view addSubview:configurationView];
    
    [self _reload];
}

- (void)_reload {
    NSDiffableDataSourceSnapshot *snapshot = [NSDiffableDataSourceSnapshot new];
    [snapshot appendSectionsWithIdentifiers:@[[NSNull null]]];
    
    [snapshot appendItemsWithIdentifiers:@[
        [self _makeStatusItmeModel],
        [self _makeRegisterItemModel],
        [self _makeUnregisterItemModel],
        [self _makeOpenSystemSettingsLoginItemsItemModel]
    ]
               intoSectionWithIdentifier:[NSNull null]];
    
    [snapshot reloadItemsWithIdentifiers:snapshot.itemIdentifiers];
    
    [self.configurationView.dataSource applySnapshot:snapshot animatingDifferences:YES];
    [snapshot release];
}

- (ConfigurationView *)_configurationView {
    if (auto configurationView = _configurationView) return configurationView;
    
    ConfigurationView *configurationView = [ConfigurationView new];
    configurationView.delegate = self;
    configurationView.showBlendedBackground = NO;
    
    _configurationView = configurationView;
    return configurationView;
}

- (SMAppService *)_appService {
    if (auto appService = _appService) return appService;
    
//    SMAppService *appService = [SMAppService daemonServiceWithPlistName:@"com.pookjw.MiscellaneousAppKit.plist"];
    SMAppService *appService = [SMAppService agentServiceWithPlistName:@"com.pookjw.MiscellaneousAppKit.LoginAgent.plist"];
    
    _appService = [appService retain];
    return appService;
}

- (ConfigurationItemModel *)_makeStatusItmeModel {
    SMAppService *appService = self.appService;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeLabel
                                          identifier:@"Status"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return NSStringFromSMAppServiceStatus(appService.status);
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
}

- (ConfigurationItemModel *)_makeRegisterItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Register"
                                            userInfo:nil
                                               label:@"Register"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
}

- (ConfigurationItemModel *)_makeUnregisterItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Unregister"
                                            userInfo:nil
                                               label:@"Unregister"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
}

- (ConfigurationItemModel *)_makeOpenSystemSettingsLoginItemsItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Open System Settings Login Items"
                                            userInfo:nil
                                               label:@"Open System Settings Login Items"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
}

- (BOOL)configurationView:(nonnull ConfigurationView *)configurationView didTriggerActionWithItemModel:(nonnull ConfigurationItemModel *)itemModel newValue:(nonnull id<NSCopying>)newValue {
    NSString *identifier = itemModel.identifier;
    
    if ([identifier isEqualToString:@"Register"]) {
        NSError * _Nullable error = nil;
        [self.appService registerAndReturnError:&error];
        
        if (error) {
            NSAlert *alert = [NSAlert new];
            alert.alertStyle = NSAlertStyleInformational;
            alert.messageText = @"ERROR";
            alert.informativeText = error.description;
            
            [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
                
            }];
            [alert release];
        }
        
        [self _reload];
        return NO;
    } else if ([identifier isEqualToString:@"Unregister"]) {
        NSError * _Nullable error = nil;
        [self.appService unregisterAndReturnError:&error];
        
        if (error) {
            NSAlert *alert = [NSAlert new];
            alert.alertStyle = NSAlertStyleInformational;
            alert.messageText = @"ERROR";
            alert.informativeText = error.description;
            
            [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
                
            }];
            [alert release];
        }
        
        [self _reload];
        return NO;
    } else if ([identifier isEqualToString:@"Open System Settings Login Items"]) {
        [SMAppService openSystemSettingsLoginItems];
        return NO;
    } else {
        abort();
    }
}

- (void)didTriggerReloadButtonWithConfigurationView:(ConfigurationView *)configurationView {
    return [self _reload];
}

@end
