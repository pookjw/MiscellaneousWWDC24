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

#warning UIWindowScene UIWindow

OBJC_EXPORT id objc_msgSendSuper2(void); /* objc_super superInfo = { self, [self class] }; */

@interface SceneIntegrationViewController ()
@property (nonatomic, readonly, getter=_sceneIntegration) id sceneIntegration;
@end

@implementation SceneIntegrationViewController

- (void)viewDidMoveToWindow:(UIWindow *)window shouldAppearOrDisappear:(BOOL)shouldAppearOrDisappear {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL, id, BOOL)>(objc_msgSendSuper2)(&superInfo, _cmd, window, shouldAppearOrDisappear);
    
    if (id sceneIntegration = self.sceneIntegration) {
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(sceneIntegration, sel_registerName("setDocumentIcon:"), [UIImage systemImageNamed:@"trash"]);
        reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(sceneIntegration, sel_registerName("setPreferHeadlockedRendering:"), YES);
        reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(sceneIntegration, sel_registerName("setPrefersDocking:"), YES);
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            id entity = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(sceneIntegration, sel_registerName("entity"));
//            SPPoint3D localPosition = reinterpret_cast<SPPoint3D (*)(id, SEL)>(objc_msgSend)(entity, sel_registerName("localPosition"));
//            NSLog(@"%@", _NSStringFromSPPoint3D(localPosition));
//            reinterpret_cast<SPPoint3D (*)(id, SEL, SPPoint3D)>(objc_msgSend)(entity, sel_registerName("setLocalPosition:"), SPPoint3DMake(2000., 2000., 2000.));
//            reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(sceneIntegration, sel_registerName("update"));
//        });
    }
}

- (id)_sceneIntegration {
    return reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self.view.window.windowScene, sel_registerName("_mrui_integration"));
}

@end
