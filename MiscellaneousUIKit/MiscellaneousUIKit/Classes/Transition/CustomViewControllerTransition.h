//
//  CustomViewControllerTransition.h
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/14/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomViewControllerTransition : UIViewControllerTransition
@property (copy, readonly, nonatomic) __kindof UIView * (^sourceViewProvider)(void);
@property (readonly, nonatomic) BOOL isInteracting;
- (instancetype)initWithSourceViewProvider:(__kindof UIView * (^)())sourceViewProvider;
@end

NS_ASSUME_NONNULL_END
