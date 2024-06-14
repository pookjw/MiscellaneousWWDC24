//
//  TextViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/13/24.
//

#import "TextViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface TextViewController ()
@property (readonly, nonatomic) UITextView *textView;
@property (retain, readonly, nonatomic) UIPasteControl *pasteControl;
@property (retain, readonly, nonatomic) UIBarButtonItem *pasteControlBarButtonItem;
@property (retain, readonly, nonatomic) UIBarButtonItem *textFormattingBarButtonItem;
@end

@implementation TextViewController
@synthesize pasteControl = _pasteControl;
@synthesize pasteControlBarButtonItem = _pasteControlBarButtonItem;
@synthesize textFormattingBarButtonItem = _textFormattingBarButtonItem;

- (void)dealloc {
    [_pasteControl release];
    [_pasteControlBarButtonItem release];
    [_textFormattingBarButtonItem release];
    [super dealloc];
}

- (void)loadView {
    UITextView *textView = [UITextView new];
    textView.allowsEditingTextAttributes = YES;
//    textView.supportsAdaptiveImageGlyph = YES;
//    textView.writingToolsBehavior = UIWritingToolsBehaviorComplete;
//    textView.writingToolsAllowedInputOptions = UIWritingToolsAllowedInputOptionsTable;
    self.view = textView;
    [textView release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationItem *navigationItem = self.navigationItem;
    
    navigationItem.leftBarButtonItems = @[
        self.pasteControlBarButtonItem,
        self.textFormattingBarButtonItem
    ];
}

- (UITextView *)textView {
    return (UITextView *)self.view;
}

- (UIPasteControl *)pasteControl {
    if (auto pasteControl = _pasteControl) return pasteControl;
    
    UIPasteControlConfiguration *configuration = [UIPasteControlConfiguration new];
    configuration.displayMode = UIPasteControlDisplayModeIconAndLabel;
    
    UIPasteControl *pasteControl = [[UIPasteControl alloc] initWithConfiguration:configuration];
    [configuration release];
    
    /* id<UIPasteConfigurationSupporting> */
    pasteControl.target = self.textView;
    
    _pasteControl = [pasteControl retain];
    return [pasteControl autorelease];
}

- (UIBarButtonItem *)pasteControlBarButtonItem {
    if (auto pasteControlBarButtonItem = _pasteControlBarButtonItem) return pasteControlBarButtonItem;
    
    UIBarButtonItem *pasteControlBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.pasteControl];
    
    _pasteControlBarButtonItem = [pasteControlBarButtonItem retain];
    return [pasteControlBarButtonItem autorelease];
}

- (UIBarButtonItem *)textFormattingBarButtonItem {
    if (auto textFormattingBarButtonItem = _textFormattingBarButtonItem) return textFormattingBarButtonItem;
    
    UIBarButtonItem *textFormattingBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"paintpalette.fill"] style:UIBarButtonItemStylePlain target:self action:@selector(textFormattingBarButtonItemDidTrigger:)];
    
    _textFormattingBarButtonItem = [textFormattingBarButtonItem retain];
    return [textFormattingBarButtonItem autorelease];
}

- (void)textFormattingBarButtonItemDidTrigger:(UIBarButtonItem *)sender {
    /* UITextFormattingViewControllerConfiguration */
//    id configuration = [objc_lookUpClass("UITextFormattingViewControllerConfiguration") new];
//    
//    ((void (*)(id, SEL, BOOL))objc_msgSend)(configuration, sel_registerName("set_textViewConfiguration:"), YES);
    
    id configuration = [((id (*)(id, SEL))objc_msgSend)(self.textView, sel_registerName("textFormattingConfiguration")) copy];
    ((void (*)(id, SEL, BOOL))objc_msgSend)(configuration, sel_registerName("set_textAnimationsConfiguration:"), YES);
    
    /* UITextFormattingViewController */
    __kindof UIViewController *textFormattingViewController = ((id (*)(id, SEL, id))objc_msgSend)([objc_lookUpClass("UITextFormattingViewController") alloc], sel_registerName("initWithConfiguration:"), configuration);
    [configuration release];
    
    ((void (*)(id, SEL, id))objc_msgSend)(textFormattingViewController, sel_registerName("_setInternalDelegate:"), self.textView);
    ((void (*)(id, SEL, id))objc_msgSend)(textFormattingViewController, sel_registerName("_setEditResponder:"), self.textView);
    
    textFormattingViewController.modalPresentationStyle = UIModalPresentationPopover;
    textFormattingViewController.popoverPresentationController.sourceItem = sender;
    
    [self presentViewController:textFormattingViewController animated:YES completion:nil];
    [textFormattingViewController release];
}

@end
