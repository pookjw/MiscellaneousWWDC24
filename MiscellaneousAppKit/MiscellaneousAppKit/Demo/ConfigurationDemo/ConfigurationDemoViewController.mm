//
//  ConfigurationDemoViewController.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 1/31/25.
//

#import "ConfigurationDemoViewController.h"
#import "ConfigurationView.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface ConfigurationDemoViewController () <ConfigurationViewDelegate>
@property (retain, nonatomic, readonly, getter=_configurationView) ConfigurationView *configurationView;
@property (retain, nonatomic, readonly, getter=_circleView) NSView *circleView;
@property (assign, nonatomic, getter=_isOn, setter=_setOn:) BOOL on;
@property (assign, nonatomic, getter=_sliderValue, setter=_setSliderValue:) double sliderValue;
@property (assign, nonatomic, getter=_stepperValue, setter=_setSteperValue:) double stepperValue;
@property (assign, nonatomic, getter=_shouldReconfigure, setter=_setShouldReconfigure:) BOOL shouldReconfigure;
@property (copy, nonatomic, getter=_selectedPopUpTitles, setter=_setSelectedPopUpTitles:) NSArray<NSString *> *selectedPopUpTitles;
@end

@implementation ConfigurationDemoViewController
@synthesize configurationView = _configurationView;
@synthesize circleView = _circleView;

- (void)dealloc {
    [_configurationView release];
    [_circleView release];
    [_selectedPopUpTitles release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedPopUpTitles = @[@"👍"];
    
    ConfigurationView *configurationView = self.configurationView;
    configurationView.frame = self.view.bounds;
    configurationView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self.view addSubview:configurationView];
    
    NSView *circleView = self.circleView;
    circleView.translatesAutoresizingMaskIntoConstraints = NO;
    circleView.layer.cornerRadius = 20.;
    [self.view addSubview:circleView];
    [NSLayoutConstraint activateConstraints:@[
        [circleView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [circleView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [circleView.widthAnchor constraintEqualToConstant:40.],
        [circleView.heightAnchor constraintEqualToConstant:40.]
    ]];
    
    [self _reload];
}

- (ConfigurationView *)_configurationView {
    if (auto configurationView = _configurationView) return configurationView;
    
    ConfigurationView *configurationView = [ConfigurationView new];
    configurationView.delegate = self;
    
    _configurationView = configurationView;
    return configurationView;
}

- (NSView *)_circleView {
    if (auto circleView = _circleView) return circleView;
    
    NSView *circleView = [NSView new];
    circleView.wantsLayer = YES;
    
    _circleView = circleView;
    return circleView;
}

- (void)_reload {
    NSDiffableDataSourceSnapshot *snapshot = [NSDiffableDataSourceSnapshot new];
    [snapshot appendSectionsWithIdentifiers:@[[NSNull null]]];
    
    __block auto unretainedSelf = self;
    
    ConfigurationItemModel<NSNumber *> *switchItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                                                                         identifier:@"Dynamic Label Switch"
                                                                                           userInfo:nil
                                                                                      labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return static_cast<NSNumber *>(value).stringValue;
    }
                                                                                      valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return @(unretainedSelf.on);
    }];
    
    ConfigurationItemModel<NSNumber *> *shouldReconfigureItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                                                                                    identifier:@"Should Reconfigure"
                                                                                                      userInfo:nil
                                                                                                         label:@"Should Reconfigure"
                                                                                                 valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return @(unretainedSelf.shouldReconfigure);
    }];
    
    ConfigurationItemModel<ConfigurationSliderDescription *> *sliderItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSlider
                                                                                                               identifier:@"Slider"
                                                                                                                 userInfo:nil
                                                                                                            labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return @(static_cast<ConfigurationSliderDescription *>(value).sliderValue).stringValue;
    }
                                                                                                            valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationSliderDescription descriptionWithSliderValue:unretainedSelf.sliderValue minimumValue:0. maximumValue:1. continuous:NO];
    }];
    
    ConfigurationItemModel<ConfigurationStepperDescription *> *stepperItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeStepper
                                                                                                                 identifier:@"Stepper"
                                                                                                                   userInfo:nil
                                                                                                              labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return @(static_cast<ConfigurationStepperDescription *>(value).stepperValue).stringValue;
    }
                                                                                                              valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationStepperDescription descriptionWithStepperValue:unretainedSelf.stepperValue minimumValue:0. maximumValue:1. stepValue:0.1 continuous:NO autorepeat:YES valueWraps:YES];
    }];
    
    ConfigurationItemModel<NSNull *> *buttonItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                                                                       identifier:@"Button"
                                                                                         userInfo:nil
                                                                                            label:@"Button"
                                                                                    valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
    
    ConfigurationItemModel<NSArray<NSString *> *> *popUpButtonItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                                                                                         identifier:@"Pop Up Button"
                                                                                                           userInfo:nil
                                                                                                      labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        if (NSString *first = unretainedSelf.selectedPopUpTitles.firstObject) {
            return first;
        } else {
            return @"";
        }
    }
                                                                                                      valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationPopUpButtonDescription descriptionWithTitles:@[@"👍", @"😀", @"🥲"] selectedTitles:unretainedSelf.selectedPopUpTitles selectedDisplayTitle:unretainedSelf.selectedPopUpTitles.firstObject];
    }];
    
    NSView *circleView = self.circleView;
    
    ConfigurationItemModel<NSColor *> *colorWellItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeColorWell
                                                                                           identifier:@"Color Well"
                                                                                             userInfo:nil
                                                                                                label:@"Color Well"
                                                                                        valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSColor *backgroundColor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(circleView, sel_registerName("backgroundColor"));
        if (backgroundColor == nil) return NSColor.clearColor;
        return backgroundColor;
    }];
    
    [snapshot appendItemsWithIdentifiers:@[switchItemModel, shouldReconfigureItemModel, sliderItemModel, stepperItemModel, buttonItemModel, popUpButtonItemModel, colorWellItemModel] intoSectionWithIdentifier:[NSNull null]];
    [snapshot reloadItemsWithIdentifiers:snapshot.itemIdentifiers];
    
    [self.configurationView.dataSource applySnapshot:snapshot animatingDifferences:YES];
    [snapshot release];
}

- (void)didTriggerReloadButtonWithConfigurationView:(ConfigurationView *)configurationView {
    [self _reload];
}

- (BOOL)configurationView:(ConfigurationView *)configurationView didTriggerActionWithItemModel:(ConfigurationItemModel *)itemModel newValue:(nonnull id<NSCopying>)newValue {
    if ([itemModel.identifier isEqualToString:@"Static Label Switch"] or ([itemModel.identifier isEqualToString:@"Dynamic Label Switch"])) {
        self.on = static_cast<NSNumber *>(newValue).boolValue;
    } else if ([itemModel.identifier isEqualToString:@"Should Reconfigure"]) {
        self.shouldReconfigure = static_cast<NSNumber *>(newValue).boolValue;
    } else if ([itemModel.identifier isEqualToString:@"Slider"]) {
        double sliderValue = static_cast<NSNumber *>(newValue).doubleValue;
        self.sliderValue = sliderValue;
    } else if ([itemModel.identifier isEqualToString:@"Stepper"]) {
        double stepperValue = static_cast<NSNumber *>(newValue).doubleValue;
        self.stepperValue = stepperValue;
    } else if ([itemModel.identifier isEqualToString:@"Button"]) {
        NSLog(@"Triggered!");
    } else if ([itemModel.identifier isEqualToString:@"Pop Up Button"]) {
        auto title = static_cast<NSString *>(newValue);
        
        NSInteger index = [self.selectedPopUpTitles indexOfObject:title];
        if (index != NSNotFound) {
            NSMutableArray<NSString *> *copy = [self.selectedPopUpTitles mutableCopy];
            [copy removeObjectAtIndex:index];
            self.selectedPopUpTitles = copy;
            [copy release];
        } else {
            self.selectedPopUpTitles = [self.selectedPopUpTitles arrayByAddingObject:title];
        }
    } else if ([itemModel.identifier isEqualToString:@"Color Well"]) {
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self.circleView, sel_registerName("setBackgroundColor:"), newValue);
    } else {
        abort();
    }
    
    if (itemModel.type == ConfigurationItemModelTypePopUpButton) {
        return YES;
    } else {
        return self.shouldReconfigure;
    }
}

@end
