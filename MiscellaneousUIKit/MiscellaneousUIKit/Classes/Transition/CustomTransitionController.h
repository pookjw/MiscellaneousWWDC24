//
//  CustomTransitionController.h
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/17/24.
//

#import <UIKit/UIKit.h>
#import "CustomViewControllerTransition.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomTransitionController : NSObject <UIViewControllerAnimatedTransitioning, UIViewControllerInteractiveTransitioning>
@property (retain, nonatomic, readonly) CustomViewControllerTransition *clientTransition;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithClientTransition:(CustomViewControllerTransition *)clientTransition isAppearing:(BOOL)isAppearing interactiveTransitioning:(id<UIViewControllerInteractiveTransitioning>)interactiveTransitioning;
@end

NS_ASSUME_NONNULL_END
