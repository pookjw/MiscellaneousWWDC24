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
// TODO: NSForegroundColorAttributeName이 작동하지 않는 것 제보하기

@interface TextViewController () <NSToolbarDelegate>
@property (retain, nonatomic, readonly) NSScrollView *scrollView;
@property (retain, nonatomic, readonly) NSTextView *textView;
@property (retain, nonatomic, readonly) NSToolbar *toolbar;
@property (retain, nonatomic, readonly) NSToolbarItem *updateTextHighlightAttributesToolbarItem;
@property (retain, nonatomic, readonly) NSToolbarItem *applyTextHighlightStyleToolbarItem;
@property (retain, nonatomic, readonly) NSToolbarItem *applyTextHighlightColorSchemeToolbarItem;
@property (retain, nonatomic, readonly) NSToolbarItem *addAdaptiveImageGlyphToolbarItem;
@property (retain, nonatomic, readonly) NSToolbarItem *addLocalizedNumberFormatToolbarItem;
@end

@implementation TextViewController
@synthesize scrollView = _scrollView;
@synthesize textView = _textView;
@synthesize toolbar = _toolbar;
@synthesize updateTextHighlightAttributesToolbarItem = _updateTextHighlightAttributesToolbarItem;
@synthesize applyTextHighlightStyleToolbarItem = _applyTextHighlightStyleToolbarItem;
@synthesize applyTextHighlightColorSchemeToolbarItem = _applyTextHighlightColorSchemeToolbarItem;
@synthesize addAdaptiveImageGlyphToolbarItem = _addAdaptiveImageGlyphToolbarItem;
@synthesize addLocalizedNumberFormatToolbarItem = _addLocalizedNumberFormatToolbarItem;

- (void)dealloc {
    [_scrollView release];
    [_textView release];
    [_toolbar release];
    [_updateTextHighlightAttributesToolbarItem release];
    [_applyTextHighlightStyleToolbarItem release];
    [_applyTextHighlightColorSchemeToolbarItem release];
    [_addAdaptiveImageGlyphToolbarItem release];
    [_addLocalizedNumberFormatToolbarItem release];
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
    
    fromWindow.toolbar = nil;
    toWindow.toolbar = self.toolbar;
    
    // window에 붙어야 작동함
//    self.toolbar.itemIdentifiers = @[
//        self.updateTextHighlightAttributesToolbarItem.itemIdentifier,
//        self.applyTextHighlightStyleToolbarItem.itemIdentifier
//    ];
}

- (NSScrollView *)scrollView {
    if (auto scrollView = _scrollView) return scrollView;
    
    NSScrollView *scrollView = [NSScrollView new];
    scrollView.documentView = self.textView;
    scrollView.hasHorizontalRuler = YES;
    scrollView.hasVerticalRuler = YES;
    
    assert(scrollView.horizontalRulerView != nil);
    scrollView.horizontalRulerView.measurementUnits = NSRulerViewUnitCentimeters;
    scrollView.verticalRulerView.measurementUnits = NSRulerViewUnitCentimeters;
    
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

- (NSToolbarItem *)applyTextHighlightStyleToolbarItem {
    if (auto applyTextHighlightStyleToolbarItem = _applyTextHighlightStyleToolbarItem) return applyTextHighlightStyleToolbarItem;
    
    NSToolbarItem *applyTextHighlightStyleToolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:@"applyTextHighlightStyle"];
    applyTextHighlightStyleToolbarItem.title = @"2";
    applyTextHighlightStyleToolbarItem.target = self;
    applyTextHighlightStyleToolbarItem.action = @selector(applyTextHighlightStyleToolbarItemDidTrigger:);
    
    _applyTextHighlightStyleToolbarItem = [applyTextHighlightStyleToolbarItem retain];
    return [applyTextHighlightStyleToolbarItem autorelease];
}

- (NSToolbarItem *)applyTextHighlightColorSchemeToolbarItem {
    if (auto applyTextHighlightColorSchemeToolbarItem = _applyTextHighlightColorSchemeToolbarItem) return applyTextHighlightColorSchemeToolbarItem;
    
    NSToolbarItem *applyTextHighlightColorSchemeToolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:@"applyTextHighlightColorScheme"];
    applyTextHighlightColorSchemeToolbarItem.title = @"3";
    applyTextHighlightColorSchemeToolbarItem.target = self;
    applyTextHighlightColorSchemeToolbarItem.action = @selector(applyTextHighlightColorSchemeToolbarItemDidTrigger:);
    
    _applyTextHighlightColorSchemeToolbarItem = [applyTextHighlightColorSchemeToolbarItem retain];
    return [applyTextHighlightColorSchemeToolbarItem autorelease];
}

- (NSToolbarItem *)addAdaptiveImageGlyphToolbarItem {
    if (auto addAdaptiveImageGlyphToolbarItem = _addAdaptiveImageGlyphToolbarItem) return addAdaptiveImageGlyphToolbarItem;
    
    NSToolbarItem *addAdaptiveImageGlyphToolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:@"addAdaptiveImageGlyphToolbarItem"];
    addAdaptiveImageGlyphToolbarItem.title = @"4";
    addAdaptiveImageGlyphToolbarItem.target = self;
    addAdaptiveImageGlyphToolbarItem.action = @selector(addAdaptiveImageGlyphToolbarItemDidTrigger:);
    
    _addAdaptiveImageGlyphToolbarItem = [addAdaptiveImageGlyphToolbarItem retain];
    return [addAdaptiveImageGlyphToolbarItem autorelease];
}

- (NSToolbarItem *)addLocalizedNumberFormatToolbarItem {
    if (auto addLocalizedNumberFormatToolbarItem = _addLocalizedNumberFormatToolbarItem) return addLocalizedNumberFormatToolbarItem;
    
    NSToolbarItem *addLocalizedNumberFormatToolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:@"addLocalizedNumberFormat"];
    addLocalizedNumberFormatToolbarItem.title = @"5";
    addLocalizedNumberFormatToolbarItem.target = self;
    addLocalizedNumberFormatToolbarItem.action = @selector(addLocalizedNumberFormatToolbarItemDidTrigger:);
    
    _addLocalizedNumberFormatToolbarItem = [addLocalizedNumberFormatToolbarItem retain];
    return [addLocalizedNumberFormatToolbarItem autorelease];
}

- (void)updateTextHighlightAttributesToolbarItemDidTrigger:(NSToolbarItem *)sender {
    self.textView.textHighlightAttributes = @{
        NSBackgroundColorAttributeName: NSColor.orangeColor,
        NSForegroundColorAttributeName: NSColor.blueColor
    };
}

- (void)applyTextHighlightStyleToolbarItemDidTrigger:(NSToolbarItem *)sender {
    NSMutableAttributedString *attributedString = [self.textView.attributedString mutableCopy];
    
    [attributedString addAttributes:@{
        NSTextHighlightStyleAttributeName: NSTextHighlightStyleDefault
    } 
                              range:NSMakeRange(0, attributedString.length)];
    
//    ((void (*)(id, SEL, id))objc_msgSend)(self.textView, sel_registerName("setAttributedText:"), attributedString);
    [self.textView.textStorage setAttributedString:attributedString];
    [attributedString release];
}

- (void)applyTextHighlightColorSchemeToolbarItemDidTrigger:(NSToolbarItem *)sender {
    NSMutableAttributedString *attributedString = [self.textView.attributedString mutableCopy];
    
    [attributedString addAttributes:@{
        NSTextHighlightColorSchemeAttributeName: NSTextHighlightColorSchemePink
    }
                              range:NSMakeRange(0, attributedString.length)];
    
    [self.textView.textStorage setAttributedString:attributedString];
    [attributedString release];
}

- (void)addAdaptiveImageGlyphToolbarItemDidTrigger:(NSToolbarItem *)sender {
    /*
     po [NSAdaptiveImageGlyph contentType]
     <_UTCoreType 0x100b54b40> public.heic (not dynamic, declared)
     
     -[__NSAdaptiveImageGlyphStorage initWithImageContent:]에서 nil 나옴.
     -[__NSAdaptiveImageGlyphStorage initWithImageContent:]에서 마지막 -objectForKeyedSubscript: 두 개가 0x0이 나올텐데 여기에 아무 NSString 넣어주면 init 성공함
     */
    NSData *imageContent = [[NSData alloc] initWithContentsOfURL:[NSBundle.mainBundle URLForResource:@"image" withExtension:@"heic"]];
    NSAdaptiveImageGlyph *adaptiveImageGlyph = [[NSAdaptiveImageGlyph alloc] initWithImageContent:imageContent];
    [imageContent release];
    assert(adaptiveImageGlyph != nil);
    [adaptiveImageGlyph autorelease];
    
//    NSData *archive = [[NSData alloc] initWithContentsOfURL:[NSBundle.mainBundle URLForResource:@"adaptiveImageGlyph" withExtension:@"plist"]];
//    NSError * _Nullable error = nil;
//    NSAdaptiveImageGlyph *adaptiveImageGlyph = [NSKeyedUnarchiver unarchivedObjectOfClass:NSAdaptiveImageGlyph.class fromData:archive error:&error];
//    assert(adaptiveImageGlyph != nil);
//    assert(error != nil);
    
    //
    
    NSMutableAttributedString *attributedString = [self.textView.attributedString mutableCopy];
    
    NSAttributedString *adaptiveImageGlyphAttributedString = [NSAttributedString attributedStringWithAdaptiveImageGlyph:adaptiveImageGlyph attributes:@{}];
    
    [attributedString appendLocalizedFormat:adaptiveImageGlyphAttributedString];
    
    [self.textView.textStorage setAttributedString:attributedString];
    [attributedString release];
}

- (void)addLocalizedNumberFormatToolbarItemDidTrigger:(NSToolbarItem *)sender {
    NSMutableAttributedString *attributedString = [self.textView.attributedString mutableCopy];
    
    [attributedString addAttributes:@{
        NSLocalizedNumberFormatAttributeName: [NSLocalizedNumberFormatRule automatic]
    }
                              range:NSMakeRange(0, attributedString.length)];
    
    [self.textView.textStorage setAttributedString:attributedString];
    [attributedString release];
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
    return @[
        self.updateTextHighlightAttributesToolbarItem.itemIdentifier,
        self.applyTextHighlightStyleToolbarItem.itemIdentifier,
        self.applyTextHighlightColorSchemeToolbarItem.itemIdentifier,
        self.addAdaptiveImageGlyphToolbarItem.itemIdentifier,
        self.addLocalizedNumberFormatToolbarItem.itemIdentifier
    ];
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
    return [self toolbarAllowedItemIdentifiers:toolbar];
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSToolbarItemIdentifier)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
    if ([itemIdentifier isEqualToString:self.updateTextHighlightAttributesToolbarItem.itemIdentifier]) {
        return self.updateTextHighlightAttributesToolbarItem;
    } else if ([itemIdentifier isEqualToString:self.applyTextHighlightStyleToolbarItem.itemIdentifier]) {
        return self.applyTextHighlightStyleToolbarItem;
    } else if ([itemIdentifier isEqualToString:self.applyTextHighlightColorSchemeToolbarItem.itemIdentifier]) {
        return self.applyTextHighlightColorSchemeToolbarItem;
    } else if ([itemIdentifier isEqualToString:self.addAdaptiveImageGlyphToolbarItem.itemIdentifier]) {
        return self.addAdaptiveImageGlyphToolbarItem;
    } else if ([itemIdentifier isEqualToString:self.addLocalizedNumberFormatToolbarItem.itemIdentifier]) {
        return self.addLocalizedNumberFormatToolbarItem;
    } else {
        return nil;
    }
}

@end
