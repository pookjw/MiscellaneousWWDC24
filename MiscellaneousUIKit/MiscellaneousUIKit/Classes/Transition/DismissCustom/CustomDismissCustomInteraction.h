//
//  CustomDismissCustomInteraction.h
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/19/24.
//

#import <UIKit/UIKit.h>
#import "CustomDismissInteractiveTransitioning.h"
#import "CustomDimissInteractable.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomDismissCustomInteraction : NSObject <CustomDimissInteractable>
@property (retain, readonly, nonatomic) CustomDismissInteractiveTransitioning *interactiveTransitioning;
@property (readonly, nonatomic) BOOL isInteracting;
@end

NS_ASSUME_NONNULL_END
