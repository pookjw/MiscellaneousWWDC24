//
//  ARStereoPropertiesViewController.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 2/24/25.
//

#warning WIP

#import "ARStereoPropertiesViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import <ARKit/ARKit.h>
#import "UIApplication+mrui_requestSceneWrapper.hpp"

AR_EXTERN id ar_session_get_session_remote_service(id<OS_ar_data_provider> data_provider);

@interface ARStereoPropertiesViewController ()
@property (retain, nonatomic, readonly, getter=_barButtonItem) UIBarButtonItem *barButtonItem;
@property (retain, nonatomic, readonly, getter=_arSession) ar_session_t arSession;
@property (retain, nonatomic, readonly, getter=_stereoPropertiesProvider) ar_stereo_properties_provider_t stereoPropertiesProvider;
@property (retain, nonatomic, readonly, getter=_worldTrackingProvider) ar_world_tracking_provider_t worldTrackingProvider;
@property (retain, nonatomic, readonly, getter=_handTrackingProvider) ar_hand_tracking_provider_t handTrackingProvider;
@property (retain, nonatomic, nullable, getter=_updateLink, setter=_setUpdateLink:) UIUpdateLink *updateLink;
@end

@implementation ARStereoPropertiesViewController
@synthesize barButtonItem = _barButtonItem;
@synthesize updateLink = _updateLink;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self _commonInit_ARStereoPropertiesViewController];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self _commonInit_ARStereoPropertiesViewController];
    }
    
    return self;
}

- (void)dealloc {
    ar_session_t arSession = _arSession;
    ar_session_stop(arSession);
    ar_release(arSession);
    
    ar_release(_stereoPropertiesProvider);
    ar_release(_worldTrackingProvider);
    ar_release(_handTrackingProvider);
    
    [_barButtonItem release];
    
    if (UIUpdateLink *updateLink = _updateLink) {
        updateLink.enabled = NO;
        [updateLink release];
    }
    
    [super dealloc];
}

- (void)_commonInit_ARStereoPropertiesViewController {
    _arSession = ar_session_create();
    
    {
        ar_stereo_properties_configuration_t configuration = ar_stereo_properties_configuration_create();
        _stereoPropertiesProvider = ar_stereo_properties_provider_create(configuration);
        ar_release(configuration);
    }
    
    {
        ar_world_tracking_configuration_t configuration = ar_world_tracking_configuration_create();
        _worldTrackingProvider = ar_world_tracking_provider_create(configuration);
        ar_release(configuration);
    }
    
    {
        ar_hand_tracking_configuration_t configuration = ar_hand_tracking_configuration_create();
        _handTrackingProvider = ar_hand_tracking_provider_create(configuration);
        ar_release(configuration);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.barButtonItem;
    
    NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:@"ARStereoProperties"];
    [UIApplication.sharedApplication mruiw_requestFullImmersiveSceneWithUserActivity:userActivity completionHandler:^(NSError * _Nullable error) {
        assert(error == nil);
    }];
    [userActivity release];
}

- (UIBarButtonItem *)_barButtonItem {
    if (auto barButtonItem = _barButtonItem) return barButtonItem;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"gear"] menu:[self _makeMenu]];
    
    _barButtonItem = barButtonItem;
    return barButtonItem;
}

- (UIMenu *)_makeMenu {
    ar_session_t arSession = self.arSession;
    ar_stereo_properties_provider_t stereoPropertiesProvider = self.stereoPropertiesProvider;
    ar_world_tracking_provider_t worldTrackingProvider = self.worldTrackingProvider;
    ar_hand_tracking_provider_t handTrackingProvider = self.handTrackingProvider;
    __weak auto weakSelf = self;
    
    UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
        if (weakSelf.updateLink != nil) {
            // TODO: Stop/Run
            UIAction *action = [UIAction actionWithTitle:@"Running" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                
            }];
            action.attributes = UIMenuElementAttributesDisabled;
            completion(@[action]);
            return;
        }
        
        bool supported = ar_stereo_properties_provider_is_supported() and ar_world_tracking_provider_is_supported();
        if (!supported) {
            UIAction *action = [UIAction actionWithTitle:@"Not Supported" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                
            }];
            action.attributes = UIMenuElementAttributesDisabled;
            completion(@[action]);
            return;
        }
        
        UIAction *runAction = [UIAction actionWithTitle:@"Run" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            ar_data_providers_t dataProviders = ar_data_providers_create_with_data_providers(stereoPropertiesProvider, worldTrackingProvider, handTrackingProvider, nil);
            ar_session_run(arSession, dataProviders);
            ar_release(dataProviders);
            
            if (auto loaded = weakSelf) {
                UIUpdateLink *updateLink = [UIUpdateLink updateLinkForView:loaded.view actionTarget:loaded selector:@selector(_didTriggerUpdateLink:)];
                updateLink.requiresContinuousUpdates = YES;
                loaded.updateLink = updateLink;
                updateLink.enabled = YES;
            }
        }];
        
        ar_authorization_type_t authorizationType = ar_stereo_properties_provider_get_required_authorization_type();
        authorizationType = static_cast<ar_authorization_type_t>(authorizationType | ar_world_tracking_provider_get_required_authorization_type());
        authorizationType = static_cast<ar_authorization_type_t>(authorizationType | ar_hand_tracking_provider_get_required_authorization_type());
//        authorizationType = static_cast<ar_authorization_type_t>(1 << 4);
        
        if (authorizationType == ar_authorization_type_none) {
            completion(@[runAction]);
            return;
        }
        
        ar_session_query_authorization_results(arSession, authorizationType, ^(ar_authorization_results_t  _Nonnull authorization_results, ar_error_t  _Nullable error) {
            assert(error == nil);
            assert(ar_authorization_results_get_count(authorization_results) > 0);
            
            ar_authorization_results_enumerate_results(authorization_results, ^bool(ar_authorization_result_t  _Nonnull authorization_result) {
                assert(ar_authorization_result_get_authorization_type(authorization_result) == authorizationType);
                ar_authorization_status_t status = ar_authorization_result_get_status(authorization_result);
                
                switch (status) {
                    case ar_authorization_status_not_determined: {
                        UIAction *action = [UIAction actionWithTitle:@"Request Authorization" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                            ar_session_request_authorization(arSession, authorizationType, ^(ar_authorization_results_t  _Nonnull authorization_results, ar_error_t  _Nullable error) {
                                assert(error == nil);
                                assert(ar_authorization_results_get_count(authorization_results) > 0);
                                
                                ar_authorization_results_enumerate_results(authorization_results, ^bool(ar_authorization_result_t  _Nonnull authorization_result) {
                                    ar_authorization_status_t status = ar_authorization_result_get_status(authorization_result);
                                    assert(status == ar_authorization_status_allowed);
                                    return true;
                                });
                            });
                        }];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completion(@[action]);
                        });
                        
                        break;
                    }
                    case ar_authorization_status_allowed: {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completion(@[runAction]);
                        });
                        
                        break;
                    }
                    case ar_authorization_status_denied:
                    default:
                        abort();
                }
                
                return false;
            });
        });
    }];
    
    return [UIMenu menuWithChildren:@[element]];
}

- (void)_didTriggerUpdateLink:(UIUpdateLink *)sender {
//    id remoteService = ar_session_get_session_remote_service(self.stereoPropertiesProvider);
//    id remoteService = *(id *)((uintptr_t)(self.stereoPropertiesProvider) + 0x10);
//    reinterpret_cast<void (*)(id, SEL, unsigned long, id)>(objc_msgSend)(remoteService, sel_registerName("syncServiceWithTimeout:callback:"), 10000000000, ^(NSError * _Nullable error) {
//        id syncService = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(remoteService, sel_registerName("syncService"));
//        NSLog(@"%@", syncService);
//    });
//    id syncService = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(remoteService, sel_registerName("syncService"));
//    NSLog(@"%@", syncService);
    
    switch (ar_data_provider_get_state(self.stereoPropertiesProvider)) {
        case ar_data_provider_state_initialized:
            NSLog(@"Initialized");
            break;
        case ar_data_provider_state_running:
            NSLog(@"Running");
            break;
        case ar_data_provider_state_stopped:
            NSLog(@"Stopped");
            break;
        case ar_data_provider_state_paused:
            NSLog(@"Paused");
            break;
        default:
            break;
    }
    
    ar_viewpoint_properties_t properties = ar_viewpoint_properties_create();
    
    if (!ar_stereo_properties_provider_get_viewpoint_properties(self.stereoPropertiesProvider, properties)) {
        ar_release(properties);
        return;
    }
    
    simd::float4x4 leftViewPointTransform = ar_viewpoint_properties_get_device_from_left_viewpoint_transform(properties);
    simd::float4x4 rightViewPointTransform = ar_viewpoint_properties_get_device_from_right_viewpoint_transform(properties);
    ar_release(properties);
    
//    ar_device_anchor_t deviceAnchor = ar_device_anchor_create();
//    ar_device_anchor_query_status_t status = ar_world_tracking_provider_query_device_anchor_at_timestamp(_worldTrackingProvider, sender.currentUpdateInfo.modelTime, deviceAnchor);
//    if (status != ar_device_anchor_query_status_success) {
//        return;
//    }
//    NSLog(@"%@", deviceAnchor);
    
//    ar_hand_anchor_t leftAnchor = ar_hand_anchor_create();
//    ar_hand_anchor_t rightAnchor = ar_hand_anchor_create();
//    if (ar_hand_tracking_provider_get_latest_anchors(self.handTrackingProvider, leftAnchor, rightAnchor)) {
//        NSLog(@"%@ %@", leftAnchor, rightAnchor);
//    }
//    ar_release(leftAnchor);
//    ar_release(rightAnchor);
}

@end
