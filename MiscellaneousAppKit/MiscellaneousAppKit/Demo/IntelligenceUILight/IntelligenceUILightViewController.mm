//
//  IntelligenceUILightViewController.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/15/25.
//

/*
 NSIntelligenceUINoiseView도 있지만 이건 Color Palette만 다른 것
 */

#import "IntelligenceUILightViewController.h"
#import "ConfigurationView.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface IntelligenceUILightViewController () <ConfigurationViewDelegate>
@property (retain, nonatomic, readonly, getter=_splitView) NSSplitView *splitView;
@property (retain, nonatomic, readonly, getter=_configurationView) ConfigurationView *configurationView;
@property (retain, nonatomic, readonly, getter=_lightView) __kindof NSView *lightView;
@end

@implementation IntelligenceUILightViewController
@synthesize splitView = _splitView;
@synthesize configurationView = _configurationView;
@synthesize lightView = _lightView;

- (void)dealloc {
    [_splitView release];
    [_configurationView release];
    [_lightView release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.splitView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _reload];
}

- (NSSplitView *)_splitView {
    if (auto splitView = _splitView) return splitView;
    
    NSSplitView *splitView = [NSSplitView new];
    splitView.vertical = YES;
    splitView.dividerStyle = NSSplitViewDividerStyleThick;
    
    [splitView addArrangedSubview:self.configurationView];
    [splitView addArrangedSubview:self.lightView];
    
    _splitView = splitView;
    return splitView;
}

- (ConfigurationView *)_configurationView {
    if (auto configurationView = _configurationView) return configurationView;
    
    ConfigurationView *configurationView = [ConfigurationView new];
    configurationView.delegate = self;
    
    _configurationView = configurationView;
    return configurationView;
}

- (__kindof NSView *)_lightView {
    if (auto lightView = _lightView) return lightView;
    
    __kindof NSView *lightView = [objc_lookUpClass("NSIntelligenceUILightView") new];
    
    _lightView = lightView;
    return lightView;
}

- (void)_reload {
    NSCollectionViewDiffableDataSource<NSNull *, ConfigurationItemModel *> *dataSource = self.configurationView.dataSource;
    NSDiffableDataSourceSnapshot<NSNull *, ConfigurationItemModel *> *snapshot = [NSDiffableDataSourceSnapshot new];
    
    [snapshot appendSectionsWithIdentifiers:@[[NSNull null]]];
    [snapshot appendItemsWithIdentifiers:@[
        [self _makeAudioLevelItemModel],
        [self _makeMinimumPowerLevelItemModel],
        [self _makeColorPaletteItemModel],
        [self _makeScopeItemModel]
    ]
               intoSectionWithIdentifier:[NSNull null]];
    
    [dataSource applySnapshot:snapshot animatingDifferences:NO];
    [snapshot release];
}

- (ConfigurationItemModel *)_makeAudioLevelItemModel {
    __kindof NSView *lightView = self.lightView;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSlider
                                          identifier:@"Audio Level"
                                            userInfo:nil
                                               label:@"Audio Level (???)"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        CGFloat audioLevel = reinterpret_cast<CGFloat (*)(id, SEL)>(objc_msgSend)(lightView, sel_registerName("audioLevel"));
        return [ConfigurationSliderDescription descriptionWithSliderValue:audioLevel minimumValue:0. maximumValue:100. continuous:YES];
    }];
}

- (ConfigurationItemModel *)_makeMinimumPowerLevelItemModel {
    __kindof NSView *lightView = self.lightView;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSlider
                                          identifier:@"Minimum Power Level"
                                            userInfo:nil
                                               label:@"Minimum Power Level"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        float minimumPowerLevel = reinterpret_cast<float (*)(id, SEL)>(objc_msgSend)(lightView, sel_registerName("minimumPowerLevel"));
        return [ConfigurationSliderDescription descriptionWithSliderValue:minimumPowerLevel minimumValue:0. maximumValue:100. continuous:YES];
    }];
}

- (ConfigurationItemModel *)_makeColorPaletteItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                          identifier:@"Color Palette"
                                            userInfo:nil
                                               label:@"Color Palette"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        /*
         -[SUICIntelligentLightLayer _loadMetalPipelines]
         
         101: (
             IntelligentLightVert,
             IntelligentLightFrag
         )
         
         102: (
             IntelligentLightVert,
             IntelligentLightFrag,
             IntelligentLightVert,
             IntelligentLightSaturatedV1Frag
         )
         
         103: (
             IntelligentLightVert,
             IntelligentLightFrag,
             IntelligentLightVert,
             IntelligentLightMacFrag
         )
         
         104: (
             IntelligentLightVert,
             IntelligentLightFrag,
             IntelligentLightVert,
             IntelligentLightFrag
         )
         
         500: (
             IntelligentLightVert,
             IntelligentLightFrag,
             IntelligentLightNoiseVert,
             IntelligentLightNoiseFrag
         )
         
         501: (
             IntelligentLightVert,
             IntelligentLightFrag,
             IntelligentLightNoiseVert,
             IntelligentLightNoiseFullFrag
         )
         */
        
        return [ConfigurationPopUpButtonDescription descriptionWithTitles:@[
            @"101", @"102", @"103", @"104", @"500", @"501"
        ]
                                                           selectedTitles:@[]
                                                     selectedDisplayTitle:nil];
    }];
}

- (ConfigurationItemModel *)_makeScopeItemModel {
    __kindof NSView *lightView = self.lightView;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                          identifier:@"Scope"
                                            userInfo:nil
                                               label:@"Scope"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSInteger scope = reinterpret_cast<NSInteger (*)(id, SEL)>(objc_msgSend)(lightView, sel_registerName("scope"));
        
        // -[NSIntelligenceUILightView layout]을 보면 0 또는 0이 아닐 때만 처리하고 있음
        /*
         Scope는 랜더링될 크기를 정한다. 0은 NSWindow 기반이며, 1은 NSView 기반이다.
         Split View의 Diver를 움직여보면 차이를 알 수 있다.
         */
        return [ConfigurationPopUpButtonDescription descriptionWithTitles:@[
            @"0", @"1"
        ]
                                                           selectedTitles:@[@(scope).stringValue]
                                                     selectedDisplayTitle:@(scope).stringValue];
    }];
}

- (BOOL)configurationView:(ConfigurationView *)configurationView didTriggerActionWithItemModel:(ConfigurationItemModel *)itemModel newValue:(id<NSCopying>)newValue {
    NSString *identifier = itemModel.identifier;
    
    if ([identifier isEqualToString:@"Minimum Power Level"]) {
        reinterpret_cast<void (*)(id, SEL, float)>(objc_msgSend)(self.lightView, sel_registerName("setMinimumPowerLevel:"), static_cast<NSNumber *>(newValue).floatValue);
        return NO;
    } else if ([identifier isEqualToString:@"Audio Level"]) {
        reinterpret_cast<void (*)(id, SEL, CGFloat)>(objc_msgSend)(self.lightView, sel_registerName("setAudioLevel:"), static_cast<NSNumber *>(newValue).doubleValue);
        return NO;
    } else if ([identifier isEqualToString:@"Color Palette"]) {
        auto title = static_cast<NSString *>(newValue);
        NSUInteger colorPalette = title.integerValue;
        id configuration = reinterpret_cast<id (*)(id, SEL, NSUInteger)>(objc_msgSend)([objc_lookUpClass("NSIntelligentLightRootConfiguration") alloc], sel_registerName("initWithColorPalette:"), colorPalette);
        id root = reinterpret_cast<id (*)(id, SEL, id, id)>(objc_msgSend)([objc_lookUpClass("NSIntelligentLightRoot") alloc], sel_registerName("initWithWindow:configuration:"), self.lightView.window, configuration);
        [configuration release];
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self.lightView, sel_registerName("setRoot:"), root);
        [root release];
        return YES;
    } else if ([identifier isEqualToString:@"Scope"]) {
        auto title = static_cast<NSString *>(newValue);
        NSInteger scope = title.integerValue;
        reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(self.lightView, sel_registerName("setScope:"), scope);
        return YES;
    } else {
        abort();
    }
}

- (void)didTriggerReloadButtonWithConfigurationView:(ConfigurationView *)configurationView {
    [self _reload];
}

@end
