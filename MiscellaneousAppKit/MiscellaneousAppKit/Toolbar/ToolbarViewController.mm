//
//  ToolbarViewController.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/24/24.
//

#import "ToolbarViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

@interface ToolbarViewController () <NSToolbarDelegate>
@property (retain, readonly, nonatomic) NSToolbar *toolbar;
@property (retain, readonly, nonatomic) NSToolbarItem *testToolbarItem;
@end

@implementation ToolbarViewController
@synthesize toolbar = _toolbar;
@synthesize testToolbarItem = _testToolbarItem;

- (void)dealloc {
    [_toolbar release];
    [_testToolbarItem release];
    [super dealloc];
}

- (void)_viewDidMoveToWindow:(NSWindow * _Nullable)toWindow fromWindow:(NSWindow * _Nullable)fromWindow {
    objc_super superInfo = { self, [self class] };
    ((void (*)(objc_super *, SEL, id, id))objc_msgSendSuper2)(&superInfo, _cmd, toWindow, fromWindow);
    
    if ([fromWindow.toolbar isEqual:self.toolbar]) {
        fromWindow.toolbar = nil;
    }
    
    toWindow.toolbar = self.toolbar;
}

- (NSToolbar *)toolbar {
    if (auto toolbar = _toolbar) return toolbar;
    
    NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:@"MyToolbar"];
    
    toolbar.delegate = self;
    
    _toolbar = [toolbar retain];
    return [toolbar autorelease];
}

- (NSToolbarItem *)testToolbarItem {
    if (auto testToolbarItem = _testToolbarItem) return testToolbarItem;
    
    NSToolbarItem *testToolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:@"testToolbarItem"];
    testToolbarItem.label = @"Test";
    testToolbarItem.title = @"Title";
//    testToolbarItem.image = [NSImage imageWithSystemSymbolName:@"eraser.line.dashed.fill" accessibilityDescription:nil];
    testToolbarItem.target = self;
    testToolbarItem.action = @selector(testToolbarItemDidTrigger:);
    
    _testToolbarItem = [testToolbarItem retain];
    return [testToolbarItem autorelease];
}

- (void)testToolbarItemDidTrigger:(NSToolbarItem *)sender {
//    [self.toolbar removeItemWithItemIdentifier:sender.itemIdentifier];
    self.toolbar.allowsDisplayModeCustomization = NO;
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
    return @[
        self.testToolbarItem.itemIdentifier
    ];
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
    return [self toolbarAllowedItemIdentifiers:toolbar];
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSToolbarItemIdentifier)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
    if ([itemIdentifier isEqualToString:self.testToolbarItem.itemIdentifier]) {
        return self.testToolbarItem;
    } else {
        return nil;
    }
}

@end
