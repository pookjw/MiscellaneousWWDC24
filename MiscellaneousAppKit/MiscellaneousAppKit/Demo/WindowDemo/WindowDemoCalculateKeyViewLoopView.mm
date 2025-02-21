//
//  WindowDemoCalculateKeyViewLoopView.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/21/25.
//

#import "WindowDemoCalculateKeyViewLoopView.h"
#import "WindowDemoKeyViewFirstRespondableView.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface WindowDemoCalculateKeyViewLoopView ()
@property (retain, nonatomic, readonly, getter=_stackView) NSStackView *stackView;
@property (retain, nonatomic, readonly, getter=_autorecalculatesKeyViewLoopButton) NSButton *autorecalculatesKeyViewLoopButton;
@property (retain, nonatomic, readonly, getter=_recalculateKeyViewLoopButton) NSButton *recalculateKeyViewLoopButton;
@property (retain, nonatomic, readonly, getter=_selectPreviousKeyViewButton) NSButton *selectPreviousKeyViewButton;
@property (retain, nonatomic, readonly, getter=_selectNextKeyViewButton) NSButton *selectNextKeyViewButton;
@property (retain, nonatomic, readonly, getter=_addFirstRespondableViewButton) NSButton *addFirstRespondableViewButton;
@property (assign, nonatomic, getter=_shouldMakeFirstResponderForAddedView, setter=_setShouldMakeFirstResponderForAddedView:) BOOL shouldMakeFirstResponderForAddedView;
@end

@implementation WindowDemoCalculateKeyViewLoopView

- (instancetype)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.shouldMakeFirstResponderForAddedView = YES;
        
        NSButton *autorecalculatesKeyViewLoopButton = [NSButton checkboxWithTitle:@"Autorecalculates Key View" target:self action:@selector(_didTriggerAutorecalculatesKeyViewLoopButton:)];
        NSButton *recalculateKeyViewLoopButton = [NSButton buttonWithTitle:@"Recalculate Key View Loop" target:self action:@selector(_didTriggerRecalculateKeyViewLoopButton:)];
        
        NSButton *selectPreviousKeyViewButton = [NSButton buttonWithTitle:@"selectPreviousKeyView:" target:self action:@selector(_didTriggerSelectPreviousKeyViewButton:)];
        NSButton *selectNextKeyViewButton = [NSButton buttonWithTitle:@"selectNextKeyView:" target:self action:@selector(_didTriggerSelectNextKeyViewButton:)];
        
        NSButton *addFirstRespondableViewButton = [NSButton buttonWithTitle:@"Add View" target:self action:@selector(_didTriggerAddFirstRespondableViewButton:)];
        
        NSStackView *stackView = [NSStackView new];
        stackView.orientation = NSUserInterfaceLayoutOrientationVertical;
        stackView.distribution = NSStackViewDistributionFillProportionally;
        stackView.alignment = NSLayoutAttributeCenterX;
        
        [stackView addArrangedSubview:autorecalculatesKeyViewLoopButton];
        [stackView addArrangedSubview:recalculateKeyViewLoopButton];
        [stackView addArrangedSubview:selectPreviousKeyViewButton];
        [stackView addArrangedSubview:selectNextKeyViewButton];
        [stackView addArrangedSubview:addFirstRespondableViewButton];
        
        stackView.frame = self.bounds;
        stackView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        [self addSubview:stackView];
        
        _autorecalculatesKeyViewLoopButton = [autorecalculatesKeyViewLoopButton retain];
        _recalculateKeyViewLoopButton = [recalculateKeyViewLoopButton retain];
        _selectPreviousKeyViewButton = [selectPreviousKeyViewButton retain];
        _selectNextKeyViewButton = [selectNextKeyViewButton retain];
        _addFirstRespondableViewButton = [addFirstRespondableViewButton retain];
        _stackView = stackView;
    }
    
    return self;
}

- (void)dealloc {
    [_stackView release];
    [_autorecalculatesKeyViewLoopButton release];
    [_recalculateKeyViewLoopButton release];
    [_selectPreviousKeyViewButton release];
    [_selectNextKeyViewButton release];
    [_addFirstRespondableViewButton release];
    [super dealloc];
}

- (void)viewDidMoveToWindow {
    [super viewDidMoveToWindow];
    
    if (NSWindow *window = self.window) {
        self.autorecalculatesKeyViewLoopButton.state = window.autorecalculatesKeyViewLoop ? NSControlStateValueOn : NSControlStateValueOff;
    }
}

- (NSSize)fittingSize {
    return self.stackView.fittingSize;
}

- (NSSize)intrinsicContentSize {
    return self.stackView.intrinsicContentSize;
}

- (BOOL)canBecomeKeyView {
    return YES;
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (void)_didTriggerAutorecalculatesKeyViewLoopButton:(NSButton *)sender {
    self.window.autorecalculatesKeyViewLoop = (sender.state == NSControlStateValueOn);
}

- (void)_didTriggerRecalculateKeyViewLoopButton:(NSButton *)sender {
    [self.window recalculateKeyViewLoop];
}

- (void)_didTriggerSelectPreviousKeyViewButton:(NSButton *)sender {
    [self.window selectPreviousKeyView:sender];
}

- (void)_didTriggerSelectNextKeyViewButton:(NSButton *)sender {
    [self.window selectNextKeyView:sender];
}

- (void)_didTriggerAddFirstRespondableViewButton:(NSButton *)sender {
    WindowDemoKeyViewFirstRespondableView *view = [WindowDemoKeyViewFirstRespondableView new];
    [self.stackView insertArrangedSubview:view atIndex:0];
    
    if (self.shouldMakeFirstResponderForAddedView) {
        [self.window makeFirstResponder:view];
        self.shouldMakeFirstResponderForAddedView = NO;
    }
    
    [view release];
    
    NSAlert *alert = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self.window, sel_registerName("alert"));
    assert([alert.accessoryView isEqual:self]);
    self.frame = NSMakeRect(0., 0., NSWidth(self.frame), self.fittingSize.height);
    [alert layout];
}

@end
