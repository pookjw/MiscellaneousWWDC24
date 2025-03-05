//
//  ViewDemoSortSubviewsView.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 3/6/25.
//

#import "ViewDemoSortSubviewsView.h"
#import <objc/message.h>
#import <objc/runtime.h>
#include <random>

NSComparisonResult randomSort(__kindof NSView *lhsView, __kindof NSView *rhsView, void * _Nullable context) {
    std::random_device rd;  
    std::mt19937 gen(rd());
    std::uniform_int_distribution<int> distribution(0, 2);
    int randomValue = distribution(gen) - 1;
    return static_cast<NSComparisonResult>(randomValue);
}

@interface ViewDemoSortSubviewsView ()
@property (retain, nonatomic, readonly, getter=_primaryView) NSView *primaryView;
@property (retain, nonatomic, readonly, getter=_secondaryView) NSView *secondaryView;
@property (retain, nonatomic, readonly, getter=_tertiaryView) NSView *tertiaryView;
@property (retain, nonatomic, readonly, getter=_sortButton) NSButton *sortButton;
@end

@implementation ViewDemoSortSubviewsView
@synthesize primaryView = _primaryView;
@synthesize secondaryView = _secondaryView;
@synthesize tertiaryView = _tertiaryView;
@synthesize sortButton = _sortButton;

- (instancetype)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.primaryView];
        [self addSubview:self.secondaryView];
        [self addSubview:self.tertiaryView];
        [self addSubview:self.sortButton];
    }
    
    return self;
}

- (void)dealloc {
    [_primaryView release];
    [_secondaryView release];
    [_tertiaryView release];
    [_sortButton release];
    [super dealloc];
}

- (void)layout {
    [super layout];
    
    NSSize buttonSize = self.sortButton.fittingSize;
    self.sortButton.frame = NSMakeRect(0., 0., NSWidth(self.bounds), buttonSize.height);
    
    self.primaryView.frame = NSMakeRect(20.,
                                        60. + buttonSize.height,
                                        NSWidth(self.bounds) - 80.,
                                        NSHeight(self.bounds) - 80. - buttonSize.height);
    
    self.secondaryView.frame = NSMakeRect(40.,
                                          40. + buttonSize.height,
                                          NSWidth(self.bounds) - 80.,
                                          NSHeight(self.bounds) - 80. - buttonSize.height);
    
    self.tertiaryView.frame = NSMakeRect(60.,
                                         20. + buttonSize.height,
                                         NSWidth(self.bounds) - 80.,
                                         NSHeight(self.bounds) - 80. - buttonSize.height);
}

- (NSView *)_primaryView {
    if (auto primaryView = _primaryView) return primaryView;
    
    NSView *primaryView = [NSView new];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(primaryView, sel_registerName("setBackgroundColor:"), NSColor.systemRedColor);
    
    _primaryView = primaryView;
    return primaryView;
}

- (NSView *)_secondaryView {
    if (auto secondaryView = _secondaryView) return secondaryView;
    
    NSView *secondaryView = [NSView new];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(secondaryView, sel_registerName("setBackgroundColor:"), NSColor.systemGreenColor);
    
    _secondaryView = secondaryView;
    return secondaryView;
}

- (NSView *)_tertiaryView {
    if (auto tertiaryView = _tertiaryView) return tertiaryView;
    
    NSView *tertiaryView = [NSView new];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(tertiaryView, sel_registerName("setBackgroundColor:"), NSColor.systemBlueColor);
    
    _tertiaryView = tertiaryView;
    return tertiaryView;
}

- (NSButton *)_sortButton {
    if (auto sortButton = _sortButton) return sortButton;
    
    NSButton *sortButton = [NSButton new];
    sortButton.title = @"Random Sort";
    sortButton.target = self;
    sortButton.action = @selector(_didTriggerSortButton:);
    
    _sortButton = sortButton;
    return sortButton;
}

- (void)_didTriggerSortButton:(NSButton *)sender {
    [self sortSubviewsUsingFunction:randomSort context:NULL];
}

@end
