//
//  ViewDemoBoundsRotationView.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 4/4/25.
//

// https://x.com/_silgen_name/status/1908178997940465868

#import "ViewDemoBoundsRotationView.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

@interface ViewDemoBoundsRotationView ()
@property (retain, nonatomic, readonly, getter=_containerView) NSView *containerView;
@property (retain, nonatomic, readonly, getter=_rotationView) NSView *rotationView;
@property (retain, nonatomic, readonly, getter=_rotation2View) NSView *rotation2View;
@property (retain, nonatomic, readonly, getter=_boundsView) NSView *boundsView;
@property (retain, nonatomic, readonly, getter=_slider) NSSlider *slider;
@end

@implementation ViewDemoBoundsRotationView
@synthesize containerView = _containerView;
@synthesize rotationView = _rotationView;
@synthesize rotation2View = _rotation2View;
@synthesize boundsView = _boundsView;
@synthesize slider = _slider;

- (instancetype)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setBackgroundColor:"), NSColor.systemOrangeColor);
        
        [self addSubview:self.boundsView];
        
        [self addSubview:self.containerView];
        self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [self.containerView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
            [self.containerView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
            [self.containerView.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:0.5],
            [self.containerView.heightAnchor constraintEqualToAnchor:self.widthAnchor multiplier:0.5]
        ]];
        
        [self.containerView addSubview:self.rotationView];
        self.rotationView.frame = self.containerView.bounds;
        self.rotationView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        
        [self.containerView addSubview:self.rotation2View];
        self.rotation2View.frame = self.containerView.bounds;
        self.rotation2View.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        
        [self addSubview:self.slider];
    }
    
    return self;
}

- (void)dealloc {
    [_boundsView release];
    [_containerView release];
    [_rotationView release];
    [_rotation2View release];
    [_slider release];
    [super dealloc];
}

- (void)layout {
    [super layout];
    self.slider.frame = NSMakeRect(0., 0., self.bounds.size.width, self.slider.fittingSize.height);
}

- (NSView *)_boundsView {
    if (auto boundsView = _boundsView) return boundsView;
    
    NSView *boundsView = [NSView new];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(boundsView, sel_registerName("setBackgroundColor:"), NSColor.systemGreenColor);
    
    _boundsView = boundsView;
    return boundsView;
}

- (NSView *)_containerView {
    if (auto containerView = _containerView) return containerView;
    
    NSView *containerView = [NSView new];
    
    _containerView = containerView;
    return containerView;
}

- (NSView *)_rotationView {
    if (auto rotationView = _rotationView) return rotationView;
    
    NSView *rotationView = [NSView new];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(rotationView, sel_registerName("setBackgroundColor:"), NSColor.systemPinkColor);
    
    _rotationView = rotationView;
    return rotationView;
}

- (NSView *)_rotation2View {
    if (auto rotation2View = _rotation2View) return rotation2View;
    
    NSView *rotation2View = [NSView new];
    
    _rotation2View = rotation2View;
    return rotation2View;
}

- (NSSlider *)_slider {
    if (auto slider = _slider) return slider;
    
    NSSlider *slider = [NSSlider new];
    slider.target = self;
    slider.action = @selector(_sliderDidChange:);
    slider.minValue = -360.;
    slider.maxValue = 360.;
    
    _slider = slider;
    return slider;
}

- (void)_sliderDidChange:(NSSlider *)sender {
    CGFloat rotation;
#if CGFLOAT_IS_DOUBLE
    rotation = sender.doubleValue;
#else
    rotation = sender.floatValue;
#endif
    
    self.rotationView.frameRotation = rotation;
    self.rotation2View.boundsRotation = rotation;
    
    NSRect bounds = self.rotation2View.bounds;
    NSRect converted = [self.rotation2View convertRect:bounds toView:self];
    self.boundsView.frame = converted;
}

@end
