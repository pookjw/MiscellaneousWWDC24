//
//  CustomTransitionController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/17/24.
//

#import "CustomTransitionController.h"
#import <objc/message.h>
#import <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

@interface CustomTransitionController ()
@property (assign, readonly, nonatomic) BOOL isAppearing;
@end

@implementation CustomTransitionController

+ (void)load {
    class_addProtocol(self, NSProtocolFromString(@"UIViewControllerPreemptableAnimatedTransitioning"));
    class_addProtocol(self, NSProtocolFromString(@"UIViewControllerAnimatedTransitioning_Internal"));
    class_addProtocol(self, NSProtocolFromString(@"_UIDismissInteractionDelegate"));
    class_addProtocol(self, NSProtocolFromString(@"UIViewControllerAnimatedTransitioning_Keyboard"));
}

- (instancetype)initWithClientTransition:(CustomViewControllerTransition *)clientTransition isAppearing:(BOOL)isAppearing {
    if (self = [super init]) {
        _clientTransition = [clientTransition retain];
        _isAppearing = isAppearing;
    }
    
    return self;
}

- (void)dealloc {
    [_clientTransition release];
    [super dealloc];
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = transitionContext.containerView;
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *sourceView = self.clientTransition.sourceViewProvider();
    CGFloat displayCornerRadius = ((CGFloat (*)(id, SEL))objc_msgSend)(containerView.traitCollection, sel_registerName("displayCornerRadius"));
    
    /* _UIPortalView */
    __kindof UIView *portalView = ((id (*)(id, SEL, id))objc_msgSend)([objc_lookUpClass("_UIPortalView") alloc], sel_registerName("initWithSourceView:"), sourceView);
    
    [containerView addSubview:toView];
    [containerView addSubview:portalView];
    
    toView.alpha = 0.;
    
    CGRect sourceRect = [sourceView convertRect:sourceView.bounds toCoordinateSpace:containerView];
    CGRect finalFrame = [transitionContext finalFrameForViewController:[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey]];
    
    toView.frame = sourceRect;
    portalView.frame = sourceRect;
    ((void (*)(id, SEL, BOOL))objc_msgSend)(portalView, sel_registerName("setHidesSourceView:"), YES);
    ((void (*)(id, SEL, BOOL))objc_msgSend)(portalView, sel_registerName("setMatchesTransform:"), YES);
    ((void (*)(id, SEL, BOOL))objc_msgSend)(portalView, sel_registerName("setMatchesPosition:"), YES);
    ((void (*)(id, SEL, BOOL))objc_msgSend)(portalView, sel_registerName("setMatchesAlpha:"), NO);
    ((void (*)(id, SEL, id))objc_msgSend)(portalView.layer, sel_registerName("setOverrides:"), @{
        @"cornerRadius": @(0.),
        @"cornerCurve": kCACornerCurveContinuous
    });
    
    [containerView layoutIfNeeded];
    
    [UIView animateWithDuration:4.0 animations:^{
        toView.alpha = 1.;
        toView.layer.cornerRadius = displayCornerRadius;
        toView.layer.cornerCurve = kCACornerCurveContinuous;
        toView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [NSLayoutConstraint activateConstraints:@[
            [toView.topAnchor constraintEqualToAnchor:containerView.topAnchor],
            [toView.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor],
            [toView.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor],
            [toView.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor]
        ]];
        
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

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 4.0;
}

// TODO: UIPercentDrivenInteractiveTransition로도 한 번 해보기
- (void)startInteractiveTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    
}

@end
