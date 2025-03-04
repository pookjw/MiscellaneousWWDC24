//
//  ViewDemoAncestorSharedView.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 3/4/25.
//

#import "ViewDemoAncestorSharedView.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface ViewDemoAncestorSharedView ()
@property (retain, nonatomic, readonly, getter=_primaryView) NSTextField *primaryView;
@property (retain, nonatomic, readonly, getter=_secondaryView) NSTextField *secondaryView;
@property (retain, nonatomic, readonly, getter=_tertiaryView) NSTextField *tertiaryView;
@end

@implementation ViewDemoAncestorSharedView

@synthesize primaryView = _primaryView;
@synthesize secondaryView = _secondaryView;
@synthesize tertiaryView = _tertiaryView;

- (instancetype)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.primaryView];
        [self.primaryView addSubview:self.secondaryView];
        [self addSubview:self.tertiaryView];
        
        self.secondaryView.stringValue = [NSString stringWithFormat:@"Secondary View - Ancestor Shared With Tertiary View : %@", [self.secondaryView ancestorSharedWithView:self.tertiaryView]];
        self.tertiaryView.stringValue = [NSString stringWithFormat:@"Tertiary View - Ancestor Shared With Secondary View : %@", [self.tertiaryView ancestorSharedWithView:self.secondaryView]];
    }
    
    return self;
}

- (void)dealloc {
    [_primaryView release];
    [_secondaryView release];
    [_tertiaryView release];
    [super dealloc];
}

- (void)layout {
    [super layout];
    self.primaryView.frame = self.bounds;
    self.secondaryView.frame = NSInsetRect(self.primaryView.bounds, 20., 20.);
    self.tertiaryView.frame = NSInsetRect(self.bounds, 85., 85.);
}

- (NSTextField *)_primaryView {
    if (auto primaryView = _primaryView) return primaryView;
    
    NSTextField *primaryView = [NSTextField wrappingLabelWithString:@""];
    primaryView.stringValue = @"Primary View";
    primaryView.textColor = NSColor.blackColor;
    primaryView.backgroundColor = NSColor.whiteColor;
    primaryView.drawsBackground = YES;
    primaryView.alignment = NSTextAlignmentCenter;
    
    _primaryView = [primaryView retain];
    return primaryView;
}

- (NSTextField *)_secondaryView {
    if (auto secondaryView = _secondaryView) return secondaryView;
    
    NSTextField *secondaryView = [NSTextField wrappingLabelWithString:@"Pending"];
    secondaryView.textColor = NSColor.blackColor;
    secondaryView.backgroundColor = NSColor.systemOrangeColor;
    secondaryView.drawsBackground = YES;
    secondaryView.alignment = NSTextAlignmentCenter;
    
    _secondaryView = [secondaryView retain];
    return secondaryView;
}

- (NSTextField *)_tertiaryView {
    if (auto tertiaryView = _tertiaryView) return tertiaryView;
    
    NSTextField *tertiaryView = [NSTextField wrappingLabelWithString:@"Pending"];
    tertiaryView.textColor = NSColor.blackColor;
    tertiaryView.backgroundColor = NSColor.systemCyanColor;
    tertiaryView.drawsBackground = YES;
    tertiaryView.alignment = NSTextAlignmentCenter;
    
    _tertiaryView = [tertiaryView retain];
    return tertiaryView;
}

@end
