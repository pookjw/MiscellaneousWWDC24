//
//  HUDWindowPresenterViewController.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 7/1/24.
//

#import "HUDWindowPresenterViewController.h"

@interface HUDWindowPresenterViewController ()
@property (retain, readonly, nonatomic) NSButton *presentWindowButton;
@end

@implementation HUDWindowPresenterViewController

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
    NSWindow *window = [[NSPanel alloc] initWithContentRect:NSMakeRect(0., 0., 600., 400.) styleMask:NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskFullSizeContentView | NSWindowStyleMaskResizable | NSWindowStyleMaskTitled | NSWindowStyleMaskUtilityWindow backing:NSBackingStoreBuffered defer:YES];
    
    [window setFrameOrigin:self.view.window.frame.origin];
    window.releasedWhenClosed = NO;
    window.title = NSProcessInfo.processInfo.processName;
    
    NSViewController *contentViewController = [NSViewController new];
    
    window.contentViewController = contentViewController;
    [contentViewController release];
    
    [window makeKeyAndOrderFront:nil];
    [window release];
}

@end
