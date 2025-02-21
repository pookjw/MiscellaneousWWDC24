//
//  WindowDemoWindow.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 1/31/25.
//

#import "WindowDemoWindow.h"
#import "WindowDemoViewController.h"
#import "WindowDemoWindowDelegate.h"
#include <unistd.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import "WindowDemoRestoration.h"

@interface WindowDemoWindow () <NSDraggingSource>
@property (retain, nonatomic, readonly) WindowDemoWindowDelegate *ownDelegate;
@end

@implementation WindowDemoWindow

- (instancetype)init {
    self = [super initWithContentRect:NSMakeRect(0., 0., 400, 800.) styleMask:NSWindowStyleMaskBorderless | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable | NSWindowStyleMaskTitled backing:NSBackingStoreBuffered defer:NO];
    
    if (self) {
//        self.title = @"Window Demo";
        self.title = [NSString stringWithFormat:@"%d %d", getuid(), geteuid()];
        self.releasedWhenClosed = NO;
        self.frameAutosaveName = @"WindowDemo";
        self.contentMinSize = NSMakeSize(400., 800.);
        self.canBecomeVisibleWithoutLogin = YES;
        self.restorationClass = [WindowDemoRestoration class];
        self.restorable = YES;
        self.allowsConcurrentViewDrawing = YES;
        
        WindowDemoWindowDelegate *ownDelegate = [WindowDemoWindowDelegate new];
        self.delegate = ownDelegate;
        _ownDelegate = ownDelegate;
        
        WindowDemoViewController *contentViewController = [WindowDemoViewController new];
        self.contentViewController = contentViewController;
        [contentViewController release];
    }
    
    return self;
}

- (void)dealloc {
    [_ownDelegate release];
    [super dealloc];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if (sel_isEqual(aSelector, @selector(cmdForTryToPerformWith:))) {
        return self.tryToPerformEnabled;
    }
    
    return [super respondsToSelector:aSelector];
}

- (void)becomeKeyWindow {
    [super becomeKeyWindow];
    NSLog(@"%s", __func__);
}

- (void)resignKeyWindow {
    [super resignKeyWindow];
    NSLog(@"%s", __func__);
}

- (void)becomeMainWindow {
    [super becomeMainWindow];
    NSLog(@"%s", __func__);
}

- (void)resignMainWindow {
    [super resignMainWindow];
    NSLog(@"%s", __func__);
}

- (void)update {
    [super update];
//    NSLog(@"%s", __func__);
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder backgroundQueue:(NSOperationQueue *)queue {
    [super encodeRestorableStateWithCoder:coder backgroundQueue:queue];
    [self.contentViewController encodeRestorableStateWithCoder:coder backgroundQueue:queue];
}

- (void)restoreStateWithCoder:(NSCoder *)coder {
    [super restoreStateWithCoder:coder];
    [self.contentViewController restoreStateWithCoder:coder];
}

- (void)cmdForTryToPerformWith:(id)object {
    NSAlert *alert = [NSAlert new];
    alert.messageText = @"Alert";
    alert.informativeText = @"Responded!";
    
    [alert beginSheetModalForWindow:self completionHandler:^(NSModalResponse returnCode) {
        
    }];
    
    [alert release];
}

- (void)mouseDown:(NSEvent *)event {
    NSMutableSet<NSString *> * _Nullable _dragTypes;
    assert(object_getInstanceVariable(self, "_dragTypes", reinterpret_cast<void **>(&_dragTypes)) != NULL);

    if ((_dragTypes == nil) or (_dragTypes.count == 0)) {
        [super mouseDown:event];
        return;
    }
    
    NSPoint location = [event locationInWindow];
    NSDraggingItem *item_1 = [[NSDraggingItem alloc] initWithPasteboardWriter:@"Test 1"];
    [item_1 setDraggingFrame:NSMakeRect(location.x, location.y, 100., 100.) contents:[NSImage imageWithSystemSymbolName:@"apple.intelligence" accessibilityDescription:nil]];
    NSDraggingItem *item_2 = [[NSDraggingItem alloc] initWithPasteboardWriter:@"Test 2"];
    [item_2 setDraggingFrame:NSMakeRect(location.x, location.y, 100., 100.) contents:[NSImage imageWithSystemSymbolName:@"apple.writing.tools" accessibilityDescription:nil]];
    [self beginDraggingSessionWithItems:@[item_1, item_2] event:event source:self];
    [item_1 release];
    [item_2 release];
}

- (NSDragOperation)draggingSession:(nonnull NSDraggingSession *)session sourceOperationMaskForDraggingContext:(NSDraggingContext)context {
    NSLog(@"draggingSession %@", session);
    return NSDragOperationCopy;
}

@end
