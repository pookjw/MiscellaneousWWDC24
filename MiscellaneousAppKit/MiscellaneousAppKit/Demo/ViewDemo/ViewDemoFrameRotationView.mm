//
//  ViewDemoFrameRotationView.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 4/2/25.
//

#import "ViewDemoFrameRotationView.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface ViewDemoFrameRotationView ()
@property (retain, nonatomic, readonly, getter=_colorView) NSView *colorView;
@property (retain, nonatomic, readonly, getter=_frameRotationSlider) NSSlider *frameRotationSlider;
@property (retain, nonatomic, readonly, getter=_frameCenterRotationSlider) NSSlider *frameCenterRotationSlider;
@end

@implementation ViewDemoFrameRotationView
@synthesize colorView = _colorView;
@synthesize frameRotationSlider = _frameRotationSlider;
@synthesize frameCenterRotationSlider = _frameCenterRotationSlider;

- (instancetype)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setBackgroundColor:"), NSColor.systemPinkColor);
        
        [self addSubview:self.colorView];
        self.colorView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        self.colorView.frame = self.bounds;
        
        [self addSubview:self.frameRotationSlider];
        [self addSubview:self.frameCenterRotationSlider];
    }
    
    return self;
}

- (void)dealloc {
    [_colorView release];
    [_frameRotationSlider release];
    [_frameCenterRotationSlider release];
    [super dealloc];
}

- (NSSize)fittingSize {
    return NSMakeSize(400., 400. + self.frameRotationSlider.fittingSize.height);
}

- (NSSize)intrinsicContentSize {
    return NSMakeSize(400., 400. + self.frameRotationSlider.intrinsicContentSize.height);
}

- (void)layout {
    [super layout];
    
    NSView *colorView = self.colorView;
    NSSlider *frameRotationSlider = self.frameRotationSlider;
    NSSlider *frameCenterRotationSlider = self.frameCenterRotationSlider;
    
    NSRect bounds = self.bounds;
    
    frameRotationSlider.frame = NSMakeRect(0.,
                                           0.,
                                           bounds.size.width,
                                           frameRotationSlider.fittingSize.height);
    
    frameCenterRotationSlider.frame = NSMakeRect(0.,
                                                 frameRotationSlider.fittingSize.height,
                                                 bounds.size.width,
                                                 frameCenterRotationSlider.fittingSize.height);
}

- (NSView *)_colorView {
    if (auto colorView = _colorView) return colorView;
    
    NSView *colorView = [NSView new];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(colorView, sel_registerName("setBackgroundColor:"), NSColor.systemOrangeColor);
    
    _colorView = colorView;
    return colorView;
}

- (NSSlider *)_frameRotationSlider {
    if (auto frameRotationSlider = _frameRotationSlider) return frameRotationSlider;
    
    NSSlider *frameRotationSlider = [NSSlider new];
    frameRotationSlider.target = self;
    frameRotationSlider.action = @selector(_didTriggerFrameRotationSlider:);
    frameRotationSlider.minValue = -180.;
    frameRotationSlider.maxValue = 180.;
    frameRotationSlider.frameRotation = self.colorView.frameRotation;
    
    _frameRotationSlider = frameRotationSlider;
    return frameRotationSlider;
}

- (NSSlider *)_frameCenterRotationSlider {
    if (auto frameCenterRotationSlider = _frameCenterRotationSlider) return frameCenterRotationSlider;
    
    NSSlider *frameCenterRotationSlider = [NSSlider new];
    frameCenterRotationSlider.target = self;
    frameCenterRotationSlider.action = @selector(_didTriggerFrameCenterRotationSlider:);
    frameCenterRotationSlider.minValue = -180.;
    frameCenterRotationSlider.maxValue = 180.;
    frameCenterRotationSlider.frameRotation = self.colorView.frameRotation;
    
    _frameCenterRotationSlider = frameCenterRotationSlider;
    return frameCenterRotationSlider;
}

- (void)_didTriggerFrameRotationSlider:(NSSlider *)sender {
#if CGFLOAT_IS_DOUBLE
    self.colorView.frameRotation = sender.doubleValue;
#else
    self.colorView.frameRotation = sender.floatValue;
#endif
}

- (void)_didTriggerFrameCenterRotationSlider:(NSSlider *)sender {
#if CGFLOAT_IS_DOUBLE
    self.colorView.frameCenterRotation = sender.doubleValue;
#else
    self.colorView.frameCenterRotation = sender.floatValue;
#endif
}

+ (void)_setFrameCenterRotation:(CGFloat)rotation view:(NSView *)view {
    NSView *superview = view.superview;
    NSRect bounds = view.bounds;
    NSPoint point = [view convertPoint:NSMakePoint(bounds.origin.x + bounds.size.width * 0.5, bounds.origin.y + bounds.size.height * 0.5) toView:superview];
    
    NSAffineTransform *transform = [NSAffineTransform transform];
    [transform translateXBy:point.x yBy:point.y];
    [transform rotateByDegrees:rotation];
    NSPoint transformedPoint = [transform transformPoint:NSMakePoint(bounds.size.width * -0.5, bounds.size.height * -0.5)];
    
    view.frameRotation = rotation;
    [view setFrameOrigin:transformedPoint];
}

@end
