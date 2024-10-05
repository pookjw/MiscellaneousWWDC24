//
//  KeyValueObservation.h
//  
//
//  Created by Jinwoo Kim on 6/11/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeyValueObservation : NSObject
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (void)invalidate;
@end

NS_ASSUME_NONNULL_END
