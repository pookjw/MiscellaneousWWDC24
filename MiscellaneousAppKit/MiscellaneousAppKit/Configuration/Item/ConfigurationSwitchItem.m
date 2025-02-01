//
//  ConfigurationSwitchItem.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 1/31/25.
//

#import "ConfigurationSwitchItem.h"

@interface ConfigurationSwitchItem ()
@end

@implementation ConfigurationSwitchItem

- (void)dealloc {
    [_toggleSwitch release];
    [super dealloc];
}

- (IBAction)_didChangeSwitchValue:(NSSwitch *)sender {
    [self.delegate configurationSwitchItem:self didToggleValue:sender.state == NSControlStateValueOn];
}

@end
