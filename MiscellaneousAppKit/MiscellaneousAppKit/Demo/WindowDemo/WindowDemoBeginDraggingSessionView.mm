//
//  WindowDemoBeginDraggingSessionView.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/27/25.
//

#import "WindowDemoBeginDraggingSessionView.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface _WindowDemoBeginDraggingSessionDraggingView : NSView <NSDraggingSource>
@end

@implementation _WindowDemoBeginDraggingSessionDraggingView

- (instancetype)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setBackgroundColor:"), NSColor.whiteColor);
    }
    
    return self;
}

- (NSSize)fittingSize {
    return NSMakeSize(300., 300.);
}

- (NSSize)intrinsicContentSize {
    return NSMakeSize(300., 300.);
}

- (void)mouseDown:(NSEvent *)event {
    NSDraggingItem *item_1 = [[NSDraggingItem alloc] initWithPasteboardWriter:@"Test 1"];
    [item_1 setDraggingFrame:self.bounds contents:[NSImage imageWithSystemSymbolName:@"rectangle.portrait.and.arrow.forward" accessibilityDescription:nil]];
    
    NSDraggingItem *item_2 = [[NSDraggingItem alloc] initWithPasteboardWriter:@"Test 2"];
    [item_2 setDraggingFrame:self.bounds contents:[NSImage imageWithSystemSymbolName:@"pencil.tip" accessibilityDescription:nil]];
    
    NSDraggingSession *session = [self.window beginDraggingSessionWithItems:@[item_1, item_2]
                                                                      event:event
                                                                     source:self];
    [item_1 release];
    [item_2 release];
}

- (NSDragOperation)draggingSession:(NSDraggingSession *)session sourceOperationMaskForDraggingContext:(NSDraggingContext)context {
    return NSDragOperationCopy;
}

- (void)draggingSession:(NSDraggingSession *)session willBeginAtPoint:(NSPoint)screenPoint {
    NSLog(@"%s", __func__);
}

- (void)draggingSession:(NSDraggingSession *)session movedToPoint:(NSPoint)screenPoint {
    NSLog(@"%s", __func__);
}

- (void)draggingSession:(NSDraggingSession *)session endedAtPoint:(NSPoint)screenPoint operation:(NSDragOperation)operation {
    NSLog(@"%s", __func__);
}

- (BOOL)ignoreModifierKeysForDraggingSession:(NSDraggingSession *)session {
    NSLog(@"%s", __func__);
    return NO;
}

@end

@interface WindowDemoBeginDraggingSessionView ()
@property (retain, nonatomic, readonly, getter=_stackView) NSStackView *stackView;
@property (retain, nonatomic, readonly, getter=_draggingView) _WindowDemoBeginDraggingSessionDraggingView *draggingView;
@property (retain, nonatomic, readonly, getter=_label) NSTextField *label;
@end

@implementation WindowDemoBeginDraggingSessionView
@synthesize stackView = _stackView;
@synthesize draggingView = _draggingView;
@synthesize label = _label;

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
    [_draggingView release];
    [_label release];
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
    
    [stackView addArrangedSubview:self.draggingView];
    [stackView addArrangedSubview:self.label];
    
    stackView.orientation = NSUserInterfaceLayoutOrientationVertical;
    stackView.distribution = NSStackViewDistributionFill;
    stackView.alignment = NSLayoutAttributeWidth;
    
    _stackView = stackView;
    return stackView;
}

- (_WindowDemoBeginDraggingSessionDraggingView *)_draggingView {
    if (auto draggingView = _draggingView) return draggingView;
    
    _WindowDemoBeginDraggingSessionDraggingView *draggingView = [_WindowDemoBeginDraggingSessionDraggingView new];
    
    _draggingView = draggingView;
    return draggingView;
}

- (NSTextField *)_label {
    if (auto label = _label) return label;
    
    NSTextField *label = [NSTextField wrappingLabelWithString:@"Pending"];
    label.alignment = NSTextAlignmentCenter;
    
    _label = [label retain];
    return label;
}

@end
