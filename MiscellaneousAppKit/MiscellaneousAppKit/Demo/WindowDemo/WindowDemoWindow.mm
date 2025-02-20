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

@interface WindowDemoWindow ()
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

- (void)cmdForTryToPerformWith:(id)object {
    NSAlert *alert = [NSAlert new];
    alert.messageText = @"Alert";
    alert.informativeText = @"Responded!";
    
    [alert beginSheetModalForWindow:self completionHandler:^(NSModalResponse returnCode) {
        
    }];
    
    [alert release];
}

@end
