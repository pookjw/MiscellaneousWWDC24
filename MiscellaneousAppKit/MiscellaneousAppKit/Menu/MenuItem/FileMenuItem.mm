//
//  FileMenuItem.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 1/31/25.
//

#import "FileMenuItem.h"

@interface FileMenuItem ()
@property (retain, readonly, nonatomic, getter=_closeMenuItem) NSMenuItem *closeMenuItem;
@end

@implementation FileMenuItem
@synthesize closeMenuItem = _closeMenuItem;

- (instancetype)initWithTitle:(NSString *)string action:(SEL)selector keyEquivalent:(NSString *)charCode {
    if (self = [super initWithTitle:string action:selector keyEquivalent:charCode]) {
        [self commonInit_FileMenuItem];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self commonInit_FileMenuItem];
    }
    
    return self;
}

- (void)dealloc {
    [_closeMenuItem release];
    [super dealloc];
}

- (void)commonInit_FileMenuItem {
    NSMenu *submenu = [NSMenu new];
    
    [submenu addItem:self.closeMenuItem];
    
    self.submenu = submenu;
    [submenu release];
}

- (NSMenuItem *)_closeMenuItem {
    if (auto closeMenuItem = _closeMenuItem) return closeMenuItem;
    
    NSMenuItem *closeMenuItem = [[NSMenuItem alloc] initWithTitle:@"Close" action:@selector(selectAll:) keyEquivalent:@"w"];
    closeMenuItem.action = @selector(performClose:);
    
    _closeMenuItem = closeMenuItem;
    return closeMenuItem;
}

@end
