//
//  SearchToolbarItemViewController.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 7/16/24.
//

#import "SearchToolbarItemViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

// validateVisibleItems이 뭔지 보기
// NSControlTextEditingDelegate 써보기 https://t.co/RuWGIkIlWl

OBJC_EXPORT id objc_msgSendSuper2(void);

@interface SearchToolbarItemViewController () <NSToolbarDelegate, NSSearchFieldDelegate, NSMenuDelegate>
@property (retain, readonly, nonatomic) NSToolbar *toolbar;
@property (retain, readonly, nonatomic) NSSearchToolbarItem *searchToolbarItem;
@property (retain, readonly, nonatomic) NSMenu *searchMenuTemplate;
@property (retain, readonly, nonatomic) NSStackView *stackView;
@property (retain, readonly, nonatomic) NSButton *toggleSearchInteractionButton;
@property (retain, readonly, nonatomic) NSButton *logRecentSearchesButton;
@property (retain, readonly, nonatomic) NSButton *clearRecentSearchesButton;
@property (nonatomic) BOOL completePosting;
@property (nonatomic) BOOL commandHandling;
@end

@implementation SearchToolbarItemViewController
@synthesize toolbar = _toolbar;
@synthesize searchToolbarItem = _searchToolbarItem;
@synthesize searchMenuTemplate = _searchMenuTemplate;
@synthesize stackView = _stackView;
@synthesize toggleSearchInteractionButton = _toggleSearchInteractionButton;
@synthesize logRecentSearchesButton = _logRecentSearchesButton;
@synthesize clearRecentSearchesButton = _clearRecentSearchesButton;

- (void)dealloc {
    [_toolbar release];
    [_searchToolbarItem release];
    [_searchMenuTemplate release];
    [_stackView release];
    [_toggleSearchInteractionButton release];
    [_logRecentSearchesButton release];
    [_clearRecentSearchesButton release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSStackView *stackView = self.stackView;
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:stackView];
    [NSLayoutConstraint activateConstraints:@[
        [stackView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [stackView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor]
    ]];
}

- (void)_viewDidMoveToWindow:(NSWindow * _Nullable)toWindow fromWindow:(NSWindow * _Nullable)fromWindow {
    objc_super superInfo = { self, [self class] };
    ((void (*)(objc_super *, SEL, id, id))objc_msgSendSuper2)(&superInfo, _cmd, toWindow, fromWindow);
    reinterpret_cast<void (*)(objc_super *, SEL, id, id)>(objc_msgSendSuper2)(&superInfo, _cmd, toWindow, fromWindow);
    
    if ([fromWindow.toolbar isEqual:self.toolbar]) {
        fromWindow.toolbar = nil;
    }
    
    toWindow.toolbar = self.toolbar;
}

- (NSToolbar *)toolbar {
    if (auto toolbar = _toolbar) return toolbar;
    
    NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:@"SearchToolbarItemViewController"];
    
    toolbar.delegate = self;
    
    _toolbar = [toolbar retain];
    return [toolbar autorelease];
}

- (NSSearchToolbarItem *)searchToolbarItem {
    if (auto searchToolbarItem = _searchToolbarItem) return searchToolbarItem;
    
    NSSearchToolbarItem *searchToolbarItem = [[NSSearchToolbarItem alloc] initWithItemIdentifier:@"Search"];
    searchToolbarItem.resignsFirstResponderWithCancel = NO;
    
    NSSearchField *searchField = searchToolbarItem.searchField;
    
    searchField.delegate = self;
    searchField.recentsAutosaveName = @"SearchToolbarItemViewController";
    searchField.maximumRecents = 5;
    
    NSMenu *menu = [NSMenu new];
    [menu addItemWithTitle:@"Hello!" action:nil keyEquivalent:@""];
    searchField.menu = menu;
    [menu release];
    
    // 왼쪽 돋보기 아이콘 누르면 나오는 메뉴
    searchField.searchMenuTemplate = self.searchMenuTemplate;
    
    _searchToolbarItem = [searchToolbarItem retain];
    return [searchToolbarItem autorelease];
}

- (NSMenu *)searchMenuTemplate {
    if (auto searchMenuTemplate = _searchMenuTemplate) return searchMenuTemplate;
    
    NSMenu *searchMenuTemplate = [NSMenu new];
    
    NSMenu *recentsMenu = [NSMenu new];
    recentsMenu.delegate = self;
    
    NSMenuItem *recentsMenuItem = [[NSMenuItem alloc] initWithTitle:@"Recents" action:nil keyEquivalent:@""];
    recentsMenuItem.submenu = recentsMenu;
    [recentsMenu release];
    
    [searchMenuTemplate addItem:recentsMenuItem];
    [recentsMenuItem release];
    
    _searchMenuTemplate = [searchMenuTemplate retain];
    return [searchMenuTemplate autorelease];
}

- (NSButton *)toggleSearchInteractionButton {
    if (auto toggleSearchInteractionButton = _toggleSearchInteractionButton) return toggleSearchInteractionButton;
    
    NSButton *toggleSearchInteractionButton = [NSButton buttonWithTitle:@"Toggle Search Interaction" target:self action:@selector(didTriggerToggleSearchInteractionButton:)];
    
    _toggleSearchInteractionButton = [toggleSearchInteractionButton retain];
    return toggleSearchInteractionButton;
}

- (NSButton *)logRecentSearchesButton {
    if (auto logRecentSearchesButton = _logRecentSearchesButton) return logRecentSearchesButton;
    
    NSButton *logRecentSearchesButton = [NSButton buttonWithTitle:@"Log Recent Searches" target:self action:@selector(didTriggerLogRecentSearchesButton:)];
    
    _logRecentSearchesButton = [logRecentSearchesButton retain];
    return logRecentSearchesButton;
}

- (NSButton *)clearRecentSearchesButton {
    if (auto clearRecentSearchesButton = _clearRecentSearchesButton) return clearRecentSearchesButton;
    
    NSButton *clearRecentSearchesButton = [NSButton buttonWithTitle:@"Clear Recent Searches" target:self action:@selector(didTriggerClearRecentSearchesButton:)];
    
    _clearRecentSearchesButton = [clearRecentSearchesButton retain];
    return clearRecentSearchesButton;
}

- (NSStackView *)stackView {
    if (auto stackView = _stackView) return stackView;
    
    NSStackView *stackView = [NSStackView new];
    stackView.alignment = NSLayoutAttributeCenterX;
    stackView.orientation = NSUserInterfaceLayoutOrientationVertical;
    
    [stackView addArrangedSubview:self.toggleSearchInteractionButton];
    [stackView addArrangedSubview:self.logRecentSearchesButton];
    [stackView addArrangedSubview:self.clearRecentSearchesButton];
    
    _stackView = [stackView retain];
    return [stackView autorelease];
}

- (void)didTriggerToggleSearchInteractionButton:(NSButton *)sender {
//    BOOL isCurrentlyEditing = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(self.searchToolbarItem.searchField, sel_registerName("isCurrentlyEditing"));
//    BOOL isCurrentlyEditing = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(self.searchToolbarItem, sel_registerName("isEditing"));
    BOOL isCurrentlyEditing = self.searchToolbarItem.searchField.currentEditor != nil;
    
    if (isCurrentlyEditing) {
        [self.searchToolbarItem endSearchInteraction];
    } else {
        [self.searchToolbarItem beginSearchInteraction];
    }
}

- (void)didTriggerLogRecentSearchesButton:(NSButton *)sender {
    NSLog(@"%@", self.searchToolbarItem.searchField.recentSearches);
}

- (void)didTriggerClearRecentSearchesButton:(NSButton *)sender {
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self.searchToolbarItem.searchField.cell, sel_registerName("_searchFieldClearRecents:"), nil);
}

- (void)didTriggerFirstMenuItem:(NSMenuItem *)sender {
    
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
    return @[
        self.searchToolbarItem.itemIdentifier
    ];
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
    return [self toolbarDefaultItemIdentifiers:toolbar];
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarNavigationalItemIdentifiers:(NSToolbar *)toolbar {
    return [self toolbarDefaultItemIdentifiers:toolbar];
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSToolbarItemIdentifier)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
    if ([itemIdentifier isEqualToString:self.searchToolbarItem.itemIdentifier]) {
        return self.searchToolbarItem;
    } else {
        abort();
    }
}

- (void)searchFieldDidStartSearching:(NSSearchField *)sender {
    NSLog(@"%s", __func__);
}

- (void)searchFieldDidEndSearching:(NSSearchField *)sender {
    NSLog(@"%s", __func__);
}

- (void)controlTextDidChange:(NSNotification *)obj {
    NSTextView *textView = obj.userInfo[@"NSFieldEditor"];
    BOOL shouldComplete;
    
    if (_commandHandling) {
        shouldComplete = NO;
    } else {
        // NSTextViewCompletionController
        id completionController = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("NSTextViewCompletionController"), sel_registerName("sharedController"));
        
        // NSTextViewCompletionTableView
        __kindof NSTableView *tableView;
        object_getInstanceVariable(completionController, "_tableView", reinterpret_cast<void **>(&tableView));
        
        if (tableView == nil) {
            shouldComplete = YES;
        } else {
            NSInteger selectedRow = tableView.selectedRow;
            
            if (selectedRow == -1 || selectedRow == NSNotFound) {
                shouldComplete = YES;
            } else {
                shouldComplete = NO;
            }
        }
    }
    
    if (shouldComplete) {
        [textView complete:nil];
    }
    
    // complete -> completion list뜸 -> 자동으로 첫번째꺼가 선택됨 -> 글자가 바뀜 -> completion -> 반복되는 현상 방지
//    if (!self.completePosting && !self.commandHandling) {
//        _completePosting = YES;
//        [textView complete:nil];
//        _completePosting = NO;
//    }
}

- (NSArray<NSString *> *)control:(NSControl *)control textView:(NSTextView *)textView completions:(NSArray<NSString *> *)words forPartialWordRange:(NSRange)charRange indexOfSelectedItem:(NSInteger *)index {
    NSArray<NSString *> *recentSearches = self.searchToolbarItem.searchField.recentSearches;
    
    NSMutableArray<NSString *> *matches = [NSMutableArray new];
    
    /*
     NSAnchoredSearch = 시작 부분만 검색
     */
    NSUInteger rangeOptions = NSAnchoredSearch | NSCaseInsensitiveSearch;
    
    for (NSString *reentSearch in recentSearches) {
        
    }
    
    return [matches autorelease];
}

// 삭제가 될 때는 Completion Menu를 띄우면 안 되므로, 삭제될 때를 감지해서 _commandHandling 값을 바꿔줌
- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector {
    if ([textView respondsToSelector:commandSelector]) {
        _commandHandling = YES;
        reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(textView, commandSelector);
        _commandHandling = NO;
        return YES;
    } else {
        return NO;
    }
}

- (NSArray *)textField:(NSTextField *)textField textView:(NSTextView *)textView candidatesForSelectedRange:(NSRange)selectedRange {
    abort();
}

- (NSArray<NSTextCheckingResult *> *)textField:(NSTextField *)textField textView:(NSTextView *)textView candidates:(NSArray<NSTextCheckingResult *> *)candidates forSelectedRange:(NSRange)selectedRange {
    abort();
}

- (BOOL)textField:(NSTextField *)textField textView:(NSTextView *)textView shouldSelectCandidateAtIndex:(NSUInteger)index {
    abort();
}


#pragma mark - NSMenuDelegate

- (NSInteger)numberOfItemsInMenu:(NSMenu *)menu {
    NSLog(@"%ld", self.searchToolbarItem.searchField.recentSearches.count);
    return self.searchToolbarItem.searchField.recentSearches.count;
}

- (BOOL)menu:(NSMenu *)menu updateItem:(NSMenuItem *)item atIndex:(NSInteger)index shouldCancel:(BOOL)shouldCancel {
    NSMenuItem *menuItem = [menu itemAtIndex:index];
    menuItem.title = self.searchToolbarItem.searchField.recentSearches[index];
    menuItem.target = self;
    menuItem.action = @selector(didTriggerRecentsMenuItem:);
    
    return YES;
}

- (void)didTriggerRecentsMenuItem:(NSMenuItem *)sender {
    NSLog(@"%@", sender.title);
}


@end
