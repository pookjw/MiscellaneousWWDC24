//
//  NSMenuItem+MAPopUpButton.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/28/24.
//

#import "NSMenuItem+MAPopUpButton.h"
#import <objc/runtime.h>

@implementation NSMenuItem (MAPopUpButton)

- (NSPopUpButton *)MA_popupButton {
    // _NSMenuImpl
    id _extra;
    object_getInstanceVariable(self.menu, "_extra", (void **)&_extra);
    
    __kindof NSView *_menuOwner;
    object_getInstanceVariable(_extra, "_menuOwner", (void **)&_menuOwner);
    
    NSPopUpButtonCell *cell = (NSPopUpButtonCell *)_menuOwner;
    NSPopUpButton *button = (NSPopUpButton *)cell.controlView;
    
    return button;
}

@end
