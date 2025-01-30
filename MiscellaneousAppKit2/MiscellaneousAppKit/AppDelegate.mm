//
//  AppDelegate.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/23/24.
//

#import "AppDelegate.h"
#import "RootWindowController.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface AppDelegate ()
@property (retain, readonly, nonatomic) RootWindowController *rootWindowController;
@property (retain, nonatomic, nullable) NSStatusItem *statusItem_1;
@end

@implementation AppDelegate
@synthesize rootWindowController = _rootWindowController;

- (void)dealloc {
    [_rootWindowController release];
    [_statusItem_1 release];
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self.rootWindowController showWindow:self];
    [self setupStatusItem];
}

- (RootWindowController *)rootWindowController {
    if (auto rootWindowController = _rootWindowController) return rootWindowController;
    
    RootWindowController *rootWindowController = [RootWindowController new];
    
    _rootWindowController = [rootWindowController retain];
    return [rootWindowController autorelease];
}

- (void)setupStatusItem {
    NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
    
    NSStatusItem *statusItem_1 = [statusBar statusItemWithLength:NSSquareStatusItemLength];
    statusItem_1.button.image = [NSImage imageWithSystemSymbolName:@"airtag.radiowaves.forward.fill" accessibilityDescription:nil];
    
    //
    
    NSMenu *menu_1 = [NSMenu new];
    
    //
    
//    [menu_1 addItem:[NSMenuItem separatorItem]];
    
    NSMenuItem *standardCopyMenuItem = ((id (*)(Class, SEL))objc_msgSend)(NSMenuItem.class, sel_registerName("standardCopyMenuItem"));
    [menu_1 addItem:standardCopyMenuItem];
    
    NSMenuItem *standardDeleteMenuItem = ((id (*)(Class, SEL))objc_msgSend)(NSMenuItem.class, sel_registerName("standardDeleteMenuItem"));
    [menu_1 addItem:standardDeleteMenuItem];
    
    NSMenuItem *standardPasteMenuItem = ((id (*)(Class, SEL))objc_msgSend)(NSMenuItem.class, sel_registerName("standardPasteMenuItem"));
    [menu_1 addItem:standardPasteMenuItem];
    
    NSMenuItem *standardQuickLookMenuItem = ((id (*)(Class, SEL))objc_msgSend)(NSMenuItem.class, sel_registerName("standardQuickLookMenuItem"));
    NSMenuItemBadge *standardQuickLookBadge = [[NSMenuItemBadge alloc] initWithCount:3 type:NSMenuItemBadgeTypeNewItems];
    standardQuickLookMenuItem.badge = standardQuickLookBadge;
    [standardQuickLookBadge release];
    [menu_1 addItem:standardQuickLookMenuItem];
    
    
    //
    
    statusItem_1.menu = menu_1;
    [menu_1 release];
    
    self.statusItem_1 = statusItem_1;
}

@end
