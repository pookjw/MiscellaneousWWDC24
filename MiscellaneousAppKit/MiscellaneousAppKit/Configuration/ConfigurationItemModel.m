//
//  ConfigurationItemModel.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 1/31/25.
//

#import "ConfigurationItemModel.h"

@implementation ConfigurationItemModel

- (instancetype)initWithType:(ConfigurationItemModelType)type identifier:(NSString *)identifier label:(NSString *)label valueResolver:(NSObject<NSCopying> * _Nonnull (^)(ConfigurationItemModel * _Nonnull))valueResolver {
    if (self = [super init]) {
        _type = type;
        _identifier = [identifier copy];
        _label = [label copy];
        _valueResolver = [valueResolver copy];
    }
    
    return self;
}

- (void)dealloc {
    [_identifier release];
    [_label release];
    [_valueResolver release];
    [super dealloc];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    ConfigurationItemModel *copy = [[[self class] allocWithZone:zone] init];
    
    if (copy) {
        copy->_type = _type;
        copy->_identifier = [_identifier copyWithZone:zone];
        copy->_label = [_label copyWithZone:zone];
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
