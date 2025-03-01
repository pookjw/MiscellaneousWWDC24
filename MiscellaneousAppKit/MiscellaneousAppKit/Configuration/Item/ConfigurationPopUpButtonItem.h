//
//  ConfigurationPopUpButtonItem.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/1/25.
//

#import <Cocoa/Cocoa.h>
#import "ConfigurationBaseComponentItem.h"

NS_ASSUME_NONNULL_BEGIN

@class ConfigurationPopUpButtonItem;
@protocol ConfigurationPopUpButtonItemDelegate <NSObject>
- (void)configurationPopUpButtonItem:(ConfigurationPopUpButtonItem *)configurationPopUpButtonItem didSelectItem:(NSMenuItem * _Nullable)selectedItem;
@end

@interface ConfigurationPopUpButtonItem : ConfigurationBaseComponentItem
@property (retain, nonatomic) IBOutlet NSPopUpButton *popUpButton;
@property (assign, nonatomic) id<ConfigurationPopUpButtonItemDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
