//
//  RootSplitViewController.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/23/24.
//

#import "RootSplitViewController.h"
#import "ClassListViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface RootSplitViewController () <ClassListViewControllerDelegate>
@property (retain, readonly, nonatomic) ClassListViewController *classListViewController;
@property (retain, readonly, nonatomic) NSViewController *emptyViewController;
@property (retain, readonly, nonatomic) NSSplitViewItem *classesListSplitViewItem;
@property (retain, readonly, nonatomic) NSSplitViewItem *emptySplitViewItem;
@end

@implementation RootSplitViewController
@synthesize classListViewController = _classListViewController;
@synthesize emptyViewController = _emptyViewController;
@synthesize classesListSplitViewItem = _classesListSplitViewItem;
@synthesize emptySplitViewItem = _emptySplitViewItem;

- (void)dealloc {
    [_classListViewController release];
    [_emptySplitViewItem release];
    [_classesListSplitViewItem release];
    [_emptyViewController release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.splitViewItems = @[self.classesListSplitViewItem, self.emptySplitViewItem];
    [self.classListViewController loadViewIfNeeded];
}

- (ClassListViewController *)classListViewController {
    if (auto classListViewController = _classListViewController) return classListViewController;
    
    ClassListViewController *classListViewController = [ClassListViewController new];
    classListViewController.delegate = self;
    
    _classListViewController = [classListViewController retain];
    return [classListViewController autorelease];
}

- (NSViewController *)emptyViewController {
    if (auto emptyViewController = _emptyViewController) return emptyViewController;
    
    NSViewController *emptyViewController = [NSViewController new];
    
    _emptyViewController = [emptyViewController retain];
    return [emptyViewController autorelease];
}

- (NSSplitViewItem *)classesListSplitViewItem {
    if (auto classesListSplitViewItem = _classesListSplitViewItem) return classesListSplitViewItem;
    
    NSSplitViewItem *classesListSplitViewItem = [NSSplitViewItem sidebarWithViewController:self.classListViewController];
    
    classesListSplitViewItem.canCollapse = NO;
    ((void (*)(id, SEL, CGFloat))objc_msgSend)(classesListSplitViewItem, sel_registerName("setMinimumSize:"), 100.0);
    
    _classesListSplitViewItem = [classesListSplitViewItem retain];
    return classesListSplitViewItem;
}

- (NSSplitViewItem *)emptySplitViewItem {
    if (auto emptySplitViewItem = _emptySplitViewItem) return emptySplitViewItem;
    
    NSSplitViewItem *emptySplitViewItem = [NSSplitViewItem contentListWithViewController:self.emptyViewController];
    
    _emptySplitViewItem = [emptySplitViewItem retain];
    return emptySplitViewItem;
}

- (void)classListViewController:(ClassListViewController *)classListViewController didSelectClass:(Class)selectedClass {
    __kindof NSViewController *viewController = [selectedClass new];
    
    NSSplitViewItem *contentListSplitViewItem = [NSSplitViewItem contentListWithViewController:viewController];
    [viewController release];
    
    self.splitViewItems = @[self.classesListSplitViewItem, contentListSplitViewItem];
}

@end
