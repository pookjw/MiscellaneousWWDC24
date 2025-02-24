//
//  UIApplication+mrui_requestSceneWrapper.mm
//  SurfVideo
//
//  Created by Jinwoo Kim on 11/26/23.
//

#import "UIApplication+mrui_requestSceneWrapper.hpp"

#if TARGET_OS_VISION

#import <objc/message.h>
#import <objc/runtime.h>

@implementation UIApplication (mrui_requestSceneWrapper)

- (void)mruiw_requestVolumetricSceneWithUserActivity:(NSUserActivity *)userActivity completionHandler:(void (^)(NSError * _Nullable))completionHandler {
    id specification = [objc_lookUpClass("MRUISharedApplicationFullscreenSceneSpecification_SwiftUI") new];
    [self mruiw_requestSceneWithUserActivity:userActivity preferredImmersionStyle:0 sceneRequestIntent:1005 specification:specification completionHandler:completionHandler];
    [specification release];
}

- (void)mruiw_requestMixedImmersiveSceneWithUserActivity:(NSUserActivity *)userActivity completionHandler:(void (^)(NSError * _Nullable))completionHandler {
    id specification = [objc_lookUpClass("MRUISharedApplicationFullscreenSceneSpecification_SwiftUI") new];
    [self mruiw_requestSceneWithUserActivity:userActivity preferredImmersionStyle:2 sceneRequestIntent:1001 specification:specification completionHandler:completionHandler];
    [specification release];
}

- (void)mruiw_requestProgressiveImmersiveSceneWithUserActivity:(NSUserActivity *)userActivity completionHandler:(void (^)(NSError * _Nullable))completionHandler {
    id specification = [objc_lookUpClass("MRUISharedApplicationFullscreenSceneSpecification_SwiftUI") new];
    [self mruiw_requestSceneWithUserActivity:userActivity preferredImmersionStyle:4 sceneRequestIntent:1003 specification:specification completionHandler:completionHandler];
    [specification release];
}

- (void)mruiw_requestFullImmersiveSceneWithUserActivity:(NSUserActivity *)userActivity completionHandler:(void (^)(NSError * _Nullable))completionHandler {
    id specification = [objc_lookUpClass("MRUISharedApplicationFullscreenSceneSpecification_SwiftUI") new];
    [self mruiw_requestSceneWithUserActivity:userActivity preferredImmersionStyle:8 sceneRequestIntent:1002 specification:specification completionHandler:completionHandler];
    [specification release];
}

- (void)mruiw_requestCompositiveImmersiveSceneWithUserActivity:(NSUserActivity * _Nullable)userActivity completionHandler:(void (^)(NSError * _Nullable error))completionHandler {
    id specification = [objc_lookUpClass("CPImmersiveSceneSpecification_SwiftUI") new];
    [self mruiw_requestSceneWithUserActivity:userActivity preferredImmersionStyle:8 sceneRequestIntent:1002 specification:specification completionHandler:completionHandler];
    [specification release];
}

- (void)mruiw_requestSceneWithUserActivity:(NSUserActivity *)userActivity preferredImmersionStyle:(NSUInteger)preferredImmersionStyle sceneRequestIntent:(NSUInteger)sceneRequestIntent specification:(id)specification completionHandler:(void (^)(NSError * _Nullable))completionHandler __attribute__((objc_direct)) {
    id options = [objc_lookUpClass("MRUISceneRequestOptions") new];
    
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(options, NSSelectorFromString(@"setInternalFrameworksScene:"), NO);
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(options, NSSelectorFromString(@"setDisableDefocusBehavior:"), NO);
    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(options, NSSelectorFromString(@"setPreferredImmersionStyle:"), preferredImmersionStyle);
    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(options, NSSelectorFromString(@"setAllowedImmersionStyles:"), preferredImmersionStyle);
    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(options, NSSelectorFromString(@"setSceneRequestIntent:"), sceneRequestIntent);
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(options, NSSelectorFromString(@"setSpecification:"), specification);
    
    //
    
    id initialClientSettings = [objc_lookUpClass("MRUIMutableImmersiveSceneClientSettings") new];
    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(initialClientSettings, NSSelectorFromString(@"setPreferredImmersionStyle:"), preferredImmersionStyle);
    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(initialClientSettings, NSSelectorFromString(@"setAllowedImmersionStyles:"), preferredImmersionStyle);
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(options, sel_registerName("setInitialClientSettings:"), initialClientSettings);
    [initialClientSettings release];
    
    //
    
    reinterpret_cast<void (*)(id, SEL, id, id, id)>(objc_msgSend)(self,
                                                                  NSSelectorFromString(@"mrui_requestSceneWithUserActivity:requestOptions:completionHandler:"),
                                                                  userActivity,
                                                                  options,
                                                                  completionHandler);
    
    [options release];
}

@end

#endif
