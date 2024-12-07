//
//  IndexedTextPosition.m
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 12/7/24.
//

#import "IndexedTextPosition.h"

@implementation IndexedTextPosition

- (instancetype)initWithIndex:(NSInteger)index {
    if (self = [super init]) {
        _index = index;
    }
    return self;
}

- (id)copyWithZone:(struct _NSZone *)zone {
    id copy = [[self class] new];
    
    if (copy) {
        auto casted = static_cast<IndexedTextPosition *>(copy);
        casted->_index = _index;
    }
    
    return copy;
}

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    } else if (![other isKindOfClass:IndexedTextPosition.class]) {
        return NO;
    } else {
        auto casted = static_cast<IndexedTextPosition *>(other);
        return _index == casted->_index;
    }
}

- (NSUInteger)hash {
    return _index;
}

- (NSComparisonResult)compare:(IndexedTextPosition *)otherPosition {
    return [@(_index) compare:@(otherPosition->_index)];
}

@end
