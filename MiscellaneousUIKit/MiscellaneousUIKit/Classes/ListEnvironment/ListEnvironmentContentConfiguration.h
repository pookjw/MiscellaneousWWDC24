//
//  ListEnvironmentContentConfiguration.h
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/11/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

__attribute__((objc_direct_members))
@interface ListEnvironmentContentConfiguration : NSObject <UIContentConfiguration>
@property (copy, readonly, nonatomic) NSIndexPath *indexPath;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithIndexPath:(NSIndexPath *)indexPath NS_DESIGNATED_INITIALIZER;
@end

NS_ASSUME_NONNULL_END
