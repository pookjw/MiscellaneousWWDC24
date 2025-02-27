//
//  WindowDemoIsModalWindowView.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/27/25.
//

#import "WindowDemoIsModalWindowView.h"

@interface WindowDemoIsModalWindowView ()
@property (retain, nonatomic, readonly, getter=_label) NSTextField *label;
@end

@implementation WindowDemoIsModalWindowView
@synthesize label = _label;

- (instancetype)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
        NSTextField *label = self.label;
        label.frame = self.bounds;
        label.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        [self addSubview:label];
        
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_windowDidUpdate:) name:NSWindowDidUpdateNotification object:nil];
    }
    
    return self;
}

- (void)dealloc {
    [_label release];
    [super dealloc];
}

- (NSSize)fittingSize {
    return self.label.fittingSize;
}

- (NSSize)intrinsicContentSize {
    return self.label.intrinsicContentSize;
}

- (void)_windowDidUpdate:(NSNotification *)notification {
    if ([notification.object isEqual:self.window]) {
        [self _updateLabel];
    }
}

- (NSTextField *)_label {
    if (auto label = _label) return label;
    
    NSTextField *label = [NSTextField wrappingLabelWithString:@"Pending"];
    
    _label = [label retain];
    return label;
}

- (void)_updateLabel {
    self.label.stringValue = [NSString stringWithFormat:@"Is Modal Window : %@", self.window.floatingPanel ? @"YES" : @"NO"];
}

@end
