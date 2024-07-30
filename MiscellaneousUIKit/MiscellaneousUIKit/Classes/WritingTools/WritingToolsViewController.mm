//
//  WritingToolsViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 7/30/24.
//

#import "WritingToolsViewController.h"

@interface WritingToolsViewController () <UITextViewDelegate>
@property (retain, readonly, nonatomic) UITextView *textView;
@end

@implementation WritingToolsViewController
@synthesize textView = _textView;

- (void)dealloc {
    [_textView release];
    [super dealloc];
}

- (UITextView *)textView {
    if (auto textView = _textView) return textView;
    
    UITextView *textView = [UITextView new];
    
    textView.allowedWritingToolsResultOptions = UIWritingToolsResultList | UIWritingToolsResultPlainText | UIWritingToolsResultRichText | UIWritingToolsResultTable;
    
    textView.writingToolsBehavior = UIWritingToolsBehaviorComplete;
    
    textView.delegate = self;
    
    _textView = [textView retain];
    return [textView autorelease];
}

- (void)textViewWritingToolsWillBegin:(UITextView *)textView {
    NSLog(@"%s", __func__);
}

- (void)textViewWritingToolsDidEnd:(UITextView *)textView {
    NSLog(@"%s", __func__);
}

- (NSArray<NSValue *> *)textView:(UITextView *)textView writingToolsIgnoredRangesInEnclosingRange:(NSRange)enclosingRange {
    return @[];
}



@end
