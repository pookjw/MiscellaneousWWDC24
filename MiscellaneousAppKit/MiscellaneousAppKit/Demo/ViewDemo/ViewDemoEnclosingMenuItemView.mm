//
//  ViewDemoEnclosingMenuItemView.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 3/4/25.
//

#import "ViewDemoEnclosingMenuItemView.h"

@interface ViewDemoEnclosingMenuItemView ()
@property (retain, nonatomic, readonly, getter=_label) NSTextField *label;
@end

@implementation ViewDemoEnclosingMenuItemView
@synthesize label = _label;

- (instancetype)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
        NSTextField *label = self.label;
        label.frame = self.bounds;
        label.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        [self addSubview:label];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        _label = [[self viewWithTag:100] retain];
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

- (void)viewDidMoveToSuperview {
    [super viewDidMoveToSuperview];
    
    // -[NSCustomMenuItemView _enclosingMenuItem]
    if (NSMenuItem *enclosingMenuItem = self.enclosingMenuItem) {
        self.label.stringValue = enclosingMenuItem.description;
    } else {
        self.label.stringValue = @"(null)";
    }
}

- (NSTextField *)_label {
    if (auto label = _label) return label;
    
    NSTextField *label = [NSTextField wrappingLabelWithString:@"Pending"];
    label.tag = 100;
    
    _label = [label retain];
    return label;
}

@end
