//
//  WindowDemoKeyViewDemoView.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/21/25.
//

#import "WindowDemoKeyViewDemoView.h"
#import "WindowDemoKeyViewFirstRespondableView.h"

@interface WindowDemoKeyViewDemoView ()
@property (retain, nonatomic, readonly, getter=_stackView) NSStackView *stackView;
@property (retain, nonatomic, readonly, getter=_firstRespondableView_1) WindowDemoKeyViewFirstRespondableView *firstRespondableView_1;
@property (retain, nonatomic, readonly, getter=_firstRespondableView_2) WindowDemoKeyViewFirstRespondableView *firstRespondableView_2;
@property (retain, nonatomic, readonly, getter=_firstRespondableView_3) WindowDemoKeyViewFirstRespondableView *firstRespondableView_3;
@property (retain, nonatomic, readonly, getter=_firstRespondableView_4) WindowDemoKeyViewFirstRespondableView *firstRespondableView_4;
@property (retain, nonatomic, readonly, getter=_selectKeyViewPrecedingViewButton) NSButton *selectKeyViewPrecedingViewButton;
@property (retain, nonatomic, readonly, getter=_selectKeyViewFollowingViewButton) NSButton *selectKeyViewFollowingViewButton;
@property (retain, nonatomic, readonly, getter=_selectPreviousKeyViewButton) NSButton *selectPreviousKeyViewButton;
@property (retain, nonatomic, readonly, getter=_selectNextKeyViewButton) NSButton *selectNextKeyViewButton;
@end

@implementation WindowDemoKeyViewDemoView

- (instancetype)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
        WindowDemoKeyViewFirstRespondableView *firstRespondableView_1 = [WindowDemoKeyViewFirstRespondableView new];
        WindowDemoKeyViewFirstRespondableView *firstRespondableView_2 = [WindowDemoKeyViewFirstRespondableView new];
        WindowDemoKeyViewFirstRespondableView *firstRespondableView_3 = [WindowDemoKeyViewFirstRespondableView new];
        WindowDemoKeyViewFirstRespondableView *firstRespondableView_4 = [WindowDemoKeyViewFirstRespondableView new];
        
        firstRespondableView_1.preferredPreviousValidKeyView = firstRespondableView_3;
        firstRespondableView_1.preferredNextValidKeyView = firstRespondableView_4;
        
        firstRespondableView_2.preferredPreviousValidKeyView = firstRespondableView_4;
        firstRespondableView_2.preferredNextValidKeyView = firstRespondableView_3;
        
        firstRespondableView_3.preferredPreviousValidKeyView = firstRespondableView_2;
        firstRespondableView_3.preferredNextValidKeyView = firstRespondableView_1;
        
        firstRespondableView_4.preferredPreviousValidKeyView = firstRespondableView_1;
        firstRespondableView_4.preferredNextValidKeyView = firstRespondableView_2;
        
        NSButton *selectKeyViewPrecedingViewButton = [NSButton buttonWithTitle:@"selectKeyViewPrecedingView:" target:self action:@selector(_didTriggerButton:)];
        NSButton *selectKeyViewFollowingViewButton = [NSButton buttonWithTitle:@"selectKeyViewFollowingView:" target:self action:@selector(_didTriggerButton:)];
        NSButton *selectPreviousKeyViewButton = [NSButton buttonWithTitle:@"selectPreviousKeyView:" target:self action:@selector(_didTriggerButton:)];
        NSButton *selectNextKeyViewButton = [NSButton buttonWithTitle:@"selectNextKeyView:" target:self action:@selector(_didTriggerButton:)];
        
        NSStackView *stackView = [NSStackView new];
        stackView.orientation = NSUserInterfaceLayoutOrientationVertical;
        stackView.distribution = NSStackViewDistributionFillProportionally;
        stackView.alignment = NSLayoutAttributeCenterX;
        [stackView addArrangedSubview:firstRespondableView_1];
        [stackView addArrangedSubview:firstRespondableView_2];
        [stackView addArrangedSubview:firstRespondableView_3];
        [stackView addArrangedSubview:firstRespondableView_4];
        [stackView addArrangedSubview:selectKeyViewPrecedingViewButton];
        [stackView addArrangedSubview:selectKeyViewFollowingViewButton];
        [stackView addArrangedSubview:selectPreviousKeyViewButton];
        [stackView addArrangedSubview:selectNextKeyViewButton];
        
        stackView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        stackView.frame = self.bounds;
        [self addSubview:stackView];
        
        _stackView = stackView;
        
        _firstRespondableView_1 = firstRespondableView_1;
        _firstRespondableView_2 = firstRespondableView_2;
        _firstRespondableView_3 = firstRespondableView_3;
        _firstRespondableView_4 = firstRespondableView_4;
        
        _selectKeyViewPrecedingViewButton = [selectKeyViewPrecedingViewButton retain];
        _selectKeyViewFollowingViewButton = [selectKeyViewFollowingViewButton retain];
        _selectPreviousKeyViewButton = [selectPreviousKeyViewButton retain];
        _selectNextKeyViewButton = [selectNextKeyViewButton retain];
    }
    
    return self;
}

- (void)dealloc {
    [_stackView release];
    [_firstRespondableView_1 release];
    [_firstRespondableView_2 release];
    [_firstRespondableView_3 release];
    [_firstRespondableView_4 release];
    [_selectKeyViewPrecedingViewButton release];
    [_selectKeyViewFollowingViewButton release];
    [_selectPreviousKeyViewButton release];
    [_selectNextKeyViewButton release];
    [super dealloc];
}

- (NSSize)fittingSize {
    return self.stackView.fittingSize;
}

- (NSSize)intrinsicContentSize {
    return self.stackView.intrinsicContentSize;
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (BOOL)canBecomeKeyView {
    return YES;
}

- (BOOL)becomeFirstResponder {
    return [self.firstRespondableView_1 becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    return [self.stackView resignFirstResponder];
}

- (void)_didTriggerButton:(NSButton *)sender {
    NSWindow *window = self.window;
    
    if ([sender isEqual:self.selectKeyViewPrecedingViewButton]) {
        [window selectKeyViewPrecedingView:static_cast<WindowDemoKeyViewFirstRespondableView *>(window.firstResponder)];
    } else if ([sender isEqual:self.selectKeyViewFollowingViewButton]) {
        [window selectKeyViewFollowingView:static_cast<WindowDemoKeyViewFirstRespondableView *>(window.firstResponder)];
    } else if ([sender isEqual:self.selectPreviousKeyViewButton]) {
        [window selectPreviousKeyView:sender];
    } else if ([sender isEqual:self.selectNextKeyViewButton]) {
        [window selectNextKeyView:sender];
    } else {
        abort();
    }
}

@end
