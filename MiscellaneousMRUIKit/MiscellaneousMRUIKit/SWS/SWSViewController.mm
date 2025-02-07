//
//  SWSViewController.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 2/7/25.
//

#import "SWSViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

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
        
        if (sws_platterEnabled) {
            UIAction *action = [UIAction actionWithTitle:@"Disable Platter" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(label, sel_registerName("sws_disablePlatter"));
            }];
            
            action.attributes = UIMenuElementAttributesDestructive;
            [children addObject:action];
        } else {
            UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            NSLog(@"%ld", UIBlurEffectStyleDark);
            NSLog(@"%@", effect);
            NSArray<NSString *> *styles = @[
                @"UIBlurEffectStyleLight",
                @"UIBlurEffectStyleExtraLight",
                @"UIBlurEffectStyleDark",
                @"UIBlurEffectStyleExtraDark",
                @"UIBlurEffectStyleRegular",
                @"UIBlurEffectStyleProminent",
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

        }
        
        completion(children);
        [children release];
    }];
    
    UIMenu *menu = [UIMenu menuWithChildren:@[element]];
    return menu;
}

@end
