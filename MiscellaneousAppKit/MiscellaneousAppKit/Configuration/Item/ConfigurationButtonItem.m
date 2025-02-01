//
//  ConfigurationButtonItem.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/1/25.
//

#import "ConfigurationButtonItem.h"

@interface ConfigurationButtonItem ()
@property (retain, nonatomic) IBOutlet NSButton *button;
@end

@implementation ConfigurationButtonItem

- (void)dealloc {
    [_button release];
    [super dealloc];
}

- (IBAction)_didTriggerButton:(NSButton *)sender {
    id<ConfigurationButtonItemDelegate> delegate = self.delegate;
    if (delegate == nil) return;
    
    [delegate didTriggerButton:self];
}

@end
