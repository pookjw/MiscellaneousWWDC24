//
//  StagedWindowViewController.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/29/24.
//

#import "StagedWindowViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface StagedWindowViewController ()
@property (retain, readonly, nonatomic) NSButton *presentWindowButton;
@end

@implementation StagedWindowViewController
@synthesize presentWindowButton = _presentWindowButton;

- (void)dealloc {
    [_presentWindowButton release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSButton *presentWindowButton = self.presentWindowButton;
    presentWindowButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:presentWindowButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [presentWindowButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [presentWindowButton.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor]
    ]];
}

- (NSButton *)presentWindowButton {
    if (auto presentWindowButton = _presentWindowButton) return presentWindowButton;
    
    NSButton *presentWindowButton = [NSButton buttonWithTitle:@"Present Window" target:self action:@selector(presentWindowButtonDidTrigger:)];
    
    _presentWindowButton = [presentWindowButton retain];
    return presentWindowButton;
}

- (void)presentWindowButtonDidTrigger:(NSButton *)sender {
    NSWindow *window = [[NSWindow alloc] initWithContentRect:NSMakeRect(0., 0., 600., 400.) styleMask:NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskFullSizeContentView | NSWindowStyleMaskResizable | NSWindowStyleMaskTitled backing:NSBackingStoreBuffered defer:YES];
    
    [window setFrameOrigin:self.view.window.frame.origin];
    window.releasedWhenClosed = NO;
    window.title = NSProcessInfo.processInfo.processName;
    
    NSViewController *contentViewController = [NSViewController new];
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(contentViewController.view, sel_registerName("setBackgroundColor:"), NSColor.systemOrangeColor);
    
    window.contentViewController = contentViewController;
    [contentViewController release];
    
    window.collectionBehavior = NSWindowCollectionBehaviorFullScreenPrimary;
    [window makeKeyAndOrderFront:nil];
    NSStatusWindowLevel;
    CGWindowLevel f = kCGDesktopWindowLevel;
    [window release];
}

@end
