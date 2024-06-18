//
//  CustomDismissPercentageInteraction.h
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/18/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomDismissPercentageInteraction : NSObject <UIInteraction>
@property (retain, readonly, nonatomic) UIPercentDrivenInteractiveTransition *percentDrivenInteractiveTransition;
@property (readonly, nonatomic) BOOL isInteracting;
@end

NS_ASSUME_NONNULL_END
