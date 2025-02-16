//
//  KBRenderConfigViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 2/16/25.
//

#import "KBRenderConfigViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface MagicTextView : UITextView
@end
@implementation MagicTextView
- (BOOL)_isDisplayingWritingToolsSessionInUCB {
    return YES;
}
- (BOOL)_wantsMagicBackgroundInUCB {
    return YES;
}
@end

@interface KBRenderConfigViewController ()

@end

@implementation KBRenderConfigViewController

- (void)loadView {
    UITextView *textView = [UITextView new];
    self.view = textView;
    [textView release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"gear"] menu:[self _makeMenu]];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    [barButtonItem release];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view becomeFirstResponder];
}

- (UIMenu *)_makeMenu {
    auto textView = static_cast<UITextView *>(self.view);
    
    UIAction *action_13 = [UIAction actionWithTitle:@"13" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        textView.keyboardAppearance = static_cast<UIKeyboardAppearance>(13);
        reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(textView, sel_registerName("reloadInputViews"));
    }];
    
    return [UIMenu menuWithChildren:@[action_13]];
}

@end
