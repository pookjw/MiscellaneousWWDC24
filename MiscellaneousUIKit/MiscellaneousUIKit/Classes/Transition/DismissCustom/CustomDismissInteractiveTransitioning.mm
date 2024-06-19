//
//  CustomDismissInteractiveTransitioning.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/19/24.
//

#import "CustomDismissInteractiveTransitioning.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface CustomDismissInteractiveTransitioning ()
@property (retain, nullable, nonatomic) id<UIViewControllerContextTransitioning> transitionContext;
@end

@implementation CustomDismissInteractiveTransitioning

- (void)dealloc {
    [_transitionContext release];
    [super dealloc];
}

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;
}

- (BOOL)wantsInteractiveStart {
    return NO;
}

- (void)updateWithTranslation:(CGPoint)translation {
    NSArray<id<UIViewControllerContextTransitioning>> *transitionContexts = ((id (*)(Class, SEL, id))objc_msgSend)(objc_lookUpClass("_UIViewControllerTransitionContext"), sel_registerName("_associatedTransitionContextsForInteractionController:"), self);
    id<UIViewControllerContextTransitioning> transitionContext = transitionContexts.firstObject;
    
    CGFloat percentage = translation.y / 500.;
    
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    fromView.alpha = MAX(0., 1. - percentage);
    
    [transitionContext updateInteractiveTransition:percentage];
}

- (void)finish {
    NSArray<id<UIViewControllerContextTransitioning>> *transitionContexts = ((id (*)(Class, SEL, id))objc_msgSend)(objc_lookUpClass("_UIViewControllerTransitionContext"), sel_registerName("_associatedTransitionContextsForInteractionController:"), self);
    id<UIViewControllerContextTransitioning> transitionContext = transitionContexts.firstObject;
    
    [transitionContext finishInteractiveTransition];
    [transitionContext completeTransition:YES];
}

@end
