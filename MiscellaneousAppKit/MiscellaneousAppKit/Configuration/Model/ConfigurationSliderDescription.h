//
//  ConfigurationSliderDescription.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/1/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_REFINED_FOR_SWIFT
@interface ConfigurationSliderDescription : NSObject <NSCopying>
@property (assign, nonatomic, readonly) double sliderValue;
@property (assign, nonatomic, readonly) double minimumValue;
@property (assign, nonatomic, readonly) double maximumValue;
@property (assign, nonatomic, readonly, getter=isContinuous) BOOL continuous;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
+ (ConfigurationSliderDescription *)descriptionWithSliderValue:(double)sliderValue minimumValue:(double)minimunValue maximumValue:(double)maximumValue;
+ (ConfigurationSliderDescription *)descriptionWithSliderValue:(double)sliderValue minimumValue:(double)minimunValue maximumValue:(double)maximumValue continuous:(BOOL)continuous;
- (instancetype)initWithSliderValue:(double)sliderValue minimumValue:(double)minimunValue maximumValue:(double)maximumValue;
- (instancetype)initWithSliderValue:(double)sliderValue minimumValue:(double)minimunValue maximumValue:(double)maximumValue continuous:(BOOL)continuous;

- (ConfigurationSliderDescription *)configurationWithSliderValue:(double)sliderValue;
@end

NS_ASSUME_NONNULL_END
