//
//  BannerViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 2/5/25.
//

#import "BannerViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void); /* objc_super superInfo = { self, [self class] }; */

@interface BannerViewController () <UIColorPickerViewControllerDelegate>
@property (retain, nonatomic, readonly, getter=_content) id content;
@end

@implementation BannerViewController
@synthesize content = _content;

+ (void *)_backgroundColorKey {
    static void *key = &key;
    return key;
}

+ (void *)_contentColorKey {
    static void *key = &key;
    return key;
}

- (void)dealloc {
    [_content release];
    [super dealloc];
}

- (void)loadView {
    UIButton *button = [UIButton new];
    
    button.showsMenuAsPrimaryAction = YES;
    button.menu = [self _makeMenu];
    button.preferredMenuElementOrder = UIContextMenuConfigurationElementOrderFixed;
    
    UIButtonConfiguration *configuration = [UIButtonConfiguration tintedButtonConfiguration];
    configuration.title = @"Banner";
    button.configuration = configuration;
    
    self.view = button;
    [button release];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self _presentMenu];
}

- (UIMenu *)_makeMenu {
    __weak auto weakSelf = self;
    
    UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
        id content = weakSelf.content;
        if (content == nil) {
            completion(@[]);
            return;
        }
        
        //
        
        NSString *title = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(content, sel_registerName("title"));
        NSString *body = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(content, sel_registerName("body"));
        UIImage *image = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(content, sel_registerName("image"));
        UIColor *backgroundColor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(content, sel_registerName("backgroundColor"));
        UIColor *contentColor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(content, sel_registerName("contentColor"));
        
        //
        
        UIAction *titleAction = [UIAction actionWithTitle:@"Title" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Title" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.text = title;
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:cancelAction];
            
            UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIAlertController *alertController = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(action, sel_registerName("_alertController"));
                reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(content, sel_registerName("setTitle:"), alertController.textFields[0].text);
                
                [weakSelf _presentMenu];
            }];
            [alertController addAction:doneAction];
            
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        }];
        titleAction.subtitle = title;
        
        //
        
        UIAction *bodyAction = [UIAction actionWithTitle:@"Body" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Body" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.text = body;
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:cancelAction];
            
            UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIAlertController *alertController = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(action, sel_registerName("_alertController"));
                reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(content, sel_registerName("setBody:"), alertController.textFields[0].text);
                
                [weakSelf _presentMenu];
            }];
            [alertController addAction:doneAction];
            
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        }];
        bodyAction.subtitle = body;
        
        //
        
        UIAction *systemImageNameAction = [UIAction actionWithTitle:@"System Image Name" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"System Image Name" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.text = body;
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:cancelAction];
            
            UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIAlertController *alertController = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(action, sel_registerName("_alertController"));
                
                NSString *text = alertController.textFields[0].text;
                if (text == nil) {
                    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(content, sel_registerName("setImage:"), nil);
                } else {
                    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(content, sel_registerName("setImage:"), [UIImage systemImageNamed:text]);
                }
                
                [weakSelf _presentMenu];
            }];
            [alertController addAction:doneAction];
            
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        }];
        systemImageNameAction.image = image;
        
        //
        
        UIImage *backgroundColorImage = [[UIImage systemImageNamed:@"circle.fill"] imageWithTintColor:backgroundColor renderingMode:UIImageRenderingModeAlwaysOriginal];
        UIAction *backgroundColorAction = [UIAction actionWithTitle:@"Background Color" image:backgroundColorImage identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            UIColorPickerViewController *viewController = [UIColorPickerViewController new];
            viewController.selectedColor = backgroundColor;
            viewController.supportsAlpha = YES;
            viewController.delegate = weakSelf;
            objc_setAssociatedObject(viewController, [BannerViewController _backgroundColorKey], [NSNull null], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [weakSelf presentViewController:viewController animated:YES completion:nil];
            [viewController release];
        }];
        
        //
        
        UIImage *contentColorImage = [[UIImage systemImageNamed:@"circle.fill"] imageWithTintColor:contentColor renderingMode:UIImageRenderingModeAlwaysOriginal];
        UIAction *contentColorAction = [UIAction actionWithTitle:@"Content Color" image:contentColorImage identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            UIColorPickerViewController *viewController = [UIColorPickerViewController new];
            viewController.selectedColor = contentColor;
            viewController.supportsAlpha = YES;
            viewController.delegate = weakSelf;
            objc_setAssociatedObject(viewController, [BannerViewController _contentColorKey], [NSNull null], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [weakSelf presentViewController:viewController animated:YES completion:nil];
            [viewController release];
        }];
        
        //
        
        UIAction *bannerAction = [UIAction actionWithTitle:@"Banner" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            id _bannerManager = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(weakSelf.view.window.windowScene, sel_registerName("_bannerManager"));
            id banner = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)(_bannerManager, sel_registerName("bannerWithContent:"), content);
            
            __weak id weakBanner = banner;
            
            reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(banner, sel_registerName("addDismissalAnimations:"), ^{
                NSLog(@"Animation Block");
            });
            
            reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(banner, sel_registerName("addTapHandler:"), ^ {
                reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(weakBanner, sel_registerName("dismiss"));
            });
            
            reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(banner, sel_registerName("present"));
        }];
        
        //
        
        completion(@[
            titleAction,
            bodyAction,
            systemImageNameAction,
            backgroundColorAction,
            contentColorAction,
            bannerAction,
        ]);
    }];
    
    return [UIMenu menuWithChildren:@[element]];
}

- (void)viewDidMoveToWindow:(UIWindow *)window shouldAppearOrDisappear:(BOOL)shouldAppearOrDisappear {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL, id, BOOL)>(objc_msgSendSuper2)(&superInfo, _cmd, window, shouldAppearOrDisappear);
    
    id _bannerManager = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(window.windowScene, sel_registerName("_bannerManager"));
    NSLog(@"%@", _bannerManager);
}

- (id)_content {
    if (id content = _content) return content;
    
    id content = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("_UIBannerContent"), sel_registerName("bannerContentWithTitle:"), @"Title");
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(content, sel_registerName("setBody:"), @"Hello World!");
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(content, sel_registerName("setImage:"), [UIImage systemImageNamed:@"apple.logo"]);
    
    _content = [content retain];
    return content;
}

- (void)_presentMenu {
    UIButton *button = static_cast<UIButton *>(self.view);
    for (__kindof UIContextMenuInteraction *interaction in button.interactions) {
        if (![interaction isKindOfClass:[UIContextMenuInteraction class]]) continue;
        reinterpret_cast<void (*)(id, SEL, CGPoint)>(objc_msgSend)(interaction, sel_registerName("_presentMenuAtLocation:"), CGPointZero);
        break;
    }
}

- (void)colorPickerViewControllerDidFinish:(UIColorPickerViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:^{
        [self _presentMenu];
    }];
}

- (void)colorPickerViewController:(UIColorPickerViewController *)viewController didSelectColor:(UIColor *)color continuously:(BOOL)continuously {
    if (objc_getAssociatedObject(viewController, [BannerViewController _backgroundColorKey])) {
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self.content, sel_registerName("setBackgroundColor:"), color);
    } else if (objc_getAssociatedObject(viewController, [BannerViewController _contentColorKey])) {
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self.content, sel_registerName("setContentColor:"), color);
    } else {
        abort();
    }
}

@end

/*
 -[UIScene _allWindows]
 -[UIScene _allWindowsIncludingInternalWindows:onlyVisibleWindows:]
 */
