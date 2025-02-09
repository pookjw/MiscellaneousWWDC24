//
//  OrnamentViewController.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 2/8/25.
//

#import "OrnamentViewController.h"
#import "OrnamentChildViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import "MRUISize3D.h"
#import "SPGeometry.h"

OBJC_EXPORT id objc_msgSendSuper2(void); /* objc_super superInfo = { self, [self class] }; */

/*
 mrui_nonOrnamentPresentingViewController
 mrui_ornamentsItem
 _setOrnamentsDepthDisplacement:
 _ornamentsDepthDisplacement
 */

@interface OrnamentViewController ()

@end

@implementation OrnamentViewController

- (void)loadView {
    UIButton *button = [UIButton new];
    button.menu = [self _makeMenu];
    button.showsMenuAsPrimaryAction = YES;
    button.preferredMenuElementOrder = UIContextMenuConfigurationElementOrderFixed;
    
    UIButtonConfiguration *configuration = [UIButtonConfiguration tintedButtonConfiguration];
    configuration.title = @"Menu";
    button.configuration = configuration;
    
    self.view = button;
    [button release];
}

- (void)viewDidMoveToWindow:(UIWindow *)window shouldAppearOrDisappear:(BOOL)shouldAppearOrDisappear {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL, id, BOOL)>(objc_msgSendSuper2)(&superInfo, _cmd, window, shouldAppearOrDisappear);
    
    if (window) {
        [self _presentMenu];
    }
}

- (void)_presentMenu {
    UIButton *button = static_cast<UIButton *>(self.view);
    for (__kindof UIContextMenuInteraction *interaction in button.interactions) {
        if (![interaction isKindOfClass:[UIContextMenuInteraction class]]) continue;
        reinterpret_cast<void (*)(id, SEL, CGPoint)>(objc_msgSend)(interaction, sel_registerName("_presentMenuAtLocation:"), CGPointZero);
        break;
    }
}

- (UIMenu *)_makeMenu {
    // MRUIOrnamentsItem
    id mrui_ornamentsItem = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("mrui_ornamentsItem"));
    NSArray *_allOrnaments = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(mrui_ornamentsItem, sel_registerName("_allOrnaments"));
    NSMutableArray<UIAction *> *children = [NSMutableArray new];
    
    //
    
    {
        BOOL _ornamentsArePresented = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(mrui_ornamentsItem, sel_registerName("_ornamentsArePresented"));
        UIAction *action = [UIAction actionWithTitle:@"Ornaments Are Presented" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            
        }];
        
        action.attributes = UIMenuElementAttributesDisabled;
        action.state = _ornamentsArePresented ? UIMenuElementStateOn : UIMenuElementStateOff;
        
        [children addObject:action];
    }
    
    //
    
    {
        UIAction *action = [UIAction actionWithTitle:@"Add Ornament Item" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            OrnamentChildViewController *viewController = [OrnamentChildViewController new];
            
            id ornament = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("MRUIPlatterOrnament") alloc], sel_registerName("initWithViewController:"), viewController);
            [viewController release];
            
            reinterpret_cast<void (*)(id, SEL, CGSize)>(objc_msgSend)(ornament, sel_registerName("setPreferredContentSize:"), CGSizeMake(400., 400.));
            
            NSArray *_allOrnaments = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(mrui_ornamentsItem, sel_registerName("_allOrnaments"));
            reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(mrui_ornamentsItem, sel_registerName("_setAllOrnaments:"), [_allOrnaments arrayByAddingObject:ornament]);
            [ornament release];
        }];
        
        [children addObject:action];
    }
    
    //
    
    UIMenu *menu = [UIMenu menuWithChildren:children];
    [children release];
    
    return menu;
}

@end
