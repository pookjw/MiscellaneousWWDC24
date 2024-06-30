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
        ToolbarViewController.class,
        TextViewController.class,
        RulerViewController.class,
        PopUpButtonsViewController.class,
        CursorViewController.class,
        StagedWindowViewController.class,
        WindowMovableViewController.class,
        AlertStyleViewController.class
    ];
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
