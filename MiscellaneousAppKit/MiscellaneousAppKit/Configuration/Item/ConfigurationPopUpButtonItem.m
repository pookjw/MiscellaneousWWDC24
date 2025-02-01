//
//  ConfigurationPopUpButtonItem.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/1/25.
//

#import "ConfigurationPopUpButtonItem.h"

@implementation ConfigurationPopUpButtonItem

- (void)dealloc {
    [_popUpButton release];
    [super dealloc];
}

- (IBAction)_didTriggerAction:(NSPopUpButton *)sender {
    id<ConfigurationPopUpButtonItemDelegate> delegate = self.delegate;
    if (delegate == nil) return;
    
    [delegate configurationPopUpButtonItem:self didSelectItem:sender.selectedItem];
}

@end
