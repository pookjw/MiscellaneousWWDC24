//
//  WindowDemoAnchorAttributeForOrientationView.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/26/25.
//

#import "WindowDemoAnchorAttributeForOrientationView.h"
#import "NSStringFromNSLayoutAttribute.h"
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>
#include <ranges>
#include <vector>
#import <objc/message.h>
#import <objc/runtime.h>

@interface WindowDemoAnchorAttributeForOrientationView ()
@property (retain, nonatomic, readonly, getter=_stackView) NSStackView *stackView;
@property (retain, nonatomic, getter=_labelTopConstraint, setter=_setLabelTopConstraint:) NSLayoutConstraint *labelTopConstraint;
@property (retain, nonatomic, getter=_labelLeadingConstraint, setter=_setLabelLeadingConstraint:) NSLayoutConstraint *labelLeadingConstraint;
@property (retain, nonatomic, getter=_labelTrailingConstraint, setter=_setLabelTrailingConstraint:) NSLayoutConstraint *labelTrailingConstraint;
@property (retain, nonatomic, getter=_labelBottomConstraint, setter=_setLabelBottomConstraint:) NSLayoutConstraint *labelBottomConstraint;
@property (retain, nonatomic, getter=_labelWidthConstraint, setter=_setLabelWidthConstraint:) NSLayoutConstraint *labelWidthConstraint;
@property (retain, nonatomic, getter=_labelHeightConstraint, setter=_setLabelHeightConstraint:) NSLayoutConstraint *labelHeightConstraint;
@property (retain, nonatomic, readonly, getter=_labelContainerView) NSView *labelContainerView;
@property (retain, nonatomic, readonly, getter=_label) NSTextField *label;
@property (retain, nonatomic, readonly, getter=_leadingButton) NSButton *leadingButton;
@property (retain, nonatomic, readonly, getter=_trailingButton) NSButton *trailingButton;
@property (retain, nonatomic, readonly, getter=_topButton) NSButton *topButton;
@property (retain, nonatomic, readonly, getter=_bottomButton) NSButton *bottomButton;
@property (retain, nonatomic, readonly, getter=_anchorAttributeForHorizontalOrientationButton) NSPopUpButton *anchorAttributeForHorizontalOrientationButton;
@property (retain, nonatomic, readonly, getter=_anchorAttributeForVerticalOrientationButton) NSPopUpButton *anchorAttributeForVerticalOrientationButton;
@end

@implementation WindowDemoAnchorAttributeForOrientationView
@synthesize stackView = _stackView;
@synthesize labelContainerView = _labelContainerView;
@synthesize label = _label;
@synthesize leadingButton = _leadingButton;
@synthesize trailingButton = _trailingButton;
@synthesize topButton = _topButton;
@synthesize bottomButton = _bottomButton;
@synthesize anchorAttributeForHorizontalOrientationButton = _anchorAttributeForHorizontalOrientationButton;
@synthesize anchorAttributeForVerticalOrientationButton = _anchorAttributeForVerticalOrientationButton;

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
    [_labelContainerView release];
    [_label release];
    [_leadingButton release];
    [_trailingButton release];
    [_topButton release];
    [_bottomButton release];
    [_anchorAttributeForHorizontalOrientationButton release];
    [_anchorAttributeForVerticalOrientationButton release];
    [_labelTopConstraint release];
    [_labelLeadingConstraint release];
    [_labelTrailingConstraint release];
    [_labelBottomConstraint release];
    [_labelWidthConstraint release];
    [_labelHeightConstraint release];
    [super dealloc];
}

- (void)viewDidMoveToWindow {
    [super viewDidMoveToWindow];
    
    if (NSWindow *window = self.window) {
        [self.anchorAttributeForHorizontalOrientationButton selectItemWithTitle:NSStringFromNSLayoutAttribute([window anchorAttributeForOrientation:NSLayoutConstraintOrientationHorizontal])];
        [self.anchorAttributeForVerticalOrientationButton selectItemWithTitle:NSStringFromNSLayoutAttribute([window anchorAttributeForOrientation:NSLayoutConstraintOrientationVertical])];
    }
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
    
    [stackView addArrangedSubview:self.labelContainerView];
    [stackView addArrangedSubview:self.leadingButton];
    [stackView addArrangedSubview:self.trailingButton];
    [stackView addArrangedSubview:self.topButton];
    [stackView addArrangedSubview:self.bottomButton];
    [stackView addArrangedSubview:self.anchorAttributeForHorizontalOrientationButton];
    [stackView addArrangedSubview:self.anchorAttributeForVerticalOrientationButton];
    
    stackView.orientation = NSUserInterfaceLayoutOrientationVertical;
    stackView.distribution = NSStackViewDistributionFill;
    stackView.alignment = NSLayoutAttributeCenterX;
    
    _stackView = stackView;
    return stackView;
}

- (NSView *)_labelContainerView {
    if (auto labelContainerView = _labelContainerView) return labelContainerView;
    
    NSView *labelContainerView = [NSView new];
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(labelContainerView, sel_registerName("setBackgroundColor:"), NSColor.blueColor);
    
    NSTextField *label = self.label;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [labelContainerView addSubview:label];
    
    NSLayoutConstraint *labelTopConstraint = [label.topAnchor constraintEqualToAnchor:labelContainerView.topAnchor constant:100.];
    self.labelTopConstraint = labelTopConstraint;
    NSLayoutConstraint *labelLeadingConstraint = [label.leadingAnchor constraintEqualToAnchor:labelContainerView.leadingAnchor constant:100.];
    self.labelLeadingConstraint = labelLeadingConstraint;
    NSLayoutConstraint *labelTrailingConstraint = [label.trailingAnchor constraintEqualToAnchor:labelContainerView.trailingAnchor constant:-100.];
    self.labelTrailingConstraint = labelTrailingConstraint;
    NSLayoutConstraint *labelBottomConstraint = [label.bottomAnchor constraintEqualToAnchor:labelContainerView.bottomAnchor constant:-100.];
    self.labelBottomConstraint = labelBottomConstraint;
    NSLayoutConstraint *labelWidthConstraint = [label.widthAnchor constraintEqualToConstant:100.];
    self.labelWidthConstraint = labelWidthConstraint;
    NSLayoutConstraint *labelHeightConstraint = [label.heightAnchor constraintEqualToConstant:100.];
    self.labelHeightConstraint = labelHeightConstraint;
    
    [NSLayoutConstraint activateConstraints:@[
        labelTopConstraint,
        labelLeadingConstraint,
        labelTrailingConstraint,
        labelBottomConstraint,
        labelWidthConstraint,
        labelHeightConstraint
    ]];
    
    _labelContainerView = labelContainerView;
    return labelContainerView;
}

- (NSTextField *)_label {
    if (auto label = _label) return label;
    
    NSURL *url = [NSBundle.mainBundle URLForResource:@"letter" withExtension:UTTypePlainText.preferredFilenameExtension];
    assert(url != nil);
    NSError * _Nullable error = nil;
    NSData *data = [[NSData alloc] initWithContentsOfURL:url options:0 error:&error];
    assert(error == nil);
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [data release];
    
    NSTextField *label = [NSTextField wrappingLabelWithString:string];
    [string release];
    
    label.drawsBackground = YES;
    label.textColor = NSColor.blackColor;
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(label, sel_registerName("setBackgroundColor:"), NSColor.whiteColor);
    
    _label = [label retain];
    return label;
}

- (NSButton *)_leadingButton {
    if (auto leadingButton = _leadingButton) return leadingButton;
    
    NSButton *leadingButton = [NSButton new];
    leadingButton.target = self;
    leadingButton.action = @selector(_didTriggerButton:);
    leadingButton.title = @"Toggle Left";
    
    _leadingButton = leadingButton;
    return leadingButton;
}

- (NSButton *)_trailingButton {
    if (auto trailingButton = _trailingButton) return trailingButton;
    
    NSButton *trailingButton = [NSButton new];
    trailingButton.target = self;
    trailingButton.action = @selector(_didTriggerButton:);
    trailingButton.title = @"Toggle Right";
    
    _trailingButton = trailingButton;
    return trailingButton;
}

- (NSButton *)_topButton {
    if (auto topButton = _topButton) return topButton;
    
    NSButton *topButton = [NSButton new];
    topButton.target = self;
    topButton.action = @selector(_didTriggerButton:);
    topButton.title = @"Toggle Up";
    
    _topButton = topButton;
    return topButton;
}

- (NSButton *)_bottomButton {
    if (auto bottomButton = _bottomButton) return bottomButton;
    
    NSButton *bottomButton = [NSButton new];
    bottomButton.target = self;
    bottomButton.action = @selector(_didTriggerButton:);
    bottomButton.title = @"Toggle Down";
    
    _bottomButton = bottomButton;
    return bottomButton;
}

- (NSPopUpButton *)_anchorAttributeForHorizontalOrientationButton {
    if (auto anchorAttributeForHorizontalOrientationButton = _anchorAttributeForHorizontalOrientationButton) return anchorAttributeForHorizontalOrientationButton;
    
    NSPopUpButton *anchorAttributeForHorizontalOrientationButton = [NSPopUpButton new];
    anchorAttributeForHorizontalOrientationButton.title = @"Horizontal";
    [anchorAttributeForHorizontalOrientationButton addItemsWithTitles:[self _allLayoutAttributeStrings]];
    
    anchorAttributeForHorizontalOrientationButton.target = self;
    anchorAttributeForHorizontalOrientationButton.action = @selector(_didTriggerAnchorPopupButton:);
    
    _anchorAttributeForHorizontalOrientationButton = anchorAttributeForHorizontalOrientationButton;
    return anchorAttributeForHorizontalOrientationButton;
}

- (NSPopUpButton *)_anchorAttributeForVerticalOrientationButton {
    if (auto anchorAttributeForVerticalOrientationButton = _anchorAttributeForVerticalOrientationButton) return anchorAttributeForVerticalOrientationButton;
    
    NSPopUpButton *anchorAttributeForVerticalOrientationButton = [NSPopUpButton new];
    anchorAttributeForVerticalOrientationButton.title = @"Vertical";
    [anchorAttributeForVerticalOrientationButton addItemsWithTitles:[self _allLayoutAttributeStrings]];
    
    anchorAttributeForVerticalOrientationButton.target = self;
    anchorAttributeForVerticalOrientationButton.action = @selector(_didTriggerAnchorPopupButton:);
    
    _anchorAttributeForVerticalOrientationButton = anchorAttributeForVerticalOrientationButton;
    return anchorAttributeForVerticalOrientationButton;
}

- (NSArray<NSString *> *)_allLayoutAttributeStrings {
    NSUInteger count;
    NSLayoutAttribute *allAttributes = allNSLayoutAttributes(&count);
    
    auto vector = std::views::iota(allAttributes, allAttributes + count)
    | std::views::transform([](NSLayoutAttribute *ptr) {
        return NSStringFromNSLayoutAttribute(*ptr);
    })
    | std::ranges::to<std::vector<NSString *>>();
    
    return [NSArray arrayWithObjects:vector.data() count:vector.size()];
}

- (void)_didTriggerButton:(NSButton *)sender {
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
        context.duration = 1.;
        
        NSLayoutConstraint *constraint;
        NSLayoutConstraint *otherConstraint;
        NSLayoutConstraint *sizeContraint;
        BOOL isNegative;
        if ([sender isEqual:self.leadingButton]) {
            constraint = self.labelLeadingConstraint;
            otherConstraint = self.labelTrailingConstraint;
            sizeContraint = self.labelWidthConstraint;
            isNegative = NO;
        } else if ([sender isEqual:self.trailingButton]) {
            constraint = self.labelTrailingConstraint;
            otherConstraint = self.labelLeadingConstraint;
            sizeContraint = self.labelWidthConstraint;
            isNegative = YES;
        } else if ([sender isEqual:self.topButton]) {
            constraint = self.labelTopConstraint;
            otherConstraint = self.labelBottomConstraint;
            sizeContraint = self.labelHeightConstraint;
            isNegative = NO;
        } else if ([sender isEqual:self.bottomButton]) {
            constraint = self.labelBottomConstraint;
            otherConstraint = self.labelTopConstraint;
            sizeContraint = self.labelHeightConstraint;
            isNegative = YES;
        } else {
            abort();
        }
        
        if (constraint.constant == 0.) {
            if (isNegative) {
                [constraint animator].constant = -100.;
            } else {
                [constraint animator].constant = 100.;
            }
            
            [sizeContraint animator].constant -= 100.;
        } else {
            [constraint animator].constant = 0.;
            [sizeContraint animator].constant += 100.;
        }
    }];
}

- (void)_didTriggerAnchorPopupButton:(NSPopUpButton *)sender {
    NSLayoutConstraintOrientation orientation;
    if ([sender isEqual:self.anchorAttributeForHorizontalOrientationButton]) {
        orientation = NSLayoutConstraintOrientationHorizontal;
    } else if ([sender isEqual:self.anchorAttributeForVerticalOrientationButton]) {
        orientation = NSLayoutConstraintOrientationVertical;
    } else {
        abort();
    }
    
    NSLayoutAttribute attribute = NSLayoutAttributeFromString(sender.titleOfSelectedItem);
    [self.window setAnchorAttribute:attribute forOrientation:orientation];
}

@end
