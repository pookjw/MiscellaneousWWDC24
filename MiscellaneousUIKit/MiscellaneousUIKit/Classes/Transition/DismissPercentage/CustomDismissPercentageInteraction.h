//
//  CustomDismissPercentageInteraction.h
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/18/24.
//

#import <UIKit/UIKit.h>
#import "CustomDimissInteractable.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomDismissPercentageInteraction : NSObject <CustomDimissInteractable>
@property (retain, readonly, nonatomic) UIPercentDrivenInteractiveTransition *interactiveTransitioning;
@property (readonly, nonatomic) BOOL isInteracting;
@end

NS_ASSUME_NONNULL_END
