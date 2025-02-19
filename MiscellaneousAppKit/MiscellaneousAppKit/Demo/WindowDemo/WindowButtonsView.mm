//
//  WindowButtonsView.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/19/25.
//

#import "WindowButtonsView.h"
#import "NSStringFromNSWindowButton.h"
#include <ranges>

@interface WindowButtonsView ()
@property (retain, nonatomic, readonly, getter=_gridView) NSGridView *gridView;
@end

@implementation WindowButtonsView
@synthesize gridView = _gridView;

- (instancetype)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
        NSGridView *gridView = self.gridView;
        gridView.frame = self.bounds;
        gridView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        [self addSubview:gridView];
    }
    
    return self;
}

- (void)dealloc {
    [_gridView release];
    [self.window removeObserver:self forKeyPath:@"styleMask"];
    [super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"styleMask"] or ([object isKindOfClass:[NSWindow class]])) {
        [self _didChangeStyleMask];
        return;
    }
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)viewWillMoveToWindow:(NSWindow *)newWindow {
    [super viewWillMoveToWindow:newWindow];
    
    if (NSWindow *oldWindow = self.window) {
        [oldWindow removeObserver:self forKeyPath:@"styleMask"];
    }
}

- (void)viewDidMoveToWindow {
    [super viewDidMoveToWindow];
    
    if (NSWindow *newWindow = self.window) {
        [newWindow addObserver:self forKeyPath:@"styleMask" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:NULL];
    }
}

- (NSGridView *)_gridView {
    if (auto gridView = _gridView) return gridView;
    
    NSGridView *gridView = [NSGridView new];
    gridView.xPlacement = NSGridCellPlacementCenter;
    gridView.yPlacement = NSGridCellPlacementCenter;
    
    _gridView = gridView;
    return gridView;
}

- (void)_didChangeStyleMask {
    NSGridView *gridView = self.gridView;
    
    for (NSInteger row : std::views::iota(0, gridView.numberOfRows) | std::views::reverse) {
        [gridView removeRowAtIndex:row];
    }
    
    for (NSInteger columns : std::views::iota(0, gridView.numberOfColumns) | std::views::reverse) {
        [gridView removeColumnAtIndex:columns];
    }
    
    for (NSView *subview in gridView.subviews) {
        [subview removeFromSuperview];
    }
    
    NSWindowStyleMask styleMask = self.window.styleMask;
    
    NSUInteger count;
    NSWindowButton *allWindowButtons = allNSWindowButtons(&count);
    
    for (NSWindowButton *windowButtonPtr : std::views::iota(allWindowButtons, allWindowButtons + count)) {
        NSWindowButton windowButton = *windowButtonPtr;
        
        NSString *string = NSStringFromNSWindowButton(windowButton);
        NSTextField *textField = [NSTextField wrappingLabelWithString:string];
        
        // or -standardWindowButton:
        if (NSButton *button = [NSWindow standardWindowButton:windowButton forStyleMask:styleMask]) {
            [gridView addRowWithViews:@[textField, button]];
        } else {
            [gridView addRowWithViews:@[textField]];
        }
    }
}

@end
