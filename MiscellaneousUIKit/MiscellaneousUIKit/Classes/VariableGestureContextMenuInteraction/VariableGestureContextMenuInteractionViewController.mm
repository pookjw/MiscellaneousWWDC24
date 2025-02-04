//
//  VariableGestureContextMenuInteractionViewController.m
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 2/5/25.
//

#import "VariableGestureContextMenuInteractionViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface VariableGestureContextMenuInteractionViewController () <UIContextMenuInteractionDelegate>

@end

@implementation VariableGestureContextMenuInteractionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view = self.view;
    view.backgroundColor = UIColor.tintColor;
    
    __kindof UIContextMenuInteraction *interaction = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("_UIVariableGestureContextMenuInteraction") alloc], sel_registerName("initWithDelegate:"), self);
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(interaction, sel_registerName("_setPresentOnTouchDown:"), YES);
    [view addInteraction:interaction];
    [interaction release];
}

- (UIContextMenuConfiguration *)contextMenuInteraction:(UIContextMenuInteraction *)interaction configurationForMenuAtLocation:(CGPoint)location {
    UIContextMenuConfiguration *configuration = [UIContextMenuConfiguration configurationWithIdentifier:nil
                                                                                        previewProvider:^UIViewController * _Nullable{
        return nil;
    }
                                                                                         actionProvider:^UIMenu * _Nullable(NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
        UIAction *action_1 = [UIAction actionWithTitle:@"Action 1" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            
        }];
        UIAction *action_2 = [UIAction actionWithTitle:@"Action 2" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            
        }];
        UIAction *action_3 = [UIAction actionWithTitle:@"Action 3" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            
        }];
        
        return [UIMenu menuWithChildren:@[action_1, action_2, action_3]];
    }];
    
    
    return configuration;
}

@end
