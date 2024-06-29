//
//  ClassListViewController.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/23/24.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@class ClassListViewController;
@protocol ClassListViewControllerDelegate <NSObject>
- (void)classListViewController:(ClassListViewController *)classListViewController didSelectClass:(Class)selectedClass;
@end

@interface ClassListViewController : NSViewController
@property (weak, nonatomic) id<ClassListViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
