//
//  WindowViewController.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 2/10/25.
//

#import "WindowViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void); /* objc_super superInfo = { self, [self class] }; */

@interface WindowViewController ()
@end

@implementation WindowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidMoveToWindow:(UIWindow *)window shouldAppearOrDisappear:(BOOL)shouldAppearOrDisappear {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL, id, BOOL)>(objc_msgSendSuper2)(&superInfo, _cmd, window, shouldAppearOrDisappear);
    
    if (window) {
        reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(window, sel_registerName("setDrawsProjectiveShadow:"), NO);
    }
}

/*
 drawsProjectiveShadow
 */

@end
