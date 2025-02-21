//
//  WindowDemoSetFrameUsingNameView.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/18/25.
//

#import "WindowDemoSetFrameUsingNameView.h"

@interface WindowDemoSetFrameUsingNameView () <NSTextFieldDelegate>
@property (retain, nonatomic, readonly, getter=_stackView) NSStackView *stackView;
@property (retain, nonatomic, readonly, getter=_textField) NSTextField *textField;
@property (retain, nonatomic, readonly, getter=_frameLabel) NSTextField *frameLabel;
@property (retain, nonatomic, readonly, getter=_forceButton) NSButton *forceButton;
@end

@implementation WindowDemoSetFrameUsingNameView
@synthesize stackView = _stackView;
@synthesize textField = _textField;
@synthesize frameLabel = _frameLabel;
@synthesize forceButton = _forceButton;

- (instancetype)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
        NSStackView *stackView = self.stackView;
        stackView.frame = self.bounds;
        stackView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        [self addSubview:stackView];
    }
    
    return self;
}

- (void)dealloc {
    [_stackView release];
    [_textField release];
    [_frameLabel release];
    [_forceButton release];
    [super dealloc];
}

- (NSSize)intrinsicContentSize {
    return self.stackView.intrinsicContentSize;
}

- (NSSize)fittingSize {
    return self.stackView.fittingSize;
}

- (NSWindowFrameAutosaveName)autosaveName {
    return self.textField.stringValue;
}

- (void)setAutosaveName:(NSWindowFrameAutosaveName)autosaveName {
    assert(autosaveName != nil);
    self.textField.stringValue = autosaveName;
    [self _updateFrameLabel];
}

- (BOOL)force {
    return self.forceButton.state == NSControlStateValueOn;
}

- (void)setForce:(BOOL)force {
    self.forceButton.state = force ? NSControlStateValueOn : NSControlStateValueOff;
}

- (NSStackView *)_stackView {
    if (auto stackView = _stackView) return stackView;
    
    NSStackView *stackView = [NSStackView new];
    [stackView addArrangedSubview:self.textField];
    [stackView addArrangedSubview:self.frameLabel];
    [stackView addArrangedSubview:self.forceButton];
    stackView.orientation = NSUserInterfaceLayoutOrientationVertical;
    stackView.distribution = NSStackViewDistributionFill;
    stackView.alignment = NSLayoutAttributeCenterX;
    
    _stackView = stackView;
    return stackView;
}

- (NSTextField *)_textField {
    if (auto textField = _textField) return textField;
    
    NSTextField *textField = [NSTextField new];
    textField.delegate = self;
    
    _textField = textField;
    return textField;
}

- (NSTextField *)_frameLabel {
    if (auto frameLabel = _frameLabel) return frameLabel;
    
    NSTextField *frameLabel = [NSTextField wrappingLabelWithString:@"\n\n\n"];
    frameLabel.alignment = NSTextAlignmentCenter;
    
    _frameLabel = [frameLabel retain];
    return frameLabel;
}

- (NSButton *)_forceButton {
    if (auto forceButton = _forceButton) return forceButton;
    
    NSButton *forceButton = [NSButton checkboxWithTitle:@"Force" target:nil action:nil];
    
    _forceButton = [forceButton retain];
    return forceButton;
}

- (NSWindowPersistableFrameDescriptor)frameDescriptorForAutosaveName {
    NSString *key = [NSString stringWithFormat:@"NSWindow Frame %@", self.textField.stringValue];
    return [NSUserDefaults.standardUserDefaults objectForKey:key];
}

- (void)controlTextDidChange:(NSNotification *)obj {
    [self _updateFrameLabel];
}

- (void)_updateFrameLabel {
    if (NSWindowPersistableFrameDescriptor descriptor = self.frameDescriptorForAutosaveName) {
        self.frameLabel.stringValue = [NSString stringWithFormat:@"%@", descriptor];
    } else {
        self.frameLabel.stringValue = @"";
    }
}

@end
