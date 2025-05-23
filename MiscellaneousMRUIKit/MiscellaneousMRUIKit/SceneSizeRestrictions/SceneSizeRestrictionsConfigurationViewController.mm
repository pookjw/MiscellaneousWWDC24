//
//  SceneSizeRestrictionsConfigurationViewController.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 2/10/25.
//

#import "SceneSizeRestrictionsConfigurationViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import "enableVolumetricPresntationForWindow.h"
#import "MRUISize3D.h"
#import "SPGeometry.h"
#include <vector>
#include <ranges>

OBJC_EXPORT id objc_msgSendSuper2(void); /* objc_super superInfo = { self, [self class] }; */

@interface SceneSizeRestrictionsConfigurationViewController ()
@property (assign, nonatomic, getter=_capatibilites, setter=_setCapabilities:) NSUInteger capabilities;
@end

@implementation SceneSizeRestrictionsConfigurationViewController

+ (UIMenu *)_size3DMenuWithTitle:(NSString *)title
                        subtitle:(NSString * _Nullable)subtitle
            minValueSizeResolver:(MRUISize3D (^)())minValueSizeResolver
            maxValueSizeResolder:(MRUISize3D (^)())maxValueSizeResolder
                    sizeResolver:(MRUISize3D (^)(void))sizeResolver
                didUpdateHandler:(void (^)(MRUISize3D size))didUpdateHandler {
    NSMutableArray<UIMenu *> *menus = [NSMutableArray new];
    
    {
        UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
            __kindof UIMenuElement *element = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("UICustomViewMenuElement"), sel_registerName("elementWithViewProvider:"), ^ UIView * (__kindof UIMenuElement *menuElement) {
                UISlider *slider = [UISlider new];
                
                slider.minimumValue = minValueSizeResolver().width;
                slider.maximumValue = maxValueSizeResolder().width;
                slider.value = sizeResolver().width;
                slider.continuous = NO;
                
                UIAction *action = [UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
                    auto slider = static_cast<__kindof UISlider *>(action.sender);
                    
                    MRUISize3D size = sizeResolver();
                    size.width = slider.value;
                    didUpdateHandler(size);
                }];
                
                [slider addAction:action forControlEvents:UIControlEventValueChanged];
                
                return [slider autorelease];
            });
            
            completion(@[element]);
        }];
        
        UIMenu *menu = [UIMenu menuWithTitle:@"Width" children:@[element]];
        [menus addObject:menu];
    }
    
    {
        UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
            __kindof UIMenuElement *element = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("UICustomViewMenuElement"), sel_registerName("elementWithViewProvider:"), ^ UIView * (__kindof UIMenuElement *menuElement) {
                UISlider *slider = [UISlider new];
                
                slider.minimumValue = minValueSizeResolver().height;
                slider.maximumValue = maxValueSizeResolder().height;
                slider.value = sizeResolver().height;
                slider.continuous = NO;
                
                UIAction *action = [UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
                    auto slider = static_cast<__kindof UISlider *>(action.sender);
                    MRUISize3D size = sizeResolver();
                    size.height = slider.value;
                    didUpdateHandler(size);
                }];
                
                [slider addAction:action forControlEvents:UIControlEventValueChanged];
                
                return [slider autorelease];
            });
            
            completion(@[element]);
        }];
        
        UIMenu *menu = [UIMenu menuWithTitle:@"Height" children:@[element]];
        [menus addObject:menu];
    }
    
    {
        UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
            __kindof UIMenuElement *element = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("UICustomViewMenuElement"), sel_registerName("elementWithViewProvider:"), ^ UIView * (__kindof UIMenuElement *menuElement) {
                UISlider *slider = [UISlider new];
                
                slider.minimumValue = minValueSizeResolver().depth;
                slider.maximumValue = maxValueSizeResolder().depth;
                slider.value = sizeResolver().depth;
                slider.continuous = NO;
                
                UIAction *action = [UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
                    auto slider = static_cast<__kindof UISlider *>(action.sender);
                    MRUISize3D size = sizeResolver();
                    size.depth = slider.value;
                    didUpdateHandler(size);
                }];
                
                [slider addAction:action forControlEvents:UIControlEventValueChanged];
                
                return [slider autorelease];
            });
            
            completion(@[element]);
        }];
        
        UIMenu *menu = [UIMenu menuWithTitle:@"Depth" children:@[element]];
        [menus addObject:menu];
    }
    
    //
    
    UIMenu *menu = [UIMenu menuWithTitle:title children:menus];
    [menus release];
    menu.subtitle = subtitle;
    
    return menu;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton new];
    button.menu = [self _makeMenu];
    button.showsMenuAsPrimaryAction = YES;
    button.preferredMenuElementOrder = UIContextMenuConfigurationElementOrderFixed;
    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(button, sel_registerName("sws_enablePlatter"));
    
    UIButtonConfiguration *configuration = [UIButtonConfiguration tintedButtonConfiguration];
    configuration.title = @"Menu";
    button.configuration = configuration;
    
    [self.view addSubview:button];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self.view, sel_registerName("_addBoundsMatchingConstraintsForView:"), button);
    [button release];
}

- (void)viewDidMoveToWindow:(UIWindow *)window shouldAppearOrDisappear:(BOOL)shouldAppearOrDisappear {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL, id, BOOL)>(objc_msgSendSuper2)(&superInfo, _cmd, window, shouldAppearOrDisappear);
    
    if (window) {
        enableVolumetricPresntationForWindow(window, YES);
        reinterpret_cast<void (*)(id, SEL, MRUISize3D)>(objc_msgSend)(window.windowScene.sizeRestrictions, sel_registerName("setMaximumSize3D:"), MRUISize3DMake(2000., 2000., 2000.));
        reinterpret_cast<void (*)(id, SEL, MRUISize3D)>(objc_msgSend)(window.windowScene.sizeRestrictions, sel_registerName("setMinimumSize3D:"), MRUISize3DMake(300., 300., 300.));
        [self _presentMenu];
        
        
        /*
         MRUIRealityKitSimulationEventSource
         MRUIEntityObservation
         */
        id eventSource = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("MRUIRealityKitSimulationEventSource"), sel_registerName("sharedInstance"));
        void *reEntity = reinterpret_cast<void * (*)(id, SEL)>(objc_msgSend)(window.windowScene, sel_registerName("reRootEntity"));
        assert(reEntity != NULL);
        id observation = reinterpret_cast<id (*)(id, SEL, void *)>(objc_msgSend)([objc_lookUpClass("MRUIEntityObservation") alloc], sel_registerName("initWithEntity:"), reEntity);
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(observation, sel_registerName("addObserver:"), self);
        
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(eventSource, sel_registerName("addObserver:"), observation);
        [observation release];
    }
}

- (void)simulationEventSource:(id)eventSource didReceiveEntityEvent:(id)event {
    
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
        NSMutableArray<__kindof UIMenuElement *> *children = [NSMutableArray new];
        UIWindowScene * _Nullable windowScene = self.view.window.windowScene;
        __weak auto weakSelf = self;
        
        //
        
        {
            UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
                UIMenu *menu = [SceneSizeRestrictionsConfigurationViewController _size3DMenuWithTitle:@"Request Size"
                                                                                             subtitle:nil
                                                                                 minValueSizeResolver:^MRUISize3D{
                    MRUISize3D minimumSize3D = reinterpret_cast<MRUISize3D (*)(id, SEL)>(objc_msgSend)(windowScene.sizeRestrictions, sel_registerName("minimumSize3D"));
                    return minimumSize3D;
                }
                                                                                 maxValueSizeResolder:^MRUISize3D{
                    MRUISize3D maximumSize3D = reinterpret_cast<MRUISize3D (*)(id, SEL)>(objc_msgSend)(windowScene.sizeRestrictions, sel_registerName("maximumSize3D"));
                    return maximumSize3D;
                }
                                                                                         sizeResolver:^MRUISize3D{
                    id _scene = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(windowScene, sel_registerName("_scene"));
                    id settings = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(_scene, sel_registerName("settings"));
                    MRUISize3D size = reinterpret_cast<MRUISize3D (*)(id, SEL)>(objc_msgSend)(settings, sel_registerName("size"));
                    return size;
                }
                                                                                     didUpdateHandler:^(MRUISize3D size) {
                    id options = [objc_lookUpClass("MRUIWindowSceneResizeRequestOptions") new];
                    
                    // 안 됨
//                    reinterpret_cast<void (*)(id, SEL, SPPoint3D)>(objc_msgSend)(options, sel_registerName("setAnchorPosition:"), SPPoint3DMake(1., 1., 1.));
                    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(options, sel_registerName("setCapabilities:"), weakSelf.capabilities);
                    
                    reinterpret_cast<void (*)(id, SEL, MRUISize3D, id, id)>(objc_msgSend)(windowScene, sel_registerName("mrui_requestResizeTo3DSize:options:completion:"), size, options, ^(NSError * _Nullable error) {
                        assert(error == nil);
                    });
                    [options release];
                }];
                
                completion(@[menu]);
            }];
            
            [children addObject:element];
        }
        
        {
            UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
                UIMenu *menu = [SceneSizeRestrictionsConfigurationViewController _size3DMenuWithTitle:@"Maximum Size"
                                                                                             subtitle:nil
                                                                                 minValueSizeResolver:^MRUISize3D{
                    MRUISize3D minimumSize3D = reinterpret_cast<MRUISize3D (*)(id, SEL)>(objc_msgSend)(windowScene.sizeRestrictions, sel_registerName("minimumSize3D"));
                    return minimumSize3D;
                }
                                                                                 maxValueSizeResolder:^MRUISize3D{
                    return MRUISize3DMake(2000., 2000., 2000.);
                }
                                                                                         sizeResolver:^MRUISize3D{
                    MRUISize3D maximumSize3D = reinterpret_cast<MRUISize3D (*)(id, SEL)>(objc_msgSend)(windowScene.sizeRestrictions, sel_registerName("maximumSize3D"));
                    return maximumSize3D;
                }
                                                                                     didUpdateHandler:^(MRUISize3D size) {
                    reinterpret_cast<void (*)(id, SEL, MRUISize3D)>(objc_msgSend)(windowScene.sizeRestrictions, sel_registerName("setMaximumSize3D:"), size);
                }];
                
                completion(@[menu]);
            }];
            
            [children addObject:element];
        }
        
        {
            UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
                UIMenu *menu = [SceneSizeRestrictionsConfigurationViewController _size3DMenuWithTitle:@"Minimum Size"
                                                                                             subtitle:nil
                                                                                 minValueSizeResolver:^MRUISize3D{
                    return MRUISize3DMake(300., 300., 300.);
                }
                                                                                 maxValueSizeResolder:^MRUISize3D{
                    MRUISize3D maximumSize3D = reinterpret_cast<MRUISize3D (*)(id, SEL)>(objc_msgSend)(windowScene.sizeRestrictions, sel_registerName("maximumSize3D"));
                    return maximumSize3D;
                }
                                                                                         sizeResolver:^MRUISize3D{
                    MRUISize3D minimumSize3D = reinterpret_cast<MRUISize3D (*)(id, SEL)>(objc_msgSend)(windowScene.sizeRestrictions, sel_registerName("minimumSize3D"));
                    return minimumSize3D;
                }
                                                                                     didUpdateHandler:^(MRUISize3D size) {
                    reinterpret_cast<void (*)(id, SEL, MRUISize3D)>(objc_msgSend)(windowScene.sizeRestrictions, sel_registerName("setMinimumSize3D:"), size);
                }];
                
                completion(@[menu]);
            }];
            
            [children addObject:element];
        }
        
        {
            UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
                auto actionsVec = std::vector<NSUInteger> { 0, (1 << 0) }
                | std::views::transform([windowScene, weakSelf](NSUInteger value) -> UIAction * {
                    UIAction *action = [UIAction actionWithTitle:@(value).stringValue image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                        weakSelf.capabilities = value;
                    }];
                    
                    action.state = (weakSelf.capabilities == value) ? UIMenuElementStateOn : UIMenuElementStateOff;
                    
                    return action;
                })
                | std::ranges::to<std::vector<UIAction *>>();
                
                NSArray<UIAction *> *actions = [[NSArray alloc] initWithObjects:actionsVec.data() count:actionsVec.size()];
                
                UIMenu *menu = [UIMenu menuWithTitle:@"Capabilities" children:actions];
                [actions release];
                
                completion(@[menu]);
            }];
            
            [children addObject:element];
        }
        
        //
        
        completion(children);
        [children release];
    }];
    
    //
    
    UIMenu *menu = [UIMenu menuWithChildren:@[element]];
    return menu;
}

@end
