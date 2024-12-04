//
//  WritingToolsViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 7/30/24.
//

#import "WritingToolsViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

@interface WritingToolsViewController () <UITextViewDelegate>
@property (retain, readonly, nonatomic) UITextView *textView;
@property (retain, readonly, nonatomic) UIBarButtonItem *writingToolsBarButtonItem;
@property (retain, readonly, nonatomic) UIBarButtonItem *playAnimationBarButtonItem;
@property (retain, readonly, nonatomic) UIBarButtonItem *stopAnimationBarButtonItem;
@end

@implementation WritingToolsViewController
@synthesize textView = _textView;
@synthesize writingToolsBarButtonItem = _writingToolsBarButtonItem;
@synthesize playAnimationBarButtonItem = _playAnimationBarButtonItem;
@synthesize stopAnimationBarButtonItem = _stopAnimationBarButtonItem;

- (void)dealloc {
    [_textView release];
    [_writingToolsBarButtonItem release];
    [_playAnimationBarButtonItem release];
    [_stopAnimationBarButtonItem release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.textView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    
    assert(reinterpret_cast<BOOL (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("WTWritingToolsController"), sel_registerName("isAvailable")));

    // 또는 +[UIAssistantBarButtonItemProvider systemDefaultAssistantItem]
    id systemDefaultAssistantItem = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self.textView, sel_registerName("inputAssistantItem"));
    
    self.navigationItem.leadingItemGroups = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(systemDefaultAssistantItem, sel_registerName("leadingBarButtonGroups"));
    self.navigationItem.trailingItemGroups = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(systemDefaultAssistantItem, sel_registerName("trailingBarButtonGroups"));
    self.navigationItem.centerItemGroups = @[
        [UIBarButtonItemGroup fixedGroupWithRepresentativeItem:nil items:@[
            self.playAnimationBarButtonItem,
            self.stopAnimationBarButtonItem,
            self.writingToolsBarButtonItem
        ]]
    ];
}

- (UITextView *)textView {
    if (auto textView = _textView) return textView;
    
    UITextView *textView = [UITextView new];
    
    NSURL *articleURL = [NSBundle.mainBundle URLForResource:@"article" withExtension:UTTypePlainText.preferredFilenameExtension];
    NSError * _Nullable error = nil;
    NSString *text = [[NSString alloc] initWithContentsOfURL:articleURL encoding:NSUTF8StringEncoding error:&error];
    assert(error == nil);
    textView.text = text;
    [text release];
    
//    textView.allowedWritingToolsResultOptions = UIWritingToolsResultList | UIWritingToolsResultPlainText | UIWritingToolsResultRichText;
    
//     UIWritingToolsResultTable 강제 설정
    UITextInputTraits *_textInputTraits = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(textView, sel_registerName("_textInputTraits"));
    reinterpret_cast<void (*)(id, SEL, UIWritingToolsResultOptions)>(objc_msgSend)(_textInputTraits, sel_registerName("setAllowedWritingToolsResultOptions:"), UIWritingToolsResultList | UIWritingToolsResultPlainText | UIWritingToolsResultRichText | UIWritingToolsResultTable);
    
    textView.writingToolsBehavior = UIWritingToolsBehaviorComplete;
    
    textView.delegate = self;
    textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle1];
    
    _textView = [textView retain];
    return [textView autorelease];
}

- (UIBarButtonItem *)writingToolsBarButtonItem {
    if (auto writingToolsBarButtonItem = _writingToolsBarButtonItem) return writingToolsBarButtonItem;
    
    UITextView *textView = self.textView;
    
    UIMenu *menu = [UIMenu menuWithChildren:@[
        [UIAction actionWithTitle:@"Select All" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        [textView selectAll:nil];
    }],
        [UIAction actionWithTitle:@"Start Writing Tools" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(textView, sel_registerName("_startWritingTools:"), nil); // WTUIRequestedToolNone
    }],
        [UIAction actionWithTitle:@"WTUIRequestedToolProofreading" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(textView, sel_registerName("_startProofreading"), nil); // WTUIRequestedToolProofreading
    }],
        [UIAction actionWithTitle:@"WTUIRequestedToolRewriting" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(textView, sel_registerName("_startRewriting"), nil); // WTUIRequestedToolRewriting
    }],
        [UIAction actionWithTitle:@"WTUIRequestedToolSmartReply" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        reinterpret_cast<void (*)(id, SEL, id, id, id)>(objc_msgSend)(textView, sel_registerName("_startWritingToolsWithTool:prompt:sender:"), @"WTUIRequestedToolSmartReply", nil, nil);
    }],
        [UIAction actionWithTitle:@"WTUIRequestedToolRewriteProofread" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        reinterpret_cast<void (*)(id, SEL, id, id, id)>(objc_msgSend)(textView, sel_registerName("_startWritingToolsWithTool:prompt:sender:"), @"WTUIRequestedToolRewriteProofread", nil, nil);
    }],
        [UIAction actionWithTitle:@"WTUIRequestedToolRewriteFriendly" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        reinterpret_cast<void (*)(id, SEL, id, id, id)>(objc_msgSend)(textView, sel_registerName("_startWritingToolsWithTool:prompt:sender:"), @"WTUIRequestedToolRewriteFriendly", nil, nil);
    }],
        [UIAction actionWithTitle:@"WTUIRequestedToolRewriteProfessional" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        reinterpret_cast<void (*)(id, SEL, id, id, id)>(objc_msgSend)(textView, sel_registerName("_startWritingToolsWithTool:prompt:sender:"), @"WTUIRequestedToolRewriteFriendly", nil, nil);
    }],
        [UIAction actionWithTitle:@"WTUIRequestedToolRewriteConcise" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        reinterpret_cast<void (*)(id, SEL, id, id, id)>(objc_msgSend)(textView, sel_registerName("_startWritingToolsWithTool:prompt:sender:"), @"WTUIRequestedToolRewriteFriendly", nil, nil);
    }],
        [UIAction actionWithTitle:@"WTUIRequestedToolRewriteOpenEnded" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        reinterpret_cast<void (*)(id, SEL, id, id, id)>(objc_msgSend)(textView, sel_registerName("_startWritingToolsWithTool:prompt:sender:"), @"WTUIRequestedToolRewriteOpenEnded", nil, nil);
    }],
        [UIAction actionWithTitle:@"WTUIRequestedToolSummary" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        reinterpret_cast<void (*)(id, SEL, id, id, id)>(objc_msgSend)(textView, sel_registerName("_startWritingToolsWithTool:prompt:sender:"), @"WTUIRequestedToolSummary", nil, nil);
    }],
        [UIAction actionWithTitle:@"WTUIRequestedToolTransformKeyPoints" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        reinterpret_cast<void (*)(id, SEL, id, id, id)>(objc_msgSend)(textView, sel_registerName("_startWritingToolsWithTool:prompt:sender:"), @"WTUIRequestedToolSummary", nil, nil);
    }],
        [UIAction actionWithTitle:@"WTUIRequestedToolTransformList" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        reinterpret_cast<void (*)(id, SEL, id, id, id)>(objc_msgSend)(textView, sel_registerName("_startWritingToolsWithTool:prompt:sender:"), @"WTUIRequestedToolSummary", nil, nil);
    }],
        [UIAction actionWithTitle:@"TUIRequestedToolTransformTable" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        reinterpret_cast<void (*)(id, SEL, id, id, id)>(objc_msgSend)(textView, sel_registerName("_startWritingToolsWithTool:prompt:sender:"), @"WTUIRequestedToolSummary", nil, nil);
    }]
    ]];
    
    UIBarButtonItem *writingToolsBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"ladybug.fill"] menu:menu];
    writingToolsBarButtonItem.title = @"Writing Tools";
    
    _writingToolsBarButtonItem = [writingToolsBarButtonItem retain];
    return [writingToolsBarButtonItem autorelease];
}

- (UIBarButtonItem *)playAnimationBarButtonItem {
    if (auto playAnimationBarButtonItem = _playAnimationBarButtonItem) return playAnimationBarButtonItem;
    
    UIBarButtonItem *playAnimationBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"rainbow"] style:UIBarButtonItemStylePlain target:self action:@selector(didTriggerPlayAnimationBarButtonItem:)];
    
    playAnimationBarButtonItem.title = @"Play Animation";
    
    _playAnimationBarButtonItem = [playAnimationBarButtonItem retain];
    return [playAnimationBarButtonItem autorelease];
}

- (UIBarButtonItem *)stopAnimationBarButtonItem {
    if (auto stopAnimationBarButtonItem = _stopAnimationBarButtonItem) return stopAnimationBarButtonItem;
    
    UIBarButtonItem *stopAnimationBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"rainbow"] style:UIBarButtonItemStylePlain target:self action:@selector(didTriggerStopAnimationBarButtonItem:)];
    
    stopAnimationBarButtonItem.title = @"Stop Animation";
    
    _stopAnimationBarButtonItem = [stopAnimationBarButtonItem retain];
    return [stopAnimationBarButtonItem autorelease];
}

- (void)didTriggerPlayAnimationBarButtonItem:(UIBarButtonItem *)sender {
//    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self.textView, sel_registerName("_startWritingTools:"), nil);
    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(self.textView, sel_registerName("_playInvocationAnimation"));
    
    // _UITextAssistantManager *
    id _textAssistantManager = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self.textView, sel_registerName("_textAssistantManager"));
    UITextPosition *toPosition = [self.textView positionFromPosition:self.textView.beginningOfDocument offset:self.textView.text.length];
    UITextRange *range = [self.textView textRangeFromPosition:self.textView.beginningOfDocument toPosition:toPosition];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(_textAssistantManager, sel_registerName("beginTextAssistantAnticipationForProofreadingRange:"), range);
    
//    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(_textAssistantManager, sel_registerName("beginTextAssistantAnticipation"));
    
    // Rewritten Animation은 어떻게 하지?
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(_textAssistantManager, sel_registerName("animateRewrittenTextForDelivery:"), [NSUUID UUID]);
//    });
}

- (void)didTriggerStopAnimationBarButtonItem:(UIBarButtonItem *)sender {
    // _UITextAssistantManager *
    id _textAssistantManager = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self.textView, sel_registerName("_textAssistantManager"));
    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(_textAssistantManager, sel_registerName("endTextAssistantAnticipation"));
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
