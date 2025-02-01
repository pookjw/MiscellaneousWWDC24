//
//  ConfigurationButtonItem.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/1/25.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@class ConfigurationButtonItem;
@protocol ConfigurationButtonItemDelegate <NSObject>
- (void)didTriggerButton:(ConfigurationButtonItem *)configurationButtonItem;
@end

@interface ConfigurationButtonItem : NSCollectionViewItem
@property (retain, nonatomic) IBOutlet NSPopUpButton *popUpButton;
@property (assign, nonatomic) id<ConfigurationButtonItemDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
