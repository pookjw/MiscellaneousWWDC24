//
//  CustomViewControllerTransition.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/14/24.
//

#import "CustomViewControllerTransition.h"
#import "CustomTransitionController.h"
#import <objc/message.h>
#import <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

@implementation CustomViewControllerTransition

- (instancetype)initWithSourceViewProvider:(__kindof UIView * _Nonnull (^)())sourceViewProvider {
    objc_super superInfo = { self, [self class] };
    self = ((id (*)(objc_super *, SEL))objc_msgSendSuper2)(&superInfo, sel_registerName("_init"));
    
    if (self) {
        _sourceViewProvider = [sourceViewProvider copy];
    }
    
    return self;
}

- (void)dealloc {
    [_sourceViewProvider release];
    [super dealloc];
}

/*
 container는 모든 상황에서 0x0이 나옴
 -[UIViewController _customAnimatorForPresentedController:presentingController:sourceController:]:
 -[UIViewController _customAnimatorForDismissedController:]
 에서 x3에 0x0 넣어주고 있음
 
 _UIZoomTransitionController
 */
- (id)_transitionControllerForViewController:(__kindof UIViewController *)viewController inContainer:(id)container isAppearing:(BOOL)isAppearing {
    return [[[CustomTransitionController alloc] initWithClientTransition:self isAppearing:isAppearing] autorelease];
//    return nil;
}

- (void)_wasAssignedToViewController:(__kindof UIViewController *)viewController {
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    
    // TODO: Interaction Controller
}

- (void)_viewControllerViewWillAppear {
    
}

- (BOOL)_hasOwnInteractiveExitGestureForTraits:(NSArray<UITrait> *)traits {
    return NO;
}

- (BOOL)_isSupportedGivenTraits:(NSArray<UITrait> *)traits {
    return NO;
}

@end
