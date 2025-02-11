//
//  WindowSceneZoomInteractionViewController.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 2/11/25.
//

// preferredWindowZoomMode와 관련 있어 보임

#import "WindowSceneZoomInteractionViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>
OBJC_EXPORT id objc_msgSendSuper2(void); /* objc_super superInfo = { self, [self class] }; */

@implementation WindowSceneZoomInteractionViewController

- (void)viewDidMoveToWindow:(UIWindow *)window shouldAppearOrDisappear:(BOOL)shouldAppearOrDisappear {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL, id, BOOL)>(objc_msgSendSuper2)(&superInfo, _cmd, window, shouldAppearOrDisappear);
    
    if (window) {
        NSLog(@"%@", window);
        id<UIInteraction> windowZoomInteraction = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(window, sel_registerName("windowZoomInteraction"));
        NSLog(@"%@", windowZoomInteraction);
        
        id<UIInteraction> interaction = [objc_lookUpClass("MRUIWindowSceneZoomInteraction") new];
        [window addInteraction:interaction];
        [interaction release];
        
        id mrui_integration = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(window, sel_registerName("mrui_integration"));
        BOOL supportsWindowSceneZoomInteraction = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(mrui_integration, sel_registerName("supportsWindowSceneZoomInteraction"));
        NSLog(@"%d", supportsWindowSceneZoomInteraction);
    }
}

@end
