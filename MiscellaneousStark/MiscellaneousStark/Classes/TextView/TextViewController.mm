//
//  TextViewController.mm
//  MiscellaneousStark
//
//  Created by Jinwoo Kim on 1/1/25.
//

#import "TextViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

/*
 -[UISearchController _createSystemInputViewControllerIfNeededForTraitEnvironment:]
 disableFiveRowKeyboards
 
 
 +[UISystemInputViewController _carPlay_systemInputViewControllerForResponder:editorView:containingResponder:traitCollection:]
 */

@interface TextView : UITextView
@end

@implementation TextView

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)becomeFirstResponder {
    BOOL result = [super becomeFirstResponder];
    
    if (result) {
        // TODO: 중복 확인 및 userInterfaceIdiom 변화 대응
        if (self.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiomCarPlay) {
            __kindof UIViewController *_viewControllerForAncestor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("_viewControllerForAncestor"));
            assert(_viewControllerForAncestor != nil);
            
            reinterpret_cast<void (*)(Class, SEL, NSUInteger)>(objc_msgSend)(objc_lookUpClass("UISystemInputViewController"), sel_registerName("setKeyboardInteractionModel:"), 1);
            __kindof UIViewController *systemInputViewController = reinterpret_cast<id (*)(id, SEL, id, id, id)>(objc_msgSend)(objc_lookUpClass("UISystemInputViewController"), sel_registerName("systemInputViewControllerForResponder:editorView:containingResponder:"), self, nil, _viewControllerForAncestor);
            reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(systemInputViewController, sel_registerName("setRequestedInteractionModel:"), 1);
            reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(systemInputViewController, sel_registerName("setPersistentDelegate:"), self);
            
            //
            
            // -[UISearchController _createSystemInputViewControllerIfNeededForTraitEnvironment:]
            
            UIView *contentView = _viewControllerForAncestor.view;
            __kindof UIView *keyboardView = systemInputViewController.view;
            
            [_viewControllerForAncestor addChildViewController:systemInputViewController];
            
            [contentView addSubview:keyboardView];
            keyboardView.translatesAutoresizingMaskIntoConstraints = NO;
            [NSLayoutConstraint activateConstraints:@[
                [keyboardView.leadingAnchor constraintEqualToAnchor:contentView.safeAreaLayoutGuide.leadingAnchor],
                [keyboardView.trailingAnchor constraintEqualToAnchor:contentView.safeAreaLayoutGuide.trailingAnchor],
                [keyboardView.bottomAnchor constraintEqualToAnchor:contentView.safeAreaLayoutGuide.bottomAnchor],
                [keyboardView.heightAnchor constraintEqualToConstant:[keyboardView systemLayoutSizeFittingSize:contentView.bounds.size].height]
            ]];
            
            [systemInputViewController didMoveToParentViewController:_viewControllerForAncestor];
        }
    }
    
    return result;
}

@end

@implementation TextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TextView *textView = [TextView new];
    textView.frame = self.view.bounds;
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:textView];
    [textView release];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.view becomeFirstResponder];
}

@end
