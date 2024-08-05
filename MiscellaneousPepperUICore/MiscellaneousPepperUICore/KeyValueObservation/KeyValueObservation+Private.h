//
//  KeyValueObservation+Private.h
//
//
//  Created by Jinwoo Kim on 6/11/23.
//

#import "KeyValueObservation.h"

NS_ASSUME_NONNULL_BEGIN

@interface KeyValueObservation (Private)
- (instancetype)initWithObject:(id)object forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options callback:(void (^)(id object, NSDictionary *change))callback;
@end

NS_ASSUME_NONNULL_END
