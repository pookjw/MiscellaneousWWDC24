//
//  UIApplication+mrui_requestSceneWrapper.h
//  SurfVideo
//
//  Created by Jinwoo Kim on 11/26/23.
//

#import <TargetConditionals.h>

#if TARGET_OS_VISION

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// TODO: _MRUIImmersiveSpaceSceneActivationRequestOptions 써도 될듯?

__attribute__((objc_direct_members))
@interface UIApplication (mrui_requestSceneWrapper)
- (void)mruiw_requestVolumetricSceneWithUserActivity:(NSUserActivity * _Nullable)userActivity completionHandler:(void (^)(NSError * _Nullable error))completionHandler;
- (void)mruiw_requestMixedImmersiveSceneWithUserActivity:(NSUserActivity * _Nullable)userActivity completionHandler:(void (^)(NSError * _Nullable error))completionHandler;
- (void)mruiw_requestProgressiveImmersiveSceneWithUserActivity:(NSUserActivity * _Nullable)userActivity completionHandler:(void (^)(NSError * _Nullable error))completionHandler;
- (void)mruiw_requestFullImmersiveSceneWithUserActivity:(NSUserActivity * _Nullable)userActivity completionHandler:(void (^)(NSError * _Nullable error))completionHandler;
- (void)mruiw_requestCompositiveImmersiveSceneWithUserActivity:(NSUserActivity * _Nullable)userActivity completionHandler:(void (^)(NSError * _Nullable error))completionHandler;
@end

NS_ASSUME_NONNULL_END

#endif
