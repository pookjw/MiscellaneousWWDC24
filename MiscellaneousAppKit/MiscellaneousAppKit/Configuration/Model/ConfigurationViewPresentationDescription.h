//
//  ConfigurationViewPresentationDescription.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 3/1/25.
//

#import <Cocoa/Cocoa.h>
#import "Extern.h"

NS_HEADER_AUDIT_BEGIN(nullability, sendability)

typedef NS_ENUM(NSUInteger, ConfigurationViewPresentationStyle) {
    ConfigurationViewPresentationStylePopover,
    ConfigurationViewPresentationStyleAlert
} NS_REFINED_FOR_SWIFT;

MA_EXTERN NSString * const ConfigurationViewPresentationModalResponseKey;

NS_REFINED_FOR_SWIFT
@interface ConfigurationViewPresentationDescription : NSObject <NSCopying>
@property (copy, nonatomic, readonly) __kindof NSView * (^viewBuilder)(void (^layout)(void), __kindof NSView * _Nullable reloadingView);
@property (copy, nonatomic, readonly) void (^didCloseHandler)(__kindof NSView *resolvedView, NSDictionary<NSString *, id> *info);
@property (assign, nonatomic, readonly) ConfigurationViewPresentationStyle style;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithStyle:(ConfigurationViewPresentationStyle)style viewBuilder:(__kindof NSView * (^)(void (^layout)(void), __kindof NSView * _Nullable reloadingView))viewBuilder didCloseHandler:(void (^)(__kindof NSView *resolvedView, NSDictionary<NSString *, id> *info))didCloseHandler;
+ (ConfigurationViewPresentationDescription *)descriptorWithStyle:(ConfigurationViewPresentationStyle)style viewBuilder:(__kindof NSView * (^)(void (^layout)(void), __kindof NSView * _Nullable reloadingView))viewBuilder didCloseHandler:(void (^ _Nullable)(__kindof NSView *resolvedView, NSDictionary<NSString *, id> *info))didCloseHandler;
@end

NS_HEADER_AUDIT_END(nullability, sendability)
