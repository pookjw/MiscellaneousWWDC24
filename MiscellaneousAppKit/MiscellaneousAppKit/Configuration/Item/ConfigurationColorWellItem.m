//
//  ConfigurationColorWellItem.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/2/25.
//

#import "ConfigurationColorWellItem.h"

@implementation ConfigurationColorWellItem

- (void)dealloc {
    [_colorWell release];
    [super dealloc];
}

- (IBAction)_didSelectColor:(NSColorWell *)sender {
    id<ConfigurationColorWellItemDelegate> delegate = self.delegate;
    if (delegate == nil) return;
    [delegate configurationColorWellItem:self didSelectColor:sender.color];
}

@end
