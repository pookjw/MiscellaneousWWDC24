//
//  CustomDismissInteractiveTransitioning.h
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/19/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomDismissInteractiveTransitioning : NSObject <UIViewControllerInteractiveTransitioning>
- (void)updateWithTranslation:(CGPoint)translation;
- (void)finish;
@end

NS_ASSUME_NONNULL_END
