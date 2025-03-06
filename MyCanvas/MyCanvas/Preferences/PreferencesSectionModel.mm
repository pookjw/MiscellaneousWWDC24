//
//  PreferencesSectionModel.mm
//  MyCanvas
//
//  Created by Jinwoo Kim on 3/6/25.
//

#import "PreferencesSectionModel.h"

@implementation PreferencesSectionModel

- (instancetype)initWithType:(PreferencesSectionModelType)type {
    if (self = [super init]) {
        _type = type;
    }
    
    return self;
}

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    }
    
    if (![other isKindOfClass:[PreferencesSectionModel class]]) {
        return NO;
    }
    
    auto casted = static_cast<PreferencesSectionModel *>(other);
    return _type == casted->_type;
}

- (NSUInteger)hash {
    return _type;
}

@end
