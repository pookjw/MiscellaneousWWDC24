//
//  DarknessPreferenceViewController.m
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 2/11/25.
//

#import "DarknessPreferenceViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>
#include <dlfcn.h>
#include <ranges>
#include <vector>

NSString * mui_NSStringFromMRUIDarknessPreference(NSUInteger fidelity) {
    static void *symbol;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        void *handle = dlopen("/System/Library/PrivateFrameworks/MRUIKit.framework/MRUIKit", RTLD_NOW);
        assert(handle != NULL);
        void *_symbol = dlsym(handle, "NSStringFromMRUIDarknessPreference");
        assert(_symbol != NULL);
        symbol = _symbol;
    });
    
    return reinterpret_cast<id (*)(NSUInteger)>(symbol)(fidelity);
}

/*
 Unspecified 0
 Dim 1
 Dark 2
 VeryDark 3
 */

/*
 for (NSUInteger i = 0; i < NSUIntegerMax; i++) {
     if (NSString *s = mui_NSStringFromMRUIDarknessPreference(i)) {
         NSLog(@"%@ %ld", s, i);
     }
 }
 */

/*
 ((void (*)(id, SEL, id, id))objc_msgSend)(rootViewController.view, sel_registerName("setValue:forPreferenceKey:"), @(2), objc_lookUpClass("MRUIVolumeBaseplateVisibilityPreferenceKey"));
 */

@interface DarknessPreferenceViewController ()

@end

@implementation DarknessPreferenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton new];
    
    button.menu = [self _makeMenu];
    button.showsMenuAsPrimaryAction = YES;
    button.preferredMenuElementOrder = UIContextMenuConfigurationElementOrderFixed;
    
    UIButtonConfiguration *configuration = [UIButtonConfiguration tintedButtonConfiguration];
    configuration.title = @"Darkness Preference";
    button.configuration = configuration;
    
    [self.view addSubview:button];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self.view, sel_registerName("_addBoundsMatchingConstraintsForView:"), button);
    [button release];
}

- (UIMenu *)_makeMenu {
    __weak auto weakSelf = self;
    
    UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
        NSNumber * _Nullable value = reinterpret_cast<id (*)(id, SEL, Class)>(objc_msgSend)(weakSelf, sel_registerName("aggregatedPreferenceForKey:"), objc_lookUpClass("MRUIPreferredDarknessPreferenceKey"));
        
        auto actionsVec = std::vector<NSUInteger> { 0, 1, 2, 3 }
        | std::views::transform([weakSelf, value](NSUInteger number) -> UIAction * {
            UIAction *action = [UIAction actionWithTitle:mui_NSStringFromMRUIDarknessPreference(number)
                                                   image:nil
                                              identifier:nil
                                                 handler:^(__kindof UIAction * _Nonnull action) {
                reinterpret_cast<void (*)(id, SEL, id, Class)>(objc_msgSend)(weakSelf, sel_registerName("setValue:forPreferenceKey:"), @(number), objc_lookUpClass("MRUIPreferredDarknessPreferenceKey"));
            }];
            
            if (value) {
                action.state = (value.unsignedIntegerValue == number) ? UIMenuElementStateOn : UIMenuElementStateOff;
            }
            
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
