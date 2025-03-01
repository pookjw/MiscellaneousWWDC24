//
//  ConfigurationButtonItem.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/1/25.
//

#import <Cocoa/Cocoa.h>
#import "ConfigurationBaseComponentItem.h"

NS_ASSUME_NONNULL_BEGIN

@class ConfigurationButtonItem;
@protocol ConfigurationButtonItemDelegate <NSObject>
- (void)configurationButtonItem:(ConfigurationButtonItem *)configurationButtonItem didTriggerButton:(NSButton *)sender;
@end

@interface ConfigurationButtonItem : ConfigurationBaseComponentItem
@property (assign, nonatomic) BOOL showsMenuAsPrimaryAction;
@property (retain, nonatomic) IBOutlet NSButton *button;
@property (assign, nonatomic) id<ConfigurationButtonItemDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
