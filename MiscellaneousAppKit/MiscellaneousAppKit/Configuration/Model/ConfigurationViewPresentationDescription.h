//
//  ConfigurationViewPresentationDescription.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 3/1/25.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ConfigurationViewPresentationStyle) {
    ConfigurationViewPresentationStylePopover,
    ConfigurationViewPresentationStyleAlert
};

@interface ConfigurationViewPresentationDescription : NSObject <NSCopying>
@property (copy, nonatomic, readonly) __kindof NSView * (^viewBuilder)(void (^layout)(void));
@property (assign, nonatomic, readonly) ConfigurationViewPresentationStyle style;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithStyle:(ConfigurationViewPresentationStyle)style viewBuilder:(__kindof NSView * (^)(void (^layout)(void)))viewBuilder;
+ (ConfigurationViewPresentationDescription *)descriptorWithStyle:(ConfigurationViewPresentationStyle)style viewBuilder:(__kindof NSView * (^)(void (^layout)(void)))viewBuilder;
@end

NS_ASSUME_NONNULL_END
