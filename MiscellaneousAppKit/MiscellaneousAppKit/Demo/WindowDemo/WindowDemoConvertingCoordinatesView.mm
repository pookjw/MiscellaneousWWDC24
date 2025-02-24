//
//  WindowDemoConvertingCoordinatesView.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/24/25.
//

#import "WindowDemoConvertingCoordinatesView.h"
#import "RectSlidersView.h"
#import "NSStringFromNSAlignmentOptions.h"
#include <ranges>
#import <objc/message.h>
#import <objc/runtime.h>

@interface WindowDemoConvertingCoordinatesView ()
@property (retain, nonatomic, readonly, getter=_stackView) NSStackView *stackView;
@property (retain, nonatomic, readonly, getter=_rectSlidersView) RectSlidersView *rectSlidersView;
@property (retain, nonatomic, readonly, getter=_optionsMenuButton) NSButton *optionsMenuButton;
@property (retain, nonatomic, readonly, getter=_resultLabel) NSTextField *resultLabel;
@property (assign, nonatomic) NSAlignmentOptions options;
@end

@implementation WindowDemoConvertingCoordinatesView
@synthesize stackView = _stackView;
@synthesize rectSlidersView = _rectSlidersView;
@synthesize optionsMenuButton = _optionsMenuButton;
@synthesize resultLabel = _resultLabel;

- (instancetype)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.options = NSAlignAllEdgesInward;
        
        NSStackView *stackView = self.stackView;
        stackView.frame = self.bounds;
        stackView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        [self addSubview:stackView];
        
        self.optionsMenuButton.menu = [self _makeMenu];
        
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_didChangeRectSlidersViewValue:) name:RectSlidersViewDidChangeValueNotification object:self.rectSlidersView];
        
        self.type = WindowDemoConvertingCoordinatesTypeBackingAlignedRect;
    }
    
    return self;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
    [_stackView release];
    [_rectSlidersView release];
    [_optionsMenuButton release];
    [_resultLabel release];
    [super dealloc];
}

- (NSSize)fittingSize {
    return self.stackView.fittingSize;
}

- (NSSize)intrinsicContentSize {
    return self.stackView.intrinsicContentSize;
}

- (void)setType:(WindowDemoConvertingCoordinatesType)type {
    _type = type;
    self.optionsMenuButton.hidden = (type != WindowDemoConvertingCoordinatesTypeBackingAlignedRect);
    [self _updateResultLabel];
}

- (NSStackView *)_stackView {
    if (auto stackView = _stackView) return stackView;
    
    NSStackView *stackView = [NSStackView new];
    
    [stackView addArrangedSubview:self.rectSlidersView];
    [stackView addArrangedSubview:self.optionsMenuButton];
    [stackView addArrangedSubview:self.resultLabel];
    
    stackView.orientation = NSUserInterfaceLayoutOrientationVertical;
    stackView.distribution = NSStackViewDistributionFillProportionally;
    stackView.alignment = NSLayoutAttributeCenterX;
    
    _stackView = stackView;
    return stackView;
}

- (RectSlidersView *)_rectSlidersView {
    if (auto rectSlidersView = _rectSlidersView) return rectSlidersView;
    
    RectSlidersView *rectSlidersView = [RectSlidersView new];
    
    _rectSlidersView = rectSlidersView;
    return rectSlidersView;
}

- (NSButton *)_optionsMenuButton {
    if (auto optionsMenuButton = _optionsMenuButton) return optionsMenuButton;
    
    NSButton *optionsMenuButton = [NSButton new];
    optionsMenuButton.title = @"Options";
    optionsMenuButton.target = self;
    optionsMenuButton.action = @selector(_didTriggerOptionsMenuButton:);
    
    _optionsMenuButton = optionsMenuButton;
    return optionsMenuButton;
}

- (NSTextField *)_resultLabel {
    if (auto resultLabel = _resultLabel) return resultLabel;
    
    NSTextField *resultLabel = [NSTextField wrappingLabelWithString:@""];
    
    _resultLabel = [resultLabel retain];
    return resultLabel;
}

- (void)_didChangeRectSlidersViewValue:(NSNotification *)notification {
    [self _updateResultLabel];
}

- (void)_updateResultLabel {
    RectSlidersConfiguration *configuration = self.rectSlidersView.configuration;
    NSWindow *window = self.window;
    
    NSRect inputRect = configuration.rect;
    NSRect outputRect;
    
    switch (self.type) {
        case WindowDemoConvertingCoordinatesTypeBackingAlignedRect:
            outputRect = [window backingAlignedRect:configuration.rect options:self.options];
            break;
        case WindowDemoConvertingCoordinatesTypeConvertRectFromBacking:
            outputRect = [window convertRectFromBacking:inputRect];
            break;
        case WindowDemoConvertingCoordinatesTypeConvertRectFromScreen:
            outputRect = [window convertRectFromScreen:inputRect];
            break;
        case WindowDemoConvertingCoordinatesTypeConvertRectToBacking:
            outputRect = [window convertRectToBacking:inputRect];
            break;
        case WindowDemoConvertingCoordinatesTypeConvertRectToScreen:
            outputRect = [window convertRectToScreen:inputRect];
            break;
        default:
            abort();
    }
    
    self.resultLabel.stringValue = [NSString stringWithFormat:@"Input : %@\nOutput : %@", NSStringFromRect(inputRect), NSStringFromRect(outputRect)];
    
    if (NSWindow *window = self.window) {
        NSAlert *alert = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self.window, sel_registerName("alert"));
        assert([alert.accessoryView isEqual:self]);
        self.frame = NSMakeRect(0., 0., NSWidth(self.frame), self.fittingSize.height);
        [alert layout];
    }
}

- (NSMenu *)_makeMenu {
    NSMenu *menu = [NSMenu new];
    
    {
        NSUInteger count;
        NSAlignmentOptions *allOptions = allNSAlignmentOptions(&count);
        
        NSAlignmentOptions options = self.options;
        
        for (NSAlignmentOptions *ptr : std::views::iota(allOptions, allOptions + count)) {
            NSAlignmentOptions value = *ptr;
            
            NSMenuItem *item = [NSMenuItem new];
            item.title = NSStringFromNSAlignmentOptions(value);
            item.state = ((options & value) != 0) ? NSControlStateValueOn : NSControlStateValueOff;
            item.target = self;
            item.action = @selector(_didTriggerOptionItem:);
            
            [menu addItem:item];
            [item release];
        }
    }
    
    [menu addItem:[NSMenuItem separatorItem]];
    [menu addItem:[NSMenuItem sectionHeaderWithTitle:@"Convenience Combinations"]];
    
    {
        NSUInteger count;
        NSAlignmentOptions *allOptions = allNSAlignmentOptionsConvenienceCombinations(&count);
        
        for (NSAlignmentOptions *ptr : std::views::iota(allOptions, allOptions + count)) {
            NSAlignmentOptions value = *ptr;
            
            NSMenuItem *item = [NSMenuItem new];
            item.title = NSStringFromNSStringFromNSAlignmentOptionsConvenienceCombinations(value);
            item.target = self;
            item.action = @selector(_didTriggerConvenienceCombinationItem:);
            
            [menu addItem:item];
            [item release];
        }
    }
    
    return [menu autorelease];
}

- (void)_didTriggerOptionItem:(NSMenuItem *)sender {
    NSAlignmentOptions option = NSAlignmentOptionsFromString(sender.title);
    
    switch (sender.state) {
        case NSControlStateValueOn: {
            self.options &= ~option;
            break;
        }
        case NSControlStateValueOff: {
            self.options |= option;
            break;
        }
        default:
            break;
    }
    
    self.optionsMenuButton.menu = [self _makeMenu];
    [self _updateResultLabel];
}

- (void)_didTriggerConvenienceCombinationItem:(NSMenuItem *)sender {
    NSAlignmentOptions options = NSAlignmentOptionsConvenienceCombinationsFromString(sender.title);
    self.options = options;
    self.optionsMenuButton.menu = [self _makeMenu];
    [self _updateResultLabel];
}

- (void)_didTriggerOptionsMenuButton:(NSButton *)sender {
    [NSMenu popUpContextMenu:sender.menu withEvent:sender.window.currentEvent forView:sender];
}

@end
