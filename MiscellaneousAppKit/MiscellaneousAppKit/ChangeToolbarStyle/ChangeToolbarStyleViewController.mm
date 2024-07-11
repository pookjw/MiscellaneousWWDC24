//
//  ChangeToolbarStyleViewController.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 7/11/24.
//

#import "ChangeToolbarStyleViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

// validateVisibleItems이 뭔지 보기

OBJC_EXPORT id objc_msgSendSuper2(void);

@interface ChangeToolbarStyleViewController () <NSToolbarDelegate>
@property (retain, readonly, nonatomic) NSToolbar *toolbar;
@property (retain, readonly, nonatomic) NSToolbarItem *pencilToolbarItem;
@property (retain, readonly, nonatomic) NSToolbarItem *lassoToolbarItem;
@property (retain, readonly, nonatomic) NSToolbarItem *trashToolbarItem;
@property (retain, readonly, nonatomic) NSToolbarItem *bookmarkToolbarItem;
@property (retain, readonly, nonatomic) NSToolbarItem *folderToolbarItem;
@property (retain, readonly, nonatomic) NSToolbarItem *paperplaneToolbarItem;
@property (retain, readonly, nonatomic) NSButton *changeWindowToolbarStyleButton;
@end

@implementation ChangeToolbarStyleViewController
@synthesize toolbar = _toolbar;
@synthesize pencilToolbarItem = _pencilToolbarItem;
@synthesize lassoToolbarItem = _lassoToolbarItem;
@synthesize trashToolbarItem = _trashToolbarItem;
@synthesize bookmarkToolbarItem = _bookmarkToolbarItem;
@synthesize folderToolbarItem = _folderToolbarItem;
@synthesize paperplaneToolbarItem = _paperplaneToolbarItem;
@synthesize changeWindowToolbarStyleButton = _changeWindowToolbarStyleButton;

- (void)dealloc {
    [_toolbar release];
    [_pencilToolbarItem release];
    [_lassoToolbarItem release];
    [_trashToolbarItem release];
    [_bookmarkToolbarItem release];
    [_folderToolbarItem release];
    [_paperplaneToolbarItem release];
    [_changeWindowToolbarStyleButton release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSButton *changeWindowToolbarStyleButton = self.changeWindowToolbarStyleButton;
    changeWindowToolbarStyleButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:changeWindowToolbarStyleButton];
    [NSLayoutConstraint activateConstraints:@[
        [changeWindowToolbarStyleButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [changeWindowToolbarStyleButton.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor]
    ]];
}

- (void)_viewDidMoveToWindow:(NSWindow * _Nullable)toWindow fromWindow:(NSWindow * _Nullable)fromWindow {
    objc_super superInfo = { self, [self class] };
    ((void (*)(objc_super *, SEL, id, id))objc_msgSendSuper2)(&superInfo, _cmd, toWindow, fromWindow);
    
    if ([fromWindow.toolbar isEqual:self.toolbar]) {
        fromWindow.toolbar = nil;
    }
    
    [fromWindow removeObserver:self forKeyPath:@"toolbarStyle"];
    
    toWindow.toolbar = self.toolbar;
    
    [toWindow addObserver:self forKeyPath:@"toolbarStyle" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"toolbarStyle"]) {
        self.changeWindowToolbarStyleButton.title = [self stringFromToolbarStyle:((NSWindow *)object).toolbarStyle];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (NSToolbar *)toolbar {
    if (auto toolbar = _toolbar) return toolbar;
    
    NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:@"ChangeToolbarStyleViewController"];
    
    toolbar.allowsUserCustomization = YES;
    toolbar.delegate = self;
    
    // pencilToolbarItem만 가운데에 놓는게 아니라, pencilToolbarItem를 가운데에 놓고 나머지 Item들을 근처에 배치하는 것
//    toolbar.centeredItemIdentifiers = [NSSet setWithArray:@[self.pencilToolbarItem.itemIdentifier]];
    
//    toolbar.centeredItemIdentifier = self.pencilToolbarItem.itemIdentifier;
    
    _toolbar = [toolbar retain];
    return [toolbar autorelease];
}

- (NSToolbarItem *)pencilToolbarItem {
    if (auto pencilToolbarItem = _pencilToolbarItem) return pencilToolbarItem;
    
    NSToolbarItem *pencilToolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:@"pencilToolbarItem"];
    pencilToolbarItem.target = self;
    pencilToolbarItem.action = @selector(didTriggerPencilToolbarItem:);
    pencilToolbarItem.label = @"pencil";
    pencilToolbarItem.image = [NSImage imageWithSystemSymbolName:@"pencil" accessibilityDescription:nil];
    
    _pencilToolbarItem = [pencilToolbarItem retain];
    return [pencilToolbarItem autorelease];
}

- (void)didTriggerPencilToolbarItem:(NSToolbarItem *)sender {
    
}

- (NSToolbarItem *)lassoToolbarItem {
    if (auto lassoToolbarItem = _lassoToolbarItem) return lassoToolbarItem;
    
    NSToolbarItem *lassoToolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:@"lassoToolbarItem"];
    lassoToolbarItem.target = self;
    lassoToolbarItem.action = @selector(didTriggerLassoToolbarItem:);
    lassoToolbarItem.label = @"lasso";
    lassoToolbarItem.image = [NSImage imageWithSystemSymbolName:@"lasso" accessibilityDescription:nil];
    
    _lassoToolbarItem = [lassoToolbarItem retain];
    return [lassoToolbarItem autorelease];
}

- (void)didTriggerLassoToolbarItem:(NSToolbarItem *)sender {
    
}

- (NSToolbarItem *)trashToolbarItem {
    if (auto trashToolbarItem = _trashToolbarItem) return trashToolbarItem;
    
    NSToolbarItem *trashToolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:@"trashToolbarItem"];
    trashToolbarItem.target = self;
    trashToolbarItem.action = @selector(didTriggerTrashToolbarItem:);
    trashToolbarItem.label = @"trash";
    trashToolbarItem.image = [NSImage imageWithSystemSymbolName:@"trash" accessibilityDescription:nil];
    
    _trashToolbarItem = [trashToolbarItem retain];
    return [trashToolbarItem autorelease];
}

- (void)didTriggerTrashToolbarItem:(NSToolbarItem *)sender {
    
}

- (NSToolbarItem *)bookmarkToolbarItem {
    if (auto bookmarkToolbarItem = _bookmarkToolbarItem) return bookmarkToolbarItem;
    
    NSToolbarItem *bookmarkToolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:@"bookmarkToolbarItem"];
    bookmarkToolbarItem.target = self;
    bookmarkToolbarItem.action = @selector(didTriggerBookmarkToolbarItem:);
    bookmarkToolbarItem.label = @"bookmark";
    bookmarkToolbarItem.image = [NSImage imageWithSystemSymbolName:@"bookmark" accessibilityDescription:nil];
    
    _bookmarkToolbarItem = [bookmarkToolbarItem retain];
    return [bookmarkToolbarItem autorelease];
}

- (void)didTriggerBookmarkToolbarItem:(NSToolbarItem *)sender {
    
}

- (NSToolbarItem *)folderToolbarItem {
    if (auto folderToolbarItem = _folderToolbarItem) return folderToolbarItem;
    
    NSToolbarItem *folderToolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:@"folderToolbarItem"];
    folderToolbarItem.target = self;
    folderToolbarItem.action = @selector(didTriggerFolderToolbarItem:);
    folderToolbarItem.label = @"folder";
    folderToolbarItem.image = [NSImage imageWithSystemSymbolName:@"folder" accessibilityDescription:nil];
    
    _folderToolbarItem = [folderToolbarItem retain];
    return [folderToolbarItem autorelease];
}

- (void)didTriggerFolderToolbarItem:(NSToolbarItem *)sender {
    
}

- (NSToolbarItem *)paperplaneToolbarItem {
    if (auto paperplaneToolbarItem = _paperplaneToolbarItem) return paperplaneToolbarItem;
    
    NSToolbarItem *paperplaneToolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:@"paperplaneToolbarItem"];
    paperplaneToolbarItem.target = self;
    paperplaneToolbarItem.action = @selector(didTriggerPaperplaneToolbarItem:);
    paperplaneToolbarItem.label = @"paperplane";
    paperplaneToolbarItem.image = [NSImage imageWithSystemSymbolName:@"paperplane" accessibilityDescription:nil];
    
    _paperplaneToolbarItem = [paperplaneToolbarItem retain];
    return [paperplaneToolbarItem autorelease];
}

- (void)didTriggerPaperplaneToolbarItem:(NSToolbarItem *)sender {
    
}

- (NSButton *)changeWindowToolbarStyleButton {
    if (auto changeWindowToolbarStyleButton = _changeWindowToolbarStyleButton) return changeWindowToolbarStyleButton;
    
    NSButton *changeWindowToolbarStyleButton = [NSButton buttonWithTitle:@"Automatic" target:self action:@selector(didTriggerChangeWindowToolbarStyleButton:)];
    
    changeWindowToolbarStyleButton.title = [self stringFromToolbarStyle:self.view.window.toolbarStyle];
    
    _changeWindowToolbarStyleButton = [changeWindowToolbarStyleButton retain];
    return changeWindowToolbarStyleButton;
}

- (void)didTriggerChangeWindowToolbarStyleButton:(NSButton *)sender {
    NSWindow *window = self.view.window;
    NSWindowToolbarStyle toolbarStyle = window.toolbarStyle;
    
    switch (toolbarStyle) {
        case NSWindowToolbarStyleAutomatic:
            window.toolbarStyle = NSWindowToolbarStyleExpanded;
            break;
        case NSWindowToolbarStyleExpanded:
            window.toolbarStyle = NSWindowToolbarStylePreference;
            break;
        case NSWindowToolbarStylePreference:
            window.toolbarStyle = NSWindowToolbarStyleUnified;
            break;
        case NSWindowToolbarStyleUnified:
            window.toolbarStyle = NSWindowToolbarStyleUnifiedCompact;
            break;
        case NSWindowToolbarStyleUnifiedCompact:
            window.toolbarStyle = NSWindowToolbarStyleAutomatic;
            break;
        default:
            break;
    }
    
    window.toolbar.displayMode = NSToolbarDisplayModeIconAndLabel;
}

- (NSString *)stringFromToolbarStyle:(NSWindowToolbarStyle)toolbarStyle {
    switch (toolbarStyle) {
        case NSWindowToolbarStyleAutomatic:
            return @"NSWindowToolbarStyleAutomatic";
        case NSWindowToolbarStyleExpanded:
            return @"NSWindowToolbarStyleExpanded";
        case NSWindowToolbarStylePreference:
            return @"NSWindowToolbarStylePreference";
        case NSWindowToolbarStyleUnified:
            return @"NSWindowToolbarStyleUnified";
        case NSWindowToolbarStyleUnifiedCompact:
            return @"NSWindowToolbarStyleUnifiedCompact";
        default:
            abort();
    }
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
    return @[
        self.pencilToolbarItem.itemIdentifier,
        self.lassoToolbarItem.itemIdentifier,
        self.trashToolbarItem.itemIdentifier,
        self.bookmarkToolbarItem.itemIdentifier,
//        NSToolbarFlexibleSpaceItemIdentifier,
        self.folderToolbarItem.itemIdentifier,
        self.paperplaneToolbarItem.itemIdentifier
    ];
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
    return [self toolbarAllowedItemIdentifiers:toolbar];
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarNavigationalItemIdentifiers:(NSToolbar *)toolbar {
    return @[
        self.pencilToolbarItem.itemIdentifier,
        self.lassoToolbarItem.itemIdentifier,
    ];
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSToolbarItemIdentifier)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
    if ([itemIdentifier isEqualToString:self.pencilToolbarItem.itemIdentifier]) {
        return self.pencilToolbarItem;
    } else if ([itemIdentifier isEqualToString:self.lassoToolbarItem.itemIdentifier]) {
        return self.lassoToolbarItem;
    } else if ([itemIdentifier isEqualToString:self.trashToolbarItem.itemIdentifier]) {
        return self.trashToolbarItem;
    } else if ([itemIdentifier isEqualToString:self.bookmarkToolbarItem.itemIdentifier]) {
        return self.bookmarkToolbarItem;
    } else if ([itemIdentifier isEqualToString:self.folderToolbarItem.itemIdentifier]) {
        return self.folderToolbarItem;
    } else if ([itemIdentifier isEqualToString:self.paperplaneToolbarItem.itemIdentifier]) {
        return self.paperplaneToolbarItem;
    } else {
        return nil;
    }
}

@end
