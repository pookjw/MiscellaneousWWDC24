//
//  ConfigurationColorWellItem.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/2/25.
//

#import <Cocoa/Cocoa.h>
#import "ConfigurationBaseComponentItem.h"

NS_ASSUME_NONNULL_BEGIN

@class ConfigurationColorWellItem;
@protocol ConfigurationColorWellItemDelegate <NSObject>
- (void)configurationColorWellItem:(ConfigurationColorWellItem *)configurationColorWellItem didSelectColor:(NSColor *)color;
@end

@interface ConfigurationColorWellItem : ConfigurationBaseComponentItem
@property (retain, nonatomic) IBOutlet NSColorWell *colorWell;
@property (assign, nonatomic) id<ConfigurationColorWellItemDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
