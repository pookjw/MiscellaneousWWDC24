//
//  CustomViewControllerTransition.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/14/24.
//

#import "CustomViewControllerTransition.h"
#import "CustomTransitionController.h"
#import "CustomDismissPercentageInteraction.h"
#import "CustomDismissCustomInteraction.h"
#import "CustomDimissInteractable.h"
#import <objc/message.h>
#import <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

@interface CustomViewControllerTransition ()
@property (retain, nonatomic) id<CustomDimissInteractable> _Nullable dismissInteraction;
@end

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
    [_dismissInteraction release];
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
    id<CustomDimissInteractable> interaction = nil;
    for (id<UIInteraction> _interaction in viewController.view.interactions) {
        if ([_interaction conformsToProtocol:@protocol(CustomDimissInteractable)]) {
            interaction = (id<CustomDimissInteractable>)_interaction;
        }
    }
    
    return [[[CustomTransitionController alloc] initWithClientTransition:self isAppearing:isAppearing interactiveTransitioning:interaction.interactiveTransitioning] autorelease];
}

- (void)_wasAssignedToViewController:(__kindof UIViewController *)viewController {
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    
    CustomDismissPercentageInteraction *interaction = [CustomDismissPercentageInteraction new];
//    CustomDismissCustomInteraction *interaction = [CustomDismissCustomInteraction new];
    [viewController.view addInteraction:interaction];
    self.dismissInteraction = interaction;
    [interaction release];
}

- (void)_viewControllerViewWillAppear {
    objc_super superInfo = { self, [self class] };
    ((void (*)(objc_super *, SEL))objc_msgSendSuper2)(&superInfo, _cmd);
}

- (BOOL)_hasOwnInteractiveExitGestureForTraits:(NSArray<UITrait> *)traits {
    return YES;
}

- (BOOL)_isSupportedGivenTraits:(NSArray<UITrait> *)traits {
    return YES;
}

- (BOOL)isInteracting {
    return self.dismissInteraction.isInteracting;
}

@end
