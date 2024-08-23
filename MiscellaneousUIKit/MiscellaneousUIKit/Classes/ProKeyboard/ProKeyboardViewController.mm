//
//  ProKeyboardViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 8/23/24.
//

#import "ProKeyboardViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

@implementation ProKeyboardViewController

- (void)loadView {
    UITextView *textView = [UITextView new];
    textView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
    self.view = textView;
    [textView release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *toggleBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Toggle" style:UIBarButtonItemStylePlain target:self action:@selector(didTriggerToggleBarButtonItem:)];
    
    self.navigationItem.rightBarButtonItem = toggleBarButtonItem;
    [toggleBarButtonItem release];
}

- (void)didTriggerToggleBarButtonItem:(UIBarButtonItem *)sender {
    id sharedPreferencesController = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("UIKeyboardPreferencesController"), sel_registerName("sharedPreferencesController"));
    
    BOOL enableProKeyboard = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(sharedPreferencesController, sel_registerName("enableProKeyboard"));
    
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(sharedPreferencesController, sel_registerName("setEnableProKeyboard:"), !enableProKeyboard);
}

@end
