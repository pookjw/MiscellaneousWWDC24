//
//  ViewDemoBoundsRotationView.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 4/4/25.
//

#import "ViewDemoBoundsRotationView.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

@interface ViewDemoBoundsRotationView ()
@property (retain, nonatomic, readonly, getter=_secondaryView) NSView *secondaryView;
@property (retain, nonatomic, readonly, getter=_stackView) NSStackView *stackView;
@property (retain, nonatomic, readonly, getter=_imageView) NSImageView *imageView;
@property (retain, nonatomic, readonly, getter=_slider) NSSlider *slider;
@end

@implementation ViewDemoBoundsRotationView
@synthesize secondaryView = _secondaryView;
@synthesize stackView = _stackView;
@synthesize imageView = _imageView;
@synthesize slider = _slider;

- (instancetype)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setBackgroundColor:"), NSColor.systemOrangeColor);
        
        [self addSubview:self.secondaryView];
        self.secondaryView.frame = self.bounds;
        self.secondaryView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        
//        [self.secondaryView addSubview:self.imageView];
//        self.imageView.frame = self.secondaryView.bounds;
//        self.imageView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        
        [self.secondaryView addSubview:self.stackView];
        self.stackView.frame = self.secondaryView.bounds;
        self.stackView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        
        [self addSubview:self.slider];
    }
    
    return self;
}

- (void)dealloc {
    [_secondaryView release];
    [_stackView release];
    [_imageView release];
    [_slider release];
    [super dealloc];
}

- (void)layout {
    [super layout];
    self.slider.frame = NSMakeRect(0., 0., self.bounds.size.width, self.slider.fittingSize.height);
}

- (NSView *)_secondaryView {
    if (auto secondaryView = _secondaryView) return secondaryView;
    
    NSView *secondaryView = [NSView new];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(secondaryView, sel_registerName("setBackgroundColor:"), [NSColor.blueColor colorWithAlphaComponent:0.3]);
    
    _secondaryView = secondaryView;
    return secondaryView;
}

- (NSStackView *)_stackView {
    if (auto stackView = _stackView) return stackView;
    
    NSStackView *stackView_1;
    {
        NSView *pinkView = [NSView new];
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(pinkView, sel_registerName("setBackgroundColor:"), NSColor.systemPinkColor);
        
        NSView *greenView = [NSView new];
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(greenView, sel_registerName("setBackgroundColor:"), NSColor.systemGreenColor);
        
        NSView *yellowView = [NSView new];
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(yellowView, sel_registerName("setBackgroundColor:"), NSColor.systemYellowColor);
        
        stackView_1 = [NSStackView new];
        
        [stackView_1 addArrangedSubview:pinkView];
        [pinkView release];
        [stackView_1 addArrangedSubview:greenView];
        [greenView release];
        [stackView_1 addArrangedSubview:yellowView];
        [yellowView release];
        
        stackView_1.spacing = 0.;
        stackView_1.orientation = NSUserInterfaceLayoutOrientationHorizontal;
        stackView_1.alignment = NSLayoutAttributeHeight;
        stackView_1.distribution = NSStackViewDistributionFillEqually;
    }
    
    NSStackView *stackView_2;
    {
        NSView *brownView = [NSView new];
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(brownView, sel_registerName("setBackgroundColor:"), NSColor.systemBrownColor);
        
        NSView *indigoView = [NSView new];
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(indigoView, sel_registerName("setBackgroundColor:"), NSColor.systemIndigoColor);
        
        NSView *purpleView = [NSView new];
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(purpleView, sel_registerName("setBackgroundColor:"), NSColor.systemPurpleColor);
        
        stackView_2 = [NSStackView new];
        
        [stackView_2 addArrangedSubview:brownView];
        [brownView release];
        [stackView_2 addArrangedSubview:indigoView];
        [indigoView release];
        [stackView_2 addArrangedSubview:purpleView];
        [purpleView release];
        
        stackView_2.spacing = 0.;
        stackView_2.orientation = NSUserInterfaceLayoutOrientationHorizontal;
        stackView_2.alignment = NSLayoutAttributeHeight;
        stackView_2.distribution = NSStackViewDistributionFillEqually;
    }
    
    NSStackView *stackView = [NSStackView new];
    [stackView addArrangedSubview:stackView_1];
    [stackView_1 release];
    [stackView addArrangedSubview:stackView_2];
    [stackView_2 release];
    
    stackView.spacing = 0.;
    stackView.orientation = NSUserInterfaceLayoutOrientationVertical;
    stackView.alignment = NSLayoutAttributeWidth;
    stackView.distribution = NSStackViewDistributionFillEqually;
    
    _stackView = stackView;
    return stackView;
}

- (NSImageView *)_imageView {
    if (auto imageView = _imageView) return imageView;
    
    NSURL *url = [NSBundle.mainBundle URLForResource:@"popcorns" withExtension:UTTypePNG.preferredFilenameExtension];
    assert(url != nil);
    NSImage *image = [[NSImage alloc] initWithContentsOfURL:url];
    assert(image != nil);
    
    NSImageView *imageView = [NSImageView new];
    imageView.image = image;
    [image release];
    
    _imageView = imageView;
    return imageView;
}

- (NSSlider *)_slider {
    if (auto slider = _slider) return slider;
    
    NSSlider *slider = [NSSlider new];
    slider.target = self;
    slider.action = @selector(_sliderDidChange:);
    slider.minValue = -180.;
    slider.maxValue = 180.;
    
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
    
    self.secondaryView.boundsRotation = rotation;
    NSLog(@"%@ %@", NSStringFromRect(self.secondaryView.bounds), NSStringFromRect(self.stackView.frame));
}

@end
