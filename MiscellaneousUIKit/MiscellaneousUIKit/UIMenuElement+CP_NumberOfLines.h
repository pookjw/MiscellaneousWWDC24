//
//  UIMenuElement+CP_NumberOfLines.h
//  CamPresentation
//
//  Created by Jinwoo Kim on 9/18/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIMenuElement (CP_NumberOfLines)
@property (assign, nonatomic, setter=cp_setOverrideNumberOfTitleLines:) NSInteger cp_overrideNumberOfTitleLines;
@property (assign, nonatomic, setter=cp_setOverrideNumberOfSubtitleLines:) NSInteger cp_overrideNumberOfSubtitleLines;
@end

NS_ASSUME_NONNULL_END
