//
//  MainWindowController.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 1/31/25.
//

#import "MainWindowController.h"
#import "MainWindow.h"
#import "MainViewController.h"

@interface MainWindowController ()

@end

@implementation MainWindowController

- (instancetype)init {
    MainWindow *window = [[MainWindow alloc] initWithContentRect:NSMakeRect(0., 0., 600., 400.) styleMask:NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskFullSizeContentView | NSWindowStyleMaskResizable | NSWindowStyleMaskTitled backing:NSBackingStoreBuffered defer:NO];
    
    window.title = NSProcessInfo.processInfo.processName;
    window.releasedWhenClosed = NO;
    window.movableByWindowBackground = YES;
    
    MainViewController *mainViewController = [MainViewController new];
    window.contentViewController = mainViewController;
    [mainViewController release];
    
    if (self = [super initWithWindow:window]) {
        self.windowFrameAutosaveName = @"Main";
    }
    
    [window release];
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
