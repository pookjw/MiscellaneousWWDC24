//
//  GenerateImageSegmentationImageView.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 1/7/25.
//

#import "GenerateImageSegmentationImageView.h"
#import <AVFoundation/AVFoundation.h>

@interface GenerateImageSegmentationImageView ()
@property (retain, nonatomic, readonly) NSMutableArray<NSLayoutConstraint *> *_imageLayoutGuideConstraints;
@end

@implementation GenerateImageSegmentationImageView

- (instancetype)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _commonInit];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self _commonInit];
    }
    
    return self;
}

- (void)dealloc {
    [_image release];
    [_imageLayoutGuide release];
    [__imageLayoutGuideConstraints release];
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    NSGraphicsContext *context = NSGraphicsContext.currentContext;
    [context saveGraphicsState];
    
    NSMutableArray<NSLayoutConstraint *> *imageLayoutGuideConstraints = self._imageLayoutGuideConstraints;
    [NSLayoutConstraint deactivateConstraints:imageLayoutGuideConstraints];
    [imageLayoutGuideConstraints removeAllObjects];
    
    if (NSImage *image = self.image) {
        NSLayoutGuide *imageLayoutGuide = self.imageLayoutGuide;
        NSLayoutGuide *safeAreaLayoutGuide = self.safeAreaLayoutGuide;
        CGRect aspectFitRect = AVMakeRectWithAspectRatioInsideRect(image.size, safeAreaLayoutGuide.frame);
        
        [imageLayoutGuideConstraints addObjectsFromArray:@[
            [imageLayoutGuide.centerXAnchor constraintEqualToAnchor:safeAreaLayoutGuide.centerXAnchor],
            [imageLayoutGuide.centerYAnchor constraintEqualToAnchor:safeAreaLayoutGuide.centerYAnchor],
            [imageLayoutGuide.widthAnchor constraintEqualToConstant:CGRectGetWidth(aspectFitRect)],
            [imageLayoutGuide.heightAnchor constraintEqualToConstant:CGRectGetHeight(aspectFitRect)]
        ]];
        
        [NSLayoutConstraint activateConstraints:imageLayoutGuideConstraints];
        
        [image drawInRect:AVMakeRectWithAspectRatioInsideRect(image.size, aspectFitRect)];
    }
    
    [context restoreGraphicsState];
}

- (void)setImage:(NSImage *)image {
    [_image release];
    _image = [image retain];
    
    self.needsDisplay = YES;
}

- (void)_commonInit {
    NSLayoutGuide *imageLayoutGuide = [NSLayoutGuide new];
    [self addLayoutGuide:imageLayoutGuide];
    _imageLayoutGuide = imageLayoutGuide;
    __imageLayoutGuideConstraints = [NSMutableArray new];
}

@end
