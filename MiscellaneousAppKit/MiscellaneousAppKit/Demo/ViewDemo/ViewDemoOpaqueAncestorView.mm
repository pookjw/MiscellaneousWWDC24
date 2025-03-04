//
//  ViewDemoOpaqueAncestorView.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 3/1/25.
//

#import "ViewDemoOpaqueAncestorView.h"
#import <objc/runtime.h>
#import <objc/message.h>

/*
 superview를 계속 찾아가면서 isOpaque이 YES라면 그 View를 반환
 */

@interface ViewDemoOpaqueAncestorView ()
@property (retain, nonatomic, readonly, getter=_leftView) NSView *leftView;
@property (retain, nonatomic, readonly, getter=_rightView) NSView *rightView;
@property (retain, nonatomic, readonly, getter=_aboveView) NSView *aboveView;
@property (retain, nonatomic, readonly, getter=_label) NSTextField *label;
@end

@implementation ViewDemoOpaqueAncestorView
@synthesize leftView = _leftView;
@synthesize rightView = _rightView;
@synthesize aboveView = _aboveView;
@synthesize label = _label;

- (instancetype)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.leftView];
        [self addSubview:self.rightView];
        [self addSubview:self.aboveView];
        [self addSubview:self.label];
    }
    
    return self;
}

- (void)dealloc {
    [_leftView release];
    [_rightView release];
    [_aboveView release];
    [_label release];
    [super dealloc];
}

- (BOOL)isOpaque {
    return YES;
}

- (void)layout {
    [super layout];
    
    NSView *leftView = self.leftView;
    NSView *rightView = self.rightView;
    NSView *aboveView = self.aboveView;
    NSTextField *label = self.label;
    
    if (NSString *description = aboveView.opaqueAncestor.description) {
        label.stringValue = description;
    } else {
        label.stringValue = @"(null)";
    }
    
    NSSize labelSize = reinterpret_cast<NSSize (*)(id, SEL, NSSize, NSLayoutPriority, NSLayoutPriority)>(objc_msgSend)(label, sel_registerName("systemLayoutSizeFittingSize:withHorizontalFittingPriority:verticalFittingPriority:"), NSMakeSize(NSWidth(self.bounds), DBL_MAX), NSLayoutPriorityRequired, NSLayoutPriorityFittingSizeCompression);
    label.frame = NSMakeRect(0., 0., NSWidth(self.bounds), labelSize.height);
    
    leftView.frame = NSMakeRect(0., labelSize.height, NSWidth(self.bounds) * 0.5, NSHeight(self.bounds) - labelSize.height);
    rightView.frame = NSMakeRect(NSWidth(self.bounds) * 0.5, labelSize.height, NSWidth(self.bounds) * 0.5, NSHeight(self.bounds) - labelSize.height);
    
    aboveView.frame = NSMakeRect(NSWidth(self.bounds) * 0.25,
                                 labelSize.height,
                                 NSWidth(self.bounds) * 0.3,
                                 NSHeight(self.bounds) - labelSize.height);
}

- (NSView *)_leftView {
    if (auto leftView = _leftView) return leftView;
    
    NSView *leftView = [NSView new];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(leftView, sel_registerName("setBackgroundColor:"), NSColor.systemRedColor);
    
    _leftView = leftView;
    return leftView;
}

- (NSView *)_rightView {
    if (auto rightView = _rightView) return rightView;
    
    NSView *rightView = [NSView new];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(rightView, sel_registerName("setBackgroundColor:"), NSColor.systemGreenColor);
    
    _rightView = rightView;
    return rightView;
}

- (NSView *)_aboveView {
    if (auto aboveView = _aboveView) return aboveView;
    
    NSView *aboveView = [NSView new];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(aboveView, sel_registerName("setBackgroundColor:"), [NSColor.blackColor colorWithAlphaComponent:0.5]);
    
    _aboveView = aboveView;
    return aboveView;
}

- (NSTextField *)_label {
    if (auto label = _label) return label;
    
    NSTextField *label = [NSTextField wrappingLabelWithString:@"Pending"];
    label.maximumNumberOfLines = 0;
    label.alignment = NSTextAlignmentCenter;
    
    label.lineBreakMode = NSLineBreakByCharWrapping;
    
    _label = [label retain];
    return label;
}

@end
