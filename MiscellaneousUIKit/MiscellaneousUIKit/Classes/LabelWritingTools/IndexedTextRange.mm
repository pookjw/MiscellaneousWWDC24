//
//  IndexedTextRange.m
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 12/7/24.
//

#import "IndexedTextRange.h"

@implementation IndexedTextRange
@synthesize start = _start;
@synthesize end = _end;

- (instancetype)initWithNSRange:(NSRange)range {
    if (self = [super init]) {
        _start = [[IndexedTextPosition alloc] initWithIndex:range.location];
        _end = [[IndexedTextPosition alloc] initWithIndex:range.location + range.length];
    }
    
    return self;
}

- (instancetype)initWithStart:(IndexedTextPosition *)start end:(IndexedTextPosition *)end {
    if (self = [super init]) {
        assert(start.index <= end.index);
        _start = [start copy];
        _end = [end copy];
    }
    
    return self;
}

- (void)dealloc {
    [_start release];
    [_end release];
    [super dealloc];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    id copy = [[self class] new];
    
    if (copy) {
        auto casted = static_cast<IndexedTextRange *>(copy);
        casted->_start = [_start copyWithZone:zone];
        casted->_end = [_end copyWithZone:zone];
    }
    
    return copy;
}

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    } else if (![other isKindOfClass:IndexedTextRange.class]) {
        return NO;
    } else {
        auto casted = static_cast<IndexedTextRange *>(other);
        return [_start isEqual:casted->_start] and [_end isEqual:casted->_end];
    }
}

- (NSUInteger)hash {
    return _start.hash ^ _end.hash;
}

- (BOOL)isEmpty {
    return NO;
}

- (NSRange)nsRange {
    return NSMakeRange(self.start.index, self.end.index - self.start.index);
}

@end
