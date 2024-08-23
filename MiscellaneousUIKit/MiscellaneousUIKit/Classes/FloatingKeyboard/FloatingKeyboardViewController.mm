//
//  FloatingKeyboardViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 8/23/24.
//

#import "FloatingKeyboardViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

@implementation FloatingKeyboardViewController

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
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didChangeKeyboardLayoutNotification:) name:@"UIKeyboardLayoutDidChangedNotification" object:nil];
}

- (void)didChangeKeyboardLayoutNotification:(NSNotification *)notification {
    BOOL isFloating = reinterpret_cast<BOOL (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("UIKeyboardImpl"), sel_registerName("isFloating"));
    self.navigationItem.rightBarButtonItem.title = isFloating ? @"Exit Floating" : @"Enter Floating";
}

- (void)didTriggerToggleBarButtonItem:(UIBarButtonItem *)sender {
    BOOL isFloating = reinterpret_cast<BOOL (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("UIKeyboardImpl"), sel_registerName("isFloating"));
    reinterpret_cast<void (*)(Class, SEL, BOOL, id)>(objc_msgSend)(objc_lookUpClass("UIPeripheralHost"), sel_registerName("setFloating:onCompletion:"), !isFloating, ^(BOOL) {});
}

@end
