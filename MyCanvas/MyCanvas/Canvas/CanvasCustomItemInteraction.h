//
//  CanvasCustomItemInteraction.h
//  MyCanvas
//
//  Created by Jinwoo Kim on 3/7/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CanvasCustomItemInteraction;
@protocol CanvasCustomItemInteractionDelegate <NSObject>
- (void)canvasCustomItemInteraction:(CanvasCustomItemInteraction *)canvasCustomItemInteraction didTriggerTapGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer;
- (void)canvasCustomItemInteraction:(CanvasCustomItemInteraction *)canvasCustomItemInteraction didTriggerHoverGestureRecognizer:(UIHoverGestureRecognizer *)hoverGestureRecognizer;
@end

__attribute__((objc_direct_members))
@interface CanvasCustomItemInteraction : NSObject <UIInteraction>
@property (assign, nonatomic, getter=isEnabled) BOOL enabled;
@property (assign, nonatomic, nullable) id<CanvasCustomItemInteractionDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
