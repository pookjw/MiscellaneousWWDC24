//
//  ConfigurationButtonItem.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/1/25.
//

#import "ConfigurationButtonItem.h"

@implementation ConfigurationButtonItem

- (void)dealloc {
    [_button release];
    [super dealloc];
}

- (IBAction)_didTriggerButton:(NSButton *)sender {
    if (self.showsMenuAsPrimaryAction) {
        NSMenu *menu = sender.menu;
        assert(menu != nil);
        [NSMenu popUpContextMenu:menu withEvent:sender.window.currentEvent forView:sender];
        return;
    }
    
    id<ConfigurationButtonItemDelegate> delegate = self.delegate;
    if (delegate == nil) return;
    
    [delegate didTriggerButton:self];
}

@end
