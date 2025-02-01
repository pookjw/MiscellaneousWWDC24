//
//  ConfigurationItemModel.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 1/31/25.
//

#import "ConfigurationItemModel.h"

@implementation ConfigurationItemModel

+ (ConfigurationItemModel *)itemModelWithType:(ConfigurationItemModelType)type identifier:(NSString *)identifier userInfo:(NSDictionary * _Nullable)userInfo label:(NSString *)label valueResolver:(id<NSCopying>  _Nonnull (^)(ConfigurationItemModel * _Nonnull))valueResolver {
    return [[[ConfigurationItemModel alloc] initWithType:type identifier:identifier userInfo:userInfo label:label valueResolver:valueResolver] autorelease];
}

+ (ConfigurationItemModel *)itemModelWithType:(ConfigurationItemModelType)type identifier:(NSString *)identifier userInfo:(NSDictionary * _Nullable)userInfo labelResolver:(NSString * _Nonnull (^)(ConfigurationItemModel * _Nonnull, id<NSCopying> _Nonnull))labelResolver valueResolver:(id<NSCopying>  _Nonnull (^)(ConfigurationItemModel * _Nonnull))valueResolver {
    return [[[ConfigurationItemModel alloc] initWithType:type identifier:identifier userInfo:userInfo labelResolver:labelResolver valueResolver:valueResolver] autorelease];
}

- (instancetype)initWithType:(ConfigurationItemModelType)type identifier:(NSString *)identifier userInfo:(NSDictionary * _Nullable)userInfo labelResolver:(NSString * _Nonnull (^)(ConfigurationItemModel * _Nonnull, id<NSCopying> _Nonnull))labelResolver valueResolver:(id<NSCopying> _Nonnull (^)(ConfigurationItemModel * _Nonnull))valueResolver {
    if (self = [super init]) {
        _type = type;
        _identifier = [identifier copy];
        _userInfo = [userInfo copy];
        _labelResolver = [labelResolver copy];
        _valueResolver = [valueResolver copy];
    }
    
    return self;
}

- (instancetype)initWithType:(ConfigurationItemModelType)type identifier:(NSString *)identifier userInfo:(NSDictionary * _Nullable)userInfo label:(NSString *)label valueResolver:(id<NSCopying> _Nonnull (^)(ConfigurationItemModel * _Nonnull))valueResolver {
    return [self initWithType:type
                   identifier:identifier
                     userInfo:userInfo
                labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying> _Nonnull value) {
        return label;
    }
                valueResolver:valueResolver];
}

- (void)dealloc {
    [_identifier release];
    [_labelResolver release];
    [_valueResolver release];
    [_userInfo release];
    [super dealloc];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    ConfigurationItemModel *copy = [[[self class] allocWithZone:zone] init];
    
    if (copy) {
        copy->_type = _type;
        copy->_identifier = [_identifier copyWithZone:zone];
        copy->_userInfo = [_userInfo copyWithZone:zone];
        copy->_labelResolver = [_labelResolver copyWithZone:zone];
        copy->_valueResolver = [_valueResolver copyWithZone:zone];
    }
    
    return copy;
}

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    }
    
    if (![other isKindOfClass:[ConfigurationItemModel class]]) {
        return NO;
    }
    
    ConfigurationItemModel *casted = other;
    return [_identifier isEqualToString:casted->_identifier];
}

- (NSUInteger)hash {
    return _identifier.hash;
}

@end
