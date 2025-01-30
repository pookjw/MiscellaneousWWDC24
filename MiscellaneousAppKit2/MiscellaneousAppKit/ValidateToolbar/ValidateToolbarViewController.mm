//
//  ValidateToolbarViewController.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 7/16/24.
//

#import "ValidateToolbarViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

// https://x.com/_silgen_name/status/1813231449199534385
// First Responder가 Action에 Responds 하는지 확인하는 것을 Validation이라 한다.

OBJC_EXPORT id objc_msgSendSuper2(void);

@interface VTMyToolbarItem : NSToolbarItem
@end
@implementation VTMyToolbarItem

- (void)validate {
    [super validate];
}

@end

@interface ValidateToolbarViewController () <NSToolbarDelegate>
@property (retain, readonly, nonatomic) NSToolbar *toolbar;
@property (retain, readonly, nonatomic) VTMyToolbarItem *testToolbarItem;
@end

@implementation ValidateToolbarViewController
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
    reinterpret_cast<void (*)(objc_super *, SEL, id, id)>(objc_msgSendSuper2)(&superInfo, _cmd, toWindow, fromWindow);
    
    if ([fromWindow.toolbar isEqual:self.toolbar]) {
        fromWindow.toolbar = nil;
    }
    
    toWindow.toolbar = self.toolbar;
}

- (NSToolbar *)toolbar {
    if (auto toolbar = _toolbar) return toolbar;
    
    NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:@"ValidateToolbarViewController"];
    
    toolbar.delegate = self;
    
    _toolbar = [toolbar retain];
    return [toolbar autorelease];
}

- (VTMyToolbarItem *)testToolbarItem {
    if (auto testToolbarItem = _testToolbarItem) return testToolbarItem;
    
    VTMyToolbarItem *testToolbarItem = [[VTMyToolbarItem alloc] initWithItemIdentifier:@"testToolbarItem"];
    
    testToolbarItem.label = @"Sheet";
    testToolbarItem.image = [NSImage imageWithSystemSymbolName:@"printer.filled.and.paper" accessibilityDescription:nil];
    testToolbarItem.target = self;
    testToolbarItem.action = @selector(didTriggerTestToolbarItem:);
    testToolbarItem.autovalidates = NO;
    
    _testToolbarItem = [testToolbarItem retain];
    return [testToolbarItem autorelease];
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
    return @[self.testToolbarItem.itemIdentifier];
}

- (void)didTriggerTestToolbarItem:(NSToolbarItem *)sender {
    NSToolbarItem *testToolbarItem = self.testToolbarItem;
    
    testToolbarItem.label = NSDate.now.description;
    testToolbarItem.target = nil;
    testToolbarItem.action = sel_registerName("fff");
    
    [self.toolbar validateVisibleItems];
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
    return [self toolbarDefaultItemIdentifiers:toolbar];
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSToolbarItemIdentifier)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
    if ([itemIdentifier isEqualToString:self.testToolbarItem.itemIdentifier]) {
        return self.testToolbarItem;
    } else {
        abort();
    }
}

@end
