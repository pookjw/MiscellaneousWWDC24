//
//  GenerateImageSegmentationView.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 1/6/25.
//

#import "GenerateImageSegmentationView.h"
#import <AVFoundation/AVFoundation.h>

@interface GenerateImageSegmentationView ()
@end

@implementation GenerateImageSegmentationView

- (void)dealloc {
    [_image release];
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    NSGraphicsContext *context = NSGraphicsContext.currentContext;
    [context saveGraphicsState];
    
    if (NSImage *image = self.image) {
        [image drawInRect:AVMakeRectWithAspectRatioInsideRect(image.size, self.safeAreaRect)];
    }
    
    [context restoreGraphicsState];
}

- (void)mouseDown:(NSEvent *)event {
    NSPoint locationInWindow = [event locationInWindow];
    NSPoint convertedLocation = [self convertPoint:locationInWindow fromView:nil];
    NSLog(@"%s %@", sel_getName(_cmd), NSStringFromPoint(convertedLocation));
}

- (void)mouseUp:(NSEvent *)event {
    NSPoint locationInWindow = [event locationInWindow];
    NSPoint convertedLocation = [self convertPoint:locationInWindow fromView:nil];
    NSLog(@"%s %@", sel_getName(_cmd), NSStringFromPoint(convertedLocation));
}

- (void)mouseDragged:(NSEvent *)event {
    NSPoint locationInWindow = [event locationInWindow];
    NSPoint convertedLocation = [self convertPoint:locationInWindow fromView:nil];
    NSLog(@"%s %@", sel_getName(_cmd), NSStringFromPoint(convertedLocation));
}

- (BOOL)mouseDownCanMoveWindow {
    return NO;
}

- (void)setImage:(NSImage *)image {
    [_image release];
    _image = [image retain];
    
    self.needsDisplay = YES;
}

@end
