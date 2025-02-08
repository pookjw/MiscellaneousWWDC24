//
//  SWSViewController.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 2/7/25.
//

#import "SWSViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>
#include <algorithm>
#include <ranges>
#include <vector>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

UIKIT_EXTERN NSString * _UIStyledEffectConvertToString(UIBlurEffectStyle);

@interface SWSViewController ()
@property (class, nonatomic, readonly, getter=_effectStylesByString) NSDictionary<NSString *, NSNumber *> *effectStylesByString;
@property (class, nonatomic, readonly, getter=_sortedEffectStyles) NSArray<NSNumber *> *sortedEffectStyles;
@property (retain, nonatomic, nullable, getter=_labelContainerView, setter=_setLabelContainerView:) UIView *labelContainerView;
@property (retain, nonatomic, nullable, getter=_label, setter=_setLabel:) UILabel *label;
@property (retain, nonatomic, nullable, getter=_menuBarButtonItem, setter=_setMenuBarButtonItem:) UIBarButtonItem *menuBarButtonItem;
@end

@implementation SWSViewController

+ (NSDictionary<NSString *,NSNumber *> *)_effectStylesByString {
    return @{
        @"UIBlurEffectStyleExtraLight": @0,
        @"UIBlurEffectStyleLight": @1,
        @"UIBlurEffectStyleDark": @2,
        @"UIBlurEffectStyleExtraDark": @3,
        @"UIBlurEffectStyleRegular": @4,
        @"UIBlurEffectStyleProminent": @5,
        @"UIBlurEffectStyleSystemUltraThinMaterial": @6,
        @"UIBlurEffectStyleSystemThinMaterial": @7,
        @"UIBlurEffectStyleSystemMaterial": @8,
        @"UIBlurEffectStyleSystemThickMaterial": @9,
        @"UIBlurEffectStyleSystemChromeMaterial": @10,
        @"UIBlurEffectStyleSystemUltraThinMaterialLight": @11,
        @"UIBlurEffectStyleSystemThinMaterialLight": @12,
        @"UIBlurEffectStyleSystemMaterialLight": @13,
        @"UIBlurEffectStyleSystemThickMaterialLight": @14,
        @"UIBlurEffectStyleSystemChromeMaterialLight": @15,
        @"UIBlurEffectStyleSystemUltraThinMaterialDark": @16,
        @"UIBlurEffectStyleSystemThinMaterialDark": @17,
        @"UIBlurEffectStyleSystemMaterialDark": @18,
        @"UIBlurEffectStyleSystemThickMaterialDark": @19,
        @"UIBlurEffectStyleSystemChromeMaterialDark": @20,
        @"UIBlurEffectStyleUltraDark": @99,
        @"UIBlurEffectStyleUltraColored": @100,
        @"UIBlurEffectStyleLightKeyboard": @501,
        @"UIBlurEffectStyleLightEmojiKeyboard": @502,
        @"UIBlurEffectStyleAutomatic": @1000,
        @"UIBlurEffectStyleSystemChromeBackground": @1100,
        @"UIBlurEffectStyleSystemChromeBackgroundLight": @1101,
        @"UIBlurEffectStyleSystemChromeBackgroundDark": @1102,
        @"UIBlurEffectStyleSystemVibrantBackgroundRegular": @1200,
        @"UIBlurEffectStyleSystemVibrantBackgroundUltraThin": @1201,
        @"UIBlurEffectStyleSystemVibrantBackgroundThin": @1202,
        @"UIBlurEffectStyleSystemVibrantBackgroundThick": @1203,
        @"UIBlurEffectStyleSystemVibrantBackgroundRegularLight": @1204,
        @"UIBlurEffectStyleSystemVibrantBackgroundUltraThinLight": @1205,
        @"UIBlurEffectStyleSystemVibrantBackgroundThinLight": @1206,
        @"UIBlurEffectStyleSystemVibrantBackgroundThickLight": @1207,
        @"UIBlurEffectStyleSystemVibrantBackgroundRegularDark": @1208,
        @"UIBlurEffectStyleSystemVibrantBackgroundUltraThinDark": @1209,
        @"UIBlurEffectStyleSystemVibrantBackgroundThinDark": @1210,
        @"UIBlurEffectStyleSystemVibrantBackgroundThickDark": @1211,
        @"UIBlurEffectStyleATVSemiLight": @4000,
        @"UIBlurEffectStyleATVMediumLight": @4001,
        @"UIBlurEffectStyleATVLight": @4002,
        @"UIBlurEffectStyleATVUltraLight": @4003,
        @"UIBlurEffectStyleATVMenuLight": @4004,
        @"UIBlurEffectStyleATVSemiDark": @4005,
        @"UIBlurEffectStyleATVMediumDark": @4006,
        @"UIBlurEffectStyleATVDark": @4007,
        @"UIBlurEffectStyleATVUltraDark": @4008,
        @"UIBlurEffectStyleATVMenuDark": @4009,
        @"UIBlurEffectStyleATVAdaptive": @4010,
        @"UIBlurEffectStyleATVAdaptiveLighten": @4011,
        @"UIBlurEffectStyleATVLightTextField": @4012,
        @"UIBlurEffectStyleATVDarkTextField": @4013,
        @"UIBlurEffectStyleATVAccessoryLight": @4014,
        @"UIBlurEffectStyleATVAccessoryDark": @4015,
        @"UIBlurEffectStyleATVBlackTextField": @4016,
        @"UIBlurEffectStyleATVAutomatic": @5000,
        @"UIBlurEffectStyleATVSemiAutomatic": @5001,
        @"UIBlurEffectStyleATVMediumAutomatic": @5002,
        @"UIBlurEffectStyleATVUltraAutomatic": @5003,
        @"UIBlurEffectStyleATVMenuAutomatic": @5004,
        @"UIBlurEffectStyleATVAccessoryAutomatic": @5005,
        @"UIBlurEffectStyleATVTextFieldAutomatic": @5006,
        @"UIBlurEffectStylePinched": @6000,
        @"UIBlurEffectStyleSelected": @6001,
        @"UIBlurEffectStyleDisabled": @6002,
        @"UIBlurEffectStyleGlassLighter": @6003,
        @"UIBlurEffectStyleGlassDarker": @6004,
        @"UIBlurEffectStyleGlassUltraDarker": @6005,
        @"UIBlurEffectStyleGlass": @6006,
        @"UIBlurEffectStyleUndefined": @0x8000000000000000,
    };
}

+ (NSArray<NSNumber *> *)_sortedEffectStyles {
    static NSArray<NSNumber *> *result;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        result = [[SWSViewController.effectStylesByString.allValues sortedArrayUsingComparator:^NSComparisonResult(NSNumber * _Nonnull obj1, NSNumber * _Nonnull obj2) {
            return [obj1 compare:obj2];
        }] copy];
    });
    
    return result;
}

- (void)dealloc {
    [_labelContainerView release];
    [_label release];
    [_menuBarButtonItem release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
    
    NSURL *url = [NSBundle.mainBundle URLForResource:@"image" withExtension:UTTypeHEIC.preferredFilenameExtension];
    assert(url != nil);
    UIImage *image = [UIImage imageWithContentsOfFile:url.path];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imageView];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self.view, sel_registerName("_addBoundsMatchingConstraintsForView:"), imageView);
    [imageView release];
//    self.view.backgroundColor = UIColor.whiteColor;
    
    //
    
    UILabel *label = [UILabel new];
    label.text = @"Label";
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleExtraLargeTitle];
    
    UIView *labelContainerView = [UIView new];
    [labelContainerView addSubview:label];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(labelContainerView, sel_registerName("_addBoundsMatchingConstraintsForView:"), label);
    
    labelContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:labelContainerView];
    [NSLayoutConstraint activateConstraints:@[
        [labelContainerView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [labelContainerView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor]
    ]];
    
    self.labelContainerView = labelContainerView;
    self.label = label;
    [labelContainerView release];
    [label release];
    
    //
    
    UIBarButtonItem *menuBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"line.3.horizontal"] menu:[self _makeMenu]];
    self.navigationItem.rightBarButtonItem = menuBarButtonItem;
    self.menuBarButtonItem = menuBarButtonItem;
    [menuBarButtonItem release];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self _presentMenu];
    });
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
    UIView *labelContainerView = self.labelContainerView;
    
    UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
        NSInteger _currentSeparatedState = reinterpret_cast<NSInteger (*)(id, SEL)>(objc_msgSend)(labelContainerView, sel_registerName("_currentSeparatedState"));
        BOOL sws_platterEnabled = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(labelContainerView, sel_registerName("sws_platterEnabled"));
        
        NSMutableArray<__kindof UIMenuElement *> *children = [NSMutableArray new];
        
        //
        
        {
            UIAction *action = [UIAction actionWithTitle:@"Setup" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                reinterpret_cast<void (*)(id, SEL, NSInteger, id)>(objc_msgSend)(labelContainerView, sel_registerName("_requestSeparatedState:withReason:"), 1, @"_UIViewSeparatedStateRequestReasonUnspecified");
                labelContainerView.layer.zPosition = 600.;
                reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(labelContainerView, sel_registerName("sws_enablePlatter"));
            }];
            
            [children addObject:action];
        }
        
        //
        
        {
            NSArray<NSString *> *reasons = @[
                @"SwiftUI.AudioFeedback",
                @"_UIViewSeparatedStateRequestReasonUnspecified",
                @"SWSSeparatedStateRequestReasonPlatter",
                @"_UIViewSeparatedStateRequestReasonClipping",
                @"SwiftUI.Transform3D"
            ];
            
            NSMutableArray<UIMenu *> *reasonMenuChildren = [[NSMutableArray alloc] initWithCapacity:reasons.count];
            for (NSString *reason in reasons) {
                auto actionsVec = std::views::iota(0, 3)
                | std::views::transform([labelContainerView, _currentSeparatedState, reason](NSInteger state) -> UIAction * {
                    UIAction *action = [UIAction actionWithTitle:@(state).stringValue image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                        reinterpret_cast<void (*)(id, SEL, NSInteger, id)>(objc_msgSend)(labelContainerView, sel_registerName("_requestSeparatedState:withReason:"), state, reason);
                    }];
                    
                    action.state = (_currentSeparatedState == state) ? UIMenuElementStateOn : UIMenuElementStateOff;
                    return action;
                })
                | std::ranges::to<std::vector<UIAction *>>();
                
                NSArray<UIAction *> *actions = [[NSArray alloc] initWithObjects:actionsVec.data() count:actionsVec.size()];
                
                UIMenu *menu = [UIMenu menuWithTitle:reason children:actions];
                [actions release];
                [reasonMenuChildren addObject:menu];
            }
            
            UIMenu *menu = [UIMenu menuWithTitle:@"Request Separate State" children:reasonMenuChildren];
            menu.subtitle = @(_currentSeparatedState).stringValue;
            [children addObject:menu];
        }
        
        //
        
        {
            __kindof UIMenuElement *element = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("UICustomViewMenuElement"), sel_registerName("elementWithViewProvider:"), ^ UIView * (__kindof UIMenuElement *menuElement) {
                __kindof UISlider *slider = [objc_lookUpClass("_UIPrototypingMenuSlider") new];
                slider.minimumValue = 0.f;
                slider.maximumValue = 600.f;
                slider.value = labelContainerView.layer.zPosition;
                
                UIAction *action = [UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
                    auto slider = static_cast<__kindof UISlider *>(action.sender);
                    labelContainerView.layer.zPosition = slider.value;
                }];
                
                [slider addAction:action forControlEvents:UIControlEventValueChanged];
                
                return [slider autorelease];
            });
            
            UIMenu *menu = [UIMenu menuWithTitle:@"Z Position" children:@[element]];
            
            [children addObject:menu];
        }
        
        //
        
        if (sws_platterEnabled) {
            UIAction *action = [UIAction actionWithTitle:@"Disable Platter" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(labelContainerView, sel_registerName("sws_disablePlatter"));
            }];
            
            action.attributes = UIMenuElementAttributesDestructive;
            [children addObject:action];
        } else {
            {
                UIAction *action = [UIAction actionWithTitle:@"Enable Platter" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(labelContainerView, sel_registerName("sws_enablePlatter"));
                }];
                [children addObject:action];
            }
            
            {
                NSArray<NSNumber *> *sortedEffectStyles = SWSViewController.sortedEffectStyles;
                NSMutableArray<UIAction *> *actions = [[NSMutableArray alloc] initWithCapacity:sortedEffectStyles.count];
                for (NSNumber *styleNumber in sortedEffectStyles) {
                    UIAction *action = [UIAction actionWithTitle:_UIStyledEffectConvertToString(static_cast<UIBlurEffectStyle>(styleNumber.integerValue))
                                                           image:nil
                                                      identifier:nil
                                                         handler:^(__kindof UIAction * _Nonnull action) {
                        reinterpret_cast<void (*)(id, SEL, UIBlurEffectStyle)>(objc_msgSend)(labelContainerView, sel_registerName("sws_enablePlatter:"), static_cast<UIBlurEffectStyle>(styleNumber.integerValue));
                    }];
                    
                    [actions addObject:action];
                }
                
                UIMenu *menu = [UIMenu menuWithTitle:@"Enable Platter using Blur Effect" children:actions];
                [actions release];
                
                [children addObject:menu];
            }
        }
        
        //
        
        {
            UIAction *action = [UIAction actionWithTitle:@"Enable Default UI Shadow" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(labelContainerView, sel_registerName("sws_enableDefaultUIShadow"));
            }];
            
            [children addObject:action];
        }
        
        //
        
        {
            __kindof UIMenuElement *enableAction = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("UICustomViewMenuElement"), sel_registerName("elementWithViewProvider:"), ^ UIView * (__kindof UIMenuElement *menuElement) {
                __kindof UISlider *slider = [objc_lookUpClass("_UIPrototypingMenuSlider") new];
                slider.minimumValue = 0.f;
                slider.maximumValue = 1000.f;
                
                UIAction *action = [UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
                    auto slider = static_cast<__kindof UISlider *>(action.sender);
                    reinterpret_cast<void (*)(id, SEL, CGFloat)>(objc_msgSend)(labelContainerView, sel_registerName("sws_enableDepthwiseClippingWithDepth:"), slider.value);
                }];
                
                [slider addAction:action forControlEvents:UIControlEventValueChanged];
                
                return [slider autorelease];
            });
            
            UIMenu *enableMenu = [UIMenu menuWithTitle:@"Enable Depthwise Clipping" children:@[enableAction]];
            
            UIAction *disableAction = [UIAction actionWithTitle:@"Disable Depthwise Clipping" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(labelContainerView, sel_registerName("sws_disableDepthwiseClipping"));
            }];
            
            UIMenu *menu = [UIMenu menuWithTitle:@"Depthwise Clipping" children:@[enableMenu, disableAction]];
            [children addObject:menu];
        }
        
        //
        
        {
            UIAction *updateCornerRadius = [UIAction actionWithTitle:@"Update Corner Radius" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(labelContainerView, sel_registerName("sws_updateCornerRadius"));
            }];
            
            [children addObject:updateCornerRadius];
        }
        
        //
        
        completion(children);
        [children release];
    }];
    
    UIMenu *menu = [UIMenu menuWithChildren:@[element]];
    return menu;
}

@end
