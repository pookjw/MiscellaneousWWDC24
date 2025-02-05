//
//  SystemBannerRequestViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 2/4/25.
//

#import "SystemBannerRequestViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface SystemBannerRequestViewController ()
@property (retain, nonatomic, readonly, getter=_request) id request;
@end

@implementation SystemBannerRequestViewController
@synthesize request = _request;

+ (BOOL)_containsEntitlement {
    id proxy = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("LSApplicationProxy"), sel_registerName("bundleProxyForCurrentProcess"));
    NSDictionary<NSString *, id> *entitlements = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(proxy, sel_registerName("entitlements"));
    NSNumber *number = entitlements[@"com.apple.private.uikit.requestsystembanner"];
    if (number == nil) return NO;
    return number.boolValue;
}

- (void)dealloc {
    [_request release];
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
        id request = weakSelf.request;
        if (request == nil) {
            completion(@[]);
            return;
        }
        
        NSString *primaryTitleText = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(request, sel_registerName("primaryTitleText"));
        NSString *secondaryTitleText = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(request, sel_registerName("secondaryTitleText"));
        CGFloat preferredMaximumBannerWidth = reinterpret_cast<CGFloat (*)(id, SEL)>(objc_msgSend)(request, sel_registerName("preferredMaximumBannerWidth"));
        CGFloat preferredMinimumBannerWidth = reinterpret_cast<CGFloat (*)(id, SEL)>(objc_msgSend)(request, sel_registerName("preferredMinimumBannerWidth"));
        NSTimeInterval bannerTimeoutDuration = reinterpret_cast<NSTimeInterval (*)(id, SEL)>(objc_msgSend)(request, sel_registerName("bannerTimeoutDuration"));
        
        //
        
        UIAction *primaryTitleTextAction = [UIAction actionWithTitle:@"Primary Title Text" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Primary Title Text" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.text = primaryTitleText;
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:cancelAction];
            
            UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIAlertController *alertController = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(action, sel_registerName("_alertController"));
                reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(request, sel_registerName("setPrimaryTitleText:"), alertController.textFields[0].text);
                
                [weakSelf _presentMenu];
            }];
            [alertController addAction:doneAction];
            
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        }];
        primaryTitleTextAction.subtitle = primaryTitleText;
        
        //
        
        UIAction *secondaryTitleTextAction = [UIAction actionWithTitle:@"Secondary Title Text" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Secondary Title Text" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.text = primaryTitleText;
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:cancelAction];
            
            UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIAlertController *alertController = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(action, sel_registerName("_alertController"));
                reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(request, sel_registerName("setSecondaryTitleText:"), alertController.textFields[0].text);
                
                [weakSelf _presentMenu];
            }];
            [alertController addAction:doneAction];
            
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        }];
        secondaryTitleTextAction.subtitle = secondaryTitleText;
        
        //
        
        __kindof UIMenuElement *preferredMaximumBannerWidthSliderElement = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("UICustomViewMenuElement"), sel_registerName("elementWithViewProvider:"), ^ UIView * (__kindof UIMenuElement *menuElement) {
            UILabel *label = [UILabel new];
            label.adjustsFontSizeToFitWidth = YES;
            label.contentScaleFactor = 0.001;
            
            //
            
            UISlider *slider = [UISlider new];
            slider.maximumValue = 3000.;
            slider.minimumValue = 100.;
            slider.value = preferredMaximumBannerWidth;
            slider.continuous = YES;
            
            auto updateText = ^(UISlider *slider) {
                label.text = [NSString stringWithFormat:@"Preferred Maximum Width : %lf", slider.value];
            };
            
            UIAction *action = [UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
                auto slider = static_cast<UISlider *>(action.sender);
                updateText(slider);
                reinterpret_cast<void (*)(id, SEL, CGFloat)>(objc_msgSend)(request, sel_registerName("setPreferredMaximumBannerWidth:"), slider.value);
            }];
            [slider addAction:action forControlEvents:UIControlEventValueChanged];
            
            updateText(slider);
            
            //
            
            UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[label, slider]];
            [label release];
            [slider release];
            
            stackView.axis = UILayoutConstraintAxisVertical;
            stackView.alignment = UIStackViewAlignmentFill;
            stackView.distribution = UIStackViewDistributionFillProportionally;
            
            return [stackView autorelease];
        });
        
        //
        
        __kindof UIMenuElement *preferredMinimumBannerWidthSliderElement = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("UICustomViewMenuElement"), sel_registerName("elementWithViewProvider:"), ^ UIView * (__kindof UIMenuElement *menuElement) {
            UILabel *label = [UILabel new];
            label.adjustsFontSizeToFitWidth = YES;
            label.contentScaleFactor = 0.001;
            
            //
            
            UISlider *slider = [UISlider new];
            slider.maximumValue = 3000.;
            slider.minimumValue = 100.;
            slider.value = preferredMinimumBannerWidth;
            slider.continuous = YES;
            
            auto updateText = ^(UISlider *slider) {
                label.text = [NSString stringWithFormat:@"Preferred Minimum Width : %lf", slider.value];
            };
            
            UIAction *action = [UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
                auto slider = static_cast<UISlider *>(action.sender);
                updateText(slider);
                reinterpret_cast<void (*)(id, SEL, CGFloat)>(objc_msgSend)(request, sel_registerName("setPreferredMinimumBannerWidth:"), slider.value);
            }];
            [slider addAction:action forControlEvents:UIControlEventValueChanged];
            
            updateText(slider);
            
            //
            
            UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[label, slider]];
            [label release];
            [slider release];
            
            stackView.axis = UILayoutConstraintAxisVertical;
            stackView.alignment = UIStackViewAlignmentFill;
            stackView.distribution = UIStackViewDistributionFillProportionally;
            
            
            return [stackView autorelease];
        });
        
        //
        
        __kindof UIMenuElement *bannerTimeoutDurationSliderElement = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("UICustomViewMenuElement"), sel_registerName("elementWithViewProvider:"), ^ UIView * (__kindof UIMenuElement *menuElement) {
            UILabel *label = [UILabel new];
            label.adjustsFontSizeToFitWidth = YES;
            label.contentScaleFactor = 0.001;
            
            //
            
            UISlider *slider = [UISlider new];
            slider.maximumValue = 60.;
            slider.minimumValue = 1.;
            slider.value = bannerTimeoutDuration;
            slider.continuous = YES;
            
            auto updateText = ^(UISlider *slider) {
                label.text = [NSString stringWithFormat:@"Banner Timeout Duration : %lf", slider.value];
            };
            
            UIAction *action = [UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
                auto slider = static_cast<UISlider *>(action.sender);
                updateText(slider);
                reinterpret_cast<void (*)(id, SEL, NSTimeInterval)>(objc_msgSend)(request, sel_registerName("setBannerTimeoutDuration:"), slider.value);
            }];
            [slider addAction:action forControlEvents:UIControlEventValueChanged];
            
            updateText(slider);
            
            //
            
            UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[label, slider]];
            [label release];
            [slider release];
            
            stackView.axis = UILayoutConstraintAxisVertical;
            stackView.alignment = UIStackViewAlignmentFill;
            stackView.distribution = UIStackViewDistributionFillProportionally;
            
            
            return [stackView autorelease];
        });
        
        //
        
        UIAction *postAction = [UIAction actionWithTitle:@"Post" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(request, sel_registerName("postBanner"));
        }];
        
        UIMenu *postMenu = [UIMenu menuWithTitle:@"" image:nil identifier:nil options:UIMenuOptionsDisplayInline children:@[postAction]];
        
        //
        
        completion(@[
            primaryTitleTextAction,
            secondaryTitleTextAction,
            preferredMaximumBannerWidthSliderElement,
            preferredMinimumBannerWidthSliderElement,
            bannerTimeoutDurationSliderElement,
            postMenu
        ]);
    }];
    
    return [UIMenu menuWithChildren:@[element]];
}

- (id)_request {
    if (id request = _request) return request;
    
    id request = [objc_lookUpClass("_UISystemBannerRequest") new];
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(request, sel_registerName("setPrimaryTitleText:"), @"Primary Title Text");
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(request, sel_registerName("setSecondaryTitleText:"), @"Secondary Title Text");
    
    _request = request;
    return request;
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

// -[_UIVariableGestureContextMenuInteraction _setPresentOnTouchDown:]
