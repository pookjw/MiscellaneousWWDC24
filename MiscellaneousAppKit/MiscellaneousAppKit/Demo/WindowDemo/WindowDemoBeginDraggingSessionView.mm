//
//  WindowDemoBeginDraggingSessionView.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/27/25.
//

#import "WindowDemoBeginDraggingSessionView.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface WindowDemoBeginDraggingSessionView () <NSDraggingSource>
@end

@implementation WindowDemoBeginDraggingSessionView

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
    abort();
}

- (NSDragOperation)draggingSession:(NSDraggingSession *)session sourceOperationMaskForDraggingContext:(NSDraggingContext)context {
    abort();
}

- (void)draggingSession:(NSDraggingSession *)session willBeginAtPoint:(NSPoint)screenPoint {
    abort();
}

- (void)draggingSession:(NSDraggingSession *)session movedToPoint:(NSPoint)screenPoint {
    abort();
}

- (void)draggingSession:(NSDraggingSession *)session endedAtPoint:(NSPoint)screenPoint operation:(NSDragOperation)operation {
    abort();
}

- (BOOL)ignoreModifierKeysForDraggingSession:(NSDraggingSession *)session {
    abort();
}

@end
