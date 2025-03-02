//
//  ConfigurationStepperDescription.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/1/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_REFINED_FOR_SWIFT
@interface ConfigurationStepperDescription : NSObject <NSCopying>
@property (assign, nonatomic, readonly) double stepperValue;
@property (assign, nonatomic, readonly) double minimumValue;
@property (assign, nonatomic, readonly) double maximumValue;
@property (assign, nonatomic, readonly) double stepValue;
@property (assign, nonatomic, readonly, getter=isContinuous) BOOL continuous;
@property (assign, nonatomic, readonly) BOOL autorepeat;
@property (assign, nonatomic, readonly) BOOL valueWraps;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
+ (ConfigurationStepperDescription *)descriptionWithStepperValue:(double)stepperValue minimumValue:(double)minimumValue maximumValue:(double)maximumValue stepValue:(double)stepValue continuous:(BOOL)continuous autorepeat:(BOOL)autorepeat valueWraps:(BOOL)valueWraps;
- (instancetype)initWithStepperValue:(double)stepperValue minimumValue:(double)minimumValue maximumValue:(double)maximumValue stepValue:(double)stepValue continuous:(BOOL)continuous autorepeat:(BOOL)autorepeat valueWraps:(BOOL)valueWraps;
- (ConfigurationStepperDescription *)descriptionWithStepperValue:(double)stepperValue;
@end

NS_ASSUME_NONNULL_END
