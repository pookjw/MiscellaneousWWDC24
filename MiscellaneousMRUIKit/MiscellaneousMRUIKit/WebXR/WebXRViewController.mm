//
//  WebXRViewController.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 12/20/24.
//

#import "WebXRViewController.h"
#import <WebKit/WebKit.h>
#import <objc/message.h>
#import <objc/runtime.h>
#import <CompositorServices/CompositorServices.h>

CP_EXTERN const UISceneSessionRole CPSceneSessionRoleImmersiveSpaceApplication;
CP_EXTERN void cp_layer_renderer_configuration_set_enable_post_processing(cp_layer_renderer_configuration_t, bool);
CP_EXTERN void cp_layer_renderer_configuration_set_contents_inverted_vertically(cp_layer_renderer_configuration_t, bool);
CP_EXTERN void cp_layer_renderer_configuration_set_use_shared_events(cp_layer_renderer_configuration_t, bool);

// ENABLE(WEBXR)

typedef NS_OPTIONS(NSUInteger, _WKXRSessionFeatureFlags) {
    _WKXRSessionFeatureFlagsNone = 0,
    _WKXRSessionFeatureFlagsReferenceSpaceTypeViewer = 1 << 0,
    _WKXRSessionFeatureFlagsReferenceSpaceTypeLocal = 1 << 1,
    _WKXRSessionFeatureFlagsReferenceSpaceTypeLocalFloor = 1 << 2,
    _WKXRSessionFeatureFlagsReferenceSpaceTypeBoundedFloor = 1 << 3,
    _WKXRSessionFeatureFlagsReferenceSpaceTypeUnbounded = 1 << 4,
    _WKXRSessionFeatureFlagsHandTracking = 1 << 5,
};

typedef NS_ENUM(NSInteger, _WKXRSessionMode) {
    _WKXRSessionModeInline,
    _WKXRSessionModeImmersiveVr,
    _WKXRSessionModeImmersiveAr,
};

typedef NS_ENUM(NSInteger, _WKXRSessionEndReason) {
    _WKXRSessionEndReasonNoError,
    _WKXRSessionEndReasonNoFrameUpdateScheduled,
    _WKXRSessionEndReasonUnknownError,
};

NSString * NSStringFromWKXRSessionFeatureFlags(_WKXRSessionFeatureFlags flags) {
    if (flags == _WKXRSessionFeatureFlagsNone) {
        return @"None";
    }
    
    NSMutableArray<NSString *> *strings = [NSMutableArray new];
    
    if ((flags & _WKXRSessionFeatureFlagsReferenceSpaceTypeViewer) == _WKXRSessionFeatureFlagsReferenceSpaceTypeViewer) {
        [strings addObject:@"Reference Space Type Viewer"];
    }
    
    if ((flags & _WKXRSessionFeatureFlagsReferenceSpaceTypeLocal) == _WKXRSessionFeatureFlagsReferenceSpaceTypeLocal) {
        [strings addObject:@"Reference Space Type Local"];
    }
    
    if ((flags & _WKXRSessionFeatureFlagsReferenceSpaceTypeLocalFloor) == _WKXRSessionFeatureFlagsReferenceSpaceTypeLocalFloor) {
        [strings addObject:@"Reference Space Type Local Floor"];
    }
    
    if ((flags & _WKXRSessionFeatureFlagsReferenceSpaceTypeBoundedFloor) == _WKXRSessionFeatureFlagsReferenceSpaceTypeBoundedFloor) {
        [strings addObject:@"Reference Space Type Bounded Floor"];
    }
    
    if ((flags & _WKXRSessionFeatureFlagsReferenceSpaceTypeUnbounded) == _WKXRSessionFeatureFlagsReferenceSpaceTypeUnbounded) {
        [strings addObject:@"Reference Space Type Unbounded"];
    }
    
    if ((flags & _WKXRSessionFeatureFlagsHandTracking) == _WKXRSessionFeatureFlagsHandTracking) {
        [strings addObject:@"Hand Tracking"];
    }
    
    NSString *string = [strings componentsJoinedByString:@", "];
    [strings release];
    
    return string;
}

NSString * NSStringFromWKXRSessionMode(_WKXRSessionMode mode) {
    switch (mode) {
        case _WKXRSessionModeInline:
            return @"Inline";
        case _WKXRSessionModeImmersiveVr:
            return @"Immersive VR";
        case _WKXRSessionModeImmersiveAr:
            return @"Immersive AR";
        default:
            abort();
    }
}

NSString * NSStringFromWKXRSessionEndReason(_WKXRSessionEndReason reason) {
    switch (reason) {
        case _WKXRSessionEndReasonNoError:
            return @"No Error";
        case _WKXRSessionEndReasonNoFrameUpdateScheduled:
            return @"No Frame Update Scheduled";
        case _WKXRSessionEndReasonUnknownError:
            return @"Unknown Error";
        default:
            abort();
    }
}

@interface WebXRViewController () <WKUIDelegate>
@end

@implementation WebXRViewController

- (void)loadView {
    WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectNull configuration:configuration];
    [configuration release];
    
    webView.UIDelegate = self;
    
    NSURL *url = [NSURL URLWithString:@"https://immersive-web.github.io/webxr-samples/"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [webView loadRequest:request];
    [request release];
    
    self.view = webView;
    [webView release];
}

- (void)viewIsAppearing:(BOOL)animated {
    [super viewIsAppearing:animated];
    
#warning -_webView:requestPermissionForXRSessionOrigin:mode:grantedFeatures:consentRequiredFeatures:consentOptionalFeatures:completionHandler:로 옮겨야 하는지 검토
    ar_session_t session = ar_session_create();
    
    ar_session_request_authorization(session, ar_world_tracking_provider_get_required_authorization_type(), ^(ar_authorization_results_t  _Nonnull authorization_results, ar_error_t  _Nullable error) {
        if (error != nil) {
            CFErrorRef cfError = ar_error_copy_cf_error(error);
            ar_release(error);
            CFShow(cfError);
            CFRelease(cfError);
            abort();
        }
        
        __block BOOL flag = YES;
        
        ar_authorization_results_enumerate_results(authorization_results, ^bool(ar_authorization_result_t  _Nonnull authorization_result) {
            ar_authorization_status_t status = ar_authorization_result_get_status(authorization_result);
            
            if (status == ar_authorization_status_allowed) {
                return true;
            } else {
                flag = NO;
                return false;
            }
        });
        
        assert(flag);
    });
    
    if (ar_hand_tracking_provider_is_supported()) {
        ar_session_request_authorization(session, ar_hand_tracking_provider_get_required_authorization_type(), ^(ar_authorization_results_t  _Nonnull authorization_results, ar_error_t  _Nullable error) {
            if (error != nil) {
                CFErrorRef cfError = ar_error_copy_cf_error(error);
                ar_release(error);
                CFShow(cfError);
                CFRelease(cfError);
                abort();
            }
            
            __block BOOL flag = YES;
            
            ar_authorization_results_enumerate_results(authorization_results, ^bool(ar_authorization_result_t  _Nonnull authorization_result) {
                ar_authorization_status_t status = ar_authorization_result_get_status(authorization_result);
                
                if (status == ar_authorization_status_allowed) {
                    return true;
                } else {
                    flag = NO;
                    return false;
                }
            });
            
            assert(flag);
        });
    }
    
    ar_release(session);
}

- (void)_webView:(WKWebView *)webView requestPermissionForXRSessionOrigin:(NSString *)originString mode:(_WKXRSessionMode)mode grantedFeatures:(_WKXRSessionFeatureFlags)grantedFeatures consentRequiredFeatures:(_WKXRSessionFeatureFlags)consentRequiredFeatures consentOptionalFeatures:(_WKXRSessionFeatureFlags)consentOptionalFeatures completionHandler:(void (^)(_WKXRSessionFeatureFlags))completionHandler {
    abort();
}

- (void)_webView:(WKWebView *)webView requestPermissionForXRSessionOrigin:(NSString *)originString mode:(_WKXRSessionMode)mode grantedFeatures:(_WKXRSessionFeatureFlags)grantedFeatures consentRequiredFeatures:(_WKXRSessionFeatureFlags)consentRequiredFeatures consentOptionalFeatures:(_WKXRSessionFeatureFlags)consentOptionalFeatures requiredFeaturesRequested:(_WKXRSessionFeatureFlags)requiredFeaturesRequested optionalFeaturesRequested:(_WKXRSessionFeatureFlags)optionalFeaturesRequested completionHandler:(void (^)(_WKXRSessionFeatureFlags))completionHandler {
    NSString *modeString = NSStringFromWKXRSessionMode(mode);
    NSString *grantedFeaturesString = NSStringFromWKXRSessionFeatureFlags(grantedFeatures);
    NSString *consentRequiredFeaturesString = NSStringFromWKXRSessionFeatureFlags(consentRequiredFeatures);
    NSString *consentOptionalFeaturesString = NSStringFromWKXRSessionFeatureFlags(consentOptionalFeatures);
    NSString *requiredFeaturesRequestedString = NSStringFromWKXRSessionFeatureFlags(requiredFeaturesRequested);
    NSString *optionalFeaturesRequestedString = NSStringFromWKXRSessionFeatureFlags(optionalFeaturesRequested);
    
    NSString *message = [[NSString alloc] initWithFormat:@"Mode: %@\nGranted Features: %@\nConsent Required Features: %@\nConsent Optional Features: %@\nRequired Features Requested: %@\nOptional Features Requested: %@", modeString, grantedFeaturesString, consentRequiredFeaturesString, consentOptionalFeaturesString, requiredFeaturesRequestedString, optionalFeaturesRequestedString];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"XR" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *allowAction = [UIAlertAction actionWithTitle:@"Allow" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 값이 잘못 전달되면 _WKXRSessionEndReasonUnknownError이 나올 것
        completionHandler(requiredFeaturesRequested | optionalFeaturesRequested);
    }];
    
    [alertController addAction:allowAction];
    
    UIAlertAction *dontAllowAction = [UIAlertAction actionWithTitle:@"Don't Allow" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(0);
    }];
    
    [alertController addAction:dontAllowAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)_webView:(WKWebView *)webView supportedXRSessionFeatures:(_WKXRSessionFeatureFlags *)vrFeatures arFeatures:(_WKXRSessionFeatureFlags *)arFeatures {
    _WKXRSessionFeatureFlags flags = *vrFeatures;
    if (((flags ^ 0xFFFFFFFF) & 0x7) != 0x0) {
        *vrFeatures = flags | 0x7;
    }
}

- (void)_webView:(WKWebView *)webView startXRSessionWithFeatures:(_WKXRSessionFeatureFlags)features completionHandler:(void (^)(id, UIViewController *))completionHandler {
    id options = [objc_lookUpClass("MRUISceneRequestOptions") new];
    
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(options, NSSelectorFromString(@"setInternalFrameworksScene:"), NO);
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(options, NSSelectorFromString(@"setDisableDefocusBehavior:"), NO);
    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(options, NSSelectorFromString(@"setPreferredImmersionStyle:"), 8);
    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(options, NSSelectorFromString(@"setAllowedImmersionStyles:"), 10);
    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(options, NSSelectorFromString(@"setSceneRequestIntent:"), 1001);
    
    id specification = [objc_lookUpClass("CPImmersiveSceneSpecification_SwiftUI") new];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(options, NSSelectorFromString(@"setSpecification:"), specification);
    [specification release];
    
    //
    
    id initialClientSettings = [objc_lookUpClass("MRUIMutableImmersiveSceneClientSettings") new];
    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(initialClientSettings, NSSelectorFromString(@"setPreferredImmersionStyle:"), 8);
    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(initialClientSettings, NSSelectorFromString(@"setAllowedImmersionStyles:"), 10);
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(options, sel_registerName("setInitialClientSettings:"), initialClientSettings);
    [initialClientSettings release];
    
    //
    
    id content = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("CPLayerBoxedEnvironmentContent") alloc], sel_registerName("initWithViewControllerProvider:"), ^ UIViewController * (id content) {
        UIViewController *viewController = [UIViewController new];
        return [viewController autorelease];
    });
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(content, sel_registerName("setConfigurationProvider:"), self);
    
    reinterpret_cast<void (*)(id, SEL, id, id, id)>(objc_msgSend)(UIApplication.sharedApplication,
                                                                  NSSelectorFromString(@"mrui_requestSceneWithUserActivity:requestOptions:completionHandler:"),
                                                                  nil,
                                                                  options,
                                                                  ^(NSError * _Nullable error ){
        for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
            if (![scene.session.role isEqualToString:CPSceneSessionRoleImmersiveSpaceApplication]) continue;
            
            reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(content, sel_registerName("prepareForPresentationInScene:"), scene);
            reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(content, sel_registerName("show"));
            
            cp_layer_renderer_t layerRenderer = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(content, sel_registerName("layer"));
            UIViewController *rootVC = static_cast<UIWindowScene *>(scene).keyWindow.rootViewController;
            completionHandler(layerRenderer, rootVC);
            
            break;
        }
    });
    
    [options release];
    
    [content release];
}

- (void)_webViewEndXRSession:(WKWebView *)webView withReason:(_WKXRSessionEndReason)endReason {
    NSLog(@"%@", NSStringFromWKXRSessionEndReason(endReason));
    
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if (![scene.session.role isEqualToString:CPSceneSessionRoleImmersiveSpaceApplication]) continue;
        
        [UIApplication.sharedApplication requestSceneSessionDestruction:scene.session options:nil errorHandler:^(NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
        
        break;
    }
}

- (cp_layer_renderer_configuration_t)layerConfigurationWithDefaultConfiguration:(cp_layer_renderer_configuration_t)defaultConfiguration layerCapabilites:(cp_layer_renderer_capabilities_t)layerCapabilites {
    cp_layer_renderer_configuration_t copy = [defaultConfiguration copy];
    
    cp_layer_renderer_configuration_set_color_format(copy, MTLPixelFormatBGRA8Unorm_sRGB);
    cp_layer_renderer_configuration_set_enable_post_processing(copy, false);
    cp_layer_renderer_configuration_set_contents_inverted_vertically(copy, true);
    cp_layer_renderer_configuration_set_use_shared_events(copy, true);
    
    return [copy autorelease];
}

@end
