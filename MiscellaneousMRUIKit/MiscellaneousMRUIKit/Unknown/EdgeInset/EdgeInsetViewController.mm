//
//  EdgeInsetViewController.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 2/11/25.
//

#import "EdgeInsetViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void); /* objc_super superInfo = { self, [self class] }; */

@implementation EdgeInsetViewController

+ (UIMenu *)_edgeInsetsMenuWithTitle:(NSString *)title
                    minValueResolver:(UIEdgeInsets (^)(void))minValueResolver
                    maxValueResolver:(UIEdgeInsets (^)(void))maxValueResolver
                       valueResolver:(UIEdgeInsets (^)(void))valueResolver
                    didUpdateHandler:(void (^)(UIEdgeInsets edgeInsets))didUpdateHandler {
    NSMutableArray<UIMenu *> *menus = [NSMutableArray new];
    
    {
        UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
            __kindof UIMenuElement *element = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("UICustomViewMenuElement"), sel_registerName("elementWithViewProvider:"), ^ UIView * (__kindof UIMenuElement *menuElement) {
                UISlider *slider = [UISlider new];
                
                slider.minimumValue = minValueResolver().top;
                slider.maximumValue = maxValueResolver().top;
                slider.value = valueResolver().top;
                slider.continuous = NO;
                
                UIAction *action = [UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
                    auto slider = static_cast<__kindof UISlider *>(action.sender);
                    UIEdgeInsets edgeInsets = valueResolver();
                    edgeInsets.top = slider.value;
                    didUpdateHandler(edgeInsets);
                }];
                
                [slider addAction:action forControlEvents:UIControlEventValueChanged];
                
                return [slider autorelease];
            });
            
            completion(@[element]);
        }];
        
        UIMenu *menu = [UIMenu menuWithTitle:@"Top" children:@[element]];
        [menus addObject:menu];
    }
    
    {
        UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
            __kindof UIMenuElement *element = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("UICustomViewMenuElement"), sel_registerName("elementWithViewProvider:"), ^ UIView * (__kindof UIMenuElement *menuElement) {
                UISlider *slider = [UISlider new];
                
                slider.minimumValue = minValueResolver().left;
                slider.maximumValue = maxValueResolver().left;
                slider.value = valueResolver().left;
                slider.continuous = NO;
                
                UIAction *action = [UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
                    auto slider = static_cast<__kindof UISlider *>(action.sender);
                    UIEdgeInsets edgeInsets = valueResolver();
                    edgeInsets.left = slider.value;
                    didUpdateHandler(edgeInsets);
                }];
                
                [slider addAction:action forControlEvents:UIControlEventValueChanged];
                
                return [slider autorelease];
            });
            
            completion(@[element]);
        }];
        
        UIMenu *menu = [UIMenu menuWithTitle:@"Left" children:@[element]];
        [menus addObject:menu];
    }
    
    {
        UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
            __kindof UIMenuElement *element = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("UICustomViewMenuElement"), sel_registerName("elementWithViewProvider:"), ^ UIView * (__kindof UIMenuElement *menuElement) {
                UISlider *slider = [UISlider new];
                
                slider.minimumValue = minValueResolver().right;
                slider.maximumValue = maxValueResolver().right;
                slider.value = valueResolver().right;
                slider.continuous = NO;
                
                UIAction *action = [UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
                    auto slider = static_cast<__kindof UISlider *>(action.sender);
                    UIEdgeInsets edgeInsets = valueResolver();
                    edgeInsets.right = slider.value;
                    didUpdateHandler(edgeInsets);
                }];
                
                [slider addAction:action forControlEvents:UIControlEventValueChanged];
                
                return [slider autorelease];
            });
            
            completion(@[element]);
        }];
        
        UIMenu *menu = [UIMenu menuWithTitle:@"Right" children:@[element]];
        [menus addObject:menu];
    }
    
    {
        UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
            __kindof UIMenuElement *element = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("UICustomViewMenuElement"), sel_registerName("elementWithViewProvider:"), ^ UIView * (__kindof UIMenuElement *menuElement) {
                UISlider *slider = [UISlider new];
                
                slider.minimumValue = minValueResolver().bottom;
                slider.maximumValue = maxValueResolver().bottom;
                slider.value = valueResolver().bottom;
                slider.continuous = NO;
                
                UIAction *action = [UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
                    auto slider = static_cast<__kindof UISlider *>(action.sender);
                    UIEdgeInsets edgeInsets = valueResolver();
                    edgeInsets.bottom = slider.value;
                    didUpdateHandler(edgeInsets);
                }];
                
                [slider addAction:action forControlEvents:UIControlEventValueChanged];
                
                return [slider autorelease];
            });
            
            completion(@[element]);
        }];
        
        UIMenu *menu = [UIMenu menuWithTitle:@"Bottom" children:@[element]];
        [menus addObject:menu];
    }
    
    UIMenu *menu = [UIMenu menuWithTitle:title children:menus];
    [menus release];
    return menu;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton new];
    button.menu = [self _makeMenu];
    button.showsMenuAsPrimaryAction = YES;
    button.preferredMenuElementOrder = UIContextMenuConfigurationElementOrderFixed;
    
    UIButtonConfiguration *configuration = [UIButtonConfiguration tintedButtonConfiguration];
    configuration.title = @"Menu";
    button.configuration = configuration;
    
    [self.view addSubview:button];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self.view, sel_registerName("_addBoundsMatchingConstraintsForView:"), button);
    [button release];
    
    self.navigationItem.title = @"???";
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
    __weak auto weakSelf = self;
    
    UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
        id mrui_placement = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(weakSelf.view.window.windowScene, sel_registerName("mrui_placement"));
        NSMutableArray<UIMenu *> *menus = [NSMutableArray new];
        
        {
            UIMenu *menu = [EdgeInsetViewController _edgeInsetsMenuWithTitle:@"Edge Insets"
                                                            minValueResolver:^UIEdgeInsets{
                return UIEdgeInsetsZero;
            }
                                                            maxValueResolver:^UIEdgeInsets{
                return UIEdgeInsetsMake(2000., 2000., 2000., 2000.);
            }
                                                               valueResolver:^UIEdgeInsets{
                id _Nullable preferredEdgeInsetConfiguration = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(mrui_placement, sel_registerName("preferredEdgeInsetConfiguration"));
                if (preferredEdgeInsetConfiguration == nil) {
                    return UIEdgeInsetsZero;
                }
                
                UIEdgeInsets edgeInsets = reinterpret_cast<UIEdgeInsets (*)(id, SEL)>(objc_msgSend)(preferredEdgeInsetConfiguration, sel_registerName("edgeInsets"));
                return edgeInsets;
            }
                                                            didUpdateHandler:^(UIEdgeInsets edgeInsets) {
                UIEdgeInsets relativeEdgeInsets;
                if (id preferredEdgeInsetConfiguration = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(mrui_placement, sel_registerName("preferredEdgeInsetConfiguration"))) {
                    relativeEdgeInsets = reinterpret_cast<UIEdgeInsets (*)(id, SEL)>(objc_msgSend)(preferredEdgeInsetConfiguration, sel_registerName("relativeEdgeInsets"));
                } else {
                    relativeEdgeInsets = UIEdgeInsetsZero;
                }
                
                id configuration = reinterpret_cast<id (*)(id, SEL, UIEdgeInsets, UIEdgeInsets)>(objc_msgSend)([objc_lookUpClass("MRUIEdgeInsetConfiguration") alloc], sel_registerName("initWithEdgeInsets:relativeEdgeInsets:"), edgeInsets, relativeEdgeInsets);
                reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(mrui_placement, sel_registerName("setPreferredEdgeInsetConfiguration:"), configuration);
                [configuration release];
            }];
            
            [menus addObject:menu];
        }
        
        {
            UIMenu *menu = [EdgeInsetViewController _edgeInsetsMenuWithTitle:@"Relative Edge Insets"
                                                            minValueResolver:^UIEdgeInsets{
                return UIEdgeInsetsZero;
            }
                                                            maxValueResolver:^UIEdgeInsets{
                return UIEdgeInsetsMake(2000., 2000., 2000., 2000.);
            }
                                                               valueResolver:^UIEdgeInsets{
                id preferredEdgeInsetConfiguration = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(mrui_placement, sel_registerName("preferredEdgeInsetConfiguration"));
                UIEdgeInsets relativeEdgeInsets = reinterpret_cast<UIEdgeInsets (*)(id, SEL)>(objc_msgSend)(preferredEdgeInsetConfiguration, sel_registerName("relativeEdgeInsets"));
                return relativeEdgeInsets;
            }
                                                            didUpdateHandler:^(UIEdgeInsets relativeEdgeInsets) {
                UIEdgeInsets edgeInsets;
                if (id preferredEdgeInsetConfiguration = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(mrui_placement, sel_registerName("preferredEdgeInsetConfiguration"))) {
                    edgeInsets = reinterpret_cast<UIEdgeInsets (*)(id, SEL)>(objc_msgSend)(preferredEdgeInsetConfiguration, sel_registerName("edgeInsets"));
                } else {
                    edgeInsets = UIEdgeInsetsZero;
                }
                
                id configuration = reinterpret_cast<id (*)(id, SEL, UIEdgeInsets, UIEdgeInsets)>(objc_msgSend)([objc_lookUpClass("MRUIEdgeInsetConfiguration") alloc], sel_registerName("initWithEdgeInsets:relativeEdgeInsets:"), edgeInsets, relativeEdgeInsets);
                reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(mrui_placement, sel_registerName("setPreferredEdgeInsetConfiguration:"), configuration);
                [configuration release];
            }];
            
            [menus addObject:menu];
        }
        
        completion(menus);
        [menus release];
    }];
    
    return [UIMenu menuWithChildren:@[element]];
}

@end
