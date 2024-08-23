//
//  WritingToolsViewController.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 7/31/24.
//

#import "WritingToolsViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import <dlfcn.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

// +[WTWritingTools sharedInstance]

OBJC_EXPORT id objc_msgSendSuper2(void);

namespace _WTWritingToolsViewController {

void *customPopoverBehaviorKey = &customPopoverBehaviorKey;

void open() {
    void *handle = dlopen("/System/Library/PrivateFrameworks/WritingToolsUI.framework/Versions/A/WritingToolsUI", RTLD_NOW);
    assert(handle != NULL);
}

namespace showInPopover_relativeToRect_ofView_forRequestedTool {
void (*original)(id, SEL, id, CGRect, id, NSInteger);
void custom(__kindof NSViewController *self, SEL _cmd, NSPopover *popover, CGRect rect, NSView *view, NSInteger tool) {
    id<NSTextInput> textInputClient = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("textInputClient"));
    
    if (NSNumber *customPopoverBehavior = objc_getAssociatedObject(textInputClient, customPopoverBehaviorKey)) {
        popover.behavior = static_cast<NSPopoverBehavior>(customPopoverBehavior.integerValue);
    }
    
    original(self, _cmd, popover, rect, view, tool);
}
void swizzle() {
    Method method = class_getInstanceMethod(objc_lookUpClass("WTWritingToolsViewController"), sel_registerName("showInPopover:relativeToRect:ofView:forRequestedTool:"));
    original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}
}

namespace setAppFocusLostObserver {
void (*original)(id, SEL, id);
void custom(__kindof NSViewController *self, SEL _cmd, id appFocusLostObserver) {
    id<NSTextInput> textInputClient = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("textInputClient"));
    
    if (objc_getAssociatedObject(textInputClient, customPopoverBehaviorKey) != NULL) {
        [NSNotificationCenter.defaultCenter removeObserver:appFocusLostObserver];
    } else {
        original(self, _cmd, appFocusLostObserver);
    }
}
void swizzle() {
    Method method = class_getInstanceMethod(objc_lookUpClass("WTWritingToolsViewController"), sel_registerName("setAppFocusLostObserver:"));
    original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}
}

}

//namespace _NSTextView {
//namespace _textRangeForCharRange {
//id (*original)(id, SEL, NSRange);
//id custom(NSTextView *self, SEL _cmd, NSRange charRange) {
//    if (charRange.location > 4000000000) {
//        return original(self, _cmd, NSMakeRange(0, self.string.length));
//    }
//    return original(self, _cmd, charRange);
//}
//void swizzle() {
//    Method method = class_getInstanceMethod(NSTextView.class, sel_registerName("_textRangeForCharRange:"));
//    original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
//    method_setImplementation(method, reinterpret_cast<IMP>(custom));
//}
//}
//}

@interface WritingToolsViewController () <NSToolbarDelegate>
@property (retain, readonly, nonatomic) NSToolbar *toolbar;
@property (retain, readonly, nonatomic) NSMenuToolbarItem *textEffectToolbarItem;
@property (retain, readonly, nonatomic) NSMenuToolbarItem *originalWritingToolsToolbarItem;
@property (retain, readonly, nonatomic) NSMenuToolbarItem *writingToolsToolbarItem;
@property (retain, readonly, nonatomic) NSScrollView *scrollView;
@property (retain, readonly, nonatomic) NSTextView *textView;
@end

@implementation WritingToolsViewController
@synthesize toolbar = _toolbar;
@synthesize textEffectToolbarItem = _textEffectToolbarItem;
@synthesize originalWritingToolsToolbarItem = _originalWritingToolsToolbarItem;
@synthesize writingToolsToolbarItem = _writingToolsToolbarItem;
@synthesize scrollView = _scrollView;
@synthesize textView = _textView;

+ (void)load {
    using namespace _WTWritingToolsViewController;
    open();
    showInPopover_relativeToRect_ofView_forRequestedTool::swizzle();
    setAppFocusLostObserver::swizzle();
    
//    _NSTextView::_textRangeForCharRange::swizzle();
}

- (void)dealloc {
    [_toolbar release];
    [_textEffectToolbarItem release];
    [_originalWritingToolsToolbarItem release];
    [_writingToolsToolbarItem release];
    [_scrollView release];
    [_textView release];
    
    [super dealloc];
}

- (void)_viewDidMoveToWindow:(NSWindow * _Nullable)toWindow fromWindow:(NSWindow * _Nullable)fromWindow {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL, id, id)>(objc_msgSendSuper2)(&superInfo, _cmd, toWindow, fromWindow);
    
    if ([fromWindow.toolbar isEqual:self.toolbar]) {
        fromWindow.toolbar = nil;
    }
    
    toWindow.toolbar = self.toolbar;
}

- (void)loadView {
    self.view = self.scrollView;
}

- (NSToolbar *)toolbar {
    if (auto toolbar = _toolbar) return toolbar;
    
    NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:@"WritingToolsViewController"];
    
    toolbar.delegate = self;
    
    _toolbar = [toolbar retain];
    return [toolbar autorelease];
}

- (NSMenuToolbarItem *)textEffectToolbarItem {
    if (auto textEffectToolbarItem = _textEffectToolbarItem) return textEffectToolbarItem;
    
    NSMenuToolbarItem *textEffectToolbarItem = [[NSMenuToolbarItem alloc] initWithItemIdentifier:@"textEffectToolbarItem"];
    
    NSMenu *menu = [NSMenu new];
    
    NSMenuItem *sweepTextEffectMenuItem = [menu addItemWithTitle:@"_WTSweepTextEffect" action:@selector(didTriggerSweepTextEffectMenuItem:) keyEquivalent:@""];
    sweepTextEffectMenuItem.target = self;
    
    NSMenuItem *replaceTextEffectMenuItem = [menu addItemWithTitle:@"_WTReplaceTextEffect" action:@selector(didTriggerReplaceTextEffectMenuItem:) keyEquivalent:@""];
    replaceTextEffectMenuItem.target = self;
    
    NSMenuItem *finaleTextEffectMenuItem = [menu addItemWithTitle:@"_WTFinaleTextEffect" action:@selector(didTriggerFinaleTextEffectMenuItem:) keyEquivalent:@""];
    finaleTextEffectMenuItem.target = self;
    
    [menu addItem:[NSMenuItem separatorItem]];
    
    NSMenuItem *stopTextEffectMenuItem = [menu addItemWithTitle:@"Stop Text Effect" action:@selector(didTriggerStopTextEffectMenuItem:) keyEquivalent:@""];
    stopTextEffectMenuItem.target = self;
    
    textEffectToolbarItem.menu = menu;
    [menu release];
    
    _textEffectToolbarItem = [textEffectToolbarItem retain];
    return [textEffectToolbarItem autorelease];
}

- (void)didTriggerSweepTextEffectMenuItem:(NSMenuItem *)sender {
    // _WTSweepTextEffect
    reinterpret_cast<void (*)(id, SEL, NSRange)>(objc_msgSend)(self.textView, sel_registerName("_invokePonderingForRange:"), NSMakeRange(0, self.textView.string.length));
}

- (void)didTriggerReplaceTextEffectMenuItem:(NSMenuItem *)sender {
    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(self.textView, sel_registerName("_installWritingToolsEffectViewIfNecessary"));

    // _WTTextEffectView *
    __kindof NSView *textEffectView = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self.textView, sel_registerName("textEffectView"));
    
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(textEffectView, sel_registerName("removeAllEffectsAnimated:"), YES);
    
    // _WTTextRangeChunk
    id chunk = reinterpret_cast<id (*)(id, SEL, NSRange)>(objc_msgSend)([objc_lookUpClass("_WTTextRangeChunk") alloc], sel_registerName("initWithRange:"), NSMakeRange(0, self.textView.string.length));
    id effect = reinterpret_cast<id (*)(id, SEL, id, id)>(objc_msgSend)([objc_lookUpClass("_WTReplaceTextEffect") alloc], sel_registerName("initWithChunk:effectView:"), chunk, textEffectView);
    [chunk release];
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(textEffectView, sel_registerName("addEffect:"), effect);
    
    [effect release];
    
//    reinterpret_cast<void (*)(id, SEL, NSRange, id, id)>(objc_msgSend)(self.textView, sel_registerName("performReplaceWithSourceRange:changeBlock:completionBlock:"), NSMakeRange(0, self.textView.string.length), ^{
//        
//    }, ^NSRange {
//        return NSMakeRange(0, self.textView.string.length);
//    });
}

- (void)didTriggerFinaleTextEffectMenuItem:(NSMenuItem *)sender {
    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(self.textView, sel_registerName("_installWritingToolsEffectViewIfNecessary"));
    
    // _WTTextEffectView *
    __kindof NSView *textEffectView = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self.textView, sel_registerName("textEffectView"));
    
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(textEffectView, sel_registerName("removeAllEffectsAnimated:"), NO);
    
    // _WTTextRangeChunk
    id chunk = reinterpret_cast<id (*)(id, SEL, NSRange)>(objc_msgSend)([objc_lookUpClass("_WTTextRangeChunk") alloc], sel_registerName("initWithRange:"), NSMakeRange(0, self.textView.string.length));
    id effect = reinterpret_cast<id (*)(id, SEL, id, id)>(objc_msgSend)([objc_lookUpClass("_WTFinaleTextEffect") alloc], sel_registerName("initWithChunk:effectView:"), chunk, textEffectView);
    [chunk release];
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(textEffectView, sel_registerName("addEffect:"), effect);
    
    [effect release];
}

- (void)didTriggerStopTextEffectMenuItem:(NSMenuItem *)sender {
//    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(self.textView, sel_registerName("stopWritingToolsAnimations"));
    
    // _WTTextEffectView *
    __kindof NSView *textEffectView = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self.textView, sel_registerName("textEffectView"));
    
    if (textEffectView == nil) return;
    
//    NSMutableDictionary *textEffects = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(textEffectView, sel_registerName("textEffects"));
//    
//    for (id effect in textEffects.allValues) {
////        if ([effect isKindOfClass:objc_lookUpClass("_WTSweepTextEffect")]) {
////            reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(effect, sel_registerName("invalidate:"), NO);
////        }
//        reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(effect, sel_registerName("setHidesOriginal:"), YES);
//    }
    
    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(textEffectView, sel_registerName("removeAllEffects"));
    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(self.textView, sel_registerName("_uninstallWritingToolsEffectView"));
    
    // updateIsTextVisible:forChunk:은 아무것도 안함
//    // _WTTextRangeChunk
//    id chunk = reinterpret_cast<id (*)(id, SEL, NSRange)>(objc_msgSend)([objc_lookUpClass("_WTTextRangeChunk") alloc], sel_registerName("initWithRange:"), NSMakeRange(0, self.textView.string.length));
//    reinterpret_cast<void (*)(id, SEL, BOOL, id)>(objc_msgSend)(self.textView, sel_registerName("updateIsTextVisible:forChunk:"), YES, chunk);
//    [chunk release];
    
    // stopWritingToolsAnimations를 가져온 코드인데 임의로 Animation 실행한거라 _writingToolsData이 0x0이라 의미 없는듯
    // NSTextViewSharedData
//    id _sharedData;
//    object_getInstanceVariable(self.textView, "_sharedData", reinterpret_cast<void **>(&_sharedData));
//    
//    id _writingToolsData;
//    object_getInstanceVariable(_sharedData, "_writingToolsData", reinterpret_cast<void **>(&_writingToolsData));
//    
//    id textAnimationContexts = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(_writingToolsData, sel_registerName("textAnimationContexts"));
//    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(textAnimationContexts, sel_registerName("removeAllObjects"));
    
    
    
//    id context = reinterpret_cast<id (*)(id, SEL, NSRange)>(objc_msgSend)(self.textView, sel_registerName("textAnimationContextForRange:"), NSMakeRange(0, self.textView.string.length));
}

- (NSMenuToolbarItem *)originalWritingToolsToolbarItem {
    if (auto originalWritingToolsToolbarItem = _originalWritingToolsToolbarItem) return originalWritingToolsToolbarItem;
    
    NSMenuToolbarItem *originalWritingToolsToolbarItem = [[NSMenuToolbarItem alloc] initWithItemIdentifier:@"originalWritingToolsToolbarItem"];
    
    originalWritingToolsToolbarItem.image = [NSImage imageWithSystemSymbolName:@"pencil.tip" accessibilityDescription:nil];
    
    NSMenu *menu = [NSMenu new];
    NSMenuItem *standardWritingToolsMenuItem = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(NSMenuItem.class, sel_registerName("standardWritingToolsMenuItem"));
    [menu addItem:standardWritingToolsMenuItem];
    originalWritingToolsToolbarItem.menu = menu;
    [menu release];
    
    _originalWritingToolsToolbarItem = [originalWritingToolsToolbarItem retain];
    return [originalWritingToolsToolbarItem autorelease];
}

- (NSMenuToolbarItem *)writingToolsToolbarItem {
    if (auto writingToolsToolbarItem = _writingToolsToolbarItem) return writingToolsToolbarItem;
    
    NSMenuToolbarItem *writingToolsToolbarItem = [[NSMenuToolbarItem alloc] initWithItemIdentifier:@"writingToolsToolbarItem"];
    
    writingToolsToolbarItem.image = [NSImage imageWithSystemSymbolName:@"pencil" accessibilityDescription:nil];
    
    NSMenu *menu = [NSMenu new];
    
    NSMenuItem *showWritingToolsMenuItem = [menu addItemWithTitle:@"Show Writing Tools" action:sel_registerName("showWritingTools:") keyEquivalent:@""];
    showWritingToolsMenuItem.target = self.textView;
    
    NSMenuItem *proofreadingMenuItem = [menu addItemWithTitle:@"Proofreading" action:@selector(didTriggerWritingToolsMenuItem:) keyEquivalent:@""];
    proofreadingMenuItem.tag = 1;
    
    NSMenuItem *rewriteMenuItem = [menu addItemWithTitle:@"Rewrite" action:@selector(didTriggerWritingToolsMenuItem:) keyEquivalent:@""];
    rewriteMenuItem.tag = 2;
    
    NSMenuItem *makeFriendlyMenuItem = [menu addItemWithTitle:@"Make Friendly" action:@selector(didTriggerWritingToolsMenuItem:) keyEquivalent:@""];
    makeFriendlyMenuItem.tag = 11;
    
    NSMenuItem *makeProfessionalMenuItem = [menu addItemWithTitle:@"Make Professional" action:@selector(didTriggerWritingToolsMenuItem:) keyEquivalent:@""];
    makeProfessionalMenuItem.tag = 12;
    
    NSMenuItem *makeConciseMenuItem = [menu addItemWithTitle:@"Make Concise" action:@selector(didTriggerWritingToolsMenuItem:) keyEquivalent:@""];
    makeConciseMenuItem.tag = 13;
    
    NSMenuItem *summarizeMenuItem = [menu addItemWithTitle:@"Summarize" action:@selector(didTriggerWritingToolsMenuItem:) keyEquivalent:@""];
    summarizeMenuItem.tag = 21;
    
    NSMenuItem *createKeyPointsMenuItem = [menu addItemWithTitle:@"Create Key Points" action:@selector(didTriggerWritingToolsMenuItem:) keyEquivalent:@""];
    createKeyPointsMenuItem.tag = 22;
    
    NSMenuItem *makeListMenuItem = [menu addItemWithTitle:@"Make List" action:@selector(didTriggerWritingToolsMenuItem:) keyEquivalent:@""];
    makeListMenuItem.tag = 23;
    
    NSMenuItem *makeTableMenuItem = [menu addItemWithTitle:@"Make Table" action:@selector(didTriggerWritingToolsMenuItem:) keyEquivalent:@""];
    makeTableMenuItem.tag = 24;
    
    writingToolsToolbarItem.menu = menu;
    [menu release];
    
    _writingToolsToolbarItem = [writingToolsToolbarItem retain];
    return [writingToolsToolbarItem autorelease];
}

- (void)didTriggerWritingToolsMenuItem:(NSMenuItem *)sender {
    reinterpret_cast<void (*)(id, SEL, NSInteger, id, id)>(objc_msgSend)(self.textView, sel_registerName("_showWritingTools:smartReplyConfiguration:sender:"), sender.tag, nil, nil);
}

- (NSScrollView *)scrollView {
    if (auto scrollView = _scrollView) return scrollView;
    
    NSScrollView *scrollView = [NSScrollView new];
    scrollView.documentView = self.textView;
    
    _scrollView = [scrollView retain];
    return [scrollView autorelease];
}

- (NSTextView *)textView {
    if (auto textView = _textView) return textView;
    
    NSTextView *textView = [NSTextView new];
    textView.autoresizingMask = NSViewWidthSizable;
    
    NSURL *articleURL = [NSBundle.mainBundle URLForResource:@"article" withExtension:UTTypePlainText.preferredFilenameExtension];
    NSError * _Nullable error = nil;
    NSString *text = [[NSString alloc] initWithContentsOfURL:articleURL encoding:NSUTF8StringEncoding error:&error];
    assert(error == nil);
    textView.string = text;
    
    objc_setAssociatedObject(textView, _WTWritingToolsViewController::customPopoverBehaviorKey, @(NSPopoverBehaviorSemitransient), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    _textView = [textView retain];
    return [textView autorelease];
}

//- (void)didTriggerStartAnimationToolbarItem:(NSToolbarItem *)sender {
//    reinterpret_cast<void (*)(id, SEL, NSInteger, NSRange)>(objc_msgSend)(self.textView, sel_registerName("startWritingToolsAnimationOfType:inRange:"), 1, NSMakeRange(0, self.textView.string.length));
//}
//
//- (void)didTriggerStopAnimationToolbarItem:(NSToolbarItem *)sender {
//    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(self.textView, sel_registerName("stopWritingToolsAnimations"));
//    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(self.textView, sel_registerName("stopTextPlaceholderAnimations"));
//}

- (NSArray<NSToolbarItemIdentifier> *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
    return @[
        self.textEffectToolbarItem.itemIdentifier,
        self.originalWritingToolsToolbarItem.itemIdentifier,
        self.writingToolsToolbarItem.itemIdentifier
    ];
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
    return [self toolbarDefaultItemIdentifiers:toolbar];
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSToolbarItemIdentifier)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
    if ([itemIdentifier isEqualToString:self.writingToolsToolbarItem.itemIdentifier]) {
        return self.writingToolsToolbarItem;
    } else if ([itemIdentifier isEqualToString:self.originalWritingToolsToolbarItem.itemIdentifier]) {
        return self.originalWritingToolsToolbarItem;
    } else if ([itemIdentifier isEqualToString:self.textEffectToolbarItem.itemIdentifier]) {
        return self.textEffectToolbarItem;
    } else {
        return nil;
    }
}

@end
