//
//  GenerateImageSegmentationImageView.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 1/7/25.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface GenerateImageSegmentationImageView : NSView
@property (retain, nonatomic, nullable) NSImage *image;
@property (retain, nonatomic, readonly) NSLayoutGuide *imageLayoutGuide;
@end

NS_ASSUME_NONNULL_END
