//
//  ConfigurationItemModel.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 1/31/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ConfigurationItemModelType) {
    ConfigurationItemModelTypeSwitch
};

@interface ConfigurationItemModel : NSObject <NSCopying>
@property (assign, nonatomic, readonly) ConfigurationItemModelType type;
@property (copy, nonatomic, readonly) NSString *identifier;
@property (copy, nonatomic, readonly) NSString *label;
@property (copy, nonatomic, readonly) NSObject<NSCopying> * (^valueResolver)(ConfigurationItemModel *);
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(ConfigurationItemModelType)type identifier:(NSString *)identifier label:(NSString *)label valueResolver:(NSObject<NSCopying> * (^)(ConfigurationItemModel *))valueResolver;
@end

NS_ASSUME_NONNULL_END
