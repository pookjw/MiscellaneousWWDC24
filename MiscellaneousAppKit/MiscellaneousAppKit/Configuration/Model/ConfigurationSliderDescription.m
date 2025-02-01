//
//  ConfigurationSliderDescription.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/1/25.
//

#import "ConfigurationSliderDescription.h"

@implementation ConfigurationSliderDescription

+ (ConfigurationSliderDescription *)descriptionWithSliderValue:(double)sliderValue minimumValue:(double)minimunValue maximumValue:(double)maximumValue {
    return [[[ConfigurationSliderDescription alloc] initWithSliderValue:sliderValue minimumValue:minimunValue maximumValue:maximumValue] autorelease];
}

+ (ConfigurationSliderDescription *)descriptionWithSliderValue:(double)sliderValue minimumValue:(double)minimunValue maximumValue:(double)maximumValue continuous:(BOOL)continuous {
    return [[[ConfigurationSliderDescription alloc] initWithSliderValue:sliderValue minimumValue:minimunValue maximumValue:maximumValue continuous:continuous] autorelease];
}

- (instancetype)initWithSliderValue:(double)sliderValue minimumValue:(double)minimunValue maximumValue:(double)maximumValue {
    return [self initWithSliderValue:sliderValue minimumValue:minimunValue maximumValue:maximumValue continuous:NO];
}

- (instancetype)initWithSliderValue:(double)sliderValue minimumValue:(double)minimunValue maximumValue:(double)maximumValue continuous:(BOOL)continuous {
    if (self = [super init]) {
        _sliderValue = sliderValue;
        _minimumValue = minimunValue;
        _maximumValue = maximumValue;
        _continuous = continuous;
    }
    
    return self;
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return self;
}

- (ConfigurationSliderDescription *)configurationWithSliderValue:(double)sliderValue {
    return [ConfigurationSliderDescription descriptionWithSliderValue:sliderValue minimumValue:self.minimumValue maximumValue:self.maximumValue continuous:self.continuous];
}

@end
