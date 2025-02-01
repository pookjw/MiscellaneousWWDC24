//
//  ConfigurationView.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 1/31/25.
//

#import <Cocoa/Cocoa.h>
#import "ConfigurationItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@class ConfigurationView;
@protocol ConfigurationViewDelegate <NSObject>
@optional - (void)didTriggerReloadButtonWithConfigurationView:(ConfigurationView *)configurationView;
@required - (BOOL)configurationView:(ConfigurationView *)configurationView didTriggerActionWithItemModel:(ConfigurationItemModel *)itemModel newValue:(id<NSCopying>)newValue;
@end

@interface ConfigurationView : NSView
@property (assign, nonatomic) BOOL showBlendedBackground;
@property (retain, nonatomic, readonly) NSCollectionViewDiffableDataSource<NSNull *, ConfigurationItemModel *> *dataSource;
@property (assign, nonatomic) id<ConfigurationViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
