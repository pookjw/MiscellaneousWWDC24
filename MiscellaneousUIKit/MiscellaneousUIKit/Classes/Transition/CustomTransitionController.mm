//
//  CustomTransitionController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/17/24.
//

#import "CustomTransitionController.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import "CustomDismissPercentageInteraction.h"

OBJC_EXPORT id objc_msgSendSuper2(void);

@interface CustomTransitionController ()
@property (assign, readonly, nonatomic) BOOL isAppearing;
@property (retain, readonly, nonatomic) id<UIViewControllerInteractiveTransitioning> interactiveTransitioning;
@end

@implementation CustomTransitionController

+ (void)load {
    class_addProtocol(self, NSProtocolFromString(@"UIViewControllerPreemptableAnimatedTransitioning"));
    class_addProtocol(self, NSProtocolFromString(@"UIViewControllerAnimatedTransitioning_Internal"));
    class_addProtocol(self, NSProtocolFromString(@"UIViewControllerAnimatedTransitioning_Keyboard"));
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    BOOL result = [super respondsToSelector:aSelector];
    
    if (!result) {
        NSLog(@"%s", sel_getName(aSelector));
    }
    
    return result;
}

- (instancetype)initWithClientTransition:(CustomViewControllerTransition *)clientTransition isAppearing:(BOOL)isAppearing interactiveTransitioning:(id<UIViewControllerInteractiveTransitioning>)interactiveTransitioning {
    if (self = [super init]) {
        _clientTransition = [clientTransition retain];
        _isAppearing = isAppearing;
        _interactiveTransitioning = [interactiveTransitioning retain];
    }
    
    return self;
}

- (void)dealloc {
    [_clientTransition release];
    [_interactiveTransitioning release];
    [super dealloc];
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    if (_isAppearing) {
        [self startPresentationTransition:transitionContext];
    } else {
        [self startDismissalTransition:transitionContext];
    }
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 1.0;
}

- (id)_interactionController {
    if (_isAppearing) {
        return nil;
    } else {
        if (self.clientTransition.isInteracting) {
            return _interactiveTransitioning;
        } else {
            return nil;
        }
    }
}

- (void)startPresentationTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = transitionContext.containerView;
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *sourceView = self.clientTransition.sourceViewProvider();
    CGFloat displayCornerRadius = ((CGFloat (*)(id, SEL))objc_msgSend)(containerView.traitCollection, sel_registerName("displayCornerRadius"));
    CGRect sourceRect = [sourceView convertRect:sourceView.bounds toCoordinateSpace:containerView];
    CGRect finalFrame = [transitionContext finalFrameForViewController:[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey]];
    
    /* _UIPortalView */
    __kindof UIView *portalView = ((id (*)(id, SEL, id))objc_msgSend)([objc_lookUpClass("_UIPortalView") alloc], sel_registerName("initWithSourceView:"), sourceView);
    
    [containerView addSubview:toView];
    [containerView addSubview:portalView];
    
    //
    
    toView.alpha = 0.;
    toView.transform = CGAffineTransformMakeScale(sourceRect.size.width / finalFrame.size.width, sourceRect.size.height / finalFrame.size.height);
    toView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        [toView.topAnchor constraintEqualToAnchor:containerView.topAnchor],
        [toView.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor],
        [toView.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor],
        [toView.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor]
    ]];
    
    //
    
    portalView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        [portalView.topAnchor constraintEqualToAnchor:containerView.topAnchor],
        [portalView.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor],
        [portalView.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor],
        [portalView.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor]
    ]];
    
    ((void (*)(id, SEL, BOOL))objc_msgSend)(portalView, sel_registerName("setHidesSourceView:"), YES);
    ((void (*)(id, SEL, BOOL))objc_msgSend)(portalView, sel_registerName("setMatchesTransform:"), YES);
    ((void (*)(id, SEL, BOOL))objc_msgSend)(portalView, sel_registerName("setMatchesPosition:"), YES);
    ((void (*)(id, SEL, BOOL))objc_msgSend)(portalView, sel_registerName("setMatchesAlpha:"), NO);
    ((void (*)(id, SEL, id))objc_msgSend)(portalView.layer, sel_registerName("setOverrides:"), @{
        @"cornerRadius": @(0.),
        @"cornerCurve": kCACornerCurveContinuous
    });
    
    [containerView layoutIfNeeded];
    
    //
    
    [UIView animateWithDuration:1.0 animations:^{
        toView.alpha = 1.;
        toView.layer.cornerRadius = displayCornerRadius;
        toView.layer.cornerCurve = kCACornerCurveContinuous;
        toView.transform = CGAffineTransformIdentity;
        
        portalView.alpha = 0.;
        
        portalView.transform = CGAffineTransformMakeScale(finalFrame.size.width / sourceRect.size.width, finalFrame.size.height / sourceRect.size.height);
        portalView.frame = containerView.bounds;
        
        [containerView layoutIfNeeded];
    }
                     completion:^(BOOL finished) {
        [portalView removeFromSuperview];
        [transitionContext completeTransition:finished];
    }];
    
    [portalView release];
}

- (void)startDismissalTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = transitionContext.containerView;
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *sourceView = self.clientTransition.sourceViewProvider();
    CGFloat displayCornerRadius = ((CGFloat (*)(id, SEL))objc_msgSend)(containerView.traitCollection, sel_registerName("displayCornerRadius"));
    
    /* _UIPortalView */
    __kindof UIView *portalView = ((id (*)(id, SEL, id))objc_msgSend)([objc_lookUpClass("_UIPortalView") alloc], sel_registerName("initWithSourceView:"), sourceView);
    
    [containerView addSubview:portalView];
    
    sourceView.alpha = 0.;
    fromView.layer.cornerRadius = displayCornerRadius;
    fromView.layer.cornerCurve = kCACornerCurveContinuous;
    
    CGRect sourceRect = [sourceView convertRect:sourceView.bounds toCoordinateSpace:containerView];
    
    portalView.alpha = 0.;
    portalView.frame = fromView.frame;
    portalView.transform = CGAffineTransformMakeScale(fromView.frame.size.width / sourceRect.size.width, fromView.frame.size.height / sourceRect.size.height);
    
    ((void (*)(id, SEL, BOOL))objc_msgSend)(portalView, sel_registerName("setHidesSourceView:"), YES);
    ((void (*)(id, SEL, BOOL))objc_msgSend)(portalView, sel_registerName("setMatchesTransform:"), YES);
    ((void (*)(id, SEL, BOOL))objc_msgSend)(portalView, sel_registerName("setMatchesPosition:"), YES);
    ((void (*)(id, SEL, BOOL))objc_msgSend)(portalView, sel_registerName("setMatchesAlpha:"), NO);
    ((void (*)(id, SEL, id))objc_msgSend)(portalView.layer, sel_registerName("setOverrides:"), @{
        @"cornerRadius": @(0.),
        @"cornerCurve": kCACornerCurveContinuous
    });
    
    [containerView layoutIfNeeded];
    
    UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:3.0 curve:UIViewAnimationCurveEaseInOut animations:^{
        fromView.alpha = 0.;
        fromView.layer.cornerRadius = 0.;
        fromView.transform = CGAffineTransformMakeScale(sourceRect.size.width / fromView.frame.size.width, sourceRect.size.height / fromView.frame.size.height);
        
        portalView.alpha = 1.;
        portalView.transform = CGAffineTransformIdentity;
        portalView.frame = sourceRect;
        
        [containerView layoutIfNeeded];
    }];
    
    [animator addCompletion:^(UIViewAnimatingPosition finalPosition) {
        sourceView.alpha = 1.;
        [portalView removeFromSuperview];
        [fromView removeFromSuperview];
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
    
//    [animator startAnimation];
    NSUUID *_currentTrackedAnimationsUUID = ((id (*)(Class, SEL))objc_msgSend)(UIViewPropertyAnimator.class, sel_registerName("_currentTrackedAnimationsUUID"));
    ((void (*)(Class, SEL, id, id, id))objc_msgSend)(UIViewPropertyAnimator.class, sel_registerName("_saveTrackingAnimator:forUUID:andDescription:"), animator, _currentTrackedAnimationsUUID, nil);
    
    [animator release];
    
//    [UIView animateWithDuration:1.0 animations:^{
//        fromView.alpha = 0.;
//        fromView.layer.cornerRadius = 0.;
//        fromView.transform = CGAffineTransformMakeScale(sourceRect.size.width / fromView.frame.size.width, sourceRect.size.height / fromView.frame.size.height);
//        
//        portalView.alpha = 1.;
//        portalView.transform = CGAffineTransformIdentity;
//        portalView.frame = sourceRect;
//        
//        [containerView layoutIfNeeded];
//    }
//                     completion:^(BOOL finished) {
//        sourceView.alpha = 1.;
//        [portalView removeFromSuperview];
//        [fromView removeFromSuperview];
//        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
//    }];
    
    [portalView release];
}

@end
