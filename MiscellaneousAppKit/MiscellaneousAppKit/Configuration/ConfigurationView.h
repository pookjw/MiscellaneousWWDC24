//
//  ConfigurationView.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 1/31/25.
//

#import <Cocoa/Cocoa.h>
#import "ConfigurationItemModel.h"

NS_HEADER_AUDIT_BEGIN(nullability, sendability)

@class ConfigurationView;

NS_SWIFT_UI_ACTOR
NS_REFINED_FOR_SWIFT
@protocol ConfigurationViewDelegate <NSObject>
@required
- (BOOL)configurationView:(ConfigurationView *)configurationView didTriggerActionWithItemModel:(ConfigurationItemModel *)itemModel newValue:(id<NSCopying>)newValue;
@optional
- (void)didTriggerReloadButtonWithConfigurationView:(ConfigurationView *)configurationView;
@end

@interface ConfigurationView : NSView
@property (assign, nonatomic) BOOL showBlendedBackground;
@property (copy, nonatomic, readonly) NSDiffableDataSourceSnapshot<NSNull *, ConfigurationItemModel *> *snapshot NS_REFINED_FOR_SWIFT;
@property (assign, nonatomic) id<ConfigurationViewDelegate> delegate NS_REFINED_FOR_SWIFT NS_SWIFT_UNAVAILABLE("Use ConfigurationView.delegate");
- (void)reconfigureItemModelsWithIdentifiers:(NSArray<NSString *> *)identifiers;
- (void)applySnapshot:(NSDiffableDataSourceSnapshot<NSNull *, ConfigurationItemModel *> *)snapshot animatingDifferences:(BOOL)animatingDifferences NS_REFINED_FOR_SWIFT;
@end

NS_HEADER_AUDIT_END(nullability, sendability)
