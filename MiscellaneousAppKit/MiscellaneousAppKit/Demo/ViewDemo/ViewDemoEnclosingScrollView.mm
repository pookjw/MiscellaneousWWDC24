//
//  ViewDemoEnclosingScrollView.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 3/4/25.
//

#import "ViewDemoEnclosingScrollView.h"

@interface ViewDemoEnclosingScrollView ()
@property (retain, nonatomic, readonly, getter=_scrollView) NSScrollView *scrollView;
@property (retain, nonatomic, readonly, getter=_textView) NSTextView *textView;
@property (retain, nonatomic, readonly, getter=_textView_2) NSTextView *textView_2;
@end

@implementation ViewDemoEnclosingScrollView
@synthesize scrollView = _scrollView;
@synthesize textView = _textView;
@synthesize textView_2 = _textView_2;

- (instancetype)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
        NSScrollView *scrollView = self.scrollView;
        scrollView.frame = self.bounds;
        scrollView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        [self addSubview:scrollView];
        
        [self.scrollView addSubview:self.textView_2];
        
        self.textView.string = [NSString stringWithFormat:@"Document View - Enclosing Scroll View : %@", self.textView.enclosingScrollView.description];
        self.textView_2.string = [NSString stringWithFormat:@"Subview - Enclosing Scroll View : %@", self.textView_2.enclosingScrollView.description];
    }
    
    return self;
}

- (void)dealloc {
    [_scrollView release];
    [_textView release];
    [_textView_2 release];
    [super dealloc];
}

- (void)layout {
    [super layout];
    
    self.textView_2.frame = NSMakeRect(NSMidX(self.scrollView.bounds) - NSWidth(self.scrollView.bounds) * 0.15,
                                       NSMidY(self.scrollView.bounds) - NSHeight(self.scrollView.bounds) * 0.15,
                                       NSWidth(self.scrollView.bounds) * 0.3,
                                       NSHeight(self.scrollView.bounds) * 0.3);
}

- (NSScrollView *)_scrollView {
    if (auto scrollView = _scrollView) return scrollView;
    
    NSScrollView *scrollView = [NSScrollView new];
    scrollView.documentView = self.textView;
    
    _scrollView = scrollView;
    return scrollView;
}

- (NSTextView *)_textView {
    if (auto textView = _textView) return textView;
    
    NSTextView *textView = [NSTextView new];
    textView.editable = NO;
    textView.autoresizingMask = NSViewWidthSizable;
    
    _textView = textView;
    return textView;
}

- (NSTextView *)_textView_2 {
    if (auto textView_2 = _textView_2) return textView_2;
    
    NSTextView *textView_2 = [NSTextView new];
    textView_2.editable = NO;
    textView_2.autoresizingMask = NSViewWidthSizable;
    
    _textView_2 = textView_2;
    return textView_2;
}

@end
