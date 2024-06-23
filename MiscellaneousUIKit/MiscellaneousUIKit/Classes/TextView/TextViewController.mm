//
//  TextViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/13/24.
//

#import "TextViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface TextViewController () <UITextViewDelegate>
@property (readonly, nonatomic) UITextView *textView;
@property (retain, readonly, nonatomic) UIPasteControl *pasteControl;
@property (retain, readonly, nonatomic) UIBarButtonItem *pasteControlBarButtonItem;
@property (retain, readonly, nonatomic) UIBarButtonItem *textFormattingBarButtonItem;
@property (retain, readonly, nonatomic) UIBarButtonItem *updateTextHighlightAttributesBarButtomItem;
@property (retain, readonly, nonatomic) UIBarButtonItem *applyTextHighlightStyleBarButtomItem;
@property (retain, readonly, nonatomic) UIBarButtonItem *applyTextHighlightColorSchemeBarButtomItem;
@property (retain, readonly, nonatomic) UIBarButtonItem *addAdaptiveImageGlyphBarButtonItem;
@property (retain, readonly, nonatomic) UIBarButtonItem *addLocalizedNumberFormatBarButtonItem;
@end

@implementation TextViewController
@synthesize pasteControl = _pasteControl;
@synthesize pasteControlBarButtonItem = _pasteControlBarButtonItem;
@synthesize textFormattingBarButtonItem = _textFormattingBarButtonItem;
@synthesize updateTextHighlightAttributesBarButtomItem = _updateTextHighlightAttributesBarButtomItem;
@synthesize applyTextHighlightStyleBarButtomItem = _applyTextHighlightStyleBarButtomItem;
@synthesize applyTextHighlightColorSchemeBarButtomItem = _applyTextHighlightColorSchemeBarButtomItem;
@synthesize addAdaptiveImageGlyphBarButtonItem = _addAdaptiveImageGlyphBarButtonItem;
@synthesize addLocalizedNumberFormatBarButtonItem = _addLocalizedNumberFormatBarButtonItem;

- (void)dealloc {
    [_pasteControl release];
    [_pasteControlBarButtonItem release];
    [_textFormattingBarButtonItem release];
    [_updateTextHighlightAttributesBarButtomItem release];
    [_applyTextHighlightStyleBarButtomItem release];
    [_applyTextHighlightColorSchemeBarButtomItem release];
    [_addAdaptiveImageGlyphBarButtonItem release];
    [_addLocalizedNumberFormatBarButtonItem release];
    [super dealloc];
}

- (void)loadView {
    UITextView *textView = [UITextView new];
    textView.allowsEditingTextAttributes = YES;
    textView.supportsAdaptiveImageGlyph = YES;
    
    // TODO: Writing Tools with iPad
    textView.writingToolsBehavior = UIWritingToolsBehaviorComplete;
    textView.writingToolsAllowedInputOptions = UIWritingToolsAllowedInputOptionsTable;
    textView.delegate = self;
    
    self.view = textView;
    [textView release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationItem *navigationItem = self.navigationItem;
    
    navigationItem.leftBarButtonItems = @[
        self.pasteControlBarButtonItem,
        self.textFormattingBarButtonItem,
        self.updateTextHighlightAttributesBarButtomItem,
        self.applyTextHighlightStyleBarButtomItem,
        self.applyTextHighlightColorSchemeBarButtomItem,
        self.addAdaptiveImageGlyphBarButtonItem,
        self.addLocalizedNumberFormatBarButtonItem
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

- (UIBarButtonItem *)updateTextHighlightAttributesBarButtomItem {
    if (auto updateTextHighlightAttributesBarButtomItem = _updateTextHighlightAttributesBarButtomItem) return updateTextHighlightAttributesBarButtomItem;
    
    UIBarButtonItem *updateTextHighlightAttributesBarButtomItem = [[UIBarButtonItem alloc] initWithTitle:@"1" style:UIBarButtonItemStylePlain target:self action:@selector(updateTextHighlightAttributesBarButtomItemDidTrigger:)];
    
    _updateTextHighlightAttributesBarButtomItem = [updateTextHighlightAttributesBarButtomItem retain];
    return [updateTextHighlightAttributesBarButtomItem autorelease];
}

- (UIBarButtonItem *)applyTextHighlightStyleBarButtomItem {
    if (auto applyTextHighlightStyleBarButtomItem = _applyTextHighlightStyleBarButtomItem) return applyTextHighlightStyleBarButtomItem;
    
    UIBarButtonItem *applyTextHighlightStyleBarButtomItem = [[UIBarButtonItem alloc] initWithTitle:@"2" style:UIBarButtonItemStylePlain target:self action:@selector(applyTextHighlightStyleBarButtomItemDidTrigger:)];
    
    _applyTextHighlightStyleBarButtomItem = [applyTextHighlightStyleBarButtomItem retain];
    return [applyTextHighlightStyleBarButtomItem autorelease];
}

- (UIBarButtonItem *)applyTextHighlightColorSchemeBarButtomItem {
    if (auto applyTextHighlightColorSchemeBarButtomItem = _applyTextHighlightColorSchemeBarButtomItem) return applyTextHighlightColorSchemeBarButtomItem;
    
    UIBarButtonItem *applyTextHighlightColorSchemeBarButtomItem = [[UIBarButtonItem alloc] initWithTitle:@"3" style:UIBarButtonItemStylePlain target:self action:@selector(applyTextHighlightColorSchemeBarButtomItemDidTrigger:)];
    
    _applyTextHighlightColorSchemeBarButtomItem = [applyTextHighlightColorSchemeBarButtomItem retain];
    return [applyTextHighlightColorSchemeBarButtomItem autorelease];
}

- (UIBarButtonItem *)addAdaptiveImageGlyphBarButtonItem {
    if (auto addAdaptiveImageGlyphBarButtonItem = _addAdaptiveImageGlyphBarButtonItem) return addAdaptiveImageGlyphBarButtonItem;
    
    UIBarButtonItem *addAdaptiveImageGlyphBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"4" style:UIBarButtonItemStylePlain target:self action:@selector(addAdaptiveImageGlyphBarButtonItemDidTrigger:)];
    
    _addAdaptiveImageGlyphBarButtonItem = [addAdaptiveImageGlyphBarButtonItem retain];
    return [addAdaptiveImageGlyphBarButtonItem autorelease];
}

- (UIBarButtonItem *)addLocalizedNumberFormatBarButtonItem {
    if (auto addLocalizedNumberFormatBarButtonItem = _addLocalizedNumberFormatBarButtonItem) return addLocalizedNumberFormatBarButtonItem;
    
    UIBarButtonItem *addLocalizedNumberFormatBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"5" style:UIBarButtonItemStylePlain target:self action:@selector(addLocalizedNumberFormatBarButtonItemDidTrigger:)];
    
    _addLocalizedNumberFormatBarButtonItem = [addLocalizedNumberFormatBarButtonItem retain];
    return [addLocalizedNumberFormatBarButtonItem autorelease];
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

- (void)updateTextHighlightAttributesBarButtomItemDidTrigger:(UIBarButtonItem *)sender {
    self.textView.textHighlightAttributes = @{
        NSBackgroundColorAttributeName: UIColor.orangeColor,
        NSForegroundColorAttributeName: UIColor.greenColor
    };
}

- (void)applyTextHighlightStyleBarButtomItemDidTrigger:(UIBarButtonItem *)sender {
    NSMutableAttributedString *attributedText = [self.textView.attributedText mutableCopy];
    
    [attributedText addAttributes:@{
        NSTextHighlightStyleAttributeName: NSTextHighlightStyleDefault
    } 
                            range:NSMakeRange(0, attributedText.length)];
    
    self.textView.attributedText = attributedText;
    [attributedText release];
}

- (void)applyTextHighlightColorSchemeBarButtomItemDidTrigger:(UIBarButtonItem *)sender {
    NSMutableAttributedString *attributedText = [self.textView.attributedText mutableCopy];
    
    [attributedText addAttributes:@{
        NSTextHighlightColorSchemeAttributeName: NSTextHighlightColorSchemePink
    } 
                            range:NSMakeRange(0, attributedText.length)];
    
    self.textView.attributedText = attributedText;
    [attributedText release];
}

- (void)addAdaptiveImageGlyphBarButtonItemDidTrigger:(UIBarButtonItem *)sender {
    NSMutableAttributedString *attributedText = [self.textView.attributedText mutableCopy];
    
    /*
     po [NSAdaptiveImageGlyph contentType]
     <_UTCoreType 0x100b54b40> public.heic (not dynamic, declared)
     
     -[__NSAdaptiveImageGlyphStorage initWithImageContent:]에서 nil 나옴
     */
    NSData *imageContent = [[NSData alloc] initWithContentsOfURL:[NSBundle.mainBundle URLForResource:@"image" withExtension:@"heic"]];
    NSAdaptiveImageGlyph *adaptiveImageGlyph = [[NSAdaptiveImageGlyph alloc] initWithImageContent:imageContent];
    [imageContent release];
    assert(adaptiveImageGlyph != nil);
    
    NSAttributedString *adaptiveImageGlyphAttributedString = [NSAttributedString attributedStringWithAdaptiveImageGlyph:adaptiveImageGlyph attributes:@{}];
    
    [attributedText appendAttributedString:adaptiveImageGlyphAttributedString];
    
    [adaptiveImageGlyph release];
    
    self.textView.attributedText = attributedText;
    [attributedText release];
}

- (void)addLocalizedNumberFormatBarButtonItemDidTrigger:(UIBarButtonItem *)sender {
    NSMutableAttributedString *attributedText = [self.textView.attributedText mutableCopy];
    
    [attributedText addAttributes:@{
        NSLocalizedNumberFormatAttributeName: [NSLocalizedNumberFormatRule automatic]
    } 
                            range:NSMakeRange(0, attributedText.length)];
    
    self.textView.attributedText = attributedText;
    [attributedText release];
}

- (void)textViewWritingToolsWillBegin:(UITextView *)textView {
    NSLog(@"%s", __func__);
}

@end
