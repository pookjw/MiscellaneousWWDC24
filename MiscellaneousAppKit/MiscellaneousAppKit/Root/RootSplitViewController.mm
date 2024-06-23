//
//  RootSplitViewController.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/23/24.
//

#import "RootSplitViewController.h"
#import "ClassesListViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface RootSplitViewController () <ClassesListViewControllerDelegate>
@property (retain, readonly, nonatomic) ClassesListViewController *classesListViewController;
@property (retain, readonly, nonatomic) NSViewController *emptyViewController;
@property (retain, readonly, nonatomic) NSSplitViewItem *classesListSplitViewItem;
@property (retain, readonly, nonatomic) NSSplitViewItem *emptySplitViewItem;
@end

@implementation RootSplitViewController
@synthesize classesListViewController = _classesListViewController;
@synthesize emptyViewController = _emptyViewController;
@synthesize classesListSplitViewItem = _classesListSplitViewItem;
@synthesize emptySplitViewItem = _emptySplitViewItem;

- (void)dealloc {
    [_classesListViewController release];
    [_emptySplitViewItem release];
    [_classesListSplitViewItem release];
    [_emptyViewController release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.splitViewItems = @[self.classesListSplitViewItem, self.emptySplitViewItem];
}

- (ClassesListViewController *)classesListViewController {
    if (auto classesListViewController = _classesListViewController) return classesListViewController;
    
    ClassesListViewController *classesListViewController = [ClassesListViewController new];
    classesListViewController.delegate = self;
    
    _classesListViewController = [classesListViewController retain];
    return [classesListViewController autorelease];
}

- (NSViewController *)emptyViewController {
    if (auto emptyViewController = _emptyViewController) return emptyViewController;
    
    NSViewController *emptyViewController = [NSViewController new];
    
    _emptyViewController = [emptyViewController retain];
    return [emptyViewController autorelease];
}

- (NSSplitViewItem *)classesListSplitViewItem {
    if (auto classesListSplitViewItem = _classesListSplitViewItem) return classesListSplitViewItem;
    
    NSSplitViewItem *classesListSplitViewItem = [NSSplitViewItem sidebarWithViewController:self.classesListViewController];
    
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

- (void)classesListViewController:(ClassesListViewController *)classesListViewController didSelectClass:(Class)selectedClass {
    __kindof NSViewController *viewController = [selectedClass new];
    
    NSSplitViewItem *contentListSplitViewItem = [NSSplitViewItem contentListWithViewController:viewController];
    [viewController release];
    
    self.splitViewItems = @[self.classesListSplitViewItem, contentListSplitViewItem];
}

@end
