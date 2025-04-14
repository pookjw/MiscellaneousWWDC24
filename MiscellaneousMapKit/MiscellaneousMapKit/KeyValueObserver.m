//
//  KeyValueObserver.m
//  MiscellaneousMapKit
//
//  Created by Jinwoo Kim on 4/14/25.
//

#import "KeyValueObserver.h"

@interface KeyValueObserver () {
    id _object;
    NSString *_keyPath;
    void (^ _handler)(KeyValueObserver *observer, NSString *keyPath, id object, NSDictionary *change);
}
@end

@implementation KeyValueObserver

- (instancetype)initWithObject:(id)object forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options handler:(void (^)(KeyValueObserver * _Nonnull, NSString * _Nonnull, id _Nonnull, NSDictionary * _Nonnull))handler {
    if (self = [super init]) {
        _object = [object retain];
        _keyPath = [keyPath copy];
        _handler = [handler copy];
        [(NSObject *)object addObserver:self forKeyPath:keyPath options:options context:NULL];
    }
    
    return self;
}

- (void)dealloc {
    [_object removeObserver:self forKeyPath:_keyPath];
    [_object release];
    [_keyPath release];
    [_handler release];
    [super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:_keyPath] && [object isEqual:_object]) {
        _handler(self, keyPath, object, change);
        return;
    }
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)invalidate {
    [_object removeObserver:self forKeyPath:_keyPath];
    [_object release];
    _object = nil;
    [_handler release];
    _handler = nil;
}

@end
