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
        
        [NSApp addObserver:self forKeyPath:@"modalWindow" options:NSKeyValueObservingOptionNew context:NULL];
    }
    
    return self;
}

- (void)dealloc {
    [_label release];
    [super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"modalWindow"] and [object isKindOfClass:[NSApplication class]]) {
        [self _updateLabel];
        return;
    }
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (NSSize)fittingSize {
    return self.label.fittingSize;
}

- (NSSize)intrinsicContentSize {
    return self.label.intrinsicContentSize;
}

//- (void)viewWillMoveToWindow:(NSWindow *)newWindow {
//    [super viewWillMoveToWindow:newWindow];
//    [self.window removeObserver:self forKeyPath:@"isModalPanel"];
//}
//
//- (void)viewDidMoveToWindow {
//    [super viewDidMoveToWindow];
//    
//    if (NSWindow *window = self.window) {
//        [window addObserver:self forKeyPath:@"isModalPanel" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:NULL];
//    }
//}

- (NSTextField *)_label {
    if (auto label = _label) return label;
    
    NSTextField *label = [NSTextField wrappingLabelWithString:@"Pending"];
    
    _label = [label retain];
    return label;
}

- (void)_updateLabel {
    self.label.stringValue = [NSString stringWithFormat:@"Is Modal Window : %@", self.window.modalPanel ? @"YES" : @"NO"];
}

@end
