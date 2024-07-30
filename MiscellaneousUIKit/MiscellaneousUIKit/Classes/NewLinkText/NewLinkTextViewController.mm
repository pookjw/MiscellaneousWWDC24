//
//  NewLinkTextViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 7/30/24.
//

#import "NewLinkTextViewController.h"

@interface NewLinkTextViewController () <UITextViewDelegate>
@property (retain, readonly, nonatomic) UITextView *textView;
@property (retain, readonly, nonatomic) UIView *blueView;
@end

@implementation NewLinkTextViewController
@synthesize textView = _textView;
@synthesize blueView = _blueView;

- (void)dealloc {
    [_textView release];
    [_blueView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITextView *textView = self.textView;
    textView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:textView];
    [NSLayoutConstraint activateConstraints:@[
        [textView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [textView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [textView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [textView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
}

- (UITextView *)textView {
    if (auto textView = _textView) return textView;
    
    UITextView *textView = [UITextView new];
    
    textView.delegate = self;
    textView.editable = NO;
    
    NSAttributedString *attributedString_1 = [[NSAttributedString alloc] initWithString:@"Swift Forum: "];
    
    NSAttributedString *attributedString_2 = [[NSAttributedString alloc] initWithString:@"forums.swift.org" attributes:@{NSLinkAttributeName: [NSURL URLWithString:@"https://forums.swift.org"]}];
    
    NSMutableAttributedString *result = [NSMutableAttributedString new];
    [result appendAttributedString:attributedString_1];
    [result appendAttributedString:attributedString_2];
    [attributedString_1 release];
    [attributedString_2 release];
    
    textView.attributedText = result;
    [result release];
    
    _textView = [textView retain];
    return [textView autorelease];
}

- (UIView *)blueView {
    if (auto blueView = _blueView) return blueView;
    
    UIView *blueView = [UIView new];
    blueView.backgroundColor = UIColor.systemBlueColor;
    
    _blueView = [blueView retain];
    return [blueView autorelease];
}

- (UIAction *)textView:(UITextView *)textView primaryActionForTextItem:(UITextItem *)textItem defaultAction:(UIAction *)defaultAction {
    if (textItem.contentType == UITextItemContentTypeLink) {
        __weak auto weakSelf = self;
        UIAction *action = [UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
            [weakSelf.view.window.windowScene openURL:textItem.link options:nil completionHandler:nil];
        }];
        
        return action;
    } else {
        return nil;
    }
}

- (UITextItemMenuConfiguration *)textView:(UITextView *)textView menuConfigurationForTextItem:(UITextItem *)textItem defaultMenu:(UIMenu *)defaultMenu {
//    UITextItemMenuConfiguration *menuConfiguration = [UITextItemMenuConfiguration configurationWithPreview:nil menu:defaultMenu];
    
    UITextItemMenuPreview *textItemMenuPreview = [[UITextItemMenuPreview alloc] initWithView:self.blueView];
    UITextItemMenuConfiguration *menuConfiguration = [UITextItemMenuConfiguration configurationWithPreview:textItemMenuPreview menu:defaultMenu];
    [textItemMenuPreview release];
    
    return menuConfiguration;
}

@end
