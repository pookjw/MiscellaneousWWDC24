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
#import <xpc/xpc.h>
#include <array>
#include <ranges>
#include <string>
#import "NSBundle+MA_Category.h"
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

extern "C" xpc_object_t xpc_bundle_create_main(void);
extern "C" char * xpc_bundle_get_property(xpc_object_t bundle, int32_t key);

@interface ServiceManagementDemoViewController () <ConfigurationViewDelegate>
@property (retain, nonatomic, readonly, getter=_configurationView) ConfigurationView *configurationView;
@property (retain, nonatomic, readonly, getter=_helperService) SMAppService *helperService;
@property (retain, nonatomic, readonly, getter=_helperSession) xpc_session_t helperSession;
@end

@implementation ServiceManagementDemoViewController
@synthesize configurationView = _configurationView;
@synthesize helperService = _helperService;
@synthesize helperSession = _helperSession;

- (void)dealloc {
    [_configurationView release];
    [_helperService release];
    if (_helperSession) {
        xpc_session_cancel(_helperSession);
        [_helperSession release];
    }
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
        [self _makeHelperStatusItmeModel],
        [self _makeRegisterHelperItemModel],
        [self _makeUnregisterHelperItemModel],
        [self _makeOpenSystemSettingsLoginItemsItemModel],
        [self _makePingHelperItemModel],
        [self _makeRegisterLoginAgentItemModel]
    ]
               intoSectionWithIdentifier:[NSNull null]];
    
    [snapshot reloadItemsWithIdentifiers:snapshot.itemIdentifiers];
    
    [self.configurationView applySnapshot:snapshot animatingDifferences:YES];
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

- (SMAppService *)_helperService {
    if (auto helperService = _helperService) return helperService;
    
    SMAppService *helperService = [SMAppService daemonServiceWithPlistName:@"com.pookjw.MiscellaneousAppKit.Helper.plist"];
    
    _helperService = [helperService retain];
    return helperService;
}

- (xpc_session_t)_helperSession {
    if (auto helperSession = _helperSession) return helperSession;
    
    xpc_rich_error_t richError = NULL;
    xpc_session_t helperSession = xpc_session_create_mach_service("com.pookjw.MiscellaneousAppKit.Helper",
                                                                  NULL,
                                                                  XPC_SESSION_CREATE_MACH_PRIVILEGED,
                                                                  &richError);
    if (richError) {
        char *description = xpc_rich_error_copy_description(richError);
        NSLog(@"%s", description);
        free(description);
        abort();
    }
    
    _helperSession = helperSession;
    return helperSession;
}

- (ConfigurationItemModel *)_makeHelperStatusItmeModel {
    SMAppService *helperService = self.helperService;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeLabel
                                          identifier:@"Helper Status"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return NSStringFromSMAppServiceStatus(helperService.status);
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
}

- (ConfigurationItemModel *)_makeRegisterHelperItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Register Helper"
                                            userInfo:nil
                                               label:@"Register Helper"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
}

- (ConfigurationItemModel *)_makeUnregisterHelperItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Unregister Helper"
                                            userInfo:nil
                                               label:@"Unregister Helper"
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

- (ConfigurationItemModel *)_makePingHelperItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Ping Helper"
                                            userInfo:nil
                                               label:@"Ping Helper"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
}

- (ConfigurationItemModel *)_makeRegisterLoginAgentItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Register Login Agent"
                                            userInfo:nil
                                               label:@"Register Login Agent"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
}

- (BOOL)configurationView:(nonnull ConfigurationView *)configurationView didTriggerActionWithItemModel:(nonnull ConfigurationItemModel *)itemModel newValue:(nonnull id<NSCopying>)newValue {
    NSString *identifier = itemModel.identifier;
    
    if ([identifier isEqualToString:@"Register Helper"]) {
        NSError * _Nullable error = nil;
        [self.helperService registerAndReturnError:&error];
        
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
    } else if ([identifier isEqualToString:@"Unregister Helper"]) {
        NSError * _Nullable error = nil;
        [self.helperService unregisterAndReturnError:&error];
        
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
    } else if ([identifier isEqualToString:@"Ping Helper"]) {
        xpc_session_t helperSession = self.helperSession;
        
        constexpr const std::array<const char *, 1> keys {
            "action"
        };
        
        xpc_object_t action = xpc_string_create("ping");
        const std::array<xpc_object_t, 1> values {
            action
        };
        
        xpc_object_t dictionary = xpc_dictionary_create(keys.data(), values.data(), keys.size());
        
        for (xpc_object_t object : values) {
            xpc_release(object);
        }
        
        xpc_session_send_message_with_reply_async(helperSession, dictionary, ^(xpc_object_t  _Nullable reply, xpc_rich_error_t  _Nullable error) {
            assert(error == NULL);
            
            const char *result = xpc_dictionary_get_string(reply, "result");
            NSString *resultString = [NSString stringWithCString:result encoding:NSUTF8StringEncoding];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSAlert *alert = [NSAlert new];
                alert.alertStyle = NSAlertStyleInformational;
                alert.messageText = @"Result";
                alert.informativeText = resultString;
                
                [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
                    
                }];
                [alert release];
            });
        });
        xpc_release(dictionary);
        
        return NO;
    } else if ([identifier isEqualToString:@"Register Login Agent"]) {
        xpc_object_t bundle = xpc_bundle_create_main();
        std::string rootPath = xpc_bundle_get_property(bundle, 2);
        xpc_release(bundle);
        std::string plistPath = rootPath + "/Contents/Library/LaunchAgents/com.pookjw.MiscellaneousAppKit.LoginAgent.plist";
        
        xpc_session_t helperSession = self.helperSession;
        
        constexpr const std::array<const char *, 3> keys {
            "action",
            "plistPath",
            "privilegedHelperToolsPath"
        };
        
        xpc_object_t action = xpc_string_create("registerLoginAgent");
        xpc_object_t plistPathObject = xpc_string_create(plistPath.data());
        xpc_object_t privilegedHelperToolsPath = xpc_string_create(rootPath.data());
        const std::array<xpc_object_t, 3> values {
            action,
            plistPathObject,
            privilegedHelperToolsPath
        };
        
        xpc_object_t dictionary = xpc_dictionary_create(keys.data(), values.data(), keys.size());
        
        for (xpc_object_t object : values) {
            xpc_release(object);
        }
        
        xpc_session_send_message_with_reply_async(helperSession, dictionary, ^(xpc_object_t  _Nullable reply, xpc_rich_error_t  _Nullable error) {
            assert(error == NULL);
            
            const char *result = xpc_dictionary_get_string(reply, "result");
            NSString *resultString = [NSString stringWithCString:result encoding:NSUTF8StringEncoding];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSAlert *alert = [NSAlert new];
                alert.alertStyle = NSAlertStyleInformational;
                alert.messageText = @"Result";
                alert.informativeText = resultString;
                
                [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
                    
                }];
                [alert release];
            });
        });
        xpc_release(dictionary);
        
        return NO;
    } else {
        abort();
    }
}

- (void)didTriggerReloadButtonWithConfigurationView:(ConfigurationView *)configurationView {
    return [self _reload];
}

@end
