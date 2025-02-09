//
//  StageViewController.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 2/10/25.
//

#import "StageViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

#warning TODO Stage SceneSizeRestrictionsViewController UIWindowScene UIWindow

OBJC_EXPORT id objc_msgSendSuper2(void); /* objc_super superInfo = { self, [self class] }; */

@interface StageViewController ()

@end

@implementation StageViewController

- (void)loadView {
    UIButton *button = [UIButton new];
    
    button.preferredMenuElementOrder = UIContextMenuConfigurationElementOrderFixed;
    button.showsMenuAsPrimaryAction = YES;
    button.menu = [self _makeMenu];
    
    UIButtonConfiguration *configuration = [UIButtonConfiguration tintedButtonConfiguration];
    configuration.title = @"Menu";
    button.configuration = configuration;
    
    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(button, sel_registerName("sws_enablePlatter"));
    
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
    UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
        NSArray *stages = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("MRUIStage"), sel_registerName("stages"));
        NSMutableArray<UIMenu *> *menus = [[NSMutableArray alloc] initWithCapacity:stages.count];
        
        for (id stage in stages) {
            NSMutableArray<__kindof UIMenuElement *> *children = [NSMutableArray new];
            
            {
                NSMutableArray<__kindof UIMenuElement *> *elements = [NSMutableArray new];
                
                id screen = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(stage, sel_registerName("screen"));
                
                {
                    CGRect bounds = reinterpret_cast<CGRect (*)(id, SEL)>(objc_msgSend)(screen, sel_registerName("bounds"));
                    UIAction *action = [UIAction actionWithTitle:@"Bounds" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {}];
                    action.attributes = UIMenuElementAttributesDisabled;
                    action.subtitle = NSStringFromCGRect(bounds);
                    [elements addObject:action];
                }
                
                {
                    CGFloat scale = reinterpret_cast<CGFloat (*)(id, SEL)>(objc_msgSend)(screen, sel_registerName("scale"));
                    UIAction *action = [UIAction actionWithTitle:@"Scale" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {}];
                    action.attributes = UIMenuElementAttributesDisabled;
                    action.subtitle = @(scale).stringValue;
                    [elements addObject:action];
                }
                
                {
                    BOOL _isMainScreen = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(screen, sel_registerName("_isMainScreen"));
                    UIAction *action = [UIAction actionWithTitle:@"Main Screen" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {}];
                    action.attributes = UIMenuElementAttributesDisabled;
                    action.subtitle = _isMainScreen ? @"YES" : @"NO";
                    [elements addObject:action];
                }
                
                UIMenu *menu = [UIMenu menuWithTitle:@"UIScreen" children:elements];
                [elements release];
                [children addObject:menu];
            }
            
            NSString *_identifier = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(stage, sel_registerName("_identifier"));
            UIMenu *menu = [UIMenu menuWithTitle:_identifier children:children];
            [children release];
            [menus addObject:menu];
        }
        
        completion(menus);
        [menus release];
    }];
    
    UIMenu *menu = [UIMenu menuWithChildren:@[element]];
    return menu;
}

@end
