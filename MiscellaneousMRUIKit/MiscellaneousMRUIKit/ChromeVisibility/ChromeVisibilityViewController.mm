//
//  ChromeVisibilityViewController.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 2/10/25.
//

#import "ChromeVisibilityViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>
#include <dlfcn.h>
#include <ranges>
#include <vector>

NSString * mui_NSStringFromMRUIChromeVisibilityOptions(NSUInteger options) {
    static void *symbol;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        void *handle = dlopen("/System/Library/PrivateFrameworks/MRUIKit.framework/MRUIKit", RTLD_NOW);
        assert(handle != NULL);
        void *_symbol = dlsym(handle, "NSStringFromMRUIChromeVisibilityOptions");
        assert(_symbol != NULL);
        symbol = _symbol;
    });
    
    return reinterpret_cast<id (*)(NSUInteger)>(symbol)(options);
}

/*
 placement : 1 << 0
 close : 1 << 1
 share : 1 << 2
 */

OBJC_EXPORT id objc_msgSendSuper2(void); /* objc_super superInfo = { self, [self class] }; */

@interface ChromeVisibilityViewController ()

@end

@implementation ChromeVisibilityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton new];
    button.menu = [self _makeMenu];
    button.showsMenuAsPrimaryAction = YES;
    button.preferredMenuElementOrder = UIContextMenuConfigurationElementOrderFixed;
    
    UIButtonConfiguration *configuration = [UIButtonConfiguration tintedButtonConfiguration];
    configuration.title = @"Chrome Visibility";
    button.configuration = configuration;
    
    [self.view addSubview:button];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self.view, sel_registerName("_addBoundsMatchingConstraintsForView:"), button);
    [button release];
    
    self.navigationItem.title = @"Private only";
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
        NSUInteger preferredChromeVisibilityOptions = reinterpret_cast<NSUInteger (*)(id, SEL)>(objc_msgSend)(weakSelf.view.window.windowScene, sel_registerName("preferredChromeVisibilityOptions"));
        
        auto actionsVec = std::vector<NSUInteger> { 1 << 0, 1 << 1, 1 << 2 }
        | std::views::transform([weakSelf, preferredChromeVisibilityOptions](NSUInteger number) -> UIAction * {
            UIAction *action = [UIAction actionWithTitle:mui_NSStringFromMRUIChromeVisibilityOptions(number)
                                                   image:nil
                                              identifier:nil
                                                 handler:^(__kindof UIAction * _Nonnull action) {
                if (((preferredChromeVisibilityOptions & number) != 0)) {
                    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(weakSelf.view.window.windowScene, sel_registerName("setPreferredChromeVisibilityOptions:"), preferredChromeVisibilityOptions & ~number);
                } else {
                    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(weakSelf.view.window.windowScene, sel_registerName("setPreferredChromeVisibilityOptions:"), preferredChromeVisibilityOptions | number);
                }
            }];
            
            action.state = ((preferredChromeVisibilityOptions & number) != 0) ? UIMenuElementStateOn : UIMenuElementStateOff;
            return action;
        })
        | std::ranges::to<std::vector<UIAction *>>();
        
        NSArray<UIAction *> *actions = [[NSArray alloc] initWithObjects:actionsVec.data() count:actionsVec.size()];
        
        //
        
        completion(actions);
        [actions release];
    }];
    
    return [UIMenu menuWithChildren:@[element]];
}

@end
