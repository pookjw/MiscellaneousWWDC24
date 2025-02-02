//
//  AppDelegate.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 1/31/25.
//

#import "AppDelegate.h"
#import "MainWindowController.h"
#import "BaseMenu.hpp"
#import "NSWindow+MA_Category.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

- (void)dealloc {
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    startWindowActiveSpaceObservation();
    
    BaseMenu *menu = [BaseMenu new];
    NSApplication.sharedApplication.menu = menu;
    [menu release];
    
    MainWindowController *mainWindowController = [MainWindowController new];
    [mainWindowController showWindow:nil];
    [mainWindowController release];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    
}

- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)hasVisibleWindows {
    if (!hasVisibleWindows) {
        MainWindowController *mainWindowController = [MainWindowController new];
        [mainWindowController showWindow:nil];
        [mainWindowController release];
        return NO;
    }
    
    return YES;
}

- (NSMenu *)applicationDockMenu:(NSApplication *)sender {
    return nil;
}

@end
