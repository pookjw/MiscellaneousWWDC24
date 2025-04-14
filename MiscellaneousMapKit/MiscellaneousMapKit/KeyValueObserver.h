//
//  KeyValueObserver.h
//  MiscellaneousMapKit
//
//  Created by Jinwoo Kim on 4/14/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeyValueObserver : NSObject
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithObject:(id)object forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options handler:(void (^)(KeyValueObserver *observer, NSString *keyPath, id object, NSDictionary *change))handler;
- (void)invalidate;
@end

NS_ASSUME_NONNULL_END
