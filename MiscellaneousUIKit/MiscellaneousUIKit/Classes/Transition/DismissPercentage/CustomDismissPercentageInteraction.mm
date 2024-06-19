//
//  CustomDismissPercentageInteraction.m
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/18/24.
//

#import "CustomDismissPercentageInteraction.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface CustomDismissPercentageInteraction ()
@property (class, readonly, nonatomic) void *panGestureContextKey;
@property (weak, nonatomic, nullable) __kindof UIView *view;
@end

@implementation CustomDismissPercentageInteraction
@synthesize interactiveTransitioning = _interactiveTransitioning;

+ (void *)panGestureContextKey {
    static void *panGestureContextKey = &panGestureContextKey;
    return panGestureContextKey;
}

- (void)dealloc {
    [_interactiveTransitioning release];
    [super dealloc];
}

- (void)willMoveToView:(UIView *)view {
    for (__kindof UIGestureRecognizer *gestureRecognizer in view.gestureRecognizers) {
        if (objc_getAssociatedObject(gestureRecognizer, CustomDismissPercentageInteraction.panGestureContextKey) != NULL) {
            [view removeGestureRecognizer:gestureRecognizer];
            break;
        }
    }
}

- (void)didMoveToView:(UIView *)view {
    self.view = view;
    [view addGestureRecognizer:[self makePanGestureRecognizer]];
}

- (UIPercentDrivenInteractiveTransition *)interactiveTransitioning {
    if (auto interactiveTransitioning = _interactiveTransitioning) return interactiveTransitioning;
    
    UIPercentDrivenInteractiveTransition *interactiveTransitioning = [UIPercentDrivenInteractiveTransition new];
    
    _interactiveTransitioning = [interactiveTransitioning retain];
    return [interactiveTransitioning autorelease];
}

- (UIPanGestureRecognizer *)makePanGestureRecognizer {
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecogninzerDidTrigger:)];
    
    objc_setAssociatedObject(panGestureRecognizer, CustomDismissPercentageInteraction.panGestureContextKey, [NSNull null], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return [panGestureRecognizer autorelease];
}

- (BOOL)isInteracting {
    for (__kindof UIGestureRecognizer *gestureRecognizer in self.view.gestureRecognizers) {
        if (objc_getAssociatedObject(gestureRecognizer, CustomDismissPercentageInteraction.panGestureContextKey) != NULL) {
            return gestureRecognizer.state != UIGestureRecognizerStatePossible;
        }
    }
    
    return NO;
}

- (void)panGestureRecogninzerDidTrigger:(UIPanGestureRecognizer *)sender {
    UIGestureRecognizerState state = sender.state;
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            __kindof UIViewController *viewController = ((id (*)(id, SEL))objc_msgSend)(sender.view, sel_registerName("_viewControllerForAncestor"));
            
            [viewController dismissViewControllerAnimated:YES completion:nil];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGPoint translation = [sender translationInView:sender.view];
            
            NSLog(@"%lf", translation.y / 500.0);
            [self.interactiveTransitioning updateInteractiveTransition:MIN(1.0, translation.y / 500.0)];
            break;
        }
        case UIGestureRecognizerStateEnded:
//            self.percentDrivenInteractiveTransition.completionSpeed = 0.999;
            [self.interactiveTransitioning finishInteractiveTransition];
            break;
        default:
            break;
    }
}

@end
