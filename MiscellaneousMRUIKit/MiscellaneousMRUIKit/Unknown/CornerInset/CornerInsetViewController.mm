//
//  CornerInsetViewController.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 2/11/25.
//

#import "CornerInsetViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import "MRUIInset.h"
#include <dlfcn.h>

OBJC_EXPORT id objc_msgSendSuper2(void); /* objc_super superInfo = { self, [self class] }; */

@implementation CornerInsetViewController

+ (UIMenu *)_insetMenuWithTitle:(NSString *)title
               minValueResolver:(MRUIInset (^)(void))minValueResolver
               maxValueResolver:(MRUIInset (^)(void))maxValueResolver
                  valueResolver:(MRUIInset (^)(void))valueResolver
               didUpdateHandler:(void (^)(MRUIInset inset))didUpdateHandler {
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
                    MRUIInset inset = valueResolver();
                    inset.top = slider.value;
                    didUpdateHandler(inset);
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
                    MRUIInset inset = valueResolver();
                    inset.left = slider.value;
                    didUpdateHandler(inset);
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
                    MRUIInset inset = valueResolver();
                    inset.right = slider.value;
                    didUpdateHandler(inset);
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
                    MRUIInset inset = valueResolver();
                    inset.bottom = slider.value;
                    didUpdateHandler(inset);
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
            UIMenu *menu = [CornerInsetViewController _insetMenuWithTitle:@"Top Left"
                                                         minValueResolver:^MRUIInset{
                return MRUIInsetMake(0., 0., 0., 0.);
            }
                                                         maxValueResolver:^MRUIInset{
                return MRUIInsetMake(2000., 2000., 2000., 2000.);
            }
                                                            valueResolver:^MRUIInset{
                id _Nullable preferredCornerInsetConfiguration = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(mrui_placement, sel_registerName("preferredCornerInsetConfiguration"));
                if (preferredCornerInsetConfiguration == nil) {
                    return MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset topLeft = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("topLeft"));
                return topLeft;
            }
                                                         didUpdateHandler:^(MRUIInset topLeft) {
                id _Nullable preferredCornerInsetConfiguration = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(mrui_placement, sel_registerName("preferredCornerInsetConfiguration"));
                
                MRUIInset bottomLeft;
                if (preferredCornerInsetConfiguration != nil) {
                    bottomLeft = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("bottomLeft"));
                } else {
                    bottomLeft = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset bottomRight;
                if (preferredCornerInsetConfiguration != nil) {
                    bottomRight = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("bottomRight"));
                } else {
                    bottomRight = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset topRight;
                if (preferredCornerInsetConfiguration != nil) {
                    topRight = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("topRight"));
                } else {
                    topRight = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset relativeTopLeft;
                if (preferredCornerInsetConfiguration != nil) {
                    relativeTopLeft = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("relativeTopLeft"));
                } else {
                    relativeTopLeft = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset relativeBottomLeft;
                if (preferredCornerInsetConfiguration != nil) {
                    relativeBottomLeft = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("relativeBottomLeft"));
                } else {
                    relativeBottomLeft = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset relativeTopRight;
                if (preferredCornerInsetConfiguration != nil) {
                    relativeTopRight = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("relativeTopRight"));
                } else {
                    relativeTopRight = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset relativeBottomRight;
                if (preferredCornerInsetConfiguration != nil) {
                    relativeBottomRight = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("relativeBottomRight"));
                } else {
                    relativeBottomRight = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                id configuration = reinterpret_cast<id (*)(id, SEL, MRUIInset, MRUIInset, MRUIInset, MRUIInset, MRUIInset, MRUIInset, MRUIInset, MRUIInset)>(objc_msgSend)([objc_lookUpClass("MRUICornerInsetConfiguration") alloc], sel_registerName("initWithTopLeft:topRight:bottomLeft:bottomRight:relativeTopLeft:relativeTopRight:relativeBottomLeft:relativeBottomRight:"), topLeft, topRight, bottomLeft, bottomRight, relativeTopLeft, relativeTopRight, relativeBottomLeft, relativeBottomRight);
                reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(mrui_placement, sel_registerName("setPreferredCornerInsetConfiguration:"), configuration);
                [configuration release];
            }];
            
            [menus addObject:menu];
        }
        
        {
            UIMenu *menu = [CornerInsetViewController _insetMenuWithTitle:@"Bottom Left"
                                                         minValueResolver:^MRUIInset{
                return MRUIInsetMake(0., 0., 0., 0.);
            }
                                                         maxValueResolver:^MRUIInset{
                return MRUIInsetMake(2000., 2000., 2000., 2000.);
            }
                                                            valueResolver:^MRUIInset{
                id _Nullable preferredCornerInsetConfiguration = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(mrui_placement, sel_registerName("preferredCornerInsetConfiguration"));
                if (preferredCornerInsetConfiguration == nil) {
                    return MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset bottomLeft = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("bottomLeft"));
                return bottomLeft;
            }
                                                         didUpdateHandler:^(MRUIInset bottomLeft) {
                id _Nullable preferredCornerInsetConfiguration = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(mrui_placement, sel_registerName("preferredCornerInsetConfiguration"));
                
                MRUIInset topLeft;
                if (preferredCornerInsetConfiguration != nil) {
                    topLeft = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("topLeft"));
                } else {
                    topLeft = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset bottomRight;
                if (preferredCornerInsetConfiguration != nil) {
                    bottomRight = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("bottomRight"));
                } else {
                    bottomRight = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset topRight;
                if (preferredCornerInsetConfiguration != nil) {
                    topRight = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("topRight"));
                } else {
                    topRight = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset relativeTopLeft;
                if (preferredCornerInsetConfiguration != nil) {
                    relativeTopLeft = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("relativeTopLeft"));
                } else {
                    relativeTopLeft = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset relativeBottomLeft;
                if (preferredCornerInsetConfiguration != nil) {
                    relativeBottomLeft = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("relativeBottomLeft"));
                } else {
                    relativeBottomLeft = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset relativeTopRight;
                if (preferredCornerInsetConfiguration != nil) {
                    relativeTopRight = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("relativeTopRight"));
                } else {
                    relativeTopRight = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset relativeBottomRight;
                if (preferredCornerInsetConfiguration != nil) {
                    relativeBottomRight = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("relativeBottomRight"));
                } else {
                    relativeBottomRight = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                id configuration = reinterpret_cast<id (*)(id, SEL, MRUIInset, MRUIInset, MRUIInset, MRUIInset, MRUIInset, MRUIInset, MRUIInset, MRUIInset)>(objc_msgSend)([objc_lookUpClass("MRUICornerInsetConfiguration") alloc], sel_registerName("initWithTopLeft:topRight:bottomLeft:bottomRight:relativeTopLeft:relativeTopRight:relativeBottomLeft:relativeBottomRight:"), topLeft, topRight, bottomLeft, bottomRight, relativeTopLeft, relativeTopRight, relativeBottomLeft, relativeBottomRight);
                reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(mrui_placement, sel_registerName("setPreferredCornerInsetConfiguration:"), configuration);
                [configuration release];
            }];
            
            [menus addObject:menu];
        }
        
        {
            UIMenu *menu = [CornerInsetViewController _insetMenuWithTitle:@"Bottom Right"
                                                         minValueResolver:^MRUIInset{
                return MRUIInsetMake(0., 0., 0., 0.);
            }
                                                         maxValueResolver:^MRUIInset{
                return MRUIInsetMake(2000., 2000., 2000., 2000.);
            }
                                                            valueResolver:^MRUIInset{
                id _Nullable preferredCornerInsetConfiguration = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(mrui_placement, sel_registerName("preferredCornerInsetConfiguration"));
                if (preferredCornerInsetConfiguration == nil) {
                    return MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset bottomRight = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("bottomRight"));
                return bottomRight;
            }
                                                         didUpdateHandler:^(MRUIInset bottomRight) {
                id _Nullable preferredCornerInsetConfiguration = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(mrui_placement, sel_registerName("preferredCornerInsetConfiguration"));
                
                MRUIInset topLeft;
                if (preferredCornerInsetConfiguration != nil) {
                    topLeft = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("topLeft"));
                } else {
                    topLeft = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset bottomLeft;
                if (preferredCornerInsetConfiguration != nil) {
                    bottomLeft = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("bottomLeft"));
                } else {
                    bottomLeft = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset topRight;
                if (preferredCornerInsetConfiguration != nil) {
                    topRight = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("topRight"));
                } else {
                    topRight = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset relativeTopLeft;
                if (preferredCornerInsetConfiguration != nil) {
                    relativeTopLeft = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("relativeTopLeft"));
                } else {
                    relativeTopLeft = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset relativeBottomLeft;
                if (preferredCornerInsetConfiguration != nil) {
                    relativeBottomLeft = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("relativeBottomLeft"));
                } else {
                    relativeBottomLeft = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset relativeTopRight;
                if (preferredCornerInsetConfiguration != nil) {
                    relativeTopRight = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("relativeTopRight"));
                } else {
                    relativeTopRight = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset relativeBottomRight;
                if (preferredCornerInsetConfiguration != nil) {
                    relativeBottomRight = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("relativeBottomRight"));
                } else {
                    relativeBottomRight = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                id configuration = reinterpret_cast<id (*)(id, SEL, MRUIInset, MRUIInset, MRUIInset, MRUIInset, MRUIInset, MRUIInset, MRUIInset, MRUIInset)>(objc_msgSend)([objc_lookUpClass("MRUICornerInsetConfiguration") alloc], sel_registerName("initWithTopLeft:topRight:bottomLeft:bottomRight:relativeTopLeft:relativeTopRight:relativeBottomLeft:relativeBottomRight:"), topLeft, topRight, bottomLeft, bottomRight, relativeTopLeft, relativeTopRight, relativeBottomLeft, relativeBottomRight);
                reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(mrui_placement, sel_registerName("setPreferredCornerInsetConfiguration:"), configuration);
                [configuration release];
            }];
            
            [menus addObject:menu];
        }
        
        {
            UIMenu *menu = [CornerInsetViewController _insetMenuWithTitle:@"Top Right"
                                                         minValueResolver:^MRUIInset{
                return MRUIInsetMake(0., 0., 0., 0.);
            }
                                                         maxValueResolver:^MRUIInset{
                return MRUIInsetMake(2000., 2000., 2000., 2000.);
            }
                                                            valueResolver:^MRUIInset{
                id _Nullable preferredCornerInsetConfiguration = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(mrui_placement, sel_registerName("preferredCornerInsetConfiguration"));
                if (preferredCornerInsetConfiguration == nil) {
                    return MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset topRight = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("topRight"));
                return topRight;
            }
                                                         didUpdateHandler:^(MRUIInset topRight) {
                id _Nullable preferredCornerInsetConfiguration = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(mrui_placement, sel_registerName("preferredCornerInsetConfiguration"));
                
                MRUIInset topLeft;
                if (preferredCornerInsetConfiguration != nil) {
                    topLeft = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("topLeft"));
                } else {
                    topLeft = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset bottomLeft;
                if (preferredCornerInsetConfiguration != nil) {
                    bottomLeft = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("bottomLeft"));
                } else {
                    bottomLeft = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset bottomRight;
                if (preferredCornerInsetConfiguration != nil) {
                    bottomRight = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("bottomRight"));
                } else {
                    bottomRight = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset relativeTopLeft;
                if (preferredCornerInsetConfiguration != nil) {
                    relativeTopLeft = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("relativeTopLeft"));
                } else {
                    relativeTopLeft = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset relativeBottomLeft;
                if (preferredCornerInsetConfiguration != nil) {
                    relativeBottomLeft = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("relativeBottomLeft"));
                } else {
                    relativeBottomLeft = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset relativeTopRight;
                if (preferredCornerInsetConfiguration != nil) {
                    relativeTopRight = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("relativeTopRight"));
                } else {
                    relativeTopRight = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset relativeBottomRight;
                if (preferredCornerInsetConfiguration != nil) {
                    relativeBottomRight = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("relativeBottomRight"));
                } else {
                    relativeBottomRight = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                id configuration = reinterpret_cast<id (*)(id, SEL, MRUIInset, MRUIInset, MRUIInset, MRUIInset, MRUIInset, MRUIInset, MRUIInset, MRUIInset)>(objc_msgSend)([objc_lookUpClass("MRUICornerInsetConfiguration") alloc], sel_registerName("initWithTopLeft:topRight:bottomLeft:bottomRight:relativeTopLeft:relativeTopRight:relativeBottomLeft:relativeBottomRight:"), topLeft, topRight, bottomLeft, bottomRight, relativeTopLeft, relativeTopRight, relativeBottomLeft, relativeBottomRight);
                reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(mrui_placement, sel_registerName("setPreferredCornerInsetConfiguration:"), configuration);
                [configuration release];
            }];
            
            [menus addObject:menu];
        }
        
        {
            UIMenu *menu = [CornerInsetViewController _insetMenuWithTitle:@"Relative Top Left"
                                                         minValueResolver:^MRUIInset{
                return MRUIInsetMake(0., 0., 0., 0.);
            }
                                                         maxValueResolver:^MRUIInset{
                return MRUIInsetMake(2000., 2000., 2000., 2000.);
            }
                                                            valueResolver:^MRUIInset{
                id _Nullable preferredCornerInsetConfiguration = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(mrui_placement, sel_registerName("preferredCornerInsetConfiguration"));
                if (preferredCornerInsetConfiguration == nil) {
                    return MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset relativeTopLeft = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("relativeTopLeft"));
                return relativeTopLeft;
            }
                                                         didUpdateHandler:^(MRUIInset relativeTopLeft) {
                id _Nullable preferredCornerInsetConfiguration = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(mrui_placement, sel_registerName("preferredCornerInsetConfiguration"));
                
                MRUIInset topLeft;
                if (preferredCornerInsetConfiguration != nil) {
                    topLeft = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("topLeft"));
                } else {
                    topLeft = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset bottomLeft;
                if (preferredCornerInsetConfiguration != nil) {
                    bottomLeft = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("bottomLeft"));
                } else {
                    bottomLeft = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset bottomRight;
                if (preferredCornerInsetConfiguration != nil) {
                    bottomRight = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("bottomRight"));
                } else {
                    bottomRight = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset topRight;
                if (preferredCornerInsetConfiguration != nil) {
                    topRight = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("topRight"));
                } else {
                    topRight = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset relativeBottomLeft;
                if (preferredCornerInsetConfiguration != nil) {
                    relativeBottomLeft = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("relativeBottomLeft"));
                } else {
                    relativeBottomLeft = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset relativeTopRight;
                if (preferredCornerInsetConfiguration != nil) {
                    relativeTopRight = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("relativeTopRight"));
                } else {
                    relativeTopRight = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset relativeBottomRight;
                if (preferredCornerInsetConfiguration != nil) {
                    relativeBottomRight = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("relativeBottomRight"));
                } else {
                    relativeBottomRight = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                id configuration = reinterpret_cast<id (*)(id, SEL, MRUIInset, MRUIInset, MRUIInset, MRUIInset, MRUIInset, MRUIInset, MRUIInset, MRUIInset)>(objc_msgSend)([objc_lookUpClass("MRUICornerInsetConfiguration") alloc], sel_registerName("initWithTopLeft:topRight:bottomLeft:bottomRight:relativeTopLeft:relativeTopRight:relativeBottomLeft:relativeBottomRight:"), topLeft, topRight, bottomLeft, bottomRight, relativeTopLeft, relativeTopRight, relativeBottomLeft, relativeBottomRight);
                reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(mrui_placement, sel_registerName("setPreferredCornerInsetConfiguration:"), configuration);
                [configuration release];
            }];
            
            [menus addObject:menu];
        }
        
        {
            UIMenu *menu = [CornerInsetViewController _insetMenuWithTitle:@"Relative Bottom Left"
                                                         minValueResolver:^MRUIInset{
                return MRUIInsetMake(0., 0., 0., 0.);
            }
                                                         maxValueResolver:^MRUIInset{
                return MRUIInsetMake(2000., 2000., 2000., 2000.);
            }
                                                            valueResolver:^MRUIInset{
                id _Nullable preferredCornerInsetConfiguration = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(mrui_placement, sel_registerName("preferredCornerInsetConfiguration"));
                if (preferredCornerInsetConfiguration == nil) {
                    return MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset relativeBottomLeft = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("relativeBottomLeft"));
                return relativeBottomLeft;
            }
                                                         didUpdateHandler:^(MRUIInset relativeBottomLeft) {
                id _Nullable preferredCornerInsetConfiguration = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(mrui_placement, sel_registerName("preferredCornerInsetConfiguration"));
                
                MRUIInset topLeft;
                if (preferredCornerInsetConfiguration != nil) {
                    topLeft = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("topLeft"));
                } else {
                    topLeft = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset bottomLeft;
                if (preferredCornerInsetConfiguration != nil) {
                    bottomLeft = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("bottomLeft"));
                } else {
                    bottomLeft = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset bottomRight;
                if (preferredCornerInsetConfiguration != nil) {
                    bottomRight = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("bottomRight"));
                } else {
                    bottomRight = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset topRight;
                if (preferredCornerInsetConfiguration != nil) {
                    topRight = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("topRight"));
                } else {
                    topRight = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset relativeTopLeft;
                if (preferredCornerInsetConfiguration != nil) {
                    relativeTopLeft = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("relativeTopLeft"));
                } else {
                    relativeTopLeft = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset relativeTopRight;
                if (preferredCornerInsetConfiguration != nil) {
                    relativeTopRight = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("relativeTopRight"));
                } else {
                    relativeTopRight = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset relativeBottomRight;
                if (preferredCornerInsetConfiguration != nil) {
                    relativeBottomRight = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("relativeBottomRight"));
                } else {
                    relativeBottomRight = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                id configuration = reinterpret_cast<id (*)(id, SEL, MRUIInset, MRUIInset, MRUIInset, MRUIInset, MRUIInset, MRUIInset, MRUIInset, MRUIInset)>(objc_msgSend)([objc_lookUpClass("MRUICornerInsetConfiguration") alloc], sel_registerName("initWithTopLeft:topRight:bottomLeft:bottomRight:relativeTopLeft:relativeTopRight:relativeBottomLeft:relativeBottomRight:"), topLeft, topRight, bottomLeft, bottomRight, relativeTopLeft, relativeTopRight, relativeBottomLeft, relativeBottomRight);
                reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(mrui_placement, sel_registerName("setPreferredCornerInsetConfiguration:"), configuration);
                [configuration release];
            }];
            
            [menus addObject:menu];
        }
        
        {
            UIMenu *menu = [CornerInsetViewController _insetMenuWithTitle:@"Relative Top Right"
                                                         minValueResolver:^MRUIInset{
                return MRUIInsetMake(0., 0., 0., 0.);
            }
                                                         maxValueResolver:^MRUIInset{
                return MRUIInsetMake(2000., 2000., 2000., 2000.);
            }
                                                            valueResolver:^MRUIInset{
                id _Nullable preferredCornerInsetConfiguration = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(mrui_placement, sel_registerName("preferredCornerInsetConfiguration"));
                if (preferredCornerInsetConfiguration == nil) {
                    return MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset relativeTopRight = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("relativeTopRight"));
                return relativeTopRight;
            }
                                                         didUpdateHandler:^(MRUIInset relativeTopRight) {
                id _Nullable preferredCornerInsetConfiguration = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(mrui_placement, sel_registerName("preferredCornerInsetConfiguration"));
                
                MRUIInset topLeft;
                if (preferredCornerInsetConfiguration != nil) {
                    topLeft = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("topLeft"));
                } else {
                    topLeft = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset bottomLeft;
                if (preferredCornerInsetConfiguration != nil) {
                    bottomLeft = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("bottomLeft"));
                } else {
                    bottomLeft = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset bottomRight;
                if (preferredCornerInsetConfiguration != nil) {
                    bottomRight = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("bottomRight"));
                } else {
                    bottomRight = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset topRight;
                if (preferredCornerInsetConfiguration != nil) {
                    topRight = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("topRight"));
                } else {
                    topRight = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset relativeTopLeft;
                if (preferredCornerInsetConfiguration != nil) {
                    relativeTopLeft = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("relativeTopLeft"));
                } else {
                    relativeTopLeft = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset relativeBottomLeft;
                if (preferredCornerInsetConfiguration != nil) {
                    relativeBottomLeft = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("relativeBottomLeft"));
                } else {
                    relativeBottomLeft = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset relativeBottomRight;
                if (preferredCornerInsetConfiguration != nil) {
                    relativeBottomRight = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("relativeBottomRight"));
                } else {
                    relativeBottomRight = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                id configuration = reinterpret_cast<id (*)(id, SEL, MRUIInset, MRUIInset, MRUIInset, MRUIInset, MRUIInset, MRUIInset, MRUIInset, MRUIInset)>(objc_msgSend)([objc_lookUpClass("MRUICornerInsetConfiguration") alloc], sel_registerName("initWithTopLeft:topRight:bottomLeft:bottomRight:relativeTopLeft:relativeTopRight:relativeBottomLeft:relativeBottomRight:"), topLeft, topRight, bottomLeft, bottomRight, relativeTopLeft, relativeTopRight, relativeBottomLeft, relativeBottomRight);
                reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(mrui_placement, sel_registerName("setPreferredCornerInsetConfiguration:"), configuration);
                [configuration release];
            }];
            
            [menus addObject:menu];
        }
        
        {
            UIMenu *menu = [CornerInsetViewController _insetMenuWithTitle:@"Relative Bottom Right"
                                                         minValueResolver:^MRUIInset{
                return MRUIInsetMake(0., 0., 0., 0.);
            }
                                                         maxValueResolver:^MRUIInset{
                return MRUIInsetMake(2000., 2000., 2000., 2000.);
            }
                                                            valueResolver:^MRUIInset{
                id _Nullable preferredCornerInsetConfiguration = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(mrui_placement, sel_registerName("preferredCornerInsetConfiguration"));
                if (preferredCornerInsetConfiguration == nil) {
                    return MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset relativeBottomRight = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("relativeBottomRight"));
                return relativeBottomRight;
            }
                                                         didUpdateHandler:^(MRUIInset relativeBottomRight) {
                id _Nullable preferredCornerInsetConfiguration = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(mrui_placement, sel_registerName("preferredCornerInsetConfiguration"));
                
                MRUIInset topLeft;
                if (preferredCornerInsetConfiguration != nil) {
                    topLeft = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("topLeft"));
                } else {
                    topLeft = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset bottomLeft;
                if (preferredCornerInsetConfiguration != nil) {
                    bottomLeft = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("bottomLeft"));
                } else {
                    bottomLeft = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset bottomRight;
                if (preferredCornerInsetConfiguration != nil) {
                    bottomRight = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("bottomRight"));
                } else {
                    bottomRight = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset topRight;
                if (preferredCornerInsetConfiguration != nil) {
                    topRight = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("topRight"));
                } else {
                    topRight = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset relativeTopLeft;
                if (preferredCornerInsetConfiguration != nil) {
                    relativeTopLeft = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("relativeTopLeft"));
                } else {
                    relativeTopLeft = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset relativeBottomLeft;
                if (preferredCornerInsetConfiguration != nil) {
                    relativeBottomLeft = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("relativeBottomLeft"));
                } else {
                    relativeBottomLeft = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                MRUIInset relativeTopRight;
                if (preferredCornerInsetConfiguration != nil) {
                    relativeTopRight = reinterpret_cast<MRUIInset (*)(id, SEL)>(objc_msgSend)(preferredCornerInsetConfiguration, sel_registerName("relativeTopRight"));
                } else {
                    relativeTopRight = MRUIInsetMake(0., 0., 0., 0.);
                }
                
                id configuration = reinterpret_cast<id (*)(id, SEL, MRUIInset, MRUIInset, MRUIInset, MRUIInset, MRUIInset, MRUIInset, MRUIInset, MRUIInset)>(objc_msgSend)([objc_lookUpClass("MRUICornerInsetConfiguration") alloc], sel_registerName("initWithTopLeft:topRight:bottomLeft:bottomRight:relativeTopLeft:relativeTopRight:relativeBottomLeft:relativeBottomRight:"), topLeft, topRight, bottomLeft, bottomRight, relativeTopLeft, relativeTopRight, relativeBottomLeft, relativeBottomRight);
                reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(mrui_placement, sel_registerName("setPreferredCornerInsetConfiguration:"), configuration);
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
