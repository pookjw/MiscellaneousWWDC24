//
//  WindowDemoKeyViewFirstRespondableView.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/21/25.
//

#import "WindowDemoKeyViewFirstRespondableView.h"

@interface WindowDemoKeyViewFirstRespondableView ()
@property (retain, nonatomic, readonly, getter=_label) NSTextField *label;
@end

@implementation WindowDemoKeyViewFirstRespondableView
@synthesize label = _label;

- (instancetype)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
        NSTextField *label = self.label;
        label.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        label.frame = self.bounds;
        [self addSubview:label];
    }
    
    return self;
}

- (void)dealloc {
    [_preferredNextValidKeyView release];
    [_preferredPreviousValidKeyView release];
    [_label release];
    [super dealloc];
}

- (NSTextField *)_label {
    if (auto label = _label) return label;
    
    NSTextField *label = [NSTextField labelWithString:@"Not First Responder"];
    label.alignment = NSTextAlignmentCenter;
    
    _label = label;
    return label;
}

- (NSSize)fittingSize {
    return self.label.fittingSize;
}

- (NSSize)intrinsicContentSize {
    return self.label.intrinsicContentSize;
}

- (BOOL)canBecomeKeyView {
    return YES;
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (BOOL)becomeFirstResponder {
    BOOL result = [super becomeFirstResponder];
    
    if (result) {
        self.label.stringValue = @"First Responder";
    }
    
    return result;
}

- (BOOL)resignFirstResponder {
    BOOL result = [super resignFirstResponder];
    
    if (result) {
        self.label.stringValue = @"Not First Responder";
    }
    
    return result;
}

- (NSView *)previousValidKeyView {
    if (NSView *preferredPreviousValidKeyView = self.preferredPreviousValidKeyView) {
        return preferredPreviousValidKeyView;
    }
    
    return [super previousValidKeyView];
}

- (NSView *)nextValidKeyView {
    if (NSView *preferredNextValidKeyView = self.preferredNextValidKeyView) {
        return preferredNextValidKeyView;
    }
    
    return [super nextValidKeyView];
}

@end
