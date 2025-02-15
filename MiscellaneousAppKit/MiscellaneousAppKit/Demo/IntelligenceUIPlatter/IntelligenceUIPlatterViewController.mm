//
//  IntelligenceUIPlatterViewController.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/15/25.
//

#import "IntelligenceUIPlatterViewController.h"
#import "ConfigurationView.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface IntelligenceUIPlatterViewController () <ConfigurationViewDelegate>
@property (retain, nonatomic, readonly, getter=_splitView) NSSplitView *splitView;
@property (retain, nonatomic, readonly, getter=_configurationView) ConfigurationView *configurationView;
@property (retain, nonatomic, readonly, getter=_platterContainerView) NSView *platterContainerView;
@property (retain, nonatomic, readonly, getter=_platterView) __kindof NSView *platterView;
@end

@implementation IntelligenceUIPlatterViewController
@synthesize splitView = _splitView;
@synthesize configurationView = _configurationView;
@synthesize platterContainerView = _platterContainerView;
@synthesize platterView = _platterView;

- (void)dealloc {
    [_splitView release];
    [_configurationView release];
    [_platterContainerView release];
    [_platterView release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.splitView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _reload];
}

- (void)viewDidLayout {
    [super viewDidLayout];
    
    __kindof NSView *platterView = self.platterView;
    CGFloat cornerRadius = reinterpret_cast<CGFloat (*)(id, SEL)>(objc_msgSend)(platterView, sel_registerName("cornerRadius"));
    cornerRadius = MIN(cornerRadius, MIN(NSWidth(platterView.bounds), NSHeight(platterView.bounds)) * 0.5);
    reinterpret_cast<void (*)(id, SEL, CGFloat)>(objc_msgSend)(platterView, sel_registerName("setCornerRadius:"), cornerRadius);
    
    [self.configurationView reconfigureItemModelsWithIdentifiers:@[@"Corner Radius"]];
}

- (NSSplitView *)_splitView {
    if (auto splitView = _splitView) return splitView;
    
    NSSplitView *splitView = [NSSplitView new];
    splitView.vertical = YES;
    splitView.dividerStyle = NSSplitViewDividerStyleThick;
    
    [splitView addArrangedSubview:self.configurationView];
    [splitView addArrangedSubview:self.platterContainerView];
    
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

- (NSView *)_platterContainerView {
    if (auto platterContainerView = _platterContainerView) return platterContainerView;
    
    NSView *platterContainerView = [NSView new];
    __kindof NSView *platterView = self.platterView;
    platterView.translatesAutoresizingMaskIntoConstraints = NO;
    [platterContainerView addSubview:platterView];
    [NSLayoutConstraint activateConstraints:@[
        [platterView.centerXAnchor constraintEqualToAnchor:platterContainerView.centerXAnchor],
        [platterView.centerYAnchor constraintEqualToAnchor:platterContainerView.centerYAnchor],
        [platterView.widthAnchor constraintEqualToAnchor:platterContainerView.widthAnchor multiplier:0.75],
        [platterView.heightAnchor constraintEqualToAnchor:platterContainerView.heightAnchor multiplier:0.75]
    ]];
    
    _platterContainerView = platterContainerView;
    return platterContainerView;
}

- (__kindof NSView *)_platterView {
    if (auto platterView = _platterView) return platterView;
    
    __kindof NSView *platterView = [objc_lookUpClass("_NSIntelligenceUIPlatterView") new];
    
    NSClickGestureRecognizer *gestureRecognizer = [[NSClickGestureRecognizer alloc] initWithTarget:self action:@selector(_didClockPlatterView:)];
    [platterView addGestureRecognizer:gestureRecognizer];
    [gestureRecognizer release];
    
    _platterView = platterView;
    return platterView;
}

- (void)_didClockPlatterView:(NSClickGestureRecognizer *)sender {
    __kindof NSView *platterView = self.platterView;
    NSPoint nsPoint = [sender locationInView:platterView];
    CGPoint cgPoint = NSPointToCGPoint(nsPoint);
    cgPoint.y = NSHeight(platterView.bounds) - cgPoint.y;
    reinterpret_cast<void (*)(id, SEL, CGPoint)>(objc_msgSend)(platterView, sel_registerName("shimmerFromPoint:"), cgPoint);
}

- (void)_reload {
    NSCollectionViewDiffableDataSource<NSNull *, ConfigurationItemModel *> *dataSource = self.configurationView.dataSource;
    NSDiffableDataSourceSnapshot<NSNull *, ConfigurationItemModel *> *snapshot = [NSDiffableDataSourceSnapshot new];
    
    [snapshot appendSectionsWithIdentifiers:@[[NSNull null]]];
    [snapshot appendItemsWithIdentifiers:@[
        [self _makeCornerRadiusItemModel],
        [self _makeHasInteriorLightItemModel],
        [self _makeHasExteriorLightItemModel],
        [self _makeIndicatesIndeterminateProgressItemModel],
        [self _makeUsesAudioLevelsItemModel],
        [self _makeAudioLevelItemModel],
        [self _makeClipsToBoundsModel],
        [self _makeInteriorLightFractionItemModel],
        [self _makeExteriorLightFractionItemModel],
        [self _makeBorderFractionItemModel],
        [self _makeIndeterminateIndicatorFractionItemModel],
        [self _makeBorderedItemModel],
        [self _makeShimmerItemModel],
        [self _makeShimmerFromEdgeItemModel]
    ]
               intoSectionWithIdentifier:[NSNull null]];
    
    [dataSource applySnapshot:snapshot animatingDifferences:NO];
    [snapshot release];
}

- (ConfigurationItemModel *)_makeCornerRadiusItemModel {
    __kindof NSView *platterView = self.platterView;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSlider
                                          identifier:@"Corner Radius"
                                            userInfo:nil
                                               label:@"Corner Radius"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        CGFloat cornerRadius = reinterpret_cast<CGFloat (*)(id, SEL)>(objc_msgSend)(platterView, sel_registerName("cornerRadius"));
        return [ConfigurationSliderDescription descriptionWithSliderValue:cornerRadius
                                                             minimumValue:0.
                                                             maximumValue:MIN(NSWidth(platterView.bounds), NSHeight(platterView.bounds)) * 0.5
                                                               continuous:YES];
    }];
}

- (ConfigurationItemModel *)_makeHasInteriorLightItemModel {
    __kindof NSView *platterView = self.platterView;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                          identifier:@"Has Interior Light"
                                            userInfo:nil
                                               label:@"Has Interior Light"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        BOOL hasInteriorLight = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(platterView, sel_registerName("hasInteriorLight"));
        return @(hasInteriorLight);
    }];
}

- (ConfigurationItemModel *)_makeIndicatesIndeterminateProgressItemModel {
    __kindof NSView *platterView = self.platterView;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                          identifier:@"Indicates Indeterminate Progress"
                                            userInfo:nil
                                               label:@"Indicates Indeterminate Progress"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        BOOL indicatesIndeterminateProgress = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(platterView, sel_registerName("indicatesIndeterminateProgress"));
        return @(indicatesIndeterminateProgress);
    }];
}

- (ConfigurationItemModel *)_makeHasExteriorLightItemModel {
    __kindof NSView *platterView = self.platterView;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                          identifier:@"Has Exterior Light"
                                            userInfo:nil
                                               label:@"Has Exterior Light"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        BOOL hasExteriorLight = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(platterView, sel_registerName("hasExteriorLight"));
        return @(hasExteriorLight);
    }];
}

- (ConfigurationItemModel *)_makeUsesAudioLevelsItemModel {
    __kindof NSView *platterView = self.platterView;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                          identifier:@"Uses Audio Levels"
                                            userInfo:nil
                                               label:@"Uses Audio Levels"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        BOOL usesAudioLevels = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(platterView, sel_registerName("usesAudioLevels"));
        return @(usesAudioLevels);
    }];
}

- (ConfigurationItemModel *)_makeAudioLevelItemModel {
    __kindof NSView *platterView = self.platterView;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSlider
                                          identifier:@"Audio Level"
                                            userInfo:nil
                                               label:@"Audio Level"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        double audioLevel = reinterpret_cast<double (*)(id, SEL)>(objc_msgSend)(platterView, sel_registerName("audioLevel"));
        return [ConfigurationSliderDescription descriptionWithSliderValue:audioLevel minimumValue:0. maximumValue:100. continuous:YES];
    }];
}

- (ConfigurationItemModel *)_makeClipsToBoundsModel {
    __kindof NSView *platterView = self.platterView;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                          identifier:@"Clips To Bounds"
                                            userInfo:nil
                                               label:@"Clips To Bounds (???)"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        BOOL clipsToBounds = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(platterView, sel_registerName("clipsToBounds"));
        return @(clipsToBounds);
    }];
}

- (ConfigurationItemModel *)_makeInteriorLightFractionItemModel {
    __kindof NSView *platterView = self.platterView;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSlider
                                          identifier:@"Interior Light Fraction"
                                            userInfo:nil
                                               label:@"Interior Light Fraction"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        CGFloat _interiorLightFraction = reinterpret_cast<double (*)(id, SEL)>(objc_msgSend)(platterView, sel_registerName("_interiorLightFraction"));
        return [ConfigurationSliderDescription descriptionWithSliderValue:_interiorLightFraction minimumValue:0. maximumValue:1. continuous:YES];
    }];
}

- (ConfigurationItemModel *)_makeExteriorLightFractionItemModel {
    __kindof NSView *platterView = self.platterView;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSlider
                                          identifier:@"Exterior Light Fraction"
                                            userInfo:nil
                                               label:@"Exterior Light Fraction"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        CGFloat _exteriorLightFraction = reinterpret_cast<double (*)(id, SEL)>(objc_msgSend)(platterView, sel_registerName("_exteriorLightFraction"));
        return [ConfigurationSliderDescription descriptionWithSliderValue:_exteriorLightFraction minimumValue:0. maximumValue:1. continuous:YES];
    }];
}

- (ConfigurationItemModel *)_makeBorderFractionItemModel {
    __kindof NSView *platterView = self.platterView;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSlider
                                          identifier:@"Border Fraction"
                                            userInfo:nil
                                               label:@"Border Fraction"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        CGFloat _borderFraction = reinterpret_cast<double (*)(id, SEL)>(objc_msgSend)(platterView, sel_registerName("_borderFraction"));
        return [ConfigurationSliderDescription descriptionWithSliderValue:_borderFraction minimumValue:0. maximumValue:1. continuous:YES];
    }];
}

- (ConfigurationItemModel *)_makeIndeterminateIndicatorFractionItemModel {
    __kindof NSView *platterView = self.platterView;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSlider
                                          identifier:@"Indeterminate Indicator Fraction"
                                            userInfo:nil
                                               label:@"Indeterminate Indicator Fraction"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        CGFloat _indeterminateIndicatorFraction = reinterpret_cast<double (*)(id, SEL)>(objc_msgSend)(platterView, sel_registerName("_indeterminateIndicatorFraction"));
        return [ConfigurationSliderDescription descriptionWithSliderValue:_indeterminateIndicatorFraction minimumValue:0. maximumValue:1. continuous:YES];
    }];
}

- (ConfigurationItemModel *)_makeBorderedItemModel {
    __kindof NSView *platterView = self.platterView;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                          identifier:@"Bordered"
                                            userInfo:nil
                                               label:@"Bordered (???)"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        BOOL isBordered = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(platterView, sel_registerName("isBordered"));
        return @(isBordered);
    }];
}

- (ConfigurationItemModel *)_makeShimmerItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Shimmer"
                                            userInfo:nil
                                               label:@"Shimmer"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeShimmerFromEdgeItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                          identifier:@"Shimmer from Edge"
                                            userInfo:nil
                                               label:@"Shimmer from Edge"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationPopUpButtonDescription descriptionWithTitles:@[
            @"0",@"1",@"2",@"3"
        ]
                                                           selectedTitles:@[]
                                                     selectedDisplayTitle:nil];
    }];
}

- (BOOL)configurationView:(ConfigurationView *)configurationView didTriggerActionWithItemModel:(ConfigurationItemModel *)itemModel newValue:(id<NSCopying>)newValue {
    NSString *identifier = itemModel.identifier;
    __kindof NSView *platterView = self.platterView;
    
    if ([identifier isEqualToString:@"Corner Radius"]) {
        auto number = static_cast<NSNumber *>(newValue);
#if CGFLOAT_IS_DOUBLE
        reinterpret_cast<void (*)(id, SEL, CGFloat)>(objc_msgSend)(platterView, sel_registerName("setCornerRadius:"), number.doubleValue);
#else
        reinterpret_cast<void (*)(id, SEL, CGFloat)>(objc_msgSend)(platterView, sel_registerName("setCornerRadius:"), number.floatValue);
#endif
        return NO;
    } else if ([identifier isEqualToString:@"Has Interior Light"]) {
        auto number = static_cast<NSNumber *>(newValue);
        reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(platterView, sel_registerName("setHasInteriorLight:"), number.boolValue);
        return NO;
    } else if ([identifier isEqualToString:@"Has Exterior Light"]) {
        auto number = static_cast<NSNumber *>(newValue);
        reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(platterView, sel_registerName("setHasExteriorLight:"), number.boolValue);
        return NO;
    } else if ([identifier isEqualToString:@"Indicates Indeterminate Progress"]) {
        auto number = static_cast<NSNumber *>(newValue);
        reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(platterView, sel_registerName("setIndicatesIndeterminateProgress:"), number.boolValue);
        return NO;
    } else if ([identifier isEqualToString:@"Uses Audio Levels"]) {
        auto number = static_cast<NSNumber *>(newValue);
        reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(platterView, sel_registerName("setUsesAudioLevels:"), number.boolValue);
        return NO;
    } else if ([identifier isEqualToString:@"Audio Level"]) {
        reinterpret_cast<void (*)(id, SEL, double)>(objc_msgSend)(platterView, sel_registerName("setAudioLevel:"), static_cast<NSNumber *>(newValue).doubleValue);
        return NO;
    } else if ([identifier isEqualToString:@"Clips To Bounds"]) {
        reinterpret_cast<void (*)(id, SEL, double)>(objc_msgSend)(platterView, sel_registerName("setClipsToBounds:"), static_cast<NSNumber *>(newValue).doubleValue);
        return NO;
    } else if ([identifier isEqualToString:@"Interior Light Fraction"]) {
        auto number = static_cast<NSNumber *>(newValue);
#if CGFLOAT_IS_DOUBLE
        reinterpret_cast<void (*)(id, SEL, CGFloat)>(objc_msgSend)(platterView, sel_registerName("set_interiorLightFraction:"), number.doubleValue);
#else
        reinterpret_cast<void (*)(id, SEL, CGFloat)>(objc_msgSend)(platterView, sel_registerName("set_interiorLightFraction:"), number.floatValue);
#endif
        return NO;
    } else if ([identifier isEqualToString:@"Exterior Light Fraction"]) {
        auto number = static_cast<NSNumber *>(newValue);
#if CGFLOAT_IS_DOUBLE
        reinterpret_cast<void (*)(id, SEL, CGFloat)>(objc_msgSend)(platterView, sel_registerName("set_exteriorLightFraction:"), number.doubleValue);
#else
        reinterpret_cast<void (*)(id, SEL, CGFloat)>(objc_msgSend)(platterView, sel_registerName("set_exteriorLightFraction:"), number.floatValue);
#endif
        return NO;
    } else if ([identifier isEqualToString:@"Border Fraction"]) {
        auto number = static_cast<NSNumber *>(newValue);
#if CGFLOAT_IS_DOUBLE
        reinterpret_cast<void (*)(id, SEL, CGFloat)>(objc_msgSend)(platterView, sel_registerName("set_borderFraction:"), number.doubleValue);
#else
        reinterpret_cast<void (*)(id, SEL, CGFloat)>(objc_msgSend)(platterView, sel_registerName("set_borderFraction:"), number.floatValue);
#endif
        return NO;
    } else if ([identifier isEqualToString:@"Indeterminate Indicator Fraction"]) {
        auto number = static_cast<NSNumber *>(newValue);
#if CGFLOAT_IS_DOUBLE
        reinterpret_cast<void (*)(id, SEL, CGFloat)>(objc_msgSend)(platterView, sel_registerName("set_indeterminateIndicatorFraction:"), number.doubleValue);
#else
        reinterpret_cast<void (*)(id, SEL, CGFloat)>(objc_msgSend)(platterView, sel_registerName("set_indeterminateIndicatorFraction:"), number.floatValue);
#endif
        return NO;
    } else if ([identifier isEqualToString:@"Bordered"]) {
        reinterpret_cast<void (*)(id, SEL, double)>(objc_msgSend)(platterView, sel_registerName("setBordered:"), static_cast<NSNumber *>(newValue).doubleValue);
        return NO;
    } else if ([identifier isEqualToString:@"Shimmer"]) {
        reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(platterView, sel_registerName("shimmer"));
        return NO;
    } else if ([identifier isEqualToString:@"Shimmer from Edge"]) {
        auto title = static_cast<NSString *>(newValue);
        NSUInteger edge = title.integerValue;
        reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(platterView, sel_registerName("shimmerFromEdge:"), edge);
        return NO;
    } else {
        abort();
    }
}

- (void)didTriggerReloadButtonWithConfigurationView:(ConfigurationView *)configurationView {
    [self _reload];
}

@end
