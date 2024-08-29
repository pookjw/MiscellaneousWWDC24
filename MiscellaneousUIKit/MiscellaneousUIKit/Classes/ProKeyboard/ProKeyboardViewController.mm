//
//  ProKeyboardViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 8/23/24.
//

#import "ProKeyboardViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

UIKIT_EXTERN NSString * UIKeyboardGetCurrentInputMode();

namespace mu_UIRemoteKeyboardWindow {
    namespace isInternalWindow {
        BOOL (*original)(id, SEL);
        BOOL custom(id, SEL) {
            return NO;
        }
        void swizzle() {
            Method method = class_getInstanceMethod(objc_lookUpClass("UIRemoteKeyboardWindow"), sel_registerName("isInternalWindow"));
            original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
            method_setImplementation(method, reinterpret_cast<IMP>(custom));
        }
    }
}

@implementation ProKeyboardViewController

+ (void)load {
    mu_UIRemoteKeyboardWindow::isInternalWindow::swizzle();
}

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
    
    //
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didChangeInputModeNotification:) name:UITextInputCurrentInputModeDidChangeNotification object:nil];
}

- (void)didTriggerToggleBarButtonItem:(UIBarButtonItem *)sender {
    id sharedPreferencesController = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("UIKeyboardPreferencesController"), sel_registerName("sharedPreferencesController"));
    
    BOOL enableProKeyboard = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(sharedPreferencesController, sel_registerName("enableProKeyboard"));
    
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(sharedPreferencesController, sel_registerName("setEnableProKeyboard:"), !enableProKeyboard);
}

- (void)didChangeInputModeNotification:(NSNotification *)notification {
    NSLog(@"%@", UIKeyboardGetCurrentInputMode());
}

@end
