//
//  ToolItemsConfigurationViewController.h
//  MyCanvas
//
//  Created by Jinwoo Kim on 3/7/25.
//

#import <UIKit/UIKit.h>
#import <PencilKit/PencilKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ToolItemsConfigurationViewController;
@protocol ToolItemsConfigurationViewControllerDelegate <NSObject>
- (void)toolItemsConfigurationViewController:(ToolItemsConfigurationViewController *)toolItemsConfigurationViewController didFinishWithToolItems:(NSArray<__kindof PKToolPickerItem *> *)toolItems;
@end

@interface ToolItemsConfigurationViewController : UIViewController
@property (assign, nonatomic) id<ToolItemsConfigurationViewControllerDelegate> delegate;
- (instancetype)initWithToolItems:(NSArray<__kindof PKToolPickerItem *> *)toolItems;
@end

NS_ASSUME_NONNULL_END
