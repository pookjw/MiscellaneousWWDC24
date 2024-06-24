//
//  BaseMenu.mm
//  Swain
//
//  Created by Jinwoo Kim on 2/6/24.
//

#import "BaseMenu.hpp"
#import "AppMenuItem.hpp"
#import "EditMenuItem.hpp"

__attribute__((objc_direct_members))
@interface BaseMenu () {
    AppMenuItem *_appMenuItem;
    EditMenuItem *_editMenuItem;
}
@property (retain, readonly, nonatomic) AppMenuItem *appMenuItem;
@property (retain, readonly, nonatomic) EditMenuItem *editMenuItem;
@end

@implementation BaseMenu

- (instancetype)initWithTitle:(NSString *)title {
    if (self = [super initWithTitle:title]) {
        [self commonInit_BaseMenu];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self commonInit_BaseMenu];
    }
    
    return self;
}

- (void)dealloc {
    [_appMenuItem release];
    [_editMenuItem release];
    [super dealloc];
}

- (void)commonInit_BaseMenu __attribute__((objc_direct)) {
    [self addItem:self.appMenuItem];
    [self addItem:self.editMenuItem];
}

- (AppMenuItem *)appMenuItem {
    if (auto appMenuItem = _appMenuItem) return appMenuItem;
    
    AppMenuItem *appMenuItem = [AppMenuItem new];
    
    _appMenuItem = [appMenuItem retain];
    return [appMenuItem autorelease];
}

- (EditMenuItem *)editMenuItem {
    if (auto editMenuItem = _editMenuItem) return editMenuItem;
    
    EditMenuItem *editMenuItem = [[EditMenuItem alloc] initWithTitle:@"File" action:nil keyEquivalent:[NSString string]];
    
    _editMenuItem = [editMenuItem retain];
    return [editMenuItem autorelease];
}

@end
