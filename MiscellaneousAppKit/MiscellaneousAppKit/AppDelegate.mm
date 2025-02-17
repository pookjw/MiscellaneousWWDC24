//
//  AppDelegate.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 1/31/25.
//

#import "AppDelegate.h"
#import "MainWindowController.h"
#import "MyMenu.h"
#import "NSWindow+MA_Category.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface AppDelegate ()
@end

@implementation AppDelegate

- (void)dealloc {
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    startWindowActiveSpaceObservation();
    NSLog(@"%s", getenv("MTC_APPKIT_SUPPRESSIONS"));
    
    MyMenu *menu = [MyMenu new];
    [NSApp setServicesMenu:menu.servicesMenu];
    [NSApp setWindowsMenu:menu.windowMenu];
    [NSApp setHelpMenu:menu.helpMenu];
    
    NSApp.mainMenu = menu;
    [menu release];
    
//    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(NSApp, sel_registerName("_customizeQuitMenuItem"));
    
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
