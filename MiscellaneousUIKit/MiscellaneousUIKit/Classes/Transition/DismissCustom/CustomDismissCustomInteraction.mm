//
//  CustomDismissCustomInteraction.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/19/24.
//

#import "CustomDismissCustomInteraction.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface CustomDismissCustomInteraction ()
@property (class, readonly, nonatomic) void *panGestureContextKey;
@property (weak, nonatomic, nullable) __kindof UIView *view;
@end

@implementation CustomDismissCustomInteraction
@synthesize interactiveTransitioning = _interactiveTransitioning;

+ (void *)panGestureContextKey {
    static void *panGestureContextKey = &panGestureContextKey;
    return panGestureContextKey;
}

- (void)dealloc {
    [_interactiveTransitioning release];
    [super dealloc];
}

- (void)willMoveToView:(nullable UIView *)view { 
    for (__kindof UIGestureRecognizer *gestureRecognizer in view.gestureRecognizers) {
        if (objc_getAssociatedObject(gestureRecognizer, CustomDismissCustomInteraction.panGestureContextKey) != NULL) {
            [view removeGestureRecognizer:gestureRecognizer];
            break;
        }
    }
}

- (void)didMoveToView:(nullable UIView *)view { 
    self.view = view;
    [view addGestureRecognizer:[self makePanGestureRecognizer]];
}

- (BOOL)isInteracting {
    for (__kindof UIGestureRecognizer *gestureRecognizer in self.view.gestureRecognizers) {
        if (objc_getAssociatedObject(gestureRecognizer, CustomDismissCustomInteraction.panGestureContextKey) != NULL) {
            return gestureRecognizer.state != UIGestureRecognizerStatePossible;
        }
    }
    
    return NO;
}

- (CustomDismissInteractiveTransitioning *)interactiveTransitioning {
    if (auto interactiveTransitioning = _interactiveTransitioning) return interactiveTransitioning;
    
    CustomDismissInteractiveTransitioning *interactiveTransitioning = [CustomDismissInteractiveTransitioning new];
    
    _interactiveTransitioning = [interactiveTransitioning retain];
    return [interactiveTransitioning autorelease];
}

- (UIPanGestureRecognizer *)makePanGestureRecognizer {
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecogninzerDidTrigger:)];
    
    objc_setAssociatedObject(panGestureRecognizer, CustomDismissCustomInteraction.panGestureContextKey, [NSNull null], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return [panGestureRecognizer autorelease];
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
            [self.interactiveTransitioning updateWithTranslation:translation];
            break;
        }
        case UIGestureRecognizerStateEnded:
            [self.interactiveTransitioning finish];
            break;
        case UIGestureRecognizerStateCancelled:
            abort();
        case UIGestureRecognizerStateFailed:
            abort();
        default:
            break;
    }
}

@end
