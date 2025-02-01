//
//  ConfigurationStepperItem.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/1/25.
//

#import "ConfigurationStepperItem.h"

@implementation ConfigurationStepperItem

- (IBAction)_didChangeValue:(NSStepper *)sender {
    id<ConfigurationStepperItemDelegate> delegate = self.delegate;
    if (delegate == nil) return;
    
    [delegate configurationStepperItem:self didChangeValue:sender.doubleValue];
}

@end
