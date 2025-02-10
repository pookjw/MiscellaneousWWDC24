//
//  SceneIntegrationViewController.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 2/10/25.
//

#import "SceneIntegrationViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import "SPGeometry.h"

OBJC_EXPORT id objc_msgSendSuper2(void); /* objc_super superInfo = { self, [self class] }; */

@interface SceneIntegrationViewController ()
@property (nonatomic, readonly, getter=_sceneIntegration) id sceneIntegration;
@end

@implementation SceneIntegrationViewController

- (void)viewDidMoveToWindow:(UIWindow *)window shouldAppearOrDisappear:(BOOL)shouldAppearOrDisappear {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL, id, BOOL)>(objc_msgSendSuper2)(&superInfo, _cmd, window, shouldAppearOrDisappear);
    
    if (id sceneIntegration = self.sceneIntegration) {
        NSString *description = reinterpret_cast<id (*)(id, SEL, BOOL)>(objc_msgSend)(sceneIntegration, sel_registerName("verboseDescription:"), YES);
        NSLog(@"%@", description);
        id realityKitScene = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(sceneIntegration, sel_registerName("realityKitScene"));
        NSLog(@"%@", realityKitScene);
        id entity = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(sceneIntegration, sel_registerName("entity"));
        NSLog(@"%@", entity);
    }
}

- (id)_sceneIntegration {
    return reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self.view.window.windowScene, sel_registerName("_mrui_integration"));
}

@end
