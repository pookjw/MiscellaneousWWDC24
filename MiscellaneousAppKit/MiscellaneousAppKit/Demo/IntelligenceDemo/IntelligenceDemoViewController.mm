//
//  IntelligenceDemoViewController.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/16/25.
//

#import "IntelligenceDemoViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

/*
 _TtC6AppKit27_NSIntelligenceUISymbolView
 _TtC6AppKit34_NSIntelligenceUIWashAnimationView
 _TtC6AppKitP33_3D641B2843142AA8DCCE043DDCE6387B32NSIntelligenceUIExteriorGlowView
 _TtC6AppKitP33_3D641B2843142AA8DCCE043DDCE6387B33NSIntelligenceUIInteriorLightView
 _TtCCO6AppKit14IntelligenceUI15PromptEntryView14BackgroundView
 _TtCO6AppKit14IntelligenceUI13TextFieldCell
 _TtCO6AppKit14IntelligenceUI15PromptEntryView
 _TtCO6AppKit14IntelligenceUI8TextView
 _TtCO6AppKit14IntelligenceUI9TextField
 _TtC6AppKit17NSLivingColorView
 */

@interface _IntelligenceDemoView : NSView
@property (retain, nonatomic, readonly, getter=_symbolView) __kindof NSView *symbolView;
@property (retain, nonatomic, readonly, getter=_washAnimationView) __kindof NSView *washAnimationView;
@property (retain, nonatomic, readonly, getter=_exteriorGlowView) __kindof NSView *exteriorGlowView;
@property (retain, nonatomic, readonly, getter=_interiorLightView) __kindof NSView *interiorLightView;
@property (retain, nonatomic, readonly, getter=_promptEntryView) __kindof NSView *promptEntryView;
@property (retain, nonatomic, readonly, getter=_textField) __kindof NSTextField *textField;
@property (retain, nonatomic, readonly, getter=_textView) __kindof NSTextView *textView;
@end

@implementation _IntelligenceDemoView
@synthesize symbolView = _symbolView;
@synthesize washAnimationView = _washAnimationView;
@synthesize exteriorGlowView = _exteriorGlowView;
@synthesize interiorLightView = _interiorLightView;
@synthesize promptEntryView = _promptEntryView;
@synthesize textField = _textField;
@synthesize textView = _textView;

- (instancetype)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.symbolView];
        [self addSubview:self.washAnimationView];
        [self addSubview:self.exteriorGlowView];
        [self addSubview:self.interiorLightView];
        [self addSubview:self.promptEntryView];
        [self addSubview:self.textField];
        [self addSubview:self.textView];
    }
    
    return self;
}

- (void)dealloc {
    [_symbolView release];
    [_washAnimationView release];
    [_exteriorGlowView release];
    [_interiorLightView release];
    [_promptEntryView release];
    [_textField release];
    [_textView release];
    [super dealloc];
}

- (void)layout {
    [super layout];
    
    NSRect bounds = self.bounds;
    
    CGFloat y = NSHeight(bounds);
    
    self.promptEntryView.frame = NSMakeRect(0.,
                                            y -= 100.,
                                            NSWidth(bounds),
                                            100.);
    
    self.symbolView.frame = NSMakeRect(0.,
                                       y -= 100.,
                                       NSWidth(bounds),
                                       100.);
    
    self.washAnimationView.frame = NSMakeRect(0.,
                                              y -= 100.,
                                              NSWidth(bounds),
                                              100.);
    
    self.exteriorGlowView.frame = NSMakeRect(0.,
                                             y -= 100.,
                                             NSWidth(bounds),
                                             100.);
    
    self.interiorLightView.frame = NSMakeRect(0.,
                                              y -= 100.,
                                              NSWidth(bounds),
                                              100.);
    
    self.textField.frame = NSMakeRect(0.,
                                      y -= 100.,
                                      NSWidth(bounds),
                                      100.);
    
    self.textView.frame = NSMakeRect(0.,
                                     y -= 100.,
                                     NSWidth(bounds),
                                     100.);
}

- (__kindof NSView *)_symbolView {
    if (auto symbolView = _symbolView) return symbolView;
    
    __kindof NSView *symbolView = [objc_lookUpClass("_TtC6AppKit27_NSIntelligenceUISymbolView") new];
    
    _symbolView = symbolView;
    return symbolView;
}

- (__kindof NSView *)_washAnimationView {
    if (auto washAnimationView = _washAnimationView) return washAnimationView;
    
    __kindof NSView *washAnimationView = [objc_lookUpClass("_TtC6AppKit34_NSIntelligenceUIWashAnimationView") new];
    
    NSClickGestureRecognizer *gestureRecognizer = [[NSClickGestureRecognizer alloc] initWithTarget:self action:@selector(_didTriggerClick:)];
    [washAnimationView addGestureRecognizer:gestureRecognizer];
    [gestureRecognizer release];
    
    _washAnimationView = washAnimationView;
    return washAnimationView;
}

- (__kindof NSView *)_exteriorGlowView {
    if (auto exteriorGlowView = _exteriorGlowView) return exteriorGlowView;
    
    __kindof NSView *exteriorGlowView = [objc_lookUpClass("_TtC6AppKitP33_3D641B2843142AA8DCCE043DDCE6387B32NSIntelligenceUIExteriorGlowView") new];
    
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(exteriorGlowView, sel_registerName("setClipsToBounds:"), YES);
    
    _exteriorGlowView = exteriorGlowView;
    return exteriorGlowView;
}

- (__kindof NSView *)_interiorLightView {
    if (auto interiorLightView = _interiorLightView) return interiorLightView;
    
    __kindof NSView *interiorLightView = [objc_lookUpClass("_TtC6AppKitP33_3D641B2843142AA8DCCE043DDCE6387B33NSIntelligenceUIInteriorLightView") new];
    
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(interiorLightView, sel_registerName("setClipsToBounds:"), YES);
    
    _interiorLightView = interiorLightView;
    return interiorLightView;
}

- (__kindof NSView *)_promptEntryView {
    if (auto promptEntryView = _promptEntryView) return promptEntryView;
    
    __kindof NSView *promptEntryView = [objc_lookUpClass("_TtCO6AppKit14IntelligenceUI15PromptEntryView") new];
    
    _promptEntryView = promptEntryView;
    return promptEntryView;
}

- (__kindof NSTextField *)_textField {
    if (auto textField = _textField) return textField;
    
    __kindof NSTextField *textField = [objc_lookUpClass("_TtCO6AppKit14IntelligenceUI9TextField") new];
    
    _textField = textField;
    return textField;
}

- (__kindof NSTextView *)_textView {
    if (auto textView = _textView) return textView;
    
    __kindof NSTextView *textView = [objc_lookUpClass("_TtCO6AppKit14IntelligenceUI8TextView") new];
    
    _textView = textView;
    return textView;
}

- (void)_didTriggerClick:(NSClickGestureRecognizer *)sender {
    reinterpret_cast<void (*)(id, SEL, id, id, CGPoint, CGPoint, id)>(objc_msgSend)(self.washAnimationView, sel_registerName("animateWithStartColor:endColor:normalizedStartPoint:normalizedEndPoint:completionHandler:"), NSColor.cyanColor, NSColor.orangeColor, CGPointMake(0., 0.), CGPointMake(1., 1.), ^{
        
    });
}

@end

@interface IntelligenceDemoViewController ()
@end

@implementation IntelligenceDemoViewController

- (void)loadView {
    _IntelligenceDemoView *view = [_IntelligenceDemoView new];
    self.view = view;
    [view release];
}

@end
