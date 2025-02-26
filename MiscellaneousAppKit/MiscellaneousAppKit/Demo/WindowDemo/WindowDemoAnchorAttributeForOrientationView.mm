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
@property (retain, nonatomic, readonly, getter=_containerView) NSView *containerView;
@property (retain, nonatomic, readonly, getter=_subcontainerView) NSView *subcontainerView;
@property (retain, nonatomic, readonly, getter=_primaryView) NSView *primaryView;
@property (retain, nonatomic, readonly, getter=_secondaryView) NSView *secondaryView;
@property (retain, nonatomic, readonly, getter=_toggleButton) NSButton *toggleButton;

@property (retain, nonatomic, getter=_subcontainerViewWidthConstraint, setter=_setSubcontainerViewWidthConstraint:) NSLayoutConstraint *subcontainerViewWidthConstraint;
@property (copy, nonatomic, getter=_expandedConstraints, setter=_setExpandedConstraints:) NSArray<NSLayoutConstraint *> *expandedConstraints;
@property (copy, nonatomic, getter=_collapsedConstraints, setter=_setCollapsedConstraints:) NSArray<NSLayoutConstraint *> *collapsedConstraints;

@property (retain, nonatomic, readonly, getter=_anchorAttributeForHorizontalOrientationButton) NSPopUpButton *anchorAttributeForHorizontalOrientationButton;
@property (assign, nonatomic, getter=_isExpanded, setter=_setExpanded:) BOOL expanded;
@end

@implementation WindowDemoAnchorAttributeForOrientationView
@synthesize stackView = _stackView;
@synthesize containerView = _containerView;
@synthesize subcontainerView = _subcontainerView;
@synthesize primaryView = _primaryView;
@synthesize secondaryView = _secondaryView;
@synthesize toggleButton = _toggleButton;
@synthesize anchorAttributeForHorizontalOrientationButton = _anchorAttributeForHorizontalOrientationButton;

- (instancetype)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
        NSStackView *stackView = self.stackView;
        stackView.frame = self.bounds;
        stackView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        [self addSubview:stackView];
        
        self.expanded = NO;
    }
    
    return self;
}

- (void)dealloc {
    [_stackView release];
    [_containerView release];
    [_subcontainerView release];
    [_primaryView release];
    [_secondaryView release];
    [_toggleButton release];
    [_anchorAttributeForHorizontalOrientationButton release];
    [_subcontainerViewWidthConstraint release];
    [_expandedConstraints release];
    [_collapsedConstraints release];
    [super dealloc];
}

- (void)viewDidMoveToWindow {
    [super viewDidMoveToWindow];
    
    if (NSWindow *window = self.window) {
        [self.anchorAttributeForHorizontalOrientationButton selectItemWithTitle:NSStringFromNSLayoutAttribute([window anchorAttributeForOrientation:NSLayoutConstraintOrientationHorizontal])];
    }
}

- (NSSize)fittingSize {
    return self.stackView.fittingSize;
}

- (NSSize)intrinsicContentSize {
    return self.stackView.intrinsicContentSize;
}

- (void)updateConstraints {
    [super updateConstraints];
    
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
        context.duration = 1.;
        
        NSView *secondaryView = self.secondaryView;
        NSLayoutConstraint *subcontainerViewWidthConstraint = [self.subcontainerViewWidthConstraint animator];
        
        NSMutableArray<NSLayoutConstraint *> *collapsedConstraints = [[NSMutableArray alloc] initWithCapacity:self.collapsedConstraints.count];
        for (NSLayoutConstraint *constraint in self.collapsedConstraints) {
            [collapsedConstraints addObject:[constraint animator]];
        }
        NSMutableArray<NSLayoutConstraint *> *expandedConstraints = [[NSMutableArray alloc] initWithCapacity:self.expandedConstraints.count];
        for (NSLayoutConstraint *constraint in self.expandedConstraints) {
            [expandedConstraints addObject:constraint];
        }
        
        if (self.expanded) {
            secondaryView.hidden = NO;
            [subcontainerViewWidthConstraint animator].constant = 200.;
            
            for (NSLayoutConstraint *constraint in collapsedConstraints) {
                constraint.active = NO;
            }
            for (NSLayoutConstraint *constraint in expandedConstraints) {
                constraint.active = YES;
            }
        } else {
            secondaryView.hidden = YES;
            subcontainerViewWidthConstraint.constant = 100.;
            
            for (NSLayoutConstraint *constraint in expandedConstraints) {
                constraint.active = NO;
            }
            for (NSLayoutConstraint *constraint in collapsedConstraints) {
                constraint.active = YES;
            }
        }
        
        [collapsedConstraints release];
        [expandedConstraints release];
    }];
}

- (NSStackView *)_stackView {
    if (auto stackView = _stackView) return stackView;
    
    NSStackView *stackView = [NSStackView new];
    
    [stackView addArrangedSubview:self.containerView];
    [stackView addArrangedSubview:self.toggleButton];
    [stackView addArrangedSubview:self.anchorAttributeForHorizontalOrientationButton];
    
    stackView.orientation = NSUserInterfaceLayoutOrientationVertical;
    stackView.distribution = NSStackViewDistributionFill;
    stackView.alignment = NSLayoutAttributeCenterX;
    
    _stackView = stackView;
    return stackView;
}

- (NSView *)_containerView {
    if (auto containerView = _containerView) return containerView;
    
    NSView *containerView = [NSView new];
    
    containerView.translatesAutoresizingMaskIntoConstraints = NO;
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(containerView, sel_registerName("setBackgroundColor:"), NSColor.blueColor);
    
    NSView *subcontainerView = self.subcontainerView;
    subcontainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [containerView addSubview:subcontainerView];
    
    NSLayoutConstraint *subcontainerViewWidthConstraint = [subcontainerView.widthAnchor constraintEqualToConstant:100.];
    self.subcontainerViewWidthConstraint = subcontainerViewWidthConstraint;
    
    [NSLayoutConstraint activateConstraints:@[
        [subcontainerView.topAnchor constraintEqualToAnchor:containerView.topAnchor],
        [subcontainerView.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor],
        [subcontainerView.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor],
        subcontainerViewWidthConstraint,
        [containerView.heightAnchor constraintEqualToConstant:200.]
    ]];
    
    _containerView = containerView;
    return containerView;
}

- (NSView *)_subcontainerView {
    if (auto subcontainerView = _subcontainerView) return subcontainerView;
    
    NSView *subcontainerView = [NSView new];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(subcontainerView, sel_registerName("setBackgroundColor:"), NSColor.redColor);
    
    NSView *primaryView = self.primaryView;
    NSView *secondaryView = self.secondaryView;
    
    primaryView.translatesAutoresizingMaskIntoConstraints = NO;
    secondaryView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [subcontainerView addSubview:primaryView];
    [subcontainerView addSubview:secondaryView];
    
    NSLayoutConstraint *primaryLeadingToSubcontainerContraint = [primaryView.leadingAnchor constraintEqualToAnchor:subcontainerView.leadingAnchor];
    self.collapsedConstraints = @[primaryLeadingToSubcontainerContraint];
    
    [NSLayoutConstraint activateConstraints:@[
        [primaryView.topAnchor constraintEqualToAnchor:subcontainerView.topAnchor],
        primaryLeadingToSubcontainerContraint,
        [primaryView.bottomAnchor constraintEqualToAnchor:subcontainerView.bottomAnchor],
        [primaryView.widthAnchor constraintEqualToConstant:100.],
        [secondaryView.widthAnchor constraintEqualToConstant:100.]
    ]];
    
    self.expandedConstraints = @[
        [secondaryView.topAnchor constraintEqualToAnchor:subcontainerView.topAnchor],
        [secondaryView.leadingAnchor constraintEqualToAnchor:subcontainerView.leadingAnchor],
        [secondaryView.bottomAnchor constraintEqualToAnchor:subcontainerView.bottomAnchor],
        [secondaryView.trailingAnchor constraintEqualToAnchor:primaryView.leadingAnchor]
    ];
    
    _subcontainerView = subcontainerView;
    return subcontainerView;
}

- (NSView *)_primaryView {
    if (auto primaryView = _primaryView) return primaryView;
    
    NSTextField *primaryView = [NSTextField labelWithString:@"Primary"];
    primaryView.drawsBackground = YES;
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(primaryView, sel_registerName("setBackgroundColor:"), NSColor.orangeColor);
    
    _primaryView = [primaryView retain];
    return primaryView;
}

- (NSView *)_secondaryView {
    if (auto secondaryView = _secondaryView) return secondaryView;
    
    NSTextField *secondaryView = [NSTextField labelWithString:@"Secondary"];
    secondaryView.drawsBackground = YES;
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(secondaryView, sel_registerName("setBackgroundColor:"), NSColor.greenColor);
    
    secondaryView.hidden = YES;
    
    _secondaryView = secondaryView;
    return secondaryView;
}

- (NSButton *)_toggleButton {
    if (auto toggleButton = _toggleButton) return toggleButton;
    
    NSButton *toggleButton = [NSButton new];
    toggleButton.title = @"Toggle";
    toggleButton.target = self;
    toggleButton.action = @selector(_didTriggerToggleButton:);
    
    _toggleButton = toggleButton;
    return toggleButton;
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

- (NSTextField *)_makeLabel {
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

    return label;
}

- (void)_didTriggerToggleButton:(NSButton *)sender {
    self.expanded = !self.expanded;
    self.needsUpdateConstraints = YES;
}

- (void)_didTriggerAnchorPopupButton:(NSPopUpButton *)sender {
    NSLayoutAttribute attribute = NSLayoutAttributeFromString(sender.titleOfSelectedItem);
    [self.window setAnchorAttribute:attribute forOrientation:NSLayoutConstraintOrientationHorizontal];
}

@end
