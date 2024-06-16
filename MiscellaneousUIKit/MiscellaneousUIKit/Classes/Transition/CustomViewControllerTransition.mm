//
//  CustomViewControllerTransition.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/14/24.
//

#import "CustomViewControllerTransition.h"
#import <objc/message.h>
#import <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

@interface CustomViewControllerTransition ()
@property (copy, readonly, nonatomic) __kindof UIView * (^sourceViewProvider)(void);
@end

@interface _CustomTransitionController : NSObject <UIViewControllerAnimatedTransitioning, UIViewControllerInteractiveTransitioning>
@property (retain, nonatomic) CustomViewControllerTransition *clientTransition;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@end

@implementation _CustomTransitionController

+ (void)load {
    class_addProtocol(self, NSProtocolFromString(@"UIViewControllerPreemptableAnimatedTransitioning"));
    class_addProtocol(self, NSProtocolFromString(@"UIViewControllerAnimatedTransitioning_Internal"));
    class_addProtocol(self, NSProtocolFromString(@"_UIDismissInteractionDelegate"));
    class_addProtocol(self, NSProtocolFromString(@"UIViewControllerAnimatedTransitioning_Keyboard"));
}

- (instancetype)initWithClientTransition:(CustomViewControllerTransition *)clientTransition {
    if (self = [super init]) {
        _clientTransition = [clientTransition retain];
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
        
//        portalView.alpha = 0.;
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

- (void)startInteractiveTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext { 
    
}

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
    return [[[_CustomTransitionController alloc] initWithClientTransition:self] autorelease];
//    return nil;
}

- (void)_wasAssignedToViewController:(__kindof UIViewController *)viewController {
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
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
