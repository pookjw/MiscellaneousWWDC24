//
//  UIScrollView+VolumeControl.h
//  VoluemKeyPad
//
//  Created by Jinwoo Kim on 7/6/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (VolumeControl)
@property (nonatomic, getter=vc_isVerticalScrollWithVolumeButtonsEnabled, setter=vc_setVerticalScrollWithVolumeButtonsEnabled:) BOOL vc_verticalScrollWithVolumeButtonsEnabled;
@end

NS_ASSUME_NONNULL_END
