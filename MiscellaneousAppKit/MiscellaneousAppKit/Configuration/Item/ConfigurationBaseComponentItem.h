//
//  ConfigurationBaseComponentItem.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 3/1/25.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConfigurationBaseComponentItem : NSCollectionViewItem
@property (copy, nonatomic, nullable) id<NSCopying> resolvedValue;
@end

NS_ASSUME_NONNULL_END
