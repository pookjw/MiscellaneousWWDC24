//
//  WindowDemoMakeFirstResponderView.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/21/25.
//

#import "WindowDemoMakeFirstResponderView.h"

@interface WindowDemoMakeFirstResponderView ()
@property (retain, nonatomic, readonly, getter=_stackView) NSStackView *stackView;
@property (retain, nonatomic, readonly, getter=_textField_1) NSTextField *textField_1;
@property (retain, nonatomic, readonly, getter=_textField_2) NSTextField *textField_2;
@property (retain, nonatomic, readonly, getter=_button) NSButton *button;
@end

@implementation WindowDemoMakeFirstResponderView
@synthesize stackView = _stackView;
@synthesize textField_1 = _textField_1;
@synthesize textField_2 = _textField_2;
@synthesize button = _button;

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
    [_textField_1 release];
    [_textField_2 release];
    [_button release];
    [super dealloc];
}

- (NSSize)fittingSize {
    return self.stackView.fittingSize;
}

- (NSSize)intrinsicContentSize {
    return self.stackView.intrinsicContentSize;
}

- (NSStackView *)_stackView {
    if (auto stackView = _stackView) return stackView;
    
    NSStackView *stackView = [NSStackView new];
    
    [stackView addArrangedSubview:self.textField_1];
    [stackView addArrangedSubview:self.textField_2];
    [stackView addArrangedSubview:self.button];
    
    stackView.orientation = NSUserInterfaceLayoutOrientationVertical;
    stackView.distribution = NSStackViewDistributionFillProportionally;
    stackView.alignment = NSLayoutAttributeCenterX;
    
    _stackView = stackView;
    return stackView;
}

- (NSTextField *)_textField_1 {
    if (auto textField_1 = _textField_1) return textField_1;
    
    NSTextField *textField_1 = [NSTextField new];
    
    _textField_1 = textField_1;
    return textField_1;
}

- (NSTextField *)_textField_2 {
    if (auto textField_2 = _textField_2) return textField_2;
    
    NSTextField *textField_2 = [NSTextField new];
    
    _textField_2 = textField_2;
    return textField_2;
}

- (NSButton *)_button {
    if (auto button = _button) return button;
    
    NSButton *button = [NSButton buttonWithTitle:@"Make First Responder" target:self action:@selector(_didTriggerButton:)];
    
    _button = [button retain];
    return button;
}

- (void)_didTriggerButton:(NSButton *)sender {
    if ([self.window.firstResponder isEqual:self.textField_1.currentEditor]) {
        [self.window makeFirstResponder:self.textField_2];
    } else {
        [self.window makeFirstResponder:self.textField_1];
    }
}

@end
