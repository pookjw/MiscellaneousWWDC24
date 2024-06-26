//
//  RulerViewController.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/25/24.
//

#import "RulerViewController.h"
#import "CustomRulerMarker.h"
#import "CustomRulerView.h"
#import <objc/message.h>
#import <objc/runtime.h>

NSRulerViewUnitName const MARulerViewUnitCentimeter = @"MARulerViewUnitMillimeter";

@interface RulerViewController ()
@property (retain, nonatomic, readonly) NSScrollView *scrollView;
@property (retain, nonatomic, readonly) CustomRulerView *customRulerView;
@end

@implementation RulerViewController
@synthesize scrollView = _scrollView;
@synthesize customRulerView = _customRulerView;

+ (void)load {
    [NSRulerView registerUnitWithName:MARulerViewUnitCentimeter
                         abbreviation:@"cm"
         unitToPointsConversionFactor:28.35
                          stepUpCycle:@[@3.0]
                        stepDownCycle:@[@0.9]];
}

- (void)dealloc {
    [_scrollView release];
    [_customRulerView release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.scrollView;
}

- (NSScrollView *)scrollView {
    if (auto scrollView = _scrollView) return scrollView;
    
    NSScrollView *scrollView = [NSScrollView new];
    scrollView.documentView = self.customRulerView;
    scrollView.hasHorizontalRuler = YES;
    scrollView.hasVerticalRuler = YES;
    
    scrollView.rulersVisible = YES;
    
    scrollView.horizontalRulerView.measurementUnits = MARulerViewUnitCentimeter;
    scrollView.verticalRulerView.measurementUnits = MARulerViewUnitCentimeter;
    
//    scrollView.horizontalRulerView.originOffset = 100.;
    
    scrollView.drawsBackground = NO;
    
    scrollView.horizontalRulerView.clientView = self.customRulerView;
    scrollView.verticalRulerView.clientView = self.customRulerView;
    
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

//- (NSTextView *)textView {
//    if (auto textView = _textView) return textView;
//    
//    NSTextView *textView = [NSTextView new];
//    textView.autoresizingMask = NSViewWidthSizable;
//    textView.usesRuler = NO;
//    
//    _textView = [textView retain];
//    return [textView autorelease];
//}

- (CustomRulerView *)customRulerView {
    if (auto customRulerView = _customRulerView) return customRulerView;
    
    CustomRulerView *customRulerView = [CustomRulerView new];
    customRulerView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    
    _customRulerView = [customRulerView retain];
    return [customRulerView autorelease];
}

@end
