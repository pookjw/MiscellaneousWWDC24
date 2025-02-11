//
//  AnchoringTargetViewController.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 2/11/25.
//

#import "AnchoringTargetViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>
#include <dlfcn.h>
#include <ranges>
#include <vector>

NSString * mui_MRUIAnchoringClassificationStringValue(NSUInteger value) {
    static void *symbol;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        void *handle = dlopen("/System/Library/PrivateFrameworks/MRUIKit.framework/MRUIKit", RTLD_NOW);
        assert(handle != NULL);
        void *_symbol = dlsym(handle, "MRUIAnchoringClassificationStringValue");
        assert(_symbol != NULL);
        symbol = _symbol;
    });
    
    return reinterpret_cast<id (*)(NSUInteger)>(symbol)(value);
}

/*
 unspecified 0
 table 1
 wall 2
 hand 3
 */


NSString * mui_MRUIUserInterfacePlaneStringValue(NSUInteger value) {
    static void *symbol;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        void *handle = dlopen("/System/Library/PrivateFrameworks/MRUIKit.framework/MRUIKit", RTLD_NOW);
        assert(handle != NULL);
        void *_symbol = dlsym(handle, "MRUIUserInterfacePlaneStringValue");
        assert(_symbol != NULL);
        symbol = _symbol;
    });
    
    return reinterpret_cast<id (*)(NSUInteger)>(symbol)(value);
}

/*
 unspecified 0
 horizontal 1
 vertical 2
 */

// -[UIWindowScene snappingSurfaceClassification]
// MRUIWindowSceneDidChangeSnappingSurfaceClassificationNotification
// @"MRUITraitName_AnchoringClassification"

@interface AnchoringTargetViewController ()

@end

@implementation AnchoringTargetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton new];
    
    button.menu = [self _makeMenu];
    button.showsMenuAsPrimaryAction = YES;
    button.preferredMenuElementOrder = UIContextMenuConfigurationElementOrderFixed;
    
    UIButtonConfiguration *configuration = [UIButtonConfiguration tintedButtonConfiguration];
    configuration.title = @"Anchoring Target";
    button.configuration = configuration;
    
    [self.view addSubview:button];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self.view, sel_registerName("_addBoundsMatchingConstraintsForView:"), button);
    [button release];
    
    self.navigationItem.title = @"???";
}

- (UIMenu *)_makeMenu {
    __weak auto weakSelf = self;
    
    UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
        NSMutableArray<UIMenu *> *menus = [NSMutableArray new];
        id preferredAnchoringTarget = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(weakSelf.view.window.windowScene, sel_registerName("preferredAnchoringTarget"));
        
        {
            __kindof UIMenuElement *element = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("UICustomViewMenuElement"), sel_registerName("elementWithViewProvider:"), ^ UIView * (__kindof UIMenuElement *menuElement) {
                CGFloat distance;
                if ([preferredAnchoringTarget isKindOfClass:objc_lookUpClass("MRUIHeadAnchoringTarget")]) {
                    distance = reinterpret_cast<CGFloat (*)(id, SEL)>(objc_msgSend)(preferredAnchoringTarget, sel_registerName("distance"));
                } else {
                    distance = 0.;
                }
                
                UISlider *slider = [UISlider new];
                
                slider.minimumValue = -3.0;
                slider.maximumValue = 3.0;
                slider.value = distance;
                slider.continuous = NO;
                
                UIAction *action = [UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
                    auto slider = static_cast<__kindof UISlider *>(action.sender);
                    
                    id preferredAnchoringTarget = reinterpret_cast<id (*)(Class, SEL, CGFloat)>(objc_msgSend)(objc_lookUpClass("MRUIHeadAnchoringTarget"), sel_registerName("targetWithDistance:"), slider.value);
                    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(weakSelf.view.window.windowScene, sel_registerName("setPreferredAnchoringTarget:"), preferredAnchoringTarget);
                }];
                
                [slider addAction:action forControlEvents:UIControlEventValueChanged];
                
                return [slider autorelease];
            });
            
            UIMenu *menu = [UIMenu menuWithTitle:@"MRUIHeadAnchoringTarget"
                                           image:([preferredAnchoringTarget isKindOfClass:objc_lookUpClass("MRUIHeadAnchoringTarget")]) ? [UIImage systemImageNamed:@"checkmark"] : nil
                                      identifier:nil
                                         options:0
                                        children:@[element]];
            
            [menus addObject:menu];
        }
        
        {
            NSMutableArray<__kindof UIMenuElement *> *elements = [NSMutableArray new];
            
            {
                auto actionsVec = std::vector<NSUInteger> { 0, 1, 2 }
                | std::views::transform([weakSelf, preferredAnchoringTarget](NSUInteger value) -> UIAction * {
                    UIAction *action = [UIAction actionWithTitle:mui_MRUIAnchoringClassificationStringValue(value)
                                                           image:nil
                                                      identifier:nil
                                                         handler:^(__kindof UIAction * _Nonnull action) {
                        NSUInteger classification;
                        if ([preferredAnchoringTarget isKindOfClass:objc_lookUpClass("MRUIPlaneAnchoringTarget")]) {
                            classification = reinterpret_cast<NSUInteger (*)(id, SEL)>(objc_msgSend)(preferredAnchoringTarget, sel_registerName("classification"));
                        } else {
                            classification = 0;
                        }
                        
                        id anchoringTarget = reinterpret_cast<id (*)(Class, SEL, NSUInteger, NSUInteger)>(objc_msgSend)(objc_lookUpClass("MRUIPlaneAnchoringTarget"), sel_registerName("targetWithInterfacePlane:classification:"), value, classification);
                        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(weakSelf.view.window.windowScene, sel_registerName("setPreferredAnchoringTarget:"), anchoringTarget);
                    }];
                    
                    if ([preferredAnchoringTarget isKindOfClass:objc_lookUpClass("MRUIPlaneAnchoringTarget")]) {
                        NSUInteger plane = reinterpret_cast<NSUInteger (*)(id, SEL)>(objc_msgSend)(preferredAnchoringTarget, sel_registerName("plane"));
                        action.state = (plane == value) ? UIMenuElementStateOn : UIMenuElementStateOff;
                    }
                    
                    return action;
                })
                | std::ranges::to<std::vector<UIAction *>>();
                
                NSArray<UIAction *> *actions = [[NSArray alloc] initWithObjects:actionsVec.data() count:actionsVec.size()];
                UIMenu *menu = [UIMenu menuWithTitle:@"Anchor" children:actions];
                [actions release];
                [elements addObject:menu];
            }
            
            {
                auto actionsVec = std::vector<NSUInteger> { 0, 1, 2, 3 }
                | std::views::transform([weakSelf, preferredAnchoringTarget](NSUInteger value) -> UIAction * {
                    UIAction *action = [UIAction actionWithTitle:mui_MRUIAnchoringClassificationStringValue(value)
                                                           image:nil
                                                      identifier:nil
                                                         handler:^(__kindof UIAction * _Nonnull action) {
                        NSUInteger plane;
                        if ([preferredAnchoringTarget isKindOfClass:objc_lookUpClass("MRUIPlaneAnchoringTarget")]) {
                            plane = reinterpret_cast<NSUInteger (*)(id, SEL)>(objc_msgSend)(preferredAnchoringTarget, sel_registerName("plane"));
                        } else {
                            plane = 0;
                        }
                        
                        id anchoringTarget = reinterpret_cast<id (*)(Class, SEL, NSUInteger, NSUInteger)>(objc_msgSend)(objc_lookUpClass("MRUIPlaneAnchoringTarget"), sel_registerName("targetWithInterfacePlane:classification:"), plane, value);
                        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(weakSelf.view.window.windowScene, sel_registerName("setPreferredAnchoringTarget:"), anchoringTarget);
                    }];
                    
                    if ([preferredAnchoringTarget isKindOfClass:objc_lookUpClass("MRUIPlaneAnchoringTarget")]) {
                        NSUInteger classification = reinterpret_cast<NSUInteger (*)(id, SEL)>(objc_msgSend)(preferredAnchoringTarget, sel_registerName("classification"));
                        action.state = (classification == value) ? UIMenuElementStateOn : UIMenuElementStateOff;
                    }
                    
                    return action;
                })
                | std::ranges::to<std::vector<UIAction *>>();
                
                NSArray<UIAction *> *actions = [[NSArray alloc] initWithObjects:actionsVec.data() count:actionsVec.size()];
                UIMenu *menu = [UIMenu menuWithTitle:@"Classification" children:actions];
                [actions release];
                [elements addObject:menu];
            }
            
            UIMenu *menu = [UIMenu menuWithTitle:@"MRUIPlaneAnchoringTarget"
                                           image:([preferredAnchoringTarget isKindOfClass:objc_lookUpClass("MRUIPlaneAnchoringTarget")]) ? [UIImage systemImageNamed:@"checkmark"] : nil
                                      identifier:nil
                                         options:0
                                        children:elements];
            [elements release];
            
            [menus addObject:menu];
        }
        
        completion(menus);
    }];
    
    return [UIMenu menuWithChildren:@[element]];
}

@end
