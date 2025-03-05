//
//  ViewDemoPositionedSubviewView.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 3/5/25.
//

#import "ViewDemoPositionedSubviewView.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "NSStringFromNSWindowOrderingMode.h"
#include <vector>
#include <ranges>

@interface ViewDemoPositionedSubviewView ()
@property (retain, nonatomic, readonly, getter=_primaryView) NSView *primaryView;
@property (retain, nonatomic, readonly, getter=_secondaryView) NSView *secondaryView;
@property (retain, nonatomic, readonly, getter=_positionPopUpButton) NSPopUpButton *positionPopUpButton;
@end

@implementation ViewDemoPositionedSubviewView
@synthesize primaryView = _primaryView;
@synthesize secondaryView = _secondaryView;
@synthesize positionPopUpButton = _positionPopUpButton;

- (instancetype)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.primaryView];
        [self addSubview:self.secondaryView positioned:NSWindowAbove relativeTo:self.primaryView];
        [self addSubview:self.positionPopUpButton];
    }
    
    return self;
}

- (void)dealloc {
    [_primaryView release];
    [_secondaryView release];
    [_positionPopUpButton release];
    [super dealloc];
}

- (void)layout {
    [super layout];
    
    NSPopUpButton *positionPopUpButton = self.positionPopUpButton;
    NSSize fittingSize = positionPopUpButton.fittingSize;
    
    positionPopUpButton.frame = NSMakeRect(0., 0., NSWidth(self.bounds), fittingSize.height);
    self.primaryView.frame = NSMakeRect(0., fittingSize.height, NSWidth(self.bounds) * 0.5, NSHeight(self.bounds) - fittingSize.height);
    self.secondaryView.frame = NSMakeRect(60., fittingSize.height + 60., NSWidth(self.bounds) - 120., NSHeight(self.bounds) - fittingSize.height - 120.);
}

- (NSView *)_primaryView {
    if (auto primaryView = _primaryView) return primaryView;
    
    NSView *primaryView = [NSView new];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(primaryView, sel_registerName("setBackgroundColor:"), NSColor.systemGreenColor);
    
    _primaryView = primaryView;
    return primaryView;
}

- (NSView *)_secondaryView {
    if (auto secondaryView = _secondaryView) return secondaryView;
    
    NSView *secondaryView = [NSView new];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(secondaryView, sel_registerName("setBackgroundColor:"), NSColor.systemBlueColor);
    
    _secondaryView = secondaryView;
    return secondaryView;
}

- (NSPopUpButton *)_positionPopUpButton {
    if (auto positionPopUpButton = _positionPopUpButton) return positionPopUpButton;
    
    NSUInteger count;
    const NSWindowOrderingMode *allModes = allNSWindowOrderingModes(&count);
    
    auto titlesVector = std::views::iota(allModes, allModes + count)
    | std::views::transform([](const NSWindowOrderingMode *ptr) {
        return *ptr;
    })
    | std::views::filter([](const NSWindowOrderingMode mode) {
        return mode != NSWindowOut;
    })
    | std::views::transform([](const NSWindowOrderingMode mode) {
        return NSStringFromNSWindowOrderingMode(mode);
    })
    | std::ranges::to<std::vector<NSString *>>();
    
    NSPopUpButton *positionPopUpButton = [NSPopUpButton new];
    
    NSArray<NSString *> *titles = [[NSArray alloc] initWithObjects:titlesVector.data() count:titlesVector.size()];
    [positionPopUpButton addItemsWithTitles:titles];
    [titles release];
    
    positionPopUpButton.target = self;
    positionPopUpButton.action = @selector(_didTriggerPositionPopUpButton:);
    
    _positionPopUpButton = positionPopUpButton;
    return positionPopUpButton;
}

- (void)_didTriggerPositionPopUpButton:(NSPopUpButton *)sender {
    NSWindowOrderingMode mode = NSWindowOrderingModeFromString(sender.title);
    [self.secondaryView removeFromSuperview];
    [self addSubview:self.secondaryView positioned:mode relativeTo:self.primaryView];
}

@end
