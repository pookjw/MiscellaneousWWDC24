//
//  VisualFidelityViewController.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 2/11/25.
//

#import "VisualFidelityViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>
#include <dlfcn.h>
#include <ranges>
#include <vector>

OBJC_EXPORT id objc_msgSendSuper2(void); /* objc_super superInfo = { self, [self class] }; */

NSString * mui_NSStringFromMRUIVisualFidelity(NSUInteger fidelity) {
    static void *symbol;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        void *handle = dlopen("/System/Library/PrivateFrameworks/MRUIKit.framework/MRUIKit", RTLD_NOW);
        assert(handle != NULL);
        void *_symbol = dlsym(handle, "NSStringFromMRUIVisualFidelity");
        assert(_symbol != NULL);
        symbol = _symbol;
    });
    
    return reinterpret_cast<id (*)(NSUInteger)>(symbol)(fidelity);
}
/*
 for (NSUInteger i = 0; i < NSUIntegerMax; i++) {
     if (NSString *s = mui_NSStringFromMRUIVisualFidelity(i)) {
         NSLog(@"%@ %ld", s, i);
     }
 }
 */

/*
 Automatic 0
 Reality 1
 Media 2
 Creation 3
 Camera 4
 */

@interface VisualFidelityViewController ()

@end

@implementation VisualFidelityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton new];
    button.menu = [self _makeMenu];
    button.showsMenuAsPrimaryAction = YES;
    button.preferredMenuElementOrder = UIContextMenuConfigurationElementOrderFixed;
    
    UIButtonConfiguration *configuration = [UIButtonConfiguration tintedButtonConfiguration];
    configuration.title = @"Visual Fidelity";
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
    UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
        NSArray *stages = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("MRUIStage"), sel_registerName("stages"));
        NSMutableArray<UIMenu *> *menus = [[NSMutableArray alloc] initWithCapacity:stages.count];
        
        for (id stage in stages) {
            NSString *_identifier = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(stage, sel_registerName("_identifier"));
            NSUInteger _preferredVisualFidelity = reinterpret_cast<NSUInteger (*)(id, SEL)>(objc_msgSend)(stage, sel_registerName("_preferredVisualFidelity"));
            
            auto actionsVec = std::vector<NSUInteger> { 0, 1, 2, 3 }
            | std::views::transform([stage, _preferredVisualFidelity](NSUInteger number) -> UIAction * {
                UIAction *action = [UIAction actionWithTitle:mui_NSStringFromMRUIVisualFidelity(number)
                                                       image:nil
                                                  identifier:nil
                                                     handler:^(__kindof UIAction * _Nonnull action) {
                    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(stage, sel_registerName("_setPreferredVisualFidelity:"), number);
                }];
                
                action.state = (_preferredVisualFidelity == number) ? UIMenuElementStateOn : UIMenuElementStateOff;
                return action;
            })
            | std::ranges::to<std::vector<UIAction *>>();
            
            NSArray<UIAction *> *actions = [[NSArray alloc] initWithObjects:actionsVec.data() count:actionsVec.size()];
            UIMenu *menu = [UIMenu menuWithTitle:_identifier children:actions];
            [actions release];
            
            [menus addObject:menu];
        }
        
        //
        
        completion(menus);
        [menus release];
    }];
    
    return [UIMenu menuWithChildren:@[element]];
}

@end
