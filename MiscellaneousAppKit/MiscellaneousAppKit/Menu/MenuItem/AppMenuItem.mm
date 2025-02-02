//
//  AppMenuItem.mm
//  Swain
//
//  Created by Jinwoo Kim on 2/6/24.
//

#import "AppMenuItem.hpp"
#import "NSBundle+MA_Category.h"

@interface AppMenuItem ()
@property (retain, readonly, nonatomic, getter=_hideMenuItem) NSMenuItem *hideMenuItem;
@end

@implementation AppMenuItem
@synthesize hideMenuItem = _hideMenuItem;

- (instancetype)initWithTitle:(NSString *)string action:(SEL)selector keyEquivalent:(NSString *)charCode {
    if (self = [super initWithTitle:string action:selector keyEquivalent:charCode]) {
        [self _commonInit_AppMenuItem];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self _commonInit_AppMenuItem];
    }
    
    return self;
}

- (void)dealloc {
    [_hideMenuItem release];
    [super dealloc];
}

- (void)_commonInit_AppMenuItem __attribute__((objc_direct)) {
    NSMenu *submenu = [NSMenu new];
    
    [submenu addItem:self.hideMenuItem];
    
    self.submenu = submenu;
    [submenu release];
}

- (NSMenuItem *)_hideMenuItem {
    if (auto hideMenuItem = _hideMenuItem) return hideMenuItem;
    
    NSString *title = _NXKitString(@"Common", @"Hide");
    NSMenuItem *hideMenuItem = [[NSMenuItem alloc] initWithTitle:title action:@selector(hide:) keyEquivalent:@"h"];
    
    _hideMenuItem = hideMenuItem;
    return hideMenuItem;
}

@end
