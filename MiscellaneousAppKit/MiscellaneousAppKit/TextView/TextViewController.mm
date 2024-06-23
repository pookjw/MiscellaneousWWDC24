//
//  TextViewController.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/23/24.
//

#import "TextViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

// TODO: NSRuler 써보기

@interface TextViewController () <NSToolbarDelegate>
@property (retain, nonatomic, readonly) NSScrollView *scrollView;
@property (retain, nonatomic, readonly) NSTextView *textView;
@property (retain, nonatomic, readonly) NSToolbar *toolbar;
@property (retain, nonatomic, readonly) NSToolbarItem *updateTextHighlightAttributesToolbarItem;
@end

@implementation TextViewController
@synthesize scrollView = _scrollView;
@synthesize textView = _textView;
@synthesize toolbar = _toolbar;
@synthesize updateTextHighlightAttributesToolbarItem = _updateTextHighlightAttributesToolbarItem;

- (void)dealloc {
    [_scrollView release];
    [_textView release];
    [_toolbar release];
    [_updateTextHighlightAttributesToolbarItem release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)_viewDidMoveToWindow:(NSWindow * _Nullable)toWindow fromWindow:(NSWindow * _Nullable)fromWindow {
    objc_super superInfo = { self, [self class] };
    ((void (*)(objc_super *, SEL, id, id))objc_msgSendSuper2)(&superInfo, _cmd, toWindow, fromWindow);
    
    toWindow.toolbar = self.toolbar;
}

- (NSScrollView *)scrollView {
    if (auto scrollView = _scrollView) return scrollView;
    
    NSScrollView *scrollView = [NSScrollView new];
    scrollView.documentView = self.textView;
    scrollView.drawsBackground = NO;
    
    _scrollView = [scrollView retain];
    return [scrollView autorelease];
}

- (NSTextView *)textView {
    if (auto textView = _textView) return textView;
    
    NSTextView *textView = [NSTextView new];
    textView.autoresizingMask = NSViewWidthSizable;
    
    _textView = [textView retain];
    return [textView autorelease];
}

- (NSToolbar *)toolbar {
    if (auto toolbar = _toolbar) return toolbar;
    
    NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:@"TextViewToolbar"];
    
    toolbar.delegate = self;
    toolbar.itemIdentifiers = @[
        @"updateTextHighlightAttributes"
    ];
    
    _toolbar = [toolbar retain];
    return [toolbar autorelease];
}

- (NSToolbarItem *)updateTextHighlightAttributesToolbarItem {
    if (auto updateTextHighlightAttributesToolbarItem = _updateTextHighlightAttributesToolbarItem) return updateTextHighlightAttributesToolbarItem;
    
    NSToolbarItem *updateTextHighlightAttributesToolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:@"updateTextHighlightAttributes"];
    updateTextHighlightAttributesToolbarItem.title = @"1";
    updateTextHighlightAttributesToolbarItem.target = self;
    updateTextHighlightAttributesToolbarItem.action = @selector(updateTextHighlightAttributesToolbarItemDidTrigger:);
    
    _updateTextHighlightAttributesToolbarItem = [updateTextHighlightAttributesToolbarItem retain];
    return [updateTextHighlightAttributesToolbarItem autorelease];
}

- (void)updateTextHighlightAttributesToolbarItemDidTrigger:(NSToolbarItem *)sender {
    
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
    return @[
        self.updateTextHighlightAttributesToolbarItem.itemIdentifier
    ];
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
    return [self toolbarAllowedItemIdentifiers:toolbar];
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSToolbarItemIdentifier)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
    if ([itemIdentifier isEqualToString:self.updateTextHighlightAttributesToolbarItem.itemIdentifier]) {
        return self.updateTextHighlightAttributesToolbarItem;
    } else {
        return nil;
    }
}

@end
