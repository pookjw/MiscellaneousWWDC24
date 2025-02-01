//
//  WindowDemoWindow.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 1/31/25.
//

#import "WindowDemoWindow.h"
#import "WindowDemoViewController.h"

@implementation WindowDemoWindow

- (instancetype)init {
    self = [super initWithContentRect:NSMakeRect(0., 0., 600., 400.) styleMask:NSWindowStyleMaskBorderless | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskFullSizeContentView | NSWindowStyleMaskResizable | NSWindowStyleMaskTitled backing:NSBackingStoreBuffered defer:NO];
    
    if (self) {
        self.title = @"Window Demo";
        self.releasedWhenClosed = NO;
        self.frameAutosaveName = @"WindowDemo";
        self.contentMinSize = NSMakeSize(400., 400.);
        
        WindowDemoViewController *contentViewController = [WindowDemoViewController new];
        self.contentViewController = contentViewController;
        [contentViewController release];
    }
    
    return self;
}

@end
