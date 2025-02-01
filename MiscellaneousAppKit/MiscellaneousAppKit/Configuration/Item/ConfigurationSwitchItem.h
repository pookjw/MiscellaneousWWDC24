//
//  ConfigurationSwitchItem.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 1/31/25.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@class ConfigurationSwitchItem;
@protocol ConfigurationSwitchItemDelegate <NSObject>
- (void)configurationSwitchItem:(ConfigurationSwitchItem *)configurationSwitchItem didToggleValue:(BOOL)value;
@end

@interface ConfigurationSwitchItem : NSCollectionViewItem
@property (retain, nonatomic) IBOutlet NSSwitch *toggleSwitch;
@property (assign, nonatomic) id<ConfigurationSwitchItemDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
