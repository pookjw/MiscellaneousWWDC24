//
//  ClassesListViewController.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/23/24.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@class ClassesListViewController;
@protocol ClassesListViewControllerDelegate <NSObject>
- (void)classesListViewController:(ClassesListViewController *)classesListViewController didSelectClass:(Class)selectedClass;
@end

@interface ClassesListViewController : NSViewController
@property (weak, nonatomic) id<ClassesListViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
