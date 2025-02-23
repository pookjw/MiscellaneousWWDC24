//
//  PasteboardDemoDetectView.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/23/25.
//

#import "PasteboardDemoDetectView.h"
#import "allNSPasteboardDetectionPatterns.h"
#import "allNSPasteboardMetadataTypes.h"

@interface PasteboardDemoDetectView ()
@property (retain, nonatomic, readonly, getter=_pasteboard) NSPasteboard *pasteboard;
@property (assign, nonatomic, readonly, getter=_type) PasteboardDemoDetectType type;
@property (retain, nonatomic, readonly, getter=_stackView) NSStackView *stackView;
@property (retain, nonatomic, readonly, getter=_pasteboardItemPopUpButton) NSPopUpButton *pasteboardItemPopUpButton;
@property (retain, nonatomic, readonly, getter=_typePopUpButton) NSPopUpButton *typePopUpButton;
@end

@implementation PasteboardDemoDetectView
@synthesize stackView = _stackView;
@synthesize pasteboardItemPopUpButton = _pasteboardItemPopUpButton;
@synthesize typePopUpButton = _typePopUpButton;

- (instancetype)initWithFrame:(NSRect)frameRect pasteboard:(NSPasteboard *)pasteboard type:(PasteboardDemoDetectType)type {
    if (self = [super initWithFrame:frameRect]) {
        _pasteboard = [pasteboard retain];
        _type = type;
        
        NSStackView *stackView = self.stackView;
        stackView.frame = self.bounds;
        stackView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        [self addSubview:stackView];
    }
    
    return self;
}

- (void)dealloc {
    [_pasteboard release];
    [_stackView release];
    [_pasteboardItemPopUpButton release];
    [_typePopUpButton release];
    [super dealloc];
}

- (NSSize)fittingSize {
    return self.stackView.fittingSize;
}

- (NSSize)intrinsicContentSize {
    return self.stackView.intrinsicContentSize;
}

- (NSInteger)selectedPasteboardItemIndex {
    return self.pasteboardItemPopUpButton.indexOfSelectedItem;
}

- (NSSet<NSString *> *)selectedTypes {
    NSMenuItem *selectedItem = self.typePopUpButton.selectedItem;
    if (selectedItem == nil) return [NSSet set];
    
    return [NSSet setWithObject:selectedItem.title];
}

- (NSStackView *)_stackView {
    if (auto stackView = _stackView) return stackView;
    
    NSStackView *stackView = [NSStackView new];
    stackView.orientation = NSUserInterfaceLayoutOrientationVertical;
    stackView.distribution = NSStackViewDistributionFillProportionally;
    stackView.alignment = NSLayoutAttributeCenterX;
    
    [stackView addArrangedSubview:self.pasteboardItemPopUpButton];
    [stackView addArrangedSubview:self.typePopUpButton];
    
    _stackView = stackView;
    return stackView;
}

- (NSPopUpButton *)_pasteboardItemPopUpButton {
    if (auto pasteboardItemPopUpButton = _pasteboardItemPopUpButton) return pasteboardItemPopUpButton;
    
    NSPopUpButton *pasteboardItemPopUpButton = [NSPopUpButton new];
    
    for (NSPasteboardItem *item in self.pasteboard.pasteboardItems) {
        [pasteboardItemPopUpButton addItemWithTitle:item.description];
    }
    
    _pasteboardItemPopUpButton = pasteboardItemPopUpButton;
    return pasteboardItemPopUpButton;
}

- (NSPopUpButton *)_typePopUpButton {
    if (auto typePopUpButton = _typePopUpButton) return typePopUpButton;
    
    NSPopUpButton *typePopUpButton = [NSPopUpButton new];
    
    switch (self.type) {
        case PasteboardDemoDetectTypeMetadata: {
            [typePopUpButton addItemsWithTitles:allNSPasteboardMetadataTypes];
            break;
        }
        case PasteboardDemoDetectTypePatterns:
        case PasteboardDemoDetectTypeValues: {
            [typePopUpButton addItemsWithTitles:allNSPasteboardDetectionPatterns];
            break;
        }
        default:
            abort();
    }
    
    _typePopUpButton = typePopUpButton;
    return typePopUpButton;
}

@end
