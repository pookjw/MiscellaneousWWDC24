//
//  GenerateImageSegmentationDrawingView.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 1/7/25.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@class GenerateImageSegmentationDrawingView;
@protocol GenerateImageSegmentationDrawingViewDelegate <NSObject>
- (void)generateImageSegmentationDrawingView:(GenerateImageSegmentationDrawingView *)generateImageSegmentationDrawingView didFinishDrawingWithPoints:(NSArray<NSValue *> *)points;
@end

@interface GenerateImageSegmentationDrawingView : NSView
@property (assign, nonatomic, nullable) id<GenerateImageSegmentationDrawingViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
