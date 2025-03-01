//
//  ConfigurationSliderItem.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/1/25.
//

#import <Cocoa/Cocoa.h>
#import "ConfigurationBaseComponentItem.h"

NS_ASSUME_NONNULL_BEGIN

@class ConfigurationSliderItem;
@protocol ConfigurationSliderItemDelegate <NSObject>
- (void)configurationSliderItem:(ConfigurationSliderItem *)configurationSliderItem didChangeValue:(double)value;
@end

@interface ConfigurationSliderItem : ConfigurationBaseComponentItem
@property (retain, nonatomic) IBOutlet NSSlider *slider;
@property (assign, nonatomic) id<ConfigurationSliderItemDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
