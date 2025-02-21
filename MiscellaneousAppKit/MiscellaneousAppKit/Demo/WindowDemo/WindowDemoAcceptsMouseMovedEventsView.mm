//
//  WindowDemoAcceptsMouseMovedEventsView.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/21/25.
//

#import "WindowDemoAcceptsMouseMovedEventsView.h"

@interface WindowDemoAcceptsMouseMovedEventsView ()
@property (retain, nonatomic, readonly, getter=_toggleSwitch) NSSwitch *toggleSwitch;
@property (retain, nonatomic, readonly, getter=_label) NSTextField *label;
@end

@implementation WindowDemoAcceptsMouseMovedEventsView
@synthesize toggleSwitch = _toggleSwitch;
@synthesize label = _label;

- (instancetype)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
        NSSwitch *toggleSwitch = self.toggleSwitch;
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:toggleSwitch];
        [NSLayoutConstraint activateConstraints:@[
            [toggleSwitch.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
            [toggleSwitch.topAnchor constraintEqualToAnchor:self.topAnchor]
        ]];
        
        NSTextField *label = self.label;
        label.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:label];
        [NSLayoutConstraint activateConstraints:@[
            [label.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
            [label.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
        ]];
    }
    
    return self;
}

- (void)dealloc {
    [_toggleSwitch release];
    [_label release];
    [super dealloc];
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (void)mouseMoved:(NSEvent *)event {
    [super mouseMoved:event];
    self.label.stringValue = @(event.timestamp).stringValue;
}

- (NSSwitch *)_toggleSwitch {
    if (auto toggleSwitch = _toggleSwitch) return toggleSwitch;
    
    NSSwitch *toggleSwitch = [NSSwitch new];
    toggleSwitch.target = self;
    toggleSwitch.action = @selector(_didTriggerToggleSwitch:);
    
    _toggleSwitch = toggleSwitch;
    return toggleSwitch;
}

- (NSTextField *)_label {
    if (auto label = _label) return label;
    
    NSTextField *label = [NSTextField labelWithString:@"Pending"];
    
    _label = [label retain];
    return label;
}

- (void)_didTriggerToggleSwitch:(NSSwitch *)sender {
    self.window.acceptsMouseMovedEvents = (sender.state == NSControlStateValueOn);
}

@end
