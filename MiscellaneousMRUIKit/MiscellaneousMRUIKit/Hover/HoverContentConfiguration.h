//
//  HoverContentConfiguration.h
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 2/9/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HoverContentConfiguration : NSObject <UIContentConfiguration>
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithTitle:(NSString *)title hoverStyle:(UIHoverStyle *)hoverStyle;
@end

NS_ASSUME_NONNULL_END
