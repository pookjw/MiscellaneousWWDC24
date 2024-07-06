//
//  SceneActivationViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/11/24.
//

#import "SceneActivationViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import <TargetConditionals.h>

@interface OwnWindowScenePlacement : UIWindowScenePlacement
+ (instancetype)new;
@end
@implementation OwnWindowScenePlacement


- (NSUInteger)_placementType {
    return 8;
}

@end

@implementation SceneActivationViewController

- (void)loadView {
    UIButtonConfiguration *configuration = [UIButtonConfiguration filledButtonConfiguration];
    
    __weak auto weakSelf = self;
    
    UIAction *primaryAction = [UIAction actionWithTitle:@"Push!" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        UIWindowSceneActivationRequestOptions *options = [UIWindowSceneActivationRequestOptions new];
        
        
#if TARGET_OS_VISION
        UIWindowScenePushPlacement *placement = [UIWindowScenePushPlacement placementTargetingSceneSession:weakSelf.view.window.windowScene.session];
        
//        UIWindowSceneReplacePlacement *placement = [UIWindowSceneReplacePlacement placementToReplaceSceneSession:weakSelf.view.window.windowScene.session];
        
        
//        UIWindowSceneReplacePlacement *copiedPlacement = [placement copy];
//        NSError * _Nullable error = nil;
//        NSLog(@"%@", ((id (*)(id, SEL, id *))objc_msgSend)(copiedPlacement, sel_registerName("_createConfigurationWithError:"), &error));
//        assert(!error);
//        [copiedPlacement release];
#else
//        __kindof UIWindowScenePlacement *placement = ((id (*)(Class, SEL, id))objc_msgSend)(objc_lookUpClass("_UIWindowSceneReplacePlacement"), sel_registerName("placementToReplaceSceneSession:"), weakSelf.view.window.windowScene.session);
        UIWindowSceneProminentPlacement *placement = [UIWindowSceneProminentPlacement prominentPlacement];
//        UIWindowSceneStandardPlacement *placement = [UIWindowSceneStandardPlacement standardPlacement];
//        __kindof UIWindowScenePlacement *placement = ((id (*)(Class, SEL, id))objc_msgSend)(objc_lookUpClass("_UIWindowSceneOrderedPlacement"), sel_registerName("orderedPlacementBelow:"), weakSelf.view.window.windowScene);
//        OwnWindowScenePlacement *placement = [[OwnWindowScenePlacement new] autorelease];
#endif
        
        options.placement = placement;
        
        UISceneSessionActivationRequest *request = [UISceneSessionActivationRequest requestWithRole:UIWindowSceneSessionRoleApplication];
        
        request.options = options;
        [options release];
        
        NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:@"Orange"];
        request.userActivity = userActivity;
        [userActivity release];
        
        [UIApplication.sharedApplication activateSceneSessionForRequest:request errorHandler:^(NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
    }];
    
    UIButton *button = [UIButton buttonWithConfiguration:configuration primaryAction:primaryAction];
    self.view = button;
}

@end
