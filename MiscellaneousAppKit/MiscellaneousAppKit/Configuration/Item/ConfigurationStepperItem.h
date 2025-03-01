//
//  ConfigurationStepperItem.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/1/25.
//

#import <Cocoa/Cocoa.h>
#import "ConfigurationBaseComponentItem.h"

NS_ASSUME_NONNULL_BEGIN

@class ConfigurationStepperItem;
@protocol ConfigurationStepperItemDelegate <NSObject>
- (void)configurationStepperItem:(ConfigurationStepperItem *)configurationStepperItem didChangeValue:(double)value;
@end

@interface ConfigurationStepperItem : ConfigurationBaseComponentItem
@property (retain, nonatomic) IBOutlet NSStepper *stepper;
@property (assign, nonatomic) id<ConfigurationStepperItemDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
