//
//  UnsafeDebouncer.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/15/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UnsafeDebouncer : NSObject
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithTimeInterval:(NSTimeInterval)timeInterval modes:(NSArray<NSRunLoopMode> *)modes;
- (void)scheduleBlock:(void (^)(BOOL cancelled))block;
- (void)cancelPendingBlock;
@end

NS_ASSUME_NONNULL_END
