//
//  WindowDemoValidRequestorView.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/26/25.
//

#import "WindowDemoValidRequestorView.h"
#import "allNSPasteboardTypes.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface WindowDemoValidRequestorView ()
@property (retain, nonatomic, readonly, getter=_stackView) NSStackView *stackView;
@property (retain, nonatomic, readonly, getter=_sendTypePopUpButton) NSPopUpButton *sendTypePopUpButton;
@property (retain, nonatomic, readonly, getter=_returnTypePopUpButton) NSPopUpButton *returnTypePopUpButton;
@property (retain, nonatomic, readonly, getter=_resultLabel) NSTextField *resultLabel;
@property (retain, nonatomic, readonly, getter=_checkCombinationButton) NSButton *checkCombinationButton;
@end

@implementation WindowDemoValidRequestorView
@synthesize stackView = _stackView;
@synthesize sendTypePopUpButton = _sendTypePopUpButton;
@synthesize returnTypePopUpButton = _returnTypePopUpButton;
@synthesize resultLabel = _resultLabel;
@synthesize checkCombinationButton = _checkCombinationButton;

- (instancetype)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
        NSStackView *stackView = self.stackView;
        stackView.frame = self.bounds;
        stackView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        [self addSubview:stackView];
    }
    
    return self;
}

- (void)dealloc {
    [_stackView release];
    [_sendTypePopUpButton release];
    [_returnTypePopUpButton release];
    [_resultLabel release];
    [_checkCombinationButton release];
    [super dealloc];
}

- (void)viewDidMoveToWindow {
    [super viewDidMoveToWindow];
    [self _updateResultLabel];
}

- (NSSize)fittingSize {
    return self.stackView.fittingSize;
}

- (NSSize)intrinsicContentSize {
    return self.stackView.intrinsicContentSize;
}

- (NSStackView *)_stackView {
    if (auto stackView = _stackView) return stackView;
    
    NSStackView *stackView = [NSStackView new];
    [stackView addArrangedSubview:self.sendTypePopUpButton];
    [stackView addArrangedSubview:self.returnTypePopUpButton];
    [stackView addArrangedSubview:self.resultLabel];
    [stackView addArrangedSubview:self.checkCombinationButton];
    
    stackView.orientation = NSUserInterfaceLayoutOrientationVertical;
    stackView.distribution = NSStackViewDistributionFillProportionally;
    stackView.alignment = NSLayoutAttributeCenterX;
    
    _stackView = stackView;
    return stackView;
}

- (NSPopUpButton *)_sendTypePopUpButton {
    if (auto sendTypePopUpButton = _sendTypePopUpButton) return sendTypePopUpButton;
    
    NSPopUpButton *sendTypePopUpButton = [NSPopUpButton new];
    sendTypePopUpButton.target = self;
    sendTypePopUpButton.action = @selector(_didChangeSelection:);
    [sendTypePopUpButton addItemsWithTitles:allNSPasteboardTypes];
    
    _sendTypePopUpButton = sendTypePopUpButton;
    return sendTypePopUpButton;
}

- (NSPopUpButton *)_returnTypePopUpButton {
    if (auto returnTypePopUpButton = _returnTypePopUpButton) return returnTypePopUpButton;
    
    NSPopUpButton *returnTypePopUpButton = [NSPopUpButton new];
    returnTypePopUpButton.target = self;
    returnTypePopUpButton.action = @selector(_didChangeSelection:);
    [returnTypePopUpButton addItemsWithTitles:allNSPasteboardTypes];
    
    _returnTypePopUpButton = returnTypePopUpButton;
    return returnTypePopUpButton;
}

- (NSTextField *)_resultLabel {
    if (auto resultLabel = _resultLabel) return resultLabel;
    
    NSTextField *resultLabel = [NSTextField wrappingLabelWithString:@"Pending"];
    
    _resultLabel = [resultLabel retain];
    return resultLabel;
}

- (NSButton *)_checkCombinationButton {
    if (auto checkCombinationButton = _checkCombinationButton) return checkCombinationButton;
    
    NSButton *checkCombinationButton = [NSButton new];
    checkCombinationButton.title = @"Check";
    checkCombinationButton.target = self;
    checkCombinationButton.action = @selector(_didTriggerCheckCombinationButton:);
    
    _checkCombinationButton = checkCombinationButton;
    return checkCombinationButton;
}

- (void)_didChangeSelection:(NSPopUpButton *)sender {
    [self _updateResultLabel];
    
    if (NSWindow *window = self.window) {
        NSAlert *alert = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self.window, sel_registerName("alert"));
//        assert([alert.accessoryView isEqual:self]);
        self.frame = NSMakeRect(0., 0., NSWidth(self.frame), self.fittingSize.height);
        [alert layout];
    }
}

- (void)_updateResultLabel {
    if (NSWindow *window = self.window) {
        id result = [window.sheetParent validRequestorForSendType:self.sendTypePopUpButton.titleOfSelectedItem returnType:self.returnTypePopUpButton.titleOfSelectedItem];
        
        if (result) {
            self.resultLabel.stringValue = [result description];
        } else {
            self.resultLabel.stringValue = @"(nil)";
        }
    }
}

- (void)_didTriggerCheckCombinationButton:(NSButton *)sender {
    NSWindow *sheetParent = self.window.sheetParent;
    assert(sheetParent != nil);
    
    NSMutableDictionary<NSPasteboardType, NSPasteboardType> *results = [NSMutableDictionary new];
    for (NSPasteboardType type1 in allNSPasteboardTypes) {
        for (NSPasteboardType type2 in allNSPasteboardTypes) {
            id result = [sheetParent validRequestorForSendType:type1 returnType:type2];
            if (result != nil) {
                results[type1] = type2;
            }
        }
    }
    
    NSAlert *alert = [NSAlert new];
    alert.messageText = @"Result";
    alert.informativeText = results.description;
    [results release];
    
    [alert beginSheetModalForWindow:self.window completionHandler:^(NSModalResponse returnCode) {
        
    }];
    [alert release];
}

@end
