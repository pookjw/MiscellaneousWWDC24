//
//  PasteboardDemoWriteObjectsView.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/23/25.
//

#import "PasteboardDemoWriteObjectsView.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface PasteboardDemoWriteObjectsView ()
@property (retain, nonatomic, readonly, getter=_stackView) NSStackView *stackView;
@property (retain, nonatomic, readonly, getter=_addButton) NSButton *addButton;
@end

@implementation PasteboardDemoWriteObjectsView
@synthesize stackView = _stackView;
@synthesize addButton = _addButton;

- (instancetype)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
        NSStackView *stackView = self.stackView;
        stackView.frame = self.bounds;
        stackView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        [self addSubview:stackView];
        
        [self _addNewTextField];
    }
    
    return self;
}

- (void)dealloc {
    [_stackView release];
    [_addButton release];
    [super dealloc];
}

- (NSSize)fittingSize {
    return self.stackView.fittingSize;
}

- (NSSize)intrinsicContentSize {
    return self.stackView.intrinsicContentSize;
}

- (NSArray<NSString *> *)strings {
    NSMutableArray<NSString *> *strings = [NSMutableArray new];
    
    for (NSTextField *textField in self.stackView.arrangedSubviews) {
        if (![textField isKindOfClass:[NSTextField class]]) continue;
        [strings addObject:textField.stringValue];
    }
    
    return [strings autorelease];
}

- (NSStackView *)_stackView {
    if (auto stackView = _stackView) return stackView;
    
    NSStackView *stackView = [NSStackView new];
    stackView.orientation = NSUserInterfaceLayoutOrientationVertical;
    stackView.distribution = NSStackViewDistributionFillProportionally;
    stackView.alignment = NSLayoutAttributeCenterX;
    
    [stackView addArrangedSubview:self.addButton];
    
    _stackView = stackView;
    return stackView;
}

- (NSButton *)_addButton {
    if (auto addButton = _addButton) return addButton;
    
    NSButton *addButton = [NSButton buttonWithImage:[NSImage imageWithSystemSymbolName:@"plus" accessibilityDescription:nil] target:self action:@selector(_didTriggerAddButton:)];
    
    _addButton = [addButton retain];
    return addButton;
}

- (void)_didTriggerAddButton:(NSButton *)sender {
    [self _addNewTextField];
}

- (NSTextField *)_addNewTextField {
    NSTextField *textField = [NSTextField new];
    [self.stackView insertArrangedSubview:textField atIndex:self.stackView.arrangedSubviews.count - 1];
    
    if (NSWindow *window = self.window) {
        NSAlert *alert = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self.window, sel_registerName("alert"));
        assert([alert.accessoryView isEqual:self]);
        self.frame = NSMakeRect(0., 0., NSWidth(self.frame), self.fittingSize.height);
        [alert layout];
        
        [window makeFirstResponder:textField];
    }
    
    return [textField autorelease];
}

@end
