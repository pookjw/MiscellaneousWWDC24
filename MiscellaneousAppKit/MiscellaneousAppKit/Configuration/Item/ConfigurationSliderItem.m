//
//  ConfigurationSliderItem.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/1/25.
//

#import "ConfigurationSliderItem.h"

@implementation ConfigurationSliderItem

- (void)dealloc {
    [_slider release];
    [super dealloc];
}

- (IBAction)_didChangeSliderValue:(NSSlider *)sender {
    id<ConfigurationSliderItemDelegate> delegate = self.delegate;
    if (delegate == nil) return;
    
    [delegate configurationSliderItem:self didChangeValue:sender.doubleValue];
}

@end
