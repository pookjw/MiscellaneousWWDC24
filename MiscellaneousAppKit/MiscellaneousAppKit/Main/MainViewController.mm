//
//  MainViewController.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 1/31/25.
//

#import "MainViewController.h"
#import "MainTableCellView.h"
#import "MainTableRowView.h"
#import "WindowDemoWindow.h"
#import "ViewDemoViewController.h"
#import "ConfigurationDemoViewController.h"

@interface MainViewController () <NSTableViewDataSource, NSTableViewDelegate>
@property (class, nonatomic, readonly, getter=_rowIdentifier) NSUserInterfaceItemIdentifier rowIdentifier;
@property (class, nonatomic, readonly, getter=_cellIdentifier) NSUserInterfaceItemIdentifier cellIdentifier;
@property (class, nonatomic, readonly, getter=_classes) NSArray<Class> *classes;
@property (retain, nonatomic, readonly, getter=_scrollView) NSScrollView *scrollView;
@property (retain, nonatomic, readonly, getter=_tableView) NSTableView *tableView;
@end

@implementation MainViewController
@synthesize scrollView = _scrollView;
@synthesize tableView = _tableView;

+ (NSUserInterfaceItemIdentifier)_rowIdentifier {
    return NSStringFromClass([MainTableRowView class]);
}

+ (NSUserInterfaceItemIdentifier)_cellIdentifier {
    return NSStringFromClass([MainTableCellView class]);
}

+ (NSArray<Class> *)_classes {
    return @[
        [ConfigurationDemoViewController self],
        [WindowDemoWindow self],
        [ViewDemoViewController self]
    ];
}

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
//    self.preferredContentSize = NSMakeSize(400., 400.);
    [self _performActionWithIndex:1];
}

- (NSScrollView *)_scrollView {
    if (auto scrollView = _scrollView) return scrollView;
    
    NSScrollView *scrollView = [NSScrollView new];
    scrollView.documentView = self.tableView;
    scrollView.drawsBackground = NO;
    
    _scrollView = scrollView;
    return scrollView;
}

- (NSTableView *)_tableView {
    if (auto tableView = _tableView) return tableView;
    
    NSTableView *tableView = [NSTableView new];
    
    NSNib *rowNib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([MainTableRowView class]) bundle:NSBundle.mainBundle];
    assert(rowNib != nil);
    [tableView registerNib:rowNib forIdentifier:MainViewController.rowIdentifier];
    [rowNib release];
    
    NSNib *cellNib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([MainTableCellView class]) bundle:NSBundle.mainBundle];
    assert(cellNib != nil);
    [tableView registerNib:cellNib forIdentifier:MainViewController.cellIdentifier];
    [cellNib release];
    
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.allowsEmptySelection = YES;
    tableView.style = NSTableViewStyleSourceList;
    tableView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleRegular;
    
    NSTableColumn *tableColumn = [[NSTableColumn alloc] initWithIdentifier:@""];
    [tableView addTableColumn:tableColumn];
    [tableColumn release];
    
    tableView.headerView = nil;
    
    tableView.target = self;
    tableView.doubleAction = @selector(_didTriggerDoubleAction:);
    
    _tableView = tableView;
    return tableView;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return MainViewController.classes.count;
}

- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row {
    MainTableRowView *rowView = [tableView makeViewWithIdentifier:MainViewController.rowIdentifier owner:nil];
    return rowView;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    MainTableCellView *cell = [tableView makeViewWithIdentifier:MainViewController.cellIdentifier owner:nil];
    cell.textField.stringValue = NSStringFromClass(MainViewController.classes[row]);
    return cell;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
//    NSLog(@"%@", notification);
}

- (void)_didTriggerDoubleAction:(NSTableView *)sender {
    NSInteger clickedRow = sender.clickedRow;
    [self _performActionWithIndex:clickedRow];
}

- (void)_performActionWithIndex:(NSInteger)index {
    if (index == NSNotFound or index == -1) return;
    
    Class clickedClass = MainViewController.classes[index];
    
    if ([clickedClass isSubclassOfClass:[NSWindow class]]) {
        __kindof NSWindow *window = [clickedClass new];
        [window makeKeyAndOrderFront:nil];
        [window release];
    } else if ([clickedClass isSubclassOfClass:[NSViewController class]]) {
        NSWindow *window = [[NSWindow alloc] initWithContentRect:NSMakeRect(0., 0., 600., 400.) styleMask:NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskFullSizeContentView | NSWindowStyleMaskResizable | NSWindowStyleMaskTitled backing:NSBackingStoreBuffered defer:NO];
        
        window.releasedWhenClosed = NO;
        window.title = NSStringFromClass(clickedClass);
        window.contentMinSize = NSMakeSize(400., 400.);
        
        __kindof NSViewController *contentViewController = [clickedClass new];
        window.contentViewController = contentViewController;
        [contentViewController release];
        
        [window makeKeyAndOrderFront:nil];
        [window release];
    } else {
        abort();
    }
}

@end
