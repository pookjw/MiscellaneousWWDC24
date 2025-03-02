//
//  ConfigurationViewPresentationDescription.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 3/1/25.
//

#import "ConfigurationViewPresentationDescription.h"

NSString * const ConfigurationViewPresentationModalResponseKey = @"modalResponse";

@implementation ConfigurationViewPresentationDescription

- (instancetype)initWithStyle:(ConfigurationViewPresentationStyle)style viewBuilder:(__kindof NSView * _Nonnull (^)(void (^layout)(void)))viewBuilder didCloseHandler:(void (^)(__kindof NSView *resolvedView, NSDictionary<NSString *, id> *info))didCloseHandler {
    if (self = [super init]) {
        _style = style;
        _viewBuilder = [viewBuilder copy];
        _didCloseHandler = [didCloseHandler copy];
    }
    
    return self;
}
- (void)dealloc {
    [_viewBuilder release];
    [super dealloc];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [self retain];
}

+ (ConfigurationViewPresentationDescription *)descriptorWithStyle:(ConfigurationViewPresentationStyle)style viewBuilder:(__kindof NSView * _Nonnull (^)(void (^layout)(void)))viewBuilder didCloseHandler:(void (^)(__kindof NSView *resolvedView, NSDictionary<NSString *, id> *info))didCloseHandler {
    return [[[ConfigurationViewPresentationDescription alloc] initWithStyle:style viewBuilder:viewBuilder didCloseHandler:didCloseHandler] autorelease];
}

@end
