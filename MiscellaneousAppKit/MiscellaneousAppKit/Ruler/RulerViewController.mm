//
//  RulerViewController.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/25/24.
//

#import "RulerViewController.h"
#import "CustomRulerMarker.h"
#import "RulerContentView.h"
#import "RulerView.h"
#import <objc/message.h>
#import <objc/runtime.h>

NSRulerViewUnitName const MARulerViewUnitCentimeter = @"MARulerViewUnitMillimeter";

@interface RulerViewController ()
@property (retain, nonatomic, readonly) MyScrollView *scrollView;
@property (retain, nonatomic, readonly) RulerContentView *rulerContentView;
@property (retain, nonatomic, readonly) NSButton *moveRulerlineButton;
@property (assign, nonatomic) CGFloat rulerlineLocation;
@end

@implementation RulerViewController
@synthesize scrollView = _scrollView;
@synthesize rulerContentView = _rulerContentView;
@synthesize moveRulerlineButton = _moveRulerlineButton;

+ (void)load {
    [NSRulerView registerUnitWithName:MARulerViewUnitCentimeter
                         abbreviation:@"cm"
         unitToPointsConversionFactor:28.35
                          stepUpCycle:@[@3.0]
                        stepDownCycle:@[@0.9]];
}

- (void)dealloc {
    [_scrollView release];
    [_rulerContentView release];
    [_moveRulerlineButton release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rulerlineLocation = 0.;
    
    MyScrollView *scrollView = self.scrollView;
    NSButton *moveRulerLineButton = self.moveRulerlineButton;
    
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    moveRulerLineButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:scrollView];
    [self.view addSubview:moveRulerLineButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [scrollView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [moveRulerLineButton.trailingAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.trailingAnchor],
        [moveRulerLineButton.bottomAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.bottomAnchor]
    ]];
}

- (MyScrollView *)scrollView {
    if (auto scrollView = _scrollView) return scrollView;
    
    MyScrollView *scrollView = [MyScrollView new];
    scrollView.documentView = self.rulerContentView;
    scrollView.hasHorizontalRuler = YES;
    scrollView.hasVerticalRuler = YES;
    
    scrollView.rulersVisible = YES;
    
    scrollView.horizontalRulerView.measurementUnits = MARulerViewUnitCentimeter;
    scrollView.verticalRulerView.measurementUnits = MARulerViewUnitCentimeter;
    
//    scrollView.horizontalRulerView.originOffset = 100.;
    
    scrollView.drawsBackground = NO;
    
    scrollView.horizontalRulerView.clientView = self.rulerContentView;
    scrollView.verticalRulerView.clientView = self.rulerContentView;
    
    // 줄자 두께
    scrollView.horizontalRulerView.ruleThickness = 40.;
    
//    scrollView.horizontalRulerView.reservedThicknessForMarkers = 40.;
    
    //
    
    NSTextField *textField_1 = [NSTextField new];
    textField_1.stringValue = @"Test";
    ((void (*)(id, SEL, CGSize))objc_msgSend)(textField_1, sel_registerName("setFrameSize:"), CGSizeMake(0., 50.));
    scrollView.horizontalRulerView.accessoryView = textField_1;
    [textField_1 release];
    
    NSTextField *textField_2 = [NSTextField new];
    textField_2.stringValue = @"Test";
    ((void (*)(id, SEL, CGSize))objc_msgSend)(textField_2, sel_registerName("setFrameSize:"), CGSizeMake(50., 0.));
    scrollView.verticalRulerView.accessoryView = textField_2;
    [textField_2 release];
    
    
    //
    
    for (NSUInteger i = 0; i < 10; i++) {
        CustomRulerMarker *horizontalRulerMaker = [[CustomRulerMarker alloc] initWithRulerView:scrollView.horizontalRulerView markerLocation:(CGFloat)i * 30. image:[NSImage imageWithSystemSymbolName:@"apple.logo" accessibilityDescription:nil] imageOrigin:NSZeroPoint];
        
        [scrollView.horizontalRulerView addMarker:horizontalRulerMaker];
        
        [horizontalRulerMaker release];
        
        //
        
        CustomRulerMarker *verticalRulerMaker = [[CustomRulerMarker alloc] initWithRulerView:scrollView.verticalRulerView markerLocation:(CGFloat)i * 30. image:[NSImage imageWithSystemSymbolName:@"apple.logo" accessibilityDescription:nil] imageOrigin:NSZeroPoint];
        
        [scrollView.verticalRulerView addMarker:verticalRulerMaker];
        [verticalRulerMaker release];
    }
    
    _scrollView = [scrollView retain];
    return [scrollView autorelease];
}

- (RulerContentView *)rulerContentView {
    if (auto rulerContentView = _rulerContentView) return rulerContentView;
    
    RulerContentView *rulerContentView = [RulerContentView new];
    rulerContentView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    
    _rulerContentView = [rulerContentView retain];
    return [rulerContentView autorelease];
}

- (NSButton *)moveRulerlineButton {
    if (auto moveRulerLineButton = _moveRulerlineButton) return moveRulerLineButton;
    
    NSButton *moveRulerLineButton = [NSButton buttonWithTitle:@"Move Line" target:self action:@selector(moveRulerlineButtonDidTrigger:)];
    
    _moveRulerlineButton = [moveRulerLineButton retain];
    return moveRulerLineButton;
}

- (void)moveRulerlineButtonDidTrigger:(NSButton *)sender {
    // oldLocation이 0보타 작으면 이전 line이 남고, 크거나 같으면 안 남음
    [self.scrollView.horizontalRulerView moveRulerlineFromLocation:-1. toLocation:self.rulerlineLocation];
    
    self.rulerlineLocation += 100.;
}

@end
