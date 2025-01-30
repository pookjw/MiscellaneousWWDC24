//
//  RootWindowController.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/23/24.
//

#import "RootWindowController.h"
#import "RootSplitViewController.h"

@interface RootWindow : NSWindow
@end

@implementation RootWindow

//- (void)_resetDragMargins {}

@end

@interface RootWindowController () <NSWindowDelegate>
@property (retain, readonly, nonatomic) RootSplitViewController *rootSplitViewController;
@property (retain, readonly, nonatomic) NSToolbar *toolbar;
@end

@implementation RootWindowController
@synthesize rootSplitViewController = _rootSplitViewController;
@synthesize toolbar = _toolbar;

- (BOOL)respondsToSelector:(SEL)aSelector {
    BOOL result = [super respondsToSelector:aSelector];
    
    if (!result) {
        NSLog(@"%s", sel_getName(aSelector));
    }
    
    return result;
}

- (instancetype)init {
    NSWindow *window = [[RootWindow alloc] initWithContentRect:NSMakeRect(0., 0., 600., 400.) styleMask:NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskFullSizeContentView | NSWindowStyleMaskResizable | NSWindowStyleMaskTitled backing:NSBackingStoreBuffered defer:YES];
    
    window.title = NSProcessInfo.processInfo.processName;
    window.releasedWhenClosed = NO;
    window.movableByWindowBackground = YES;
    
    if (self = [super initWithWindow:window]) {
        RootSplitViewController *rootSplitViewController = self.rootSplitViewController;
        window.contentViewController = rootSplitViewController;
        
//        window.toolbar = self.toolbar;
        window.delegate = self;
    }
    
    [window release];
    
    return self;
}

- (void)dealloc {
    [_rootSplitViewController release];
    [_toolbar release];
    [super dealloc];
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
}

- (RootSplitViewController *)rootSplitViewController {
    if (auto rootSplitViewController = _rootSplitViewController) return rootSplitViewController;
    
    RootSplitViewController *rootSplitViewController = [RootSplitViewController new];
    
    _rootSplitViewController = [rootSplitViewController retain];
    return [rootSplitViewController autorelease];
}

- (NSToolbar *)toolbar {
    if (auto toolbar = _toolbar) return toolbar;
    
    NSToolbar *toolbar = [NSToolbar new];
    
    _toolbar = [toolbar retain];
    return [toolbar autorelease];
}

- (NSRect)windowWillUseStandardFrame:(NSWindow *)window defaultFrame:(NSRect)newFrame {
    return NSMakeRect(window.frame.origin.x, window.frame.origin.y, 300., 300.);
}

@end
