//
//  ZoomModeViewController.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 2/11/25.
//

#import "ZoomModeViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>
#include <dlfcn.h>
#include <ranges>
#include <vector>

NSString * mui_NSStringFromMRUIZoomMode(NSUInteger mode) {
    static void *symbol;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        void *handle = dlopen("/System/Library/PrivateFrameworks/MRUIKit.framework/MRUIKit", RTLD_NOW);
        assert(handle != NULL);
        void *_symbol = dlsym(handle, "NSStringFromMRUIZoomMode");
        assert(_symbol != NULL);
        symbol = _symbol;
    });
    
    return reinterpret_cast<id (*)(NSUInteger)>(symbol)(mode);
}

/*
 Automatic 0
 Enabled 1
 Disabled 2
 */

/*
 for (NSUInteger i = 0; i < NSUIntegerMax; i++) {
     if (NSString *s = mui_NSStringFromMRUIZoomMode(i)) {
         NSLog(@"%@ %ld", s, i);
     }
 }
 */

@implementation ZoomModeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton new];
    
    button.menu = [self _makeMenu];
    button.showsMenuAsPrimaryAction = YES;
    button.preferredMenuElementOrder = UIContextMenuConfigurationElementOrderFixed;
    
    UIButtonConfiguration *configuration = [UIButtonConfiguration tintedButtonConfiguration];
    configuration.title = @"Zoom Mode";
    button.configuration = configuration;
    
    [self.view addSubview:button];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self.view, sel_registerName("_addBoundsMatchingConstraintsForView:"), button);
    [button release];
    
    self.navigationItem.title = @"???";
}

- (UIMenu *)_makeMenu {
    __weak auto weakSelf = self;
    
    UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
        id _mrui_integration = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(weakSelf.view.window.windowScene, sel_registerName("_mrui_integration"));
        
        NSUInteger preferredWindowZoomMode = reinterpret_cast<NSUInteger (*)(id, SEL)>(objc_msgSend)(_mrui_integration, sel_registerName("preferredWindowZoomMode"));
        
        auto actionsVec = std::vector<NSUInteger> { 0, 1, 2 }
        | std::views::transform([_mrui_integration, preferredWindowZoomMode](NSUInteger number) -> UIAction * {
            UIAction *action = [UIAction actionWithTitle:mui_NSStringFromMRUIZoomMode(number)
                                                   image:nil
                                              identifier:nil
                                                 handler:^(__kindof UIAction * _Nonnull action) {
                reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(_mrui_integration, sel_registerName("setPreferredWindowZoomMode:"), number);
            }];
            
            action.state = (preferredWindowZoomMode == number) ? UIMenuElementStateOn : UIMenuElementStateOff;
            
            return action;
        })
        | std::ranges::to<std::vector<UIAction *>>();
        
        NSArray<UIAction *> *actions = [[NSArray alloc] initWithObjects:actionsVec.data() count:actionsVec.size()];
        completion(actions);
        [actions release];
    }];
    
    return [UIMenu menuWithChildren:@[element]];
}

@end
