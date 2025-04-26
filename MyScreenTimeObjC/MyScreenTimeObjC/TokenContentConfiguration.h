//
//  TokenContentConfiguration.h
//  MyScreenTimeObjC
//
//  Created by Jinwoo Kim on 4/26/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TokenContentConfiguration : NSObject <UIContentConfiguration>
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithApplicationToken:(NSData *)applicationToken tokenType:(NSInteger)tokenType;
@end

NS_ASSUME_NONNULL_END
