//
//  ViewDemoReplaceSubviewView.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 3/6/25.
//

#import "ViewDemoReplaceSubviewView.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface ViewDemoReplaceSubviewView ()
@property (retain, nonatomic, readonly, getter=_containerView) NSView *containerView;
@property (retain, nonatomic, readonly, getter=_primaryView) NSView *primaryView;
@property (retain, nonatomic, readonly, getter=_secondaryView) NSView *secondaryView;
@property (retain, nonatomic, readonly, getter=_button) NSButton *button;
@end

@implementation ViewDemoReplaceSubviewView
@synthesize containerView = _containerView;
@synthesize primaryView = _primaryView;
@synthesize secondaryView = _secondaryView;
@synthesize button = _button;

- (instancetype)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.containerView];
        
        NSView *primaryView = self.primaryView;
        primaryView.frame = NSMakeRect(0., 0., 100., 100.);
        [self.containerView addSubview:primaryView];
        
        self.secondaryView.frame = NSMakeRect(0., 100., 100., 100.);
        
        [self addSubview:self.button];
    }
    
    return self;
}

- (void)dealloc {
    [_containerView release];
    [_primaryView release];
    [_secondaryView release];
    [_button release];
    [super dealloc];
}

- (void)layout {
    [super layout];
    NSSize fittingSize = self.button.fittingSize;
    self.button.frame = NSMakeRect(0., 0., fittingSize.width, fittingSize.height);
    self.containerView.frame = NSMakeRect(0., fittingSize.height, NSWidth(self.bounds), NSHeight(self.bounds) - fittingSize.height);
}

- (NSView *)_containerView {
    if (auto containerView = _containerView) return containerView;
    
    NSView *containerView = [NSView new];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(containerView, sel_registerName("setBackgroundColor:"), NSColor.whiteColor);
    
    _containerView = containerView;
    return containerView;
}

- (NSView *)_primaryView {
    if (auto primaryView = _primaryView) return primaryView;
    
    NSView *primaryView = [NSView new];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(primaryView, sel_registerName("setBackgroundColor:"), NSColor.systemRedColor);
    
    _primaryView = primaryView;
    return primaryView;
}

- (NSView *)_secondaryView {
    if (auto secondaryView = _secondaryView) return secondaryView;
    
    NSView *secondaryView = [NSView new];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(secondaryView, sel_registerName("setBackgroundColor:"), NSColor.systemGreenColor);
    
    _secondaryView = secondaryView;
    return secondaryView;
}

- (NSButton *)_button {
    if (auto button = _button) return button;
    
    NSButton *button = [NSButton new];
    button.title = @"Replace";
    button.target = self;
    button.action = @selector(_didTriggerButton:);
    
    _button = button;
    return button;
}

- (void)_didTriggerButton:(NSButton *)sender {
    if (self.primaryView.superview != nil) {
        [self.containerView replaceSubview:self.primaryView with:self.secondaryView];
    } else {
        [self.containerView replaceSubview:self.secondaryView with:self.primaryView];
    }
}

@end
