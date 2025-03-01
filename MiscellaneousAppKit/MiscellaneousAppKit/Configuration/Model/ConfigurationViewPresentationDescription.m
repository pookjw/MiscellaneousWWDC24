//
//  ConfigurationViewPresentationDescription.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 3/1/25.
//

#import "ConfigurationViewPresentationDescription.h"

@implementation ConfigurationViewPresentationDescription

- (instancetype)initWithStyle:(ConfigurationViewPresentationStyle)style viewBuilder:(__kindof NSView * _Nonnull (^)(void (^layout)(void)))viewBuilder {
    if (self = [super init]) {
        _style = style;
        _viewBuilder = [viewBuilder copy];
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

+ (ConfigurationViewPresentationDescription *)descriptorWithStyle:(ConfigurationViewPresentationStyle)style viewBuilder:(__kindof NSView * _Nonnull (^)(void (^layout)(void)))viewBuilder {
    return [[[ConfigurationViewPresentationDescription alloc] initWithStyle:style viewBuilder:viewBuilder] autorelease];
}

@end
