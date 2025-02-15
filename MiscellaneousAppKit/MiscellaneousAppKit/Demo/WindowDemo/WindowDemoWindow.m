//
//  WindowDemoWindow.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 1/31/25.
//

#import "WindowDemoWindow.h"
#import "WindowDemoViewController.h"
#include <unistd.h>

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
        
        WindowDemoViewController *contentViewController = [WindowDemoViewController new];
        self.contentViewController = contentViewController;
        [contentViewController release];
    }
    
    return self;
}

@end
