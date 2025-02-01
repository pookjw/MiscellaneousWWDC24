//
//  ConfigurationStepperDescription.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/1/25.
//

#import "ConfigurationStepperDescription.h"

@implementation ConfigurationStepperDescription

+ (ConfigurationStepperDescription *)descriptionWithStepperValue:(double)stepperValue minimumValue:(double)minimumValue maximumValue:(double)maximumValue stepValue:(double)stepValue continuous:(BOOL)continuous autorepeat:(BOOL)autorepeat valueWraps:(BOOL)valueWraps {
    return [[[ConfigurationStepperDescription alloc] initWithStepperValue:stepperValue minimumValue:minimumValue maximumValue:maximumValue stepValue:stepValue continuous:continuous autorepeat:autorepeat valueWraps:valueWraps] autorelease];
}

- (instancetype)initWithStepperValue:(double)stepperValue minimumValue:(double)minimumValue maximumValue:(double)maximumValue stepValue:(double)stepValue continuous:(BOOL)continuous autorepeat:(BOOL)autorepeat valueWraps:(BOOL)valueWraps {
    if (self = [super init]) {
        _stepperValue = stepperValue;
        _minimumValue = minimumValue;
        _maximumValue = maximumValue;
        _stepValue = stepValue;
        _continuous = continuous;
        _autorepeat = autorepeat;
        _valueWraps = valueWraps;
    }
    
    return self;
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return self;
}

- (ConfigurationStepperDescription *)descriptionWithStepperValue:(double)stepperValue {
    return [ConfigurationStepperDescription descriptionWithStepperValue:stepperValue minimumValue:self.minimumValue maximumValue:self.maximumValue stepValue:self.stepValue continuous:self.continuous autorepeat:self.autorepeat valueWraps:self.valueWraps];
}

@end
