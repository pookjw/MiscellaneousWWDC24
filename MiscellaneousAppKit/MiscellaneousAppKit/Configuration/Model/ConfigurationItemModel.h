//
//  ConfigurationItemModel.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 1/31/25.
//

#import <Foundation/Foundation.h>
#import "ConfigurationSliderDescription.h"
#import "ConfigurationStepperDescription.h"
#import "ConfigurationPopUpButtonDescription.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ConfigurationItemModelType) {
    ConfigurationItemModelTypeSwitch,
    ConfigurationItemModelTypeSlider,
    ConfigurationItemModelTypeStepper,
    ConfigurationItemModelTypeButton,
    ConfigurationItemModelTypePopUpButton
};

@interface ConfigurationItemModel <ValueType> : NSObject <NSCopying>
@property (assign, nonatomic, readonly) ConfigurationItemModelType type;
@property (copy, nonatomic, readonly) NSString *identifier;
@property (copy, nonatomic, readonly) NSString * (^labelResolver)(ConfigurationItemModel *, ValueType<NSCopying>);
@property (copy, nonatomic, readonly) ValueType<NSCopying> (^valueResolver)(ConfigurationItemModel *);

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

+ (ConfigurationItemModel *)itemModelWithType:(ConfigurationItemModelType)type identifier:(NSString *)identifier labelResolver:(NSString * (^)(ConfigurationItemModel * itemModel, ValueType<NSCopying> value))labelResolver valueResolver:(ValueType<NSCopying> (^)(ConfigurationItemModel * itemModel))valueResolver;
+ (ConfigurationItemModel *)itemModelWithType:(ConfigurationItemModelType)type identifier:(NSString *)identifier label:(NSString *)label valueResolver:(ValueType<NSCopying> (^)(ConfigurationItemModel * itemModel))valueResolver;

- (instancetype)initWithType:(ConfigurationItemModelType)type identifier:(NSString *)identifier labelResolver:(NSString * (^)(ConfigurationItemModel * itemModel, ValueType<NSCopying> value))labelResolver valueResolver:(ValueType<NSCopying> (^)(ConfigurationItemModel * itemModel))valueResolver;
- (instancetype)initWithType:(ConfigurationItemModelType)type identifier:(NSString *)identifier label:(NSString *)label valueResolver:(ValueType<NSCopying> (^)(ConfigurationItemModel * itemModel))valueResolver;
@end

NS_ASSUME_NONNULL_END
