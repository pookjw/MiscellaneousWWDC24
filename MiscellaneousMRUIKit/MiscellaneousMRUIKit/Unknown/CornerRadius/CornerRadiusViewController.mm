//
//  CornerRadiusViewController.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 2/11/25.
//

#import "CornerRadiusViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void); /* objc_super superInfo = { self, [self class] }; */

@implementation CornerRadiusViewController

+ (UIDeferredMenuElement *)_elementWithTitle:(NSString *)title
            minValueResolver:(CGFloat (^)(void))minValueResolver
            maxValueResolver:(CGFloat (^)(void))maxValueResolver
               valueResolver:(CGFloat (^)(void))valueResolver
            didUpdateHandler:(void (^)(CGFloat value))didUpdateHandler {
    UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
        __kindof UIMenuElement *element = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("UICustomViewMenuElement"), sel_registerName("elementWithViewProvider:"), ^ UIView * (__kindof UIMenuElement *menuElement) {
            UISlider *slider = [UISlider new];
            
            slider.minimumValue = minValueResolver();
            slider.maximumValue = maxValueResolver();
            slider.value = valueResolver();
            slider.continuous = NO;
            
            UIAction *action = [UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
                auto slider = static_cast<__kindof UISlider *>(action.sender);
                didUpdateHandler(slider.value);
            }];
            
            [slider addAction:action forControlEvents:UIControlEventValueChanged];
            
            return [slider autorelease];
        });
        
        completion(@[element]);
    }];
    
    return element;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton new];
    button.menu = [self _makeMenu];
    button.showsMenuAsPrimaryAction = YES;
    button.preferredMenuElementOrder = UIContextMenuConfigurationElementOrderFixed;
    
    UIButtonConfiguration *configuration = [UIButtonConfiguration tintedButtonConfiguration];
    configuration.title = @"Menu";
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
    __weak auto weakSelf = self;
    
    UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
        id mrui_placement = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(weakSelf.view.window.windowScene, sel_registerName("mrui_placement"));
        NSMutableArray<__kindof UIMenuElement *> *elements = [NSMutableArray new];
        
        {
            UIDeferredMenuElement *element = [CornerRadiusViewController _elementWithTitle:@"Top Left"
                                                                          minValueResolver:^CGFloat{
                return 0.;
            }
                                                                          maxValueResolver:^CGFloat{
                return 2000.;
            }
                                                                             valueResolver:^CGFloat{
                id _Nullable preferredCornerRadiusConfiguration = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(mrui_placement, sel_registerName("preferredCornerRadiusConfiguration"));
                if (preferredCornerRadiusConfiguration == nil) {
                    return 0.;
                }
                
                CGFloat topLeft = reinterpret_cast<CGFloat (*)(id, SEL)>(objc_msgSend)(preferredCornerRadiusConfiguration, sel_registerName("topLeft"));
                return topLeft;
            }
                                                                          didUpdateHandler:^(CGFloat topLeft) {
                id _Nullable preferredCornerRadiusConfiguration = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(mrui_placement, sel_registerName("preferredCornerRadiusConfiguration"));
                
                CGFloat bottomLeft;
                if (preferredCornerRadiusConfiguration != nil) {
                    bottomLeft = reinterpret_cast<CGFloat (*)(id, SEL)>(objc_msgSend)(preferredCornerRadiusConfiguration, sel_registerName("bottomLeft"));
                } else {
                    bottomLeft = 0.;
                }
                
                CGFloat bottomRight;
                if (preferredCornerRadiusConfiguration != nil) {
                    bottomRight = reinterpret_cast<CGFloat (*)(id, SEL)>(objc_msgSend)(preferredCornerRadiusConfiguration, sel_registerName("bottomRight"));
                } else {
                    bottomRight = 0.;
                }
                
                CGFloat topRight;
                if (preferredCornerRadiusConfiguration != nil) {
                    topRight = reinterpret_cast<CGFloat (*)(id, SEL)>(objc_msgSend)(preferredCornerRadiusConfiguration, sel_registerName("topRight"));
                } else {
                    topRight = 0.;
                }
                
                id configuration = reinterpret_cast<id (*)(id, SEL, CGFloat, CGFloat, CGFloat, CGFloat)>(objc_msgSend)([objc_lookUpClass("BSCornerRadiusConfiguration") alloc], sel_registerName("initWithTopLeft:bottomLeft:bottomRight:topRight:"), topLeft, bottomLeft, bottomRight, topRight);
                reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(mrui_placement, sel_registerName("setPreferredCornerRadiusConfiguration:"), configuration);
                [configuration release];
            }];
            
            [elements addObject:element];
        }
        
        {
            UIDeferredMenuElement *element = [CornerRadiusViewController _elementWithTitle:@"Bottom Left"
                                                                          minValueResolver:^CGFloat{
                return 0.;
            }
                                                                          maxValueResolver:^CGFloat{
                return 2000.;
            }
                                                                             valueResolver:^CGFloat{
                id _Nullable preferredCornerRadiusConfiguration = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(mrui_placement, sel_registerName("preferredCornerRadiusConfiguration"));
                if (preferredCornerRadiusConfiguration == nil) {
                    return 0.;
                }
                
                CGFloat bottomLeft = reinterpret_cast<CGFloat (*)(id, SEL)>(objc_msgSend)(preferredCornerRadiusConfiguration, sel_registerName("bottomLeft"));
                return bottomLeft;
            }
                                                                          didUpdateHandler:^(CGFloat bottomLeft) {
                id _Nullable preferredCornerRadiusConfiguration = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(mrui_placement, sel_registerName("preferredCornerRadiusConfiguration"));
                
                CGFloat topLeft;
                if (preferredCornerRadiusConfiguration != nil) {
                    topLeft = reinterpret_cast<CGFloat (*)(id, SEL)>(objc_msgSend)(preferredCornerRadiusConfiguration, sel_registerName("topLeft"));
                } else {
                    topLeft = 0.;
                }
                
                CGFloat bottomRight;
                if (preferredCornerRadiusConfiguration != nil) {
                    bottomRight = reinterpret_cast<CGFloat (*)(id, SEL)>(objc_msgSend)(preferredCornerRadiusConfiguration, sel_registerName("bottomRight"));
                } else {
                    bottomRight = 0.;
                }
                
                CGFloat topRight;
                if (preferredCornerRadiusConfiguration != nil) {
                    topRight = reinterpret_cast<CGFloat (*)(id, SEL)>(objc_msgSend)(preferredCornerRadiusConfiguration, sel_registerName("topRight"));
                } else {
                    topRight = 0.;
                }
                
                id configuration = reinterpret_cast<id (*)(id, SEL, CGFloat, CGFloat, CGFloat, CGFloat)>(objc_msgSend)([objc_lookUpClass("BSCornerRadiusConfiguration") alloc], sel_registerName("initWithTopLeft:bottomLeft:bottomRight:topRight:"), topLeft, bottomLeft, bottomRight, topRight);
                reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(mrui_placement, sel_registerName("setPreferredCornerRadiusConfiguration:"), configuration);
                [configuration release];
            }];
            
            [elements addObject:element];
        }
        
        {
            UIDeferredMenuElement *element = [CornerRadiusViewController _elementWithTitle:@"Bottom Right"
                                                                          minValueResolver:^CGFloat{
                return 0.;
            }
                                                                          maxValueResolver:^CGFloat{
                return 2000.;
            }
                                                                             valueResolver:^CGFloat{
                id _Nullable preferredCornerRadiusConfiguration = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(mrui_placement, sel_registerName("preferredCornerRadiusConfiguration"));
                if (preferredCornerRadiusConfiguration == nil) {
                    return 0.;
                }
                
                CGFloat bottomRight = reinterpret_cast<CGFloat (*)(id, SEL)>(objc_msgSend)(preferredCornerRadiusConfiguration, sel_registerName("bottomRight"));
                return bottomRight;
            }
                                                                          didUpdateHandler:^(CGFloat bottomRight) {
                id _Nullable preferredCornerRadiusConfiguration = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(mrui_placement, sel_registerName("preferredCornerRadiusConfiguration"));
                
                CGFloat topLeft;
                if (preferredCornerRadiusConfiguration != nil) {
                    topLeft = reinterpret_cast<CGFloat (*)(id, SEL)>(objc_msgSend)(preferredCornerRadiusConfiguration, sel_registerName("topLeft"));
                } else {
                    topLeft = 0.;
                }
                
                CGFloat bottomLeft;
                if (preferredCornerRadiusConfiguration != nil) {
                    bottomLeft = reinterpret_cast<CGFloat (*)(id, SEL)>(objc_msgSend)(preferredCornerRadiusConfiguration, sel_registerName("bottomLeft"));
                } else {
                    bottomLeft = 0.;
                }
                
                CGFloat topRight;
                if (preferredCornerRadiusConfiguration != nil) {
                    topRight = reinterpret_cast<CGFloat (*)(id, SEL)>(objc_msgSend)(preferredCornerRadiusConfiguration, sel_registerName("topRight"));
                } else {
                    topRight = 0.;
                }
                
                id configuration = reinterpret_cast<id (*)(id, SEL, CGFloat, CGFloat, CGFloat, CGFloat)>(objc_msgSend)([objc_lookUpClass("BSCornerRadiusConfiguration") alloc], sel_registerName("initWithTopLeft:bottomLeft:bottomRight:topRight:"), topLeft, bottomLeft, bottomRight, topRight);
                reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(mrui_placement, sel_registerName("setPreferredCornerRadiusConfiguration:"), configuration);
                [configuration release];
            }];
            
            [elements addObject:element];
        }
        
        {
            UIDeferredMenuElement *element = [CornerRadiusViewController _elementWithTitle:@"Top Right"
                                                                          minValueResolver:^CGFloat{
                return 0.;
            }
                                                                          maxValueResolver:^CGFloat{
                return 2000.;
            }
                                                                             valueResolver:^CGFloat{
                id _Nullable preferredCornerRadiusConfiguration = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(mrui_placement, sel_registerName("preferredCornerRadiusConfiguration"));
                if (preferredCornerRadiusConfiguration == nil) {
                    return 0.;
                }
                
                CGFloat topRight = reinterpret_cast<CGFloat (*)(id, SEL)>(objc_msgSend)(preferredCornerRadiusConfiguration, sel_registerName("topRight"));
                return topRight;
            }
                                                                          didUpdateHandler:^(CGFloat topRight) {
                id _Nullable preferredCornerRadiusConfiguration = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(mrui_placement, sel_registerName("preferredCornerRadiusConfiguration"));
                
                CGFloat topLeft;
                if (preferredCornerRadiusConfiguration != nil) {
                    topLeft = reinterpret_cast<CGFloat (*)(id, SEL)>(objc_msgSend)(preferredCornerRadiusConfiguration, sel_registerName("topLeft"));
                } else {
                    topLeft = 0.;
                }
                
                CGFloat bottomLeft;
                if (preferredCornerRadiusConfiguration != nil) {
                    bottomLeft = reinterpret_cast<CGFloat (*)(id, SEL)>(objc_msgSend)(preferredCornerRadiusConfiguration, sel_registerName("bottomLeft"));
                } else {
                    bottomLeft = 0.;
                }
                
                CGFloat bottomRight;
                if (preferredCornerRadiusConfiguration != nil) {
                    bottomRight = reinterpret_cast<CGFloat (*)(id, SEL)>(objc_msgSend)(preferredCornerRadiusConfiguration, sel_registerName("bottomRight"));
                } else {
                    bottomRight = 0.;
                }
                
                id configuration = reinterpret_cast<id (*)(id, SEL, CGFloat, CGFloat, CGFloat, CGFloat)>(objc_msgSend)([objc_lookUpClass("BSCornerRadiusConfiguration") alloc], sel_registerName("initWithTopLeft:bottomLeft:bottomRight:topRight:"), topLeft, bottomLeft, bottomRight, topRight);
                reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(mrui_placement, sel_registerName("setPreferredCornerRadiusConfiguration:"), configuration);
                [configuration release];
            }];
            
            [elements addObject:element];
        }
        
        completion(elements);
        [elements release];
    }];
    
    return [UIMenu menuWithChildren:@[element]];
}

@end
