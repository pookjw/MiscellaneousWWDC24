//
//  WritingToolsViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 7/30/24.
//

#import "WritingToolsViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

// Programatically하게 할 수 있는지
// 정확히 어떤 Action이 왔는지 감지
// UITextView 뿐만 아니라 다른 곳에서도 사용할 수 있는지

/*
 -[WTWritingToolsViewController startWritingTools]
 -[UIResponder _supportsWritingTools]
 -[UIResponder(WritingToolsSupport) _startWritingTools:]
 */

@interface WritingToolsViewController () <UITextViewDelegate>
@property (retain, readonly, nonatomic) UITextView *textView;
@property (retain, readonly, nonatomic) UIBarButtonItem *startWritingToolsBarButtonItem;
@end

@implementation WritingToolsViewController
@synthesize textView = _textView;
@synthesize startWritingToolsBarButtonItem = _startWritingToolsBarButtonItem;

- (void)dealloc {
    [_textView release];
    [_startWritingToolsBarButtonItem release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.textView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    
    self.navigationItem.rightBarButtonItem = self.startWritingToolsBarButtonItem;
}

- (UITextView *)textView {
    if (auto textView = _textView) return textView;
    
    UITextView *textView = [UITextView new];
    
    textView.text = @"Hello World!";
    
    // UIWritingToolsResultTable is not supported yet
    textView.allowedWritingToolsResultOptions = UIWritingToolsResultList | UIWritingToolsResultPlainText | UIWritingToolsResultRichText;
    
    textView.writingToolsBehavior = UIWritingToolsBehaviorComplete;
    
    textView.delegate = self;
    
    _textView = [textView retain];
    return [textView autorelease];
}

- (UIBarButtonItem *)startWritingToolsBarButtonItem {
    if (auto startWritingToolsBarButtonItem = _startWritingToolsBarButtonItem) return startWritingToolsBarButtonItem;
    
    UIBarButtonItem *startWritingToolsBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"ladybug.fill"] style:UIBarButtonItemStylePlain target:self.textView action:sel_registerName("_startWritingTools:")];
    
    _startWritingToolsBarButtonItem = [startWritingToolsBarButtonItem retain];
    return [startWritingToolsBarButtonItem autorelease];
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
