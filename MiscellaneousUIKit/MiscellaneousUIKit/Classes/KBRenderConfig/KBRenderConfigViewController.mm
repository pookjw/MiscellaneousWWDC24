//
//  KBRenderConfigViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 2/17/25.
//

#import "KBRenderConfigViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>
#include <ranges>
#include <vector>

namespace mui_UIKeyboardSceneDelegate {
    namespace _renderConfigForResponder_ {
        void *customRenderConfigKey = &customRenderConfigKey;
        id (*original)(id self, SEL _cmd, __kindof UIResponder *responder);
        id custom(id self, SEL _cmd, __kindof UIResponder *responder) {
            if (id config = objc_getAssociatedObject(responder, customRenderConfigKey)) {
                return config;
            }
            
            return original(self, _cmd, responder);
        }
        void swizzle() {
            Method method = class_getInstanceMethod(objc_lookUpClass("UIKeyboardSceneDelegate"), sel_registerName("_renderConfigForResponder:"));
            original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
            method_setImplementation(method, reinterpret_cast<IMP>(custom));
        }
    }
}

@interface KBRenderConfigViewController ()
@property (retain, nonatomic, readonly, getter=_imageView) UIImageView *imageView;
@property (retain, nonatomic, readonly, getter=_textView) UITextView *textView;
@property (retain, nonatomic, readonly, getter=_menuBarButtonItem) UIBarButtonItem *menuBarButtonItem;
@end

@implementation KBRenderConfigViewController
@synthesize imageView = _imageView;
@synthesize textView = _textView;
@synthesize menuBarButtonItem = _menuBarButtonItem;

+ (void)load {
    mui_UIKeyboardSceneDelegate::_renderConfigForResponder_::swizzle();
}

- (void)dealloc {
    [_imageView release];
    [_textView release];
    [_menuBarButtonItem release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view = self.view;
    
    UIImageView *imageView = self.imageView;
    [self.view addSubview:imageView];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(view, sel_registerName("_addBoundsMatchingConstraintsForView:"), imageView);
    
    UITextView *textView = self.textView;
    [self.view addSubview:textView];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(view, sel_registerName("_addBoundsMatchingConstraintsForView:"), textView);
    
    self.navigationItem.rightBarButtonItem = self.menuBarButtonItem;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
    [self _presentMenu];
}

- (UIImageView *)_imageView {
    if (auto imageView = _imageView) return imageView;
    
    NSURL *url = [NSBundle.mainBundle URLForResource:@"balloon" withExtension:UTTypePNG.preferredFilenameExtension];
    assert(url != nil);
    UIImage *image = [UIImage imageWithContentsOfFile:url.path];
    assert(image != nil);
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    _imageView = imageView;
    return imageView;
}

- (UITextView *)_textView {
    if (auto textView = _textView) return textView;
    
    UITextView *textView = [UITextView new];
    textView.backgroundColor = UIColor.clearColor;
    
    _textView = textView;
    return textView;
}

- (UIBarButtonItem *)_menuBarButtonItem {
    if (auto menuBarButtonItem = _menuBarButtonItem) return menuBarButtonItem;
    
    UIBarButtonItem *menuBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"gear"] menu:[self _makeMenu]];
    
    _menuBarButtonItem = menuBarButtonItem;
    return menuBarButtonItem;
}


- (void)_presentMenu {
    __kindof UIControl *requestsMenuBarButton = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self.menuBarButtonItem, sel_registerName("view"));
    
    for (id<UIInteraction> interaction in requestsMenuBarButton.interactions) {
        if ([interaction isKindOfClass:objc_lookUpClass("_UIClickPresentationInteraction")]) {
            UIContextMenuInteraction *contextMenuInteraction = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(interaction, sel_registerName("delegate"));
            reinterpret_cast<void (*)(id, SEL, CGPoint)>(objc_msgSend)(contextMenuInteraction, sel_registerName("_presentMenuAtLocation:"), CGPointZero);
            break;
        }
    }
}

- (UIMenu *)_makeMenu {
    UITextView *textView = self.textView;
    __block auto unretained = self;
    auto presentMenuBlock = ^ {
        auto retained = [[unretained retain] autorelease];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [retained _presentMenu];
        });
    };
    
    UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
        NSMutableArray<__kindof UIMenuElement *> *children = [NSMutableArray new];
        
        {
            auto presetActionsVector = std::vector<SEL> {
                sel_registerName("animatedConfigDark"),
                sel_registerName("animatedConfigLight"),
                sel_registerName("darkConfig"),
                sel_registerName("defaultConfig"),
                sel_registerName("defaultEmojiConfig"),
                sel_registerName("lowQualityDarkConfig")
            }
            | std::views::transform([textView, presentMenuBlock](SEL sel) -> UIAction * {
                UIAction *action = [UIAction actionWithTitle:[NSString stringWithCString:sel_getName(sel) encoding:NSUTF8StringEncoding]
                                                       image:nil
                                                  identifier:nil
                                                     handler:^(__kindof UIAction * _Nonnull action) {
                    id config = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("UIKBRenderConfig"), sel);
                    objc_setAssociatedObject(textView, mui_UIKeyboardSceneDelegate::_renderConfigForResponder_::customRenderConfigKey, config, OBJC_ASSOCIATION_COPY_NONATOMIC);
                    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(textView, sel_registerName("reloadInputViews"));
                    presentMenuBlock();
                }];
                
                return action;
            })
            | std::ranges::to<std::vector<UIAction *>>();
            
            NSArray<UIAction *> *presetActions = [[NSArray alloc] initWithObjects:presetActionsVector.data() count:presetActionsVector.size()];
            UIMenu *menu = [UIMenu menuWithTitle:@"Preset" children:presetActions];
            [presetActions release];
            
            [children addObject:menu];
        }
        
        {
            id keyboardSceneDelegate = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(textView.window.windowScene, sel_registerName("keyboardSceneDelegate"));
            id config = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)(keyboardSceneDelegate, sel_registerName("_renderConfigForResponder:"), textView);
            
            NSMutableArray<__kindof UIMenuElement *> *customElements = [NSMutableArray new];
            
            {
                BOOL lightKeyboard = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(config, sel_registerName("lightKeyboard"));
                UIAction *action = [UIAction actionWithTitle:@"Light Keyboard" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(config, sel_registerName("setLightKeyboard:"), !lightKeyboard);
                    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(textView, sel_registerName("reloadInputViews"));
                    presentMenuBlock();
                }];
                action.state = lightKeyboard ? UIMenuElementStateOn : UIMenuElementStateOff;
                [customElements addObject:action];
            }
            
            {
                NSInteger forceQuality = reinterpret_cast<NSInteger (*)(id, SEL)>(objc_msgSend)(config, sel_registerName("forceQuality"));
                
                auto forceQualityActionsVector = std::vector<NSInteger> {
                    // +[UIKBRenderConfig backdropStyleForStyle:quality:]
                    0x0, 0xa
                }
                | std::views::transform([textView, presentMenuBlock, config, forceQuality](NSInteger _forceQuality) -> UIAction * {
                    UIAction *action = [UIAction actionWithTitle:@(_forceQuality).stringValue image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                        id copy = [config copy];
                        reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(copy, sel_registerName("setForceQuality:"), _forceQuality);
                        objc_setAssociatedObject(textView, mui_UIKeyboardSceneDelegate::_renderConfigForResponder_::customRenderConfigKey, copy, OBJC_ASSOCIATION_COPY_NONATOMIC);
                        [copy release];
                        
                        reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(textView, sel_registerName("reloadInputViews"));
                        presentMenuBlock();
                    }];
                    
                    action.state = (forceQuality == _forceQuality) ? UIMenuElementStateOn : UIMenuElementStateOff;
                    return action;
                })
                | std::ranges::to<std::vector<UIAction *>>();
                
                NSArray<UIAction *> *forceQualityActions = [[NSArray alloc] initWithObjects:forceQualityActionsVector.data() count:forceQualityActionsVector.size()];
                UIMenu *menu = [UIMenu menuWithTitle:@"Force Quality" children:forceQualityActions];
                [forceQualityActions release];
                menu.subtitle = @(forceQuality).stringValue;
                
                [customElements addObject:menu];
            }
                
            {
                CGFloat blurRadius = reinterpret_cast<CGFloat (*)(id, SEL)>(objc_msgSend)(config, sel_registerName("blurRadius"));
                
                __kindof UIMenuElement *element = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("UICustomViewMenuElement"), sel_registerName("elementWithViewProvider:"), ^ UIView * (__kindof UIMenuElement *menuElement) {
                    __kindof UISlider *slider = [UISlider new];
                    
                    slider.minimumValue = 0.f;
                    slider.maximumValue = 100.f;
                    slider.value = blurRadius;
                    slider.continuous = YES;
                    
                    UIAction *action = [UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
                        auto slider = static_cast<UISlider *>(action.sender);
                        float value = slider.value;
                        
                        id copy = [config copy];
                        reinterpret_cast<void (*)(id, SEL, CGFloat)>(objc_msgSend)(copy, sel_registerName("setBlurRadius:"), value);
                        objc_setAssociatedObject(textView, mui_UIKeyboardSceneDelegate::_renderConfigForResponder_::customRenderConfigKey, copy, OBJC_ASSOCIATION_COPY_NONATOMIC);
                        [copy release];
                        
                        reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(textView, sel_registerName("reloadInputViews"));
                        presentMenuBlock();
                    }];
                    
                    [slider addAction:action forControlEvents:UIControlEventValueChanged];
                    return [slider autorelease];
                });
                
                UIMenu *menu = [UIMenu menuWithTitle:@"Blur Radius (Not Working)" children:@[element]];
                [customElements addObject:menu];
            }
            
            {
                CGFloat blurSaturation = reinterpret_cast<CGFloat (*)(id, SEL)>(objc_msgSend)(config, sel_registerName("blurSaturation"));
                
                __kindof UIMenuElement *element = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("UICustomViewMenuElement"), sel_registerName("elementWithViewProvider:"), ^ UIView * (__kindof UIMenuElement *menuElement) {
                    __kindof UISlider *slider = [UISlider new];
                    
                    slider.minimumValue = 0.f;
                    slider.maximumValue = 1.f;
                    slider.value = blurSaturation;
                    slider.continuous = YES;
                    
                    UIAction *action = [UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
                        auto slider = static_cast<UISlider *>(action.sender);
                        float value = slider.value;
                        
                        id copy = [config copy];
                        reinterpret_cast<void (*)(id, SEL, CGFloat)>(objc_msgSend)(copy, sel_registerName("setBlurSaturation:"), value);
                        objc_setAssociatedObject(textView, mui_UIKeyboardSceneDelegate::_renderConfigForResponder_::customRenderConfigKey, copy, OBJC_ASSOCIATION_COPY_NONATOMIC);
                        [copy release];
                        
                        reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(textView, sel_registerName("reloadInputViews"));
                        presentMenuBlock();
                    }];
                    
                    [slider addAction:action forControlEvents:UIControlEventValueChanged];
                    return [slider autorelease];
                });
                
                UIMenu *menu = [UIMenu menuWithTitle:@"Blur Saturation (Not Working)" children:@[element]];
                [customElements addObject:menu];
            }
            
            {
                CGFloat keycapOpacity = reinterpret_cast<CGFloat (*)(id, SEL)>(objc_msgSend)(config, sel_registerName("keycapOpacity"));
                
                __kindof UIMenuElement *element = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("UICustomViewMenuElement"), sel_registerName("elementWithViewProvider:"), ^ UIView * (__kindof UIMenuElement *menuElement) {
                    __kindof UISlider *slider = [UISlider new];
                    
                    slider.minimumValue = 0.f;
                    slider.maximumValue = 1.f;
                    slider.value = keycapOpacity;
                    slider.continuous = YES;
                    
                    UIAction *action = [UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
                        auto slider = static_cast<UISlider *>(action.sender);
                        float value = slider.value;
                        
                        id copy = [config copy];
                        reinterpret_cast<void (*)(id, SEL, CGFloat)>(objc_msgSend)(copy, sel_registerName("setKeycapOpacity:"), value);
                        objc_setAssociatedObject(textView, mui_UIKeyboardSceneDelegate::_renderConfigForResponder_::customRenderConfigKey, copy, OBJC_ASSOCIATION_COPY_NONATOMIC);
                        [copy release];
                        
                        reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(textView, sel_registerName("reloadInputViews"));
                        presentMenuBlock();
                    }];
                    
                    [slider addAction:action forControlEvents:UIControlEventValueChanged];
                    return [slider autorelease];
                });
                
                UIMenu *menu = [UIMenu menuWithTitle:@"Keycap Opacity (Not Working)" children:@[element]];
                [customElements addObject:menu];
            }
            
            {
                CGFloat lightKeycapOpacity = reinterpret_cast<CGFloat (*)(id, SEL)>(objc_msgSend)(config, sel_registerName("lightKeycapOpacity"));
                
                __kindof UIMenuElement *element = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("UICustomViewMenuElement"), sel_registerName("elementWithViewProvider:"), ^ UIView * (__kindof UIMenuElement *menuElement) {
                    __kindof UISlider *slider = [UISlider new];
                    
                    slider.minimumValue = 0.f;
                    slider.maximumValue = 1.f;
                    slider.value = lightKeycapOpacity;
                    slider.continuous = YES;
                    
                    UIAction *action = [UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
                        auto slider = static_cast<UISlider *>(action.sender);
                        float value = slider.value;
                        
                        id copy = [config copy];
                        reinterpret_cast<void (*)(id, SEL, CGFloat)>(objc_msgSend)(copy, sel_registerName("setLightKeycapOpacity:"), value);
                        objc_setAssociatedObject(textView, mui_UIKeyboardSceneDelegate::_renderConfigForResponder_::customRenderConfigKey, copy, OBJC_ASSOCIATION_COPY_NONATOMIC);
                        [copy release];
                        
                        reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(textView, sel_registerName("reloadInputViews"));
                        presentMenuBlock();
                    }];
                    
                    [slider addAction:action forControlEvents:UIControlEventValueChanged];
                    return [slider autorelease];
                });
                
                UIMenu *menu = [UIMenu menuWithTitle:@"Light Keycap Opacity (Not Working)" children:@[element]];
                [customElements addObject:menu];
            }
            
            {
                BOOL isFloating = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(config, sel_registerName("isFloating"));
                
                UIAction *action = [UIAction actionWithTitle:@"Floating (Not Working)" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    id copy = [config copy];
                    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(copy, sel_registerName("setIsFloating:"), !isFloating);
                    objc_setAssociatedObject(textView, mui_UIKeyboardSceneDelegate::_renderConfigForResponder_::customRenderConfigKey, copy, OBJC_ASSOCIATION_COPY_NONATOMIC);
                    [copy release];
                    
                    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(textView, sel_registerName("reloadInputViews"));
                    presentMenuBlock();
                }];
                
                action.state = isFloating ? UIMenuElementStateOn : UIMenuElementStateOff;
                [customElements addObject:action];
            }
            
            {
                BOOL emptyBackground = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(config, sel_registerName("emptyBackground"));
                
                UIAction *action = [UIAction actionWithTitle:@"emptyBackground (Not Working)" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    id copy = [config copy];
                    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(copy, sel_registerName("setEmptyBackground:"), !emptyBackground);
                    objc_setAssociatedObject(textView, mui_UIKeyboardSceneDelegate::_renderConfigForResponder_::customRenderConfigKey, copy, OBJC_ASSOCIATION_COPY_NONATOMIC);
                    [copy release];
                    
                    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(textView, sel_registerName("reloadInputViews"));
                    presentMenuBlock();
                }];
                
                action.state = emptyBackground ? UIMenuElementStateOn : UIMenuElementStateOff;
                [customElements addObject:action];
            }
            
            {
                BOOL animatedBackground = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(config, sel_registerName("animatedBackground"));
                
                UIAction *action = [UIAction actionWithTitle:@"Animated Background" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    id copy = [config copy];
                    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(copy, sel_registerName("setAnimatedBackground:"), !animatedBackground);
                    objc_setAssociatedObject(textView, mui_UIKeyboardSceneDelegate::_renderConfigForResponder_::customRenderConfigKey, copy, OBJC_ASSOCIATION_COPY_NONATOMIC);
                    [copy release];
                    
                    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(textView, sel_registerName("reloadInputViews"));
                    presentMenuBlock();
                }];
                
                action.state = animatedBackground ? UIMenuElementStateOn : UIMenuElementStateOff;
                [customElements addObject:action];
            }
            
            UIMenu *menu = [UIMenu menuWithTitle:@"Custom" children:customElements];
            [customElements release];
            [children addObject:menu];
        }
        
        completion(children);
        [children release];
    }];
    
    
    UIMenu *menu = [UIMenu menuWithChildren:@[element]];
    return menu;
}

@end
