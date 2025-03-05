//
//  ViewDemoRemoveFromSuperviewWithoutNeedingDisplayView.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 3/5/25.
//

#import "ViewDemoRemoveFromSuperviewWithoutNeedingDisplayView.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface _ViewDemoRemoveFromSuperviewWithoutNeedingDisplayChildView : NSView
@end
@implementation _ViewDemoRemoveFromSuperviewWithoutNeedingDisplayChildView
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}
@end

@interface ViewDemoRemoveFromSuperviewWithoutNeedingDisplayView ()
@property (retain, nonatomic, readonly, getter=_subview) _ViewDemoRemoveFromSuperviewWithoutNeedingDisplayChildView *subview;
@property (retain, nonatomic, readonly, getter=_popUpButton) NSPopUpButton *popUpButton;
@end

@implementation ViewDemoRemoveFromSuperviewWithoutNeedingDisplayView
@synthesize subview = _subview;
@synthesize popUpButton = _popUpButton;

- (instancetype)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.subview];
        [self addSubview:self.popUpButton];
    }
    
    return self;
}

- (void)dealloc {
    [_subview release];
    [_popUpButton release];
    [super dealloc];
}

- (void)layout {
    [super layout];
    
    NSSize fittingSize = self.popUpButton.fittingSize;
    self.popUpButton.frame = NSMakeRect(0., 0., NSWidth(self.bounds), fittingSize.height);
    
    self.subview.frame = NSInsetRect(NSMakeRect(0., fittingSize.height, NSWidth(self.bounds), NSHeight(self.bounds) - fittingSize.height),
                                     30.,
                                     30.);
}

- (_ViewDemoRemoveFromSuperviewWithoutNeedingDisplayChildView *)_subview {
    if (auto subview = _subview) return subview;
    
    _ViewDemoRemoveFromSuperviewWithoutNeedingDisplayChildView *subview = [_ViewDemoRemoveFromSuperviewWithoutNeedingDisplayChildView new];
//    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(subview, sel_registerName("setBackgroundColor:"), NSColor.systemGreenColor);
    
    _subview = subview;
    return subview;
}

- (NSPopUpButton *)_popUpButton {
    if (auto popUpButton = _popUpButton) return popUpButton;
    
    NSPopUpButton *popUpButton = [NSPopUpButton new];
    [popUpButton addItemsWithTitles:@[
        @"Add subview", @"Remove From Superview Without Needing Display", @"Redraw"
    ]];
    popUpButton.target = self;
    popUpButton.action = @selector(_didTriggerPopUpButton:);
    
    _popUpButton = popUpButton;
    return popUpButton;
}

- (void)_didTriggerPopUpButton:(NSPopUpButton *)sender {
    NSString *title = sender.titleOfSelectedItem;
    
    if ([title isEqualToString:@"Add subview"]) {
        [self addSubview:self.subview];
    } else if ([title isEqualToString:@"Remove From Superview Without Needing Display"]) {
        [self.subview removeFromSuperviewWithoutNeedingDisplay];
    } else if ([title isEqualToString:@"Redraw"]) {
        abort();
    } else {
        abort();
    }
}

@end
