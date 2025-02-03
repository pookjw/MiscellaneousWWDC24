//
//  MyMenu.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/3/25.
//

#import "MyMenu.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "NSBundle+MA_Category.h"

@interface MyMenu ()
@property (retain, nonatomic, readonly, getter=_applicationMenuItem) NSMenuItem *applicationMenuItem;
@property (retain, nonatomic, readonly, getter=_fileMenuItem) NSMenuItem *fileMenuItem;
@property (retain, nonatomic, readonly, getter=_editMenuItem) NSMenuItem *editMenuItem;
@property (retain, nonatomic, readonly, getter=_servicesMenuItem) NSMenuItem *servicesMenuItem;
@property (retain, nonatomic, readonly, getter=_windowMenuItem) NSMenuItem *windowMenuItem;
@property (retain, nonatomic, readonly, getter=_helpMenuItem) NSMenuItem *helpMenuItem;


@end

@implementation MyMenu
@synthesize applicationMenuItem = _applicationMenuItem;
@synthesize fileMenuItem = _fileMenuItem;
@synthesize editMenuItem = _editMenuItem;
@synthesize servicesMenuItem = _servicesMenuItem;
@synthesize windowMenuItem = _windowMenuItem;
@synthesize helpMenuItem = _helpMenuItem;

- (instancetype)initWithTitle:(NSString *)title {
    if (self = [super initWithTitle:title]) {
        [self _commonInit_BaseMenu];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self _commonInit_BaseMenu];
    }
    
    return self;
}

- (void)dealloc {
    [_applicationMenuItem release];
    [_fileMenuItem release];
    [_editMenuItem release];
    [_servicesMenuItem release];
    [_windowMenuItem release];
    [_helpMenuItem release];
    [super dealloc];
}

- (void)_commonInit_BaseMenu {
    [self addItem:self.applicationMenuItem];
    [self addItem:self.fileMenuItem];
    [self addItem:self.editMenuItem];
    [self addItem:self.servicesMenuItem];
    [self addItem:self.windowMenuItem];
    [self addItem:self.helpMenuItem];
}

- (NSMenu *)windowMenu {
    return self.windowMenuItem.submenu;
}

- (NSMenu *)servicesMenu {
    return self.servicesMenuItem.submenu;
}

- (NSMenu *)helpMenu {
    return self.helpMenuItem.submenu;
}

- (NSMenuItem *)_applicationMenuItem {
    if (auto applicationMenuItem = _applicationMenuItem) return applicationMenuItem;
    
    NSMenuItem *applicationMenuItem = [NSMenuItem new];
    
    NSMenu *submenu = [NSMenu new];
    
    //
    
    NSMenuItem *hideMenuItem = [[NSMenuItem alloc] initWithTitle:_NXKitString(@"Common", @"Hide") action:@selector(hide:) keyEquivalent:@"h"];
    [submenu addItem:hideMenuItem];
    [hideMenuItem release];
    
    //
    
    applicationMenuItem.submenu = submenu;
    [submenu release];
    
    _applicationMenuItem = applicationMenuItem;
    return applicationMenuItem;
}

- (NSMenuItem *)_fileMenuItem {
    if (auto fileMenuItem = _fileMenuItem) return fileMenuItem;
    
    NSString *title = _NXKitString(@"MenuCommands", @"File");
    NSMenuItem *fileMenuItem = [[NSMenuItem alloc] initWithTitle:title action:nil keyEquivalent:@""];
    
    NSMenu *submenu = [NSMenu new];
    
    //
    
    NSMenuItem *closeMenuItem = [[NSMenuItem alloc] initWithTitle:_NXKitString(@"WindowTabs", @"Close") action:@selector(selectAll:) keyEquivalent:@"w"];
    closeMenuItem.action = @selector(performClose:);
    [submenu addItem:closeMenuItem];
    [closeMenuItem release];
    
    //
    
    fileMenuItem.submenu = submenu;
    [submenu release];
    
    _fileMenuItem = fileMenuItem;
    return fileMenuItem;
}

- (NSMenuItem *)_editMenuItem {
    if (auto editMenuItem = _editMenuItem) return editMenuItem;
    
    NSString *title = _NXKitString(@"InputManager", @"Edit");
    NSMenuItem *editMenuItem = [[NSMenuItem alloc] initWithTitle:title action:NULL keyEquivalent:@""];
    
    NSMenu *submenu = [NSMenu new];
    
    //
    
    NSMenuItem *copyMenuItem = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(NSMenuItem.class, sel_registerName("standardCopyMenuItem"));
    copyMenuItem.keyEquivalent = @"c";
    [submenu addItem:copyMenuItem];
    [copyMenuItem release];
    
    NSMenuItem *deleteMenuItem = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(NSMenuItem.class, sel_registerName("standardDeleteMenuItem"));
    deleteMenuItem.keyEquivalent = @"\u{08}";
    deleteMenuItem.keyEquivalentModifierMask = NSEventModifierFlagCommand;
    [submenu addItem:deleteMenuItem];
    [deleteMenuItem release];
    
    NSMenuItem *pasteMenuItem = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(NSMenuItem.class, sel_registerName("standardPasteMenuItem"));
    pasteMenuItem.keyEquivalent = @"v";
    [submenu addItem:pasteMenuItem];
    [pasteMenuItem release];
    
    NSMenuItem *selectAllMenuItem = [[NSMenuItem alloc] initWithTitle:_NXKitString(@"FindPanel", @"Select All") action:@selector(selectAll:) keyEquivalent:@"a"];
    [submenu addItem:selectAllMenuItem];
    [selectAllMenuItem release];
    
    NSMenuItem *sectionHeaderMenuItem = [NSMenuItem sectionHeaderWithTitle:@"Header"];
    [submenu addItem:sectionHeaderMenuItem];
    
    //
    
    editMenuItem.submenu = submenu;
    [submenu release];
    
    _editMenuItem = editMenuItem;
    return editMenuItem;
}

- (NSMenuItem *)_servicesMenuItem {
    if (auto servicesMenuItem = _servicesMenuItem) return servicesMenuItem;
    
    NSString *title = _NXKitString(@"Services", @"Services");
    NSMenuItem *servicesMenuItem = [[NSMenuItem alloc] initWithTitle:title action:nil keyEquivalent:@""];
    
    NSMenu *submenu = [NSMenu new];
    servicesMenuItem.submenu = submenu;
    [submenu release];
    
    _servicesMenuItem = servicesMenuItem;
    return servicesMenuItem;
}

- (NSMenuItem *)_windowMenuItem {
    if (auto windowMenuItem = _windowMenuItem) return windowMenuItem;
    
    NSString *title = _NXKitString(@"MenuCommands", @"Window");
    NSMenuItem *windowMenuItem = [[NSMenuItem alloc] initWithTitle:title action:nil keyEquivalent:@""];
    
    NSMenu *submenu = [NSMenu new];
    windowMenuItem.submenu = submenu;
    [submenu release];
    
    _windowMenuItem = windowMenuItem;
    return windowMenuItem;
}

- (NSMenuItem *)_helpMenuItem {
    if (auto helpMenuItem = _helpMenuItem) return helpMenuItem;
    
    NSString *title = _NXKitString(@"MenuCommands", @"Help");
    NSMenuItem *helpMenuItem = [[NSMenuItem alloc] initWithTitle:title action:nil keyEquivalent:@""];
    
    NSMenu *submenu = [NSMenu new];
    helpMenuItem.submenu = submenu;
    [submenu release];
    
    _helpMenuItem = helpMenuItem;
    return helpMenuItem;
}

@end
