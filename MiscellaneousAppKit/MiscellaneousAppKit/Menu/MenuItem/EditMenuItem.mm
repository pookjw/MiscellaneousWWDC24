//
//  EditMenuItem.mm
//  Swain
//
//  Created by Jinwoo Kim on 2/6/24.
//

#import "EditMenuItem.hpp"
#import <objc/runtime.h>
#import <objc/message.h>
#import "NSBundle+MA_Category.h"

@interface EditMenuItem ()
@property (retain, readonly, nonatomic) NSMenuItem *emi_copyMenuItem;
@property (retain, readonly, nonatomic) NSMenuItem *deleteMenuItem;
@property (retain, readonly, nonatomic) NSMenuItem *pasteMenuItem;
@property (retain, readonly, nonatomic) NSMenuItem *selectAllMenuItem;
@end

@implementation EditMenuItem
@synthesize emi_copyMenuItem = _emi_copyMenuItem;
@synthesize deleteMenuItem = _deleteMenuItem;
@synthesize pasteMenuItem = _pasteMenuItem;
@synthesize selectAllMenuItem = _selectAllMenuItem;

- (instancetype)initWithTitle:(NSString *)string action:(SEL)selector keyEquivalent:(NSString *)charCode {
    if (self = [super initWithTitle:string action:selector keyEquivalent:charCode]) {
        [self commonInit_EditMenuItem];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self commonInit_EditMenuItem];
    }
    
    return self;
}

- (void)dealloc {
    [_emi_copyMenuItem release];
    [_deleteMenuItem release];
    [_pasteMenuItem release];
    [_selectAllMenuItem release];
    [super dealloc];
}

- (void)commonInit_EditMenuItem __attribute__((objc_direct)) {
    NSMenu *submenu = [NSMenu new];
    
    [submenu addItem:self.emi_copyMenuItem];
    [submenu addItem:self.deleteMenuItem];
    [submenu addItem:self.pasteMenuItem];
    [submenu addItem:[NSMenuItem separatorItem]];
    [submenu addItem:self.selectAllMenuItem];
    
    self.submenu = submenu;
    [submenu release];
}

- (NSMenuItem *)emi_copyMenuItem {
    if (auto emi_copyMenuItem = _emi_copyMenuItem) return emi_copyMenuItem;
    
    NSMenuItem *emi_copyMenuItem = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(NSMenuItem.class, sel_registerName("standardCopyMenuItem"));
    emi_copyMenuItem.keyEquivalent = @"c";
    
    _emi_copyMenuItem = [emi_copyMenuItem retain];
    return emi_copyMenuItem;
}

- (NSMenuItem *)deleteMenuItem {
    if (auto deleteMenuItem = _deleteMenuItem) return deleteMenuItem;
    
    NSMenuItem *deleteMenuItem = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(NSMenuItem.class, sel_registerName("standardDeleteMenuItem"));
    deleteMenuItem.keyEquivalent = @"\u{08}";
    deleteMenuItem.keyEquivalentModifierMask = NSEventModifierFlagCommand;
    
    _deleteMenuItem = [deleteMenuItem retain];
    return deleteMenuItem;
}

- (NSMenuItem *)pasteMenuItem {
    if (auto pasteMenuItem = _pasteMenuItem) return pasteMenuItem;
    
    NSMenuItem *pasteMenuItem = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(NSMenuItem.class, sel_registerName("standardPasteMenuItem"));
    pasteMenuItem.keyEquivalent = @"v";
    
    _pasteMenuItem = [pasteMenuItem retain];
    return pasteMenuItem;
}

- (NSMenuItem *)selectAllMenuItem {
    if (auto selectAllMenuItem = _selectAllMenuItem) return selectAllMenuItem;
    
    NSString *title = _NXKitString(@"FindPanel", @"Select All");
    NSMenuItem *selectAllMenuItem = [[NSMenuItem alloc] initWithTitle:title action:@selector(selectAll:) keyEquivalent:@"a"];
    
    _selectAllMenuItem = [selectAllMenuItem retain];
    return [selectAllMenuItem autorelease];
}

@end
