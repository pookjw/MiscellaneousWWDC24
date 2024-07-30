//
//  OldLinkTextViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 7/30/24.
//

// https://stackoverflow.com/questions/59916934/how-to-use-uipreviewparameters-to-specify-a-range-of-text-as-a-highlighted-previ

#import "OldLinkTextViewController.h"
#import <SafariServices/SafariServices.h>
#import <objc/message.h>
#import <objc/runtime.h>

void *safariViewControllerContextKey = &safariViewControllerContextKey;

@interface OldLinkTextViewController () <UITextViewDelegate, UIContextMenuInteractionDelegate>
@property (retain, readonly, nonatomic) UITextView *textView;
@property (retain, readonly, nonatomic) UIContextMenuInteraction *contextMenuInteraction;
@end

@implementation OldLinkTextViewController
@synthesize textView = _textView;
@synthesize contextMenuInteraction = _contextMenuInteraction;

- (void)dealloc {
    [_textView release];
    [_contextMenuInteraction release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.textView;
}

- (UITextView *)textView {
    if (auto textView = _textView) return textView;
    
    UITextView *textView = [UITextView new];
    
    textView.delegate = self;
    textView.editable = NO;
    textView.selectable = NO;
    
    NSAttributedString *attributedString_1 = [[NSAttributedString alloc] initWithString:@"Swift Forum: " attributes:@{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleTitle1]}];
    
    NSAttributedString *attributedString_2 = [[NSAttributedString alloc] initWithString:@"forums.swift.org" attributes:@{NSLinkAttributeName: [NSURL URLWithString:@"https://forums.swift.org"], NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleTitle1]}];
    
    NSMutableAttributedString *result = [NSMutableAttributedString new];
    [result appendAttributedString:attributedString_1];
    [result appendAttributedString:attributedString_2];
    [attributedString_1 release];
    [attributedString_2 release];
    
    textView.attributedText = result;
    [result release];
    
    [textView addInteraction:self.contextMenuInteraction];
    
    _textView = [textView retain];
    return [textView autorelease];
}

- (UIContextMenuInteraction *)contextMenuInteraction {
    if (auto contextMenuInteraction = _contextMenuInteraction) return contextMenuInteraction;
    
    UIContextMenuInteraction *contextMenuInteraction = [[UIContextMenuInteraction alloc] initWithDelegate:self];
    
    _contextMenuInteraction = [contextMenuInteraction retain];
    return [contextMenuInteraction autorelease];
}

- (NSInteger)textOffsetFromPoint:(CGPoint)point {
    UITextView *textView = self.textView;
    UITextPosition * _Nullable textPosition = [textView closestPositionToPoint:point];
    
    if (textPosition == nil) return NSNotFound;
    
    NSInteger offset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:textPosition];
    NSAttributedString *attributedText = textView.attributedText;
    
    if (offset == NSNotFound) return NSNotFound;
    if (offset >= attributedText.length) return NSNotFound;
    
    return offset;
}

- (UIContextMenuConfiguration *)contextMenuInteraction:(UIContextMenuInteraction *)interaction configurationForMenuAtLocation:(CGPoint)location {
    NSInteger offset = [self textOffsetFromPoint:location];
    
    if (offset == NSNotFound) return nil;
    
    NSAttributedString *attributedText = self.textView.attributedText;
    NSURL *URL = [attributedText attribute:NSLinkAttributeName atIndex:offset longestEffectiveRange:NULL inRange:NSMakeRange(0, attributedText.length)];
    
    if (URL == nil) return nil;
    
    SFSafariViewController *viewController = [[SFSafariViewController alloc] initWithURL:URL];
    
    UIContextMenuConfiguration *configuration = [UIContextMenuConfiguration configurationWithIdentifier:nil
                                                                                        previewProvider:^UIViewController * _Nullable{
        return viewController;
    }
                                                                                         actionProvider:^UIMenu * _Nullable(NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
        UIMenu *menu = [UIMenu menuWithChildren:suggestedActions];
        return menu;
    }];
    
    objc_setAssociatedObject(configuration, safariViewControllerContextKey, viewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [viewController release];
    
    return configuration;
}

- (UITargetedPreview *)contextMenuInteraction:(UIContextMenuInteraction *)interaction configuration:(UIContextMenuConfiguration *)configuration highlightPreviewForItemWithIdentifier:(id<NSCopying>)identifier {
    UITextView *textView = self.textView;
    CGPoint location = [interaction locationInView:textView];
    NSInteger offset = [self textOffsetFromPoint:location];
    if (offset == NSNotFound) return nil;
    
    NSAttributedString *attributedText = self.textView.attributedText;
    NSRange effectiveRange;
    [attributedText attributesAtIndex:offset effectiveRange:&effectiveRange];
    
    UITextPosition *startPosition = [textView positionFromPosition:textView.beginningOfDocument offset:effectiveRange.location];
    UITextPosition *endPosition = [textView positionFromPosition:textView.beginningOfDocument offset:effectiveRange.location + effectiveRange.length];
    
    UITextRange *textRange = [textView textRangeFromPosition:startPosition toPosition:endPosition];
    CGRect rect = [self.textView firstRectForRange:textRange];
    
    UIView *snapshotView = [textView resizableSnapshotViewFromRect:rect afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
    
    UIPreviewParameters *parameters = [[UIPreviewParameters alloc] initWithTextLineRects:@[[NSValue valueWithCGRect:CGRectMake(0., 0., CGRectGetWidth(rect), CGRectGetHeight(rect))]]];
    
    UIPreviewTarget *target = [[UIPreviewTarget alloc] initWithContainer:textView center:CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect))];
    
    UITargetedPreview *highlightPreview = [[UITargetedPreview alloc] initWithView:snapshotView
                                                                       parameters:parameters
                                                                           target:target];
    
    [parameters release];
    [target release];
    
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(highlightPreview, sel_registerName("set_springboardPlatterStyle:"), YES);
    
    return [highlightPreview autorelease];
}

//- (UITargetedPreview *)contextMenuInteraction:(UIContextMenuInteraction *)interaction configuration:(UIContextMenuConfiguration *)configuration dismissalPreviewForItemWithIdentifier:(id<NSCopying>)identifier {
//    
//}

- (void)contextMenuInteraction:(UIContextMenuInteraction *)interaction willPerformPreviewActionForMenuWithConfiguration:(UIContextMenuConfiguration *)configuration animator:(id<UIContextMenuInteractionCommitAnimating>)animator {
    SFSafariViewController *viewController = objc_getAssociatedObject(configuration, safariViewControllerContextKey);
    
    if (viewController == nil) return;
    
    objc_setAssociatedObject(configuration, safariViewControllerContextKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [animator addAnimations:^{
        [self presentViewController:viewController animated:YES completion:nil];
    }];
}

- (UIAction *)textView:(UITextView *)textView primaryActionForTextItem:(UITextItem *)textItem defaultAction:(UIAction *)defaultAction {
    return nil;
}

- (UITextItemMenuConfiguration *)textView:(UITextView *)textView menuConfigurationForTextItem:(UITextItem *)textItem defaultMenu:(UIMenu *)defaultMenu {
    return nil;
}

@end
