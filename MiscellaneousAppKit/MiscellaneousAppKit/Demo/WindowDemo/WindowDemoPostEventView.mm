//
//  WindowDemoPostEventView.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/20/25.
//

#import "WindowDemoPostEventView.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface WindowDemoPostEventView ()
@property (retain, nonatomic, readonly, getter=_stackView) NSStackView *stackView;
@property (retain, nonatomic, readonly, getter=_statusLabel) NSTextField *statusLabel;
@property (retain, nonatomic, readonly, getter=_toggleSwitch) NSSwitch *toggleSwitch;
@end

@implementation WindowDemoPostEventView
@synthesize stackView = _stackView;
@synthesize statusLabel = _statusLabel;
@synthesize toggleSwitch = _toggleSwitch;

- (instancetype)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setBackgroundColor:"), NSColor.blackColor);
        
        NSStackView *stackView = self.stackView;
        stackView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:stackView];
        [NSLayoutConstraint activateConstraints:@[
            [stackView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
            [stackView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor]
        ]];
        
        NSPanGestureRecognizer *panGestureRecognizer = [[NSPanGestureRecognizer alloc] initWithTarget:self action:@selector(_didTriggerPanGestureRecognizer:)];
        [self addGestureRecognizer:panGestureRecognizer];
        [panGestureRecognizer release];
    }
    
    return self;
}

- (void)dealloc {
    [_stackView release];
    [_statusLabel release];
    [_toggleSwitch release];
    [super dealloc];
}

- (void)_didTriggerPanGestureRecognizer:(NSPanGestureRecognizer *)sender {
    if (self.toggleSwitch.state == NSControlStateValueOn) {
        // YES로 하면 Responder Chain을 처음부터 타기에 무한루프 걸림
        [self.window postEvent:self.window.currentEvent atStart:NO];
    }
    
    self.statusLabel.stringValue = @"Pan Gesture Recognized";
}

- (void)mouseDragged:(NSEvent *)event {
    [super mouseDragged:event];
    self.statusLabel.stringValue = @"Mouse Dragged";
}

- (NSStackView *)_stackView {
    if (auto stackView = _stackView) return stackView;
    
    NSStackView *stackView = [NSStackView new];
    
    [stackView addArrangedSubview:self.statusLabel];
    [stackView addArrangedSubview:self.toggleSwitch];
    
    stackView.orientation = NSUserInterfaceLayoutOrientationVertical;
    stackView.distribution = NSStackViewDistributionFillProportionally;
    stackView.alignment = NSLayoutAttributeCenterX;
    
    _stackView = stackView;
    return stackView;
}

- (NSTextField *)_statusLabel {
    if (auto statusLabel = _statusLabel) return statusLabel;
    
    NSTextField *statusLabel = [NSTextField labelWithString:@"Pending"];
    statusLabel.textColor = NSColor.whiteColor;
    
    _statusLabel = [statusLabel retain];
    return statusLabel;
}

- (NSSwitch *)_toggleSwitch {
    if (auto toggleSwitch = _toggleSwitch) return toggleSwitch;
    
    NSSwitch *toggleSwitch = [NSSwitch new];
    
    _toggleSwitch = toggleSwitch;
    return toggleSwitch;
}

@end
