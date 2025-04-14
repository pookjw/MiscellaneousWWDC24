//
//  WindowObservingInteraction.h
//  MiscellaneousMapKit
//
//  Created by Jinwoo Kim on 4/14/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WindowObservingInteraction : NSObject <UIInteraction>
@property (nonatomic, nullable, weak, readonly) __kindof UIView *view;
@property (copy, nonatomic, nullable) void (^willMoveToWindow)(WindowObservingInteraction *interaction, UIWindow * _Nullable oldWindow, UIWindow * _Nullable newWindow);
@property (copy, nonatomic, nullable) void (^didMoveToWindow)(WindowObservingInteraction *interaction, UIWindow * _Nullable oldWindow, UIWindow * _Nullable newWindow);
@end

NS_ASSUME_NONNULL_END
