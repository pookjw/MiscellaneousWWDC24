//
//  PreferencesItemModel.mm
//  MyCanvas
//
//  Created by Jinwoo Kim on 3/6/25.
//

#import "PreferencesItemModel.h"

@implementation PreferencesItemModel

- (instancetype)initWithType:(PreferencesItemModelType)type valueResolver:(id  _Nonnull (^)())valueResolver {
    if (self = [super init]) {
        _type = type;
        _valueResolver = [valueResolver copy];
    }
    
    return self;
}

- (void)dealloc {
    [_valueResolver release];
    [super dealloc];
}

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    }
    
    if (![other isKindOfClass:[PreferencesItemModel class]]) {
        return NO;
    }
    
    auto casted = static_cast<PreferencesItemModel *>(other);
    return _type == casted->_type;
}

- (NSUInteger)hash {
    return _type;
}

@end
