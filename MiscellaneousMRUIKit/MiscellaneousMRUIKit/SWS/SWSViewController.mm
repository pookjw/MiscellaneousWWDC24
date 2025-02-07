//
//  SWSViewController.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 2/7/25.
//

#import "SWSViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

UIKIT_EXTERN NSString * _UIStyledEffectConvertToString(uint64_t);

/*
 - (void) sws_disablePlatter; (0x23f7154d8)
 - (void) sws_enableDefaultUIShadow; (0x23f713f20)
 - (void) sws_enablePlatter; (0x23f7139b4)
 - (void) sws_disableDepthwiseClipping; (0x23f702f50)
 - (void) sws_enableDepthwiseClippingWithDepth:(double)arg1; (0x23f702e40)
 - (void) sws_enablePlatter:(long)arg1; (0x23f714ca8)
 - (BOOL) sws_platterEnabled; (0x23f714e00)
 - (void) sws_updateCornerRadius; (0x23f714ce8)
 
 -[_UIBlurEffectCoreMaterialImpl initWithStyle:]
 +[UIBlurEffect _effectWithStyle:tintColor:invertAutomaticStyle:]
 +[_UIBackdropViewSettings settingsForStyle:graphicsQuality:]
 _UIStyledEffectConvertToString
 */

@interface SWSViewController ()
@property (retain, nonatomic, nullable, getter=_label, setter=_setLabel:) UILabel *label;
@end

@implementation SWSViewController

- (void)dealloc {
    [_label release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *label = [UILabel new];
    label.text = @"Label";
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleExtraLargeTitle];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:label];
    [NSLayoutConstraint activateConstraints:@[
        [label.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [label.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor]
    ]];
    
    self.label = label;
    [label release];
    
    //
    
    UIBarButtonItem *menuBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"line.3.horizontal"] menu:[self _makeMenu]];
    self.navigationItem.rightBarButtonItem = menuBarButtonItem;
    [menuBarButtonItem release];
}

- (UIMenu *)_makeMenu {
    UILabel *label = self.label;
    
    UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
        BOOL sws_platterEnabled = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(label, sel_registerName("sws_platterEnabled"));
        
        NSMutableArray<__kindof UIMenuElement *> *children = [NSMutableArray new];
        
        UIAction *action = [UIAction actionWithTitle:@"Disable Platter" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(label, sel_registerName("sws_disablePlatter"));
        }];
        
        action.attributes = UIMenuElementAttributesDestructive;
        [children addObject:action];
        if (sws_platterEnabled) {
            UIAction *action = [UIAction actionWithTitle:@"Disable Platter" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(label, sel_registerName("sws_disablePlatter"));
            }];
            
            action.attributes = UIMenuElementAttributesDestructive;
            [children addObject:action];
        } else {
            /*
             (lldb) p/d *(uint64_t *)(0x000000018626c730 + (0 << 3))
             (uint64_t) 6
             (lldb) p/d *(uint64_t *)(0x000000018626c730 + (1 << 3))
             (uint64_t) 7
             (lldb) p/d *(uint64_t *)(0x000000018626c730 + (2 << 3))
             (uint64_t) 8
             (lldb) p/d *(uint64_t *)(0x000000018626c730 + (3 << 3))
             (uint64_t) 9
             (lldb) p/d *(uint64_t *)(0x000000018626c730 + (4 << 3))
             (uint64_t) 8
             (lldb) p/d *(uint64_t *)(0x000000018626c730 + (5 << 3))
             (uint64_t) 8
             
             UIBlurEffectStyleExtraLight: 0
             UIBlurEffectStyleLight: 1
             UIBlurEffectStyleDark: 2
             UIBlurEffectStyleExtraDark: 3
             UIBlurEffectStyleRegular: 4
             UIBlurEffectStyleProminent: 5
             UIBlurEffectStyleSystemUltraThinMaterial: 6
             UIBlurEffectStyleSystemThinMaterial: 7
             UIBlurEffectStyleSystemMaterial: 8
             UIBlurEffectStyleSystemThickMaterial: 9
             UIBlurEffectStyleSystemChromeMaterial: 10
             UIBlurEffectStyleSystemUltraThinMaterialLight: 11
             UIBlurEffectStyleSystemThinMaterialLight: 12
             UIBlurEffectStyleSystemMaterialLight: 13
             UIBlurEffectStyleSystemThickMaterialLight: 14
             UIBlurEffectStyleSystemChromeMaterialLight: 15
             UIBlurEffectStyleSystemUltraThinMaterialDark: 16
             UIBlurEffectStyleSystemThinMaterialDark: 17
             UIBlurEffectStyleSystemMaterialDark: 18
             UIBlurEffectStyleSystemThickMaterialDark: 19
             UIBlurEffectStyleSystemChromeMaterialDark: 20
             UIBlurEffectStyleUltraDark: 99
             UIBlurEffectStyleUltraColored: 100
             UIBlurEffectStyleLightKeyboard: 501
             UIBlurEffectStyleLightEmojiKeyboard: 502
             UIBlurEffectStyleAutomatic: 1000
             UIBlurEffectStyleSystemChromeBackground: 1100
             UIBlurEffectStyleSystemChromeBackgroundLight: 1101
             UIBlurEffectStyleSystemChromeBackgroundDark: 1102
             UIBlurEffectStyleSystemVibrantBackgroundRegular: 1200
             UIBlurEffectStyleSystemVibrantBackgroundUltraThin: 1201
             UIBlurEffectStyleSystemVibrantBackgroundThin: 1202
             UIBlurEffectStyleSystemVibrantBackgroundThick: 1203
             UIBlurEffectStyleSystemVibrantBackgroundRegularLight: 1204
             UIBlurEffectStyleSystemVibrantBackgroundUltraThinLight: 1205
             UIBlurEffectStyleSystemVibrantBackgroundThinLight: 1206
             UIBlurEffectStyleSystemVibrantBackgroundThickLight: 1207
             UIBlurEffectStyleSystemVibrantBackgroundRegularDark: 1208
             UIBlurEffectStyleSystemVibrantBackgroundUltraThinDark: 1209
             UIBlurEffectStyleSystemVibrantBackgroundThinDark: 1210
             UIBlurEffectStyleSystemVibrantBackgroundThickDark: 1211
             UIBlurEffectStyleATVSemiLight: 4000
             UIBlurEffectStyleATVMediumLight: 4001
             UIBlurEffectStyleATVLight: 4002
             UIBlurEffectStyleATVUltraLight: 4003
             UIBlurEffectStyleATVMenuLight: 4004
             UIBlurEffectStyleATVSemiDark: 4005
             UIBlurEffectStyleATVMediumDark: 4006
             UIBlurEffectStyleATVDark: 4007
             UIBlurEffectStyleATVUltraDark: 4008
             UIBlurEffectStyleATVMenuDark: 4009
             UIBlurEffectStyleATVAdaptive: 4010
             UIBlurEffectStyleATVAdaptiveLighten: 4011
             UIBlurEffectStyleATVLightTextField: 4012
             UIBlurEffectStyleATVDarkTextField: 4013
             UIBlurEffectStyleATVAccessoryLight: 4014
             UIBlurEffectStyleATVAccessoryDark: 4015
             UIBlurEffectStyleATVBlackTextField: 4016
             UIBlurEffectStyleATVAutomatic: 5000
             UIBlurEffectStyleATVSemiAutomatic: 5001
             UIBlurEffectStyleATVMediumAutomatic: 5002
             UIBlurEffectStyleATVUltraAutomatic: 5003
             UIBlurEffectStyleATVMenuAutomatic: 5004
             UIBlurEffectStyleATVAccessoryAutomatic: 5005
             UIBlurEffectStyleATVTextFieldAutomatic: 5006
             UIBlurEffectStylePinched: 6000
             UIBlurEffectStyleSelected: 6001
             UIBlurEffectStyleDisabled: 6002
             UIBlurEffectStyleGlassLighter: 6003
             UIBlurEffectStyleGlassDarker: 6004
             UIBlurEffectStyleGlassUltraDarker: 6005
             UIBlurEffectStyleGlass: 6006
             UIBlurEffectStyleUndefined: 0x8000000000000000
             */
            
            NSArray<NSString *> *styles = @[
                @"UIBlurEffectStyleLight", // 6
                @"UIBlurEffectStyleExtraLight", // 7
                @"UIBlurEffectStyleDark", // 8
                @"UIBlurEffectStyleExtraDark", // 9
                @"UIBlurEffectStyleRegular", // 8
                @"UIBlurEffectStyleProminent", // 8
                @"UIBlurEffectStyleSystemUltraThinMaterial",
                @"UIBlurEffectStyleSystemThinMaterial",
                @"UIBlurEffectStyleSystemMaterial",
                @"UIBlurEffectStyleSystemThickMaterial",
                @"UIBlurEffectStyleSystemChromeMaterial",
                @"UIBlurEffectStyleSystemUltraThinMaterialLight",
                @"UIBlurEffectStyleSystemThinMaterialLight",
                @"UIBlurEffectStyleSystemMaterialLight",
                @"UIBlurEffectStyleSystemThickMaterialLight",
                @"UIBlurEffectStyleSystemChromeMaterialLight",
                @"UIBlurEffectStyleSystemUltraThinMaterialDark",
                @"UIBlurEffectStyleSystemThinMaterialDark",
                @"UIBlurEffectStyleSystemMaterialDark",
                @"UIBlurEffectStyleSystemThickMaterialDark",
                @"UIBlurEffectStyleSystemChromeMaterialDark",
                @"UIBlurEffectStyleUndefined",
                @"UIBlurEffectStyleUltraDark",
                @"UIBlurEffectStyleUltraColored",
                @"UIBlurEffectStyleLightKeyboard",
                @"UIBlurEffectStyleLightEmojiKeyboard",
                @"UIBlurEffectStyleAutomatic",
                @"UIBlurEffectStyleSystemChromeBackground",
                @"UIBlurEffectStyleSystemChromeBackgroundLight",
                @"UIBlurEffectStyleSystemChromeBackgroundDark",
                @"UIBlurEffectStyleSystemVibrantBackgroundRegular",
                @"UIBlurEffectStyleSystemVibrantBackgroundUltraThin",
                @"UIBlurEffectStyleSystemVibrantBackgroundThin",
                @"UIBlurEffectStyleSystemVibrantBackgroundThick",
                @"UIBlurEffectStyleSystemVibrantBackgroundRegularLight",
                @"UIBlurEffectStyleSystemVibrantBackgroundUltraThinLight",
                @"UIBlurEffectStyleSystemVibrantBackgroundThinLight",
                @"UIBlurEffectStyleSystemVibrantBackgroundThickLight",
                @"UIBlurEffectStyleSystemVibrantBackgroundRegularDark",
                @"UIBlurEffectStyleSystemVibrantBackgroundUltraThinDark",
                @"UIBlurEffectStyleSystemVibrantBackgroundThinDark",
                @"UIBlurEffectStyleSystemVibrantBackgroundThickDark",
                @"UIBlurEffectStylePinched",
                @"UIBlurEffectStyleSelected",
                @"UIBlurEffectStyleDisabled",
                @"UIBlurEffectStyleGlassLighter",
                @"UIBlurEffectStyleGlassDarker",
                @"UIBlurEffectStyleGlassUltraDarker",
                @"UIBlurEffectStyleGlass",
                @"UIBlurEffectStyleATVSemiLight",
                @"UIBlurEffectStyleATVMediumLight",
                @"UIBlurEffectStyleATVLight",
                @"UIBlurEffectStyleATVUltraLight",
                @"UIBlurEffectStyleATVMenuLight",
                @"UIBlurEffectStyleATVSemiDark",
                @"UIBlurEffectStyleATVMediumDark",
                @"UIBlurEffectStyleATVDark",
                @"UIBlurEffectStyleATVUltraDark",
                @"UIBlurEffectStyleATVMenuDark",
                @"UIBlurEffectStyleATVAdaptive",
                @"UIBlurEffectStyleATVAdaptiveLighten",
                @"UIBlurEffectStyleATVLightTextField",
                @"UIBlurEffectStyleATVDarkTextField",
                @"UIBlurEffectStyleATVAccessoryLight",
                @"UIBlurEffectStyleATVAccessoryDark",
                @"UIBlurEffectStyleATVBlackTextField",
                @"UIBlurEffectStyleATVAutomatic",
                @"UIBlurEffectStyleATVSemiAutomatic",
                @"UIBlurEffectStyleATVMediumAutomatic",
                @"UIBlurEffectStyleATVUltraAutomatic",
                @"UIBlurEffectStyleATVMenuAutomatic",
                @"UIBlurEffectStyleATVAccessoryAutomatic",
                @"UIBlurEffectStyleATVTextFieldAutomatic"
            ];
            
            NSMutableArray *copy = [styles mutableCopy];
            for (uint64_t num = 0; num < __UINT64_MAX__; num++) @autoreleasepool {
                NSString *result = _UIStyledEffectConvertToString(num);
                
                if ([styles containsObject:result]) {
                    NSLog(@"%@: %llu", result, num);
                    [copy removeObject:result];
                }
                
                if (copy.count == 0) break;
            }
        }
        
        completion(children);
        [children release];
    }];
    
    UIMenu *menu = [UIMenu menuWithChildren:@[element]];
    return menu;
}

@end
