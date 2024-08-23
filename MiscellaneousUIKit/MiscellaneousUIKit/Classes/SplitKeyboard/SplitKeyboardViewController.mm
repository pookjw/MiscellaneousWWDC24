//
//  SplitKeyboardViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 8/23/24.
//

#import "SplitKeyboardViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

// - Pro Keyboard가 켜져 있으면 작동 안함
// - UIKeyboardSupportsSplit 또는 UIKeyboardDeviceSupportsSplit이 0x1을 반황해야 가능함

UIKIT_EXTERN BOOL UIKeyboardDeviceSupportsSplit();

@implementation SplitKeyboardViewController

- (void)loadView {
    UITextView *textView = [UITextView new];
    textView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
    self.view = textView;
    [textView release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    id sharedPreferencesController = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("UIKeyboardPreferencesController"), sel_registerName("sharedPreferencesController"));
    
    BOOL enableProKeyboard = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(sharedPreferencesController, sel_registerName("enableProKeyboard"));
    
    assert(!enableProKeyboard);
    assert(UIKeyboardDeviceSupportsSplit());
    
    //
    
    UIBarButtonItem *toggleBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Toggle" style:UIBarButtonItemStylePlain target:self action:@selector(didTriggerToggleBarButtonItem:)];
    
    self.navigationItem.rightBarButtonItem = toggleBarButtonItem;
    [toggleBarButtonItem release];
    
    //
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didChangeKeyboardLayoutNotification:) name:@"UIKeyboardLayoutDidChangedNotification" object:nil];
}

- (void)didChangeKeyboardLayoutNotification:(NSNotification *)notification {
    BOOL isSplit = reinterpret_cast<BOOL (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("UIKeyboardImpl"), sel_registerName("isSplit"));
    self.navigationItem.rightBarButtonItem.title = isSplit ? @"Exit Split" : @"Enter Split";
}

- (void)didTriggerToggleBarButtonItem:(UIBarButtonItem *)sender {
    BOOL isSplit = reinterpret_cast<BOOL (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("UIKeyboardImpl"), sel_registerName("isSplit"));
    id sharedInstance = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("UIKeyboardImpl"), sel_registerName("sharedInstance"));
    reinterpret_cast<void (*)(id, SEL, BOOL, BOOL)>(objc_msgSend)(sharedInstance, sel_registerName("setSplit:animated:"), !isSplit, YES);
}

@end
