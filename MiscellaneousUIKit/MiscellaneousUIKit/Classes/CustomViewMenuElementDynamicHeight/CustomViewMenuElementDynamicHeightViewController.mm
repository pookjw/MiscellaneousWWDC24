//
//  CustomViewMenuElementDynamicHeightViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 10/26/24.
//

#import "CustomViewMenuElementDynamicHeightViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface CVMEDH_MyView : UIView {
    CGFloat _height;
}
@end
@implementation CVMEDH_MyView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _height = 50.;
        
        UIButtonConfiguration *configuration = [UIButtonConfiguration filledButtonConfiguration];
        configuration.title = @"50.";
        
        UIButton *button = [UIButton buttonWithConfiguration:configuration primaryAction:nil];
        
        __weak auto weakSelf = self;
        [button addAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
            auto unreainted = weakSelf;
            if (unreainted == nil) return;
            
            UIButton *button = (UIButton *)action.sender;
            
            if (unreainted->_height == 50.) {
                unreainted->_height = 100.;
                UIButtonConfiguration *copy = [button.configuration copy];
                copy.title = @"100.";
                button.configuration = copy;
                [copy release];
            } else {
                unreainted->_height = 50.;
                UIButtonConfiguration *copy = [button.configuration copy];
                copy.title = @"50.";
                button.configuration = copy;
                [copy release];
            }
            
            [unreainted invalidateIntrinsicContentSize];
            
            /* _UIContextMenuView * */
            __kindof UIView *menuView = unreainted.superview.superview.superview.superview.superview.superview;
            id delegate = ((id (*)(id, SEL))objc_msgSend)(menuView, sel_registerName("delegate"));
            
            [unreainted.superview invalidateIntrinsicContentSize];
            [menuView layoutIfNeeded];
            
            [UIView animateWithDuration:0.2 animations:^{
                ((void (*)(id, SEL, BOOL, BOOL, BOOL))objc_msgSend)(delegate, sel_registerName("_updatePlatterAndActionViewLayoutForce:updateAttachment:adjustDetent:"), YES, NO, NO);
            }];
        }]
         forControlEvents:UIControlEventPrimaryActionTriggered];
        
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:button];
        [NSLayoutConstraint activateConstraints:@[
            [button.topAnchor constraintEqualToAnchor:self.topAnchor],
            [button.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [button.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
            [button.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
        ]];
    }
    
    return self;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(100., _height);
}

@end

@implementation CustomViewMenuElementDynamicHeightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButtonConfiguration *configuration = [UIButtonConfiguration filledButtonConfiguration];
    configuration.title = @"Button";
    
    __kindof UIMenuElement *myViewElement = ((id (*)(Class, SEL, id))objc_msgSend)(objc_lookUpClass("UICustomViewMenuElement"), sel_registerName("elementWithViewProvider:"), ^ UIView * (__kindof UIMenuElement *menuElement) {
        return [[CVMEDH_MyView new] autorelease];
    });
    
    UIButton *button = [UIButton buttonWithConfiguration:configuration primaryAction:nil];
    button.showsMenuAsPrimaryAction = YES;
    
    __weak auto weakSelf = self;
    
    button.menu = [UIMenu menuWithChildren:@[
        myViewElement,
        [UIAction actionWithTitle:@"Dismiss" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }]
    ]];
    
    [self.view addSubview:button];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self.view, sel_registerName("_addBoundsMatchingConstraintsForView:"), button);
    
    self.view.backgroundColor = UIColor.systemOrangeColor;
}

@end
