//
//  ClassesListViewController.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/23/24.
//

#import "ClassListViewController.h"
#import "ClassTableCellView.h"
#import "ClassTableRowView.h"
#import "ClassesListTableView.h"
#import "ToolbarViewController.h"
#import "TextViewController.h"
#import "RulerViewController.h"
#import "PopUpButtonsViewController.h"
#import "CursorViewController.h"
#import "StagedWindowViewController.h"
#import "WindowMovableViewController.h"
#import "AlertStyleViewController.h"
#import "HUDWindowPresenterViewController.h"
#import "ChangeToolbarStyleViewController.h"
#import "SearchToolbarItemViewController.h"
#import "ValidateToolbarViewController.h"
#import "WritingToolsViewController.h"
#import "IntelligenceUILightViewController.h"
#import "GenerateImageSegmentationViewController.h"

APPKIT_EXTERN NSString * const NSTableViewCurrentRowSelectionUserInfoKey;
APPKIT_EXTERN NSString * const NSTableViewPreviousRowSelectionUserInfoKey;

@interface ClassListViewController () <NSTableViewDataSource, NSTableViewDelegate>
@property (retain, readonly, nonatomic) NSScrollView *scrollView;
@property (retain, readonly, nonatomic) ClassesListTableView *tableView;
@property (retain, readonly, nonatomic) NSArray<Class> *classes;
@end

@implementation ClassListViewController
@synthesize scrollView = _scrollView;
@synthesize tableView = _tableView;

- (void)dealloc {
    [_scrollView release];
    [_tableView release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
}

- (NSScrollView *)scrollView {
    if (auto scrollView = _scrollView) return scrollView;
    
    NSScrollView *scrollView = [NSScrollView new];
    scrollView.documentView = self.tableView;
    scrollView.drawsBackground = NO;
    
    _scrollView = [scrollView retain];
    return [scrollView autorelease];
}

- (ClassesListTableView *)tableView {
    if (auto tableView = _tableView) return tableView;
    
    ClassesListTableView *tableView = [ClassesListTableView new];
    
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.allowsEmptySelection = YES;
    tableView.style = NSTableViewStyleSourceList;
    tableView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleRegular;
    
    NSTableColumn *tableColumn = [[NSTableColumn alloc] initWithIdentifier:[NSString string]];
    [tableView addTableColumn:tableColumn];
    [tableColumn release];
    
    NSNib *cellNib = [[NSNib alloc] initWithNibNamed:@"ClassTableCellView" bundle:NSBundle.mainBundle];
    [tableView registerNib:cellNib forIdentifier:@"ClassTableCellView"];
    [cellNib release];
    
    NSNib *rowNib = [[NSNib alloc] initWithNibNamed:@"ClassTableRowView" bundle:NSBundle.mainBundle];
    [tableView registerNib:rowNib forIdentifier:@"ClassTableRowView"];
    [rowNib release];
    
    _tableView = [tableView retain];
    return [tableView autorelease];
}

- (NSArray<Class> *)classes {
    return @[
        GenerateImageSegmentationViewController.class,
        IntelligenceUILightViewController.class,
        WritingToolsViewController.class,
        ValidateToolbarViewController.class,
        SearchToolbarItemViewController.class,
        ChangeToolbarStyleViewController.class,
        HUDWindowPresenterViewController.class,
        AlertStyleViewController.class,
        WindowMovableViewController.class,
        StagedWindowViewController.class,
        CursorViewController.class,
        PopUpButtonsViewController.class,
        RulerViewController.class,
        TextViewController.class,
        ToolbarViewController.class
    ];
}

- (Class)selectedClass {
    NSIndexSet *selectedRowIndexes = self.tableView.selectedRowIndexes;
    if (selectedRowIndexes.count == 0) return nil;
    NSUInteger index = selectedRowIndexes.firstIndex;
    return self.classes[index];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.classes.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    return [tableView makeViewWithIdentifier:@"ClassTableCellView" owner:nil];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    return self.classes[row];
}

- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row {
    return [tableView makeViewWithIdentifier:@"ClassTableRowView" owner:nil];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSIndexSet *indexSet = notification.userInfo[NSTableViewCurrentRowSelectionUserInfoKey];
    Class selectedClass = self.classes[indexSet.firstIndex];
    
    [self.delegate classListViewController:self didSelectClass:selectedClass];
}

@end
