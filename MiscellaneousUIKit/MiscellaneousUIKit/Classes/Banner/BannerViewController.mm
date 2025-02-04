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

@interface BannerViewController ()
@property (retain, nonatomic, readonly, getter=_content) id content;
@end

@implementation BannerViewController
@synthesize content = _content;

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
        
        UIAction *bannerAction = [UIAction actionWithTitle:@"Banner" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            id _bannerManager = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(weakSelf.view.window.windowScene, sel_registerName("_bannerManager"));
            id banner = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)(_bannerManager, sel_registerName("bannerWithContent:"), content);
            NSLog(@"%@", banner);
        }];
        
        //
        
        completion(@[
            titleAction,
            bodyAction,
            bannerAction
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

@end
