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

OBJC_EXPORT id objc_msgSendSuper2(void); /* objc_super superInfo = { self, [self class] }; */

@interface SceneSizeRestrictionsConfigurationViewController ()

@end

@implementation SceneSizeRestrictionsConfigurationViewController

- (void)loadView {
    UIButton *button = [UIButton new];
    button.menu = [self _makeMenu];
    button.showsMenuAsPrimaryAction = YES;
    button.preferredMenuElementOrder = UIContextMenuConfigurationElementOrderFixed;
    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(button, sel_registerName("sws_enablePlatter"));
    
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
        enableVolumetricPresntationForWindow(window, YES);
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
    UIMenu *menu = [UIMenu menuWithChildren:@[
        [UIAction actionWithTitle:@"Title 1" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {}],
        [UIAction actionWithTitle:@"Title 2" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {}],
        [UIAction actionWithTitle:@"Title 3" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {}],
        [UIAction actionWithTitle:@"Title 4" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {}],
        [UIAction actionWithTitle:@"Title 5" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {}],
    ]];
    return menu;
}

@end
