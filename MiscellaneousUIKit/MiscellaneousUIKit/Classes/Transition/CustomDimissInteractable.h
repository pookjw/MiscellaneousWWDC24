//
//  CustomDimissInteractable.h
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/19/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CustomDimissInteractable <UIInteraction>
@property (retain, readonly, nonatomic) id<UIViewControllerInteractiveTransitioning> interactiveTransitioning;
@property (readonly, nonatomic) BOOL isInteracting;
@end

NS_ASSUME_NONNULL_END
