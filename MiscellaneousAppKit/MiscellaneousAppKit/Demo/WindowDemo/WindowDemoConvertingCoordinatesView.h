//
//  WindowDemoConvertingCoordinatesView.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/24/25.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WindowDemoConvertingCoordinatesType) {
    WindowDemoConvertingCoordinatesTypeBackingAlignedRect,
    WindowDemoConvertingCoordinatesTypeConvertRectFromBacking,
    WindowDemoConvertingCoordinatesTypeConvertRectFromScreen,
    WindowDemoConvertingCoordinatesTypeConvertRectToBacking,
    WindowDemoConvertingCoordinatesTypeConvertRectToScreen
};

@interface WindowDemoConvertingCoordinatesView : NSView
@property (assign, nonatomic) WindowDemoConvertingCoordinatesType type;
@end

NS_ASSUME_NONNULL_END
