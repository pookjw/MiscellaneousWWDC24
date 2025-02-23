//
//  PasteboardDemoSetStringView.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/23/25.
//

#import "PasteboardDemoSetStringView.h"
#import "allNSPasteboardTypes.h"

@interface PasteboardDemoSetStringView ()
@property (retain, nonatomic, readonly, getter=_stackView) NSStackView *stackView;
@property (retain, nonatomic, readonly, getter=_popUpButton) NSPopUpButton *popUpButton;
@property (retain, nonatomic, readonly, getter=_textField) NSTextField *textField;
@end

@implementation PasteboardDemoSetStringView
@synthesize stackView = _stackView;
@synthesize popUpButton = _popUpButton;
@synthesize textField = _textField;

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        NSStackView *stackView = self.stackView;
        stackView.frame = self.bounds;
        stackView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        [self addSubview:stackView];
    }
    
    return self;
}

- (void)dealloc {
    [_stackView release];
    [_popUpButton release];
    [_textField release];
    [super dealloc];
}

- (NSSize)fittingSize {
    return self.stackView.fittingSize;
}

- (NSSize)intrinsicContentSize {
    return self.stackView.intrinsicContentSize;
}

- (NSPasteboardType)pasteboardType {
    return self.popUpButton.selectedItem.title;
}

- (NSString *)string {
    return self.textField.stringValue;
}

- (NSStackView *)_stackView {
    if (auto stackView = _stackView) return stackView;
    
    NSStackView *stackView = [NSStackView new];
    
    [stackView addArrangedSubview:self.popUpButton];
    [stackView addArrangedSubview:self.textField];
    
    stackView.orientation = NSUserInterfaceLayoutOrientationVertical;
    stackView.distribution = NSStackViewDistributionFillProportionally;
    stackView.alignment = NSLayoutAttributeCenterX;
    
    _stackView = stackView;
    return stackView;
}

- (NSPopUpButton *)_popUpButton {
    if (auto popUpButton = _popUpButton) return popUpButton;
    
    NSPopUpButton *popUpButton = [NSPopUpButton new];
    [popUpButton addItemsWithTitles:allNSPasteboardTypes];
    [popUpButton selectItemWithTitle:NSPasteboardTypeString];
    
    _popUpButton = popUpButton;
    return popUpButton;
}

- (NSTextField *)_textField {
    if (auto textField = _textField) return textField;
    
    NSTextField *textField = [NSTextField new];
    
    _textField = textField;
    return textField;
}

@end
