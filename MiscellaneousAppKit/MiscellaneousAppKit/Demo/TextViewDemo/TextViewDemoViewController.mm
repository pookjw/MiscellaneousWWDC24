//
//  TextViewDemoViewController.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/19/25.
//

#import "TextViewDemoViewController.h"

@interface TextViewDemoViewController ()
@end

@implementation TextViewDemoViewController

- (void)loadView {
    NSScrollView *scrollView = [NSScrollView new];
    NSTextView *textView = [NSTextView new];
    textView.autoresizingMask = NSViewWidthSizable;
    textView.usesFindBar = YES;
    textView.incrementalSearchingEnabled = YES;
    
    scrollView.documentView = textView;
    [textView release];
    
    self.view = scrollView;
    [scrollView release];
}

@end
