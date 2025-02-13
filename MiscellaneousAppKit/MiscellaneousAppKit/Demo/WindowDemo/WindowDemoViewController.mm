//
//  WindowDemoViewController.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 1/31/25.
//

#import "WindowDemoViewController.h"
#import "ConfigurationView.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import "NSStringFromNSWindowStyleMask.h"
#import "NSColorSpace+MA_Category.h"
#include <ranges>
#include <numeric>
#include <vector>
#import "NSStringFromNSWindowDepth.h"
#import "NSStringFromNSWindowCollectionBehavior.h"
#import "NSWindow+MA_Category.h"
#import "NSStringFromNSRectEdge.h"
#import "NSStringFromNSWindowNumberListOptions.h"
#import "NSStringNSWindowSharingType.h"
#import <QuartzCore/QuartzCore.h>

OBJC_EXPORT id objc_msgSendSuper2(void); /* objc_super superInfo = { self, [self class] }; */

NSAppearanceName const NSAppearanceNameCandidateBar = @"NSAppearanceNameCandidateBar";
APPKIT_EXTERN NSAppearanceName const NSAppearanceNameSystem;
APPKIT_EXTERN NSAppearanceName const NSAppearanceNameAccessibilitySystem;
APPKIT_EXTERN NSAppearanceName const NSAppearanceNameAqua;
APPKIT_EXTERN NSAppearanceName const NSAppearanceNameLightContent;
APPKIT_EXTERN NSAppearanceName const NSAppearanceNameVibrantDark;
APPKIT_EXTERN NSAppearanceName const NSAppearanceNameVibrantLight;
APPKIT_EXTERN NSAppearanceName const NSAppearanceNameFunctionRow;
APPKIT_EXTERN NSAppearanceName const NSAppearanceNameControlStrip;
NSAppearanceName const NSAppearanceNameTouchBarCustomizationPalette = @"NSAppearanceNameTouchBarCustomizationPalette";
NSAppearanceName const NSAppearanceNameControlStripCustomizationPalette = @"NSAppearanceNameControlStripCustomizationPalette";
APPKIT_EXTERN NSAppearanceName const NSAppearanceNameMediumLight;
APPKIT_EXTERN NSAppearanceName const NSAppearanceNameDarkAqua;
APPKIT_EXTERN NSAppearanceName const NSAppearanceNameAccessibilityAqua;
APPKIT_EXTERN NSAppearanceName const NSAppearanceNameAccessibilityDarkAqua;
APPKIT_EXTERN NSAppearanceName const NSAppearanceNameAccessibilityVibrantLight;
APPKIT_EXTERN NSAppearanceName const NSAppearanceNameAccessibilityVibrantDark;
APPKIT_EXTERN NSAppearanceName const NSAppearanceNameAccessibilityMediumLight;
NSAppearanceName const NSAppearanceNameVibrantLightVisibleBezels = @"NSAppearanceNameVibrantLightVisibleBezels";
NSAppearanceName const NSAppearanceNameAquaVisibleBezels = @"NSAppearanceNameAquaVisibleBezels";
NSAppearanceName const NSAppearanceNameVibrantDarkVisibleBezels = @"NSAppearanceNameVibrantDarkVisibleBezels";
NSAppearanceName const NSAppearanceNameDarkAquaVisibleBezels = @"NSAppearanceNameDarkAquaVisibleBezels";
NSAppearanceName const NSAppearanceNameAccessibilityGraphiteDarkAqua = @"NSAppearanceNameAccessibilityGraphiteDarkAqua";

@interface WindowDemoViewController () <ConfigurationViewDelegate, NSAppearanceCustomization> {
    double _lastTimestamp;
}
@property (retain, nonatomic, readonly, getter=_configurationView) ConfigurationView *configurationView;
@property (copy, nonatomic, nullable, getter=_stageChangedDate, setter=_setStageChangedDate:) NSDate *stageChangedDate;
@property (assign, nonatomic, getter=_preventsApplicationTerminationWhenModal, setter=_setPreventsApplicationTerminationWhenModal:) BOOL preventsApplicationTerminationWhenModal;
@property (retain, nonatomic, nullable, getter=_displayLink, setter=_setDisplayLink:) CADisplayLink *displayLink;
@end

@implementation WindowDemoViewController
@synthesize configurationView = _configurationView;
@synthesize appearance = _appearance;

- (void)dealloc {
    [_configurationView release];
    [_stageChangedDate release];
    [_appearance release];
    [_displayLink invalidate];
    [_displayLink release];
    [super dealloc];
}

- (NSAppearance *)effectiveAppearance {
    return self.appearance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.preventsApplicationTerminationWhenModal = YES;
    self.appearance = [NSAppearance currentDrawingAppearance];
    
    ConfigurationView *configurationView = self.configurationView;
    configurationView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    configurationView.frame = self.view.bounds;
    [self.view addSubview:configurationView];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_didChangeWindowActiveSpace:) name:MA_NSWindowActiveSpaceDidChangeNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_didChangeActiveSpace:) name:NSWorkspaceActiveSpaceDidChangeNotification object:NSWorkspace.sharedWorkspace];
}

- (void)_viewDidMoveToWindow:(NSWindow * _Nullable)newWindow fromWindow:(NSWindow * _Nullable)oldWindow {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL, id, id)>(objc_msgSendSuper2)(&superInfo, _cmd, newWindow, oldWindow);
    [self _reload];
    
    if (newWindow) {
        newWindow.appearanceSource = self;
    }
}

- (void)_didChangeWindowActiveSpace:(NSNotification *)notification {
    if ([notification.object isEqual:self.view.window]) {
        self.stageChangedDate = [NSDate now];
        [self _reload];
    }
}

- (void)_didChangeActiveSpace:(NSNotification *)notification {
    [self _reload];
}

- (ConfigurationView *)_configurationView {
    if (auto configurationView = _configurationView) return configurationView;
    
    ConfigurationView *configurationView = [ConfigurationView new];
    configurationView.delegate = self;
    configurationView.showBlendedBackground = NO;
    
    _configurationView = configurationView;
    return configurationView;
}

- (void)_reload {
    NSDiffableDataSourceSnapshot *snapshot = [NSDiffableDataSourceSnapshot new];
    [snapshot appendSectionsWithIdentifiers:@[[NSNull null]]];
    
#pragma mark - Items 1
    [snapshot appendItemsWithIdentifiers:@[
        [self _makeDisplayLinkItemModel],
        [self _makeSharingTypeItemModel],
        [self _makeCanBecomeVisibleWithoutLoginItemModel],
        [self _makeDeviceDescriptionItemModel],
        [self _makeWindowNumbersWithOptionsItemModel],
        [self _makeWindowNumberItemModel],
        [self _makeAppearanceItemModel],
        [self _makePreventsApplicationTerminationWhenModalItemModel],
        [self _makeContentBorderThicknessForMinYEdge],
        [self _makeAutorecalculatesContentBorderThicknessItemModel],
        [self _makeInvalidateShadowItemModel],
        [self _makeHasShadowItemModel],
        [self _makeOpaqueItemModel],
        [self _makeWorksWhenModalItemModel],
        [self _makeStageChangedDateItemModel],
        [self _makeCollectionBehaviorItemModel],
        [self _makeHidesOnDeactivateItemModel],
        [self _makeOnActiveSpaceItemModel],
        [self _makeCanHideItemModel],
        [self _makeDepthLimitItemModel],
        [self _makeWindowDepthAlertItemModel],
        [self _makeDefaultDepthLimitItemModel],
        [self _makeDynamicDepthLimitItemModel],
        [self _makeColorSpaceItemModel],
        [self _makeBackgroundColorItemModel],
        [self _makeAlphaValueItemModel],
        [self _makeToggleFullScreenItemModel],
        [self _makeStyleMaskItemModel]
    ]
               intoSectionWithIdentifier:[NSNull null]];
    
    [snapshot reloadItemsWithIdentifiers:snapshot.itemIdentifiers];
    
    [self.configurationView.dataSource applySnapshot:snapshot animatingDifferences:YES];
    [snapshot release];
}

- (ConfigurationItemModel *)_makeStyleMaskItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                          identifier:@"Style Mask"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return NSStringFromNSWindowStyleMask(unretainedSelf.view.window.styleMask);
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSUInteger count;
        NSWindowStyleMask *styleMasks = allNSWindowStyleMasks(&count);
        NSWindowStyleMask styleMask = unretainedSelf.view.window.styleMask;
        
        NSMutableArray<NSString *> *allTitles = [[NSMutableArray alloc] initWithCapacity:count];
        NSMutableArray<NSString *> *selectedTitles = [NSMutableArray new];
        
        for (NSWindowStyleMask *_styleMaskPtr : std::views::iota(styleMasks, styleMasks + count)) {
            NSWindowStyleMask _styleMask = *_styleMaskPtr;
            NSString *title = NSStringFromNSWindowStyleMask(_styleMask);
            
            [allTitles addObject:title];
            
            if (styleMask & _styleMask) {
                [selectedTitles addObject:title];
            } else if (styleMask == 0 and styleMask == _styleMask) {
                [selectedTitles addObject:title];
            }
        }
        
        ConfigurationPopUpButtonDescription *description = [ConfigurationPopUpButtonDescription descriptionWithTitles:allTitles selectedTitles:selectedTitles selectedDisplayTitle:selectedTitles.firstObject];
        [allTitles release];
        [selectedTitles release];
        
        return description;
    }];
}

- (ConfigurationItemModel *)_makeToggleFullScreenItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Toggle Full Screen"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
//        BOOL avkit_isFullscreen = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(unretainedSelf.view.window, sel_registerName("avkit_isFullscreen"));
//        return @(avkit_isFullscreen).stringValue;
        BOOL isFullScreen = unretainedSelf.view.window.styleMask & NSWindowStyleMaskFullScreen;
        return [NSString stringWithFormat:@"Toggle Full Screen (%@)", isFullScreen ? @"YES" : @"NO"];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
}

- (ConfigurationItemModel *)_makeAlphaValueItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSlider
                                          identifier:@"Alpha Value"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Alpha Value (%lf)", unretainedSelf.view.window.alphaValue];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationSliderDescription descriptionWithSliderValue:unretainedSelf.view.window.alphaValue minimumValue:0.1 maximumValue:1.0 continuous:YES];
    }];
}

- (ConfigurationItemModel *)_makeBackgroundColorItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeColorWell
                                          identifier:@"Background Color"
                                            userInfo:nil
                                               label:@"Background Color"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return unretainedSelf.view.window.backgroundColor;
    }];
}

- (ConfigurationItemModel *)_makeColorSpaceItemModel {
    __block auto unretainedSelf = self;
    
    ConfigurationItemModel *itemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                                                       identifier:@"Color Spaces"
                                                                         userInfo:nil
                                                                    label:@"ColorSpace"
                                                                    valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSArray<NSColorSpace *> *colorSpaces = NSColorSpace.ma_allColorSpaces;
        NSMutableArray<NSString *> *titles = [[NSMutableArray alloc] initWithCapacity:colorSpaces.count];
        for (NSColorSpace *colorSpace in colorSpaces) {
            NSString *name = colorSpace.localizedName;
            if (name == nil) {
                name = colorSpace.description;
            }
            
            [titles addObject:name];
        }
        [titles addObject:@"Default Color Space For Screen (-_defaultColorSpaceForScreen)"];
        
        //
        
        NSColorSpace *colorSpace = unretainedSelf.view.window.colorSpace;
        if (colorSpace == nil) {
            return @"nil";
        }
        NSString *name = colorSpace.localizedName;
        if (name == nil) {
            return colorSpace.description;
        }
        
        //
        
        ConfigurationPopUpButtonDescription *description = [ConfigurationPopUpButtonDescription descriptionWithTitles:titles selectedTitles:@[name] selectedDisplayTitle:name];
        [titles release];
        
        return description;
    }];
    
    return itemModel;
}

- (ConfigurationItemModel *)_makeDynamicDepthLimitItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                          identifier:@"Dynamic Depth Limit"
                                            userInfo:nil
                                               label:@"Dynamic Depth Limit"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return @(unretainedSelf.view.window.hasDynamicDepthLimit);
    }];
}

- (ConfigurationItemModel *)_makeDepthLimitItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                          identifier:@"Depth Limit"
                                            userInfo:nil
                                               label:@"Depth Limit"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSUInteger count;
        NSWindowDepth *depths = allNSWindowDepths(&count);
        
        NSMutableArray<NSString *> *titles = [[NSMutableArray alloc] initWithCapacity:count];
        for (NSWindowDepth *depthPtr : std::views::iota(depths, depths + count)) {
            NSWindowDepth depth = *depthPtr;
            [titles addObject:NSStringFromNSWindowDepth(depth)];
        }
        
        ConfigurationPopUpButtonDescription *description = [ConfigurationPopUpButtonDescription descriptionWithTitles:titles
                                                                                                       selectedTitles:@[NSStringFromNSWindowDepth(unretainedSelf.view.window.depthLimit)]
                                                                                                 selectedDisplayTitle:NSStringFromNSWindowDepth(unretainedSelf.view.window.depthLimit)];
        [titles release];
        
        return description;
    }];
}

- (ConfigurationItemModel *)_makeDefaultDepthLimitItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Default Depth Limit"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Default Depth Limit (%@)", NSStringFromNSWindowDepth(NSWindow.defaultDepthLimit)];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
}

- (ConfigurationItemModel *)_makeWindowDepthAlertItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                          identifier:@"Window Depth Alert"
                                            userInfo:nil
                                               label:@"Window Depth Alert"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSUInteger count;
        NSWindowDepth *depths = allNSWindowDepths(&count);
        
        NSMutableArray<NSString *> *titles = [[NSMutableArray alloc] initWithCapacity:count];
        for (NSWindowDepth *depthPtr : std::views::iota(depths, depths + count)) {
            NSWindowDepth depth = *depthPtr;
            [titles addObject:NSStringFromNSWindowDepth(depth)];
        }
        
        ConfigurationPopUpButtonDescription *description = [ConfigurationPopUpButtonDescription descriptionWithTitles:titles
                                                                                                       selectedTitles:@[]
                                                                                                 selectedDisplayTitle:nil];
        [titles release];
        
        return description;
    }];
}

- (ConfigurationItemModel *)_makeCanHideItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                          identifier:@"Can Hide"
                                            userInfo:nil
                                               label:@"Can Hide"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return @(unretainedSelf.view.window.canHide);
    }];
}

- (ConfigurationItemModel *)_makeOnActiveSpaceItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeLabel
                                          identifier:@"On Active Space"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"On Active Space: %@", unretainedSelf.view.window.onActiveSpace ? @"YES" : @"NO"];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
}

- (ConfigurationItemModel *)_makeHidesOnDeactivateItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                          identifier:@"Hides On Deactivate"
                                            userInfo:nil
                                               label:@"Hides On Deactivate"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return @(unretainedSelf.view.window.hidesOnDeactivate);
    }];
}

- (ConfigurationItemModel *)_makeCollectionBehaviorItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                          identifier:@"Collection Behavior"
                                            userInfo:nil
                                               label:@"Collection Behavior"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSUInteger count;
        NSWindowCollectionBehavior *allBehaviors = allNSWindowCollectionBehaviors(&count);
        
        NSMutableArray<NSString *> *titles = [[NSMutableArray alloc] initWithCapacity:count];
        NSMutableArray<NSString *> *selectedTitles = [NSMutableArray new];
        
        for (NSWindowCollectionBehavior *behaviorPtr : std::views::iota(allBehaviors, allBehaviors + count)) {
            NSWindowCollectionBehavior behavior = *behaviorPtr;
            NSString *string = NSStringFromNSWindowCollectionBehavior(behavior);
            [titles addObject:string];
            
            if (unretainedSelf.view.window.collectionBehavior & behavior) {
                [selectedTitles addObject:string];
            }
        }
        
        if (unretainedSelf.view.window.collectionBehavior == NSWindowCollectionBehaviorDefault) {
            [selectedTitles addObject:NSStringFromNSWindowCollectionBehavior(NSWindowCollectionBehaviorDefault)];
        }
        
        ConfigurationPopUpButtonDescription *description = [ConfigurationPopUpButtonDescription descriptionWithTitles:titles selectedTitles:selectedTitles selectedDisplayTitle:selectedTitles.firstObject];
        [titles release];
        [selectedTitles release];
        
        return description;
    }];
}

- (ConfigurationItemModel *)_makeStageChangedDateItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeLabel
                                          identifier:@"Stage Changed Date"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        if (NSDate *date = unretainedSelf.stageChangedDate) {
            return [NSString stringWithFormat:@"Stage Changed: %@", date];
        } else {
            return @"(null)";
        }
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
}

- (ConfigurationItemModel *)_makeWorksWhenModalItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeLabel
                                          identifier:@"Works When Model"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Works When Model : %@", unretainedSelf.view.window.worksWhenModal ? @"YES" : @"NO"];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
}

- (ConfigurationItemModel *)_makeOpaqueItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                          identifier:@"Opaque"
                                            userInfo:nil
                                               label:@"Opaque"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return @(unretainedSelf.view.window.opaque);
    }];
}

- (ConfigurationItemModel *)_makeHasShadowItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                          identifier:@"Has Shadow"
                                            userInfo:nil
                                               label:@"Has Shadow"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return @(unretainedSelf.view.window.hasShadow);
    }];
}

- (ConfigurationItemModel *)_makeInvalidateShadowItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Invalidate Shadow"
                                            userInfo:nil
                                               label:@"Invalidate Shadow"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
}

- (ConfigurationItemModel *)_makeAutorecalculatesContentBorderThicknessItemModel {
    // https://x.com/_silgen_name/status/1889699057071010212
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                          identifier:@"Autorecalculates Content Border Thickness"
                                            userInfo:nil
                                               label:@"Autorecalculates Content Border Thickness"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSUInteger count;
        NSRectEdge *allEdges = allNSRectEdges(&count);
        
        auto titlesVector = std::views::iota(allEdges, allEdges + count)
        | std::views::transform([](NSRectEdge *ptr) { return *ptr; })
        | std::views::transform([](NSRectEdge edge) -> NSString * {
            return NSStringFromNSRectEdge(edge);
        })
        | std::ranges::to<std::vector<NSString *>>();
        
        auto selectedTitlesVector = std::views::iota(allEdges, allEdges + count)
        | std::views::transform([](NSRectEdge *ptr) { return *ptr; })
        | std::views::filter([window = unretainedSelf.view.window](NSRectEdge edge) {
            return [window autorecalculatesContentBorderThicknessForEdge:edge];
        })
        | std::views::transform([](NSRectEdge edge) -> NSString * {
            return NSStringFromNSRectEdge(edge);
        })
        | std::ranges::to<std::vector<NSString *>>();
        
        return [ConfigurationPopUpButtonDescription descriptionWithTitles:[NSArray arrayWithObjects:titlesVector.data() count:titlesVector.size()]
                                                           selectedTitles:[NSArray arrayWithObjects:selectedTitlesVector.data() count:selectedTitlesVector.size()]
                                                     selectedDisplayTitle:[NSArray arrayWithObjects:selectedTitlesVector.data() count:selectedTitlesVector.size()].firstObject];
    }];
}

- (ConfigurationItemModel *)_makeContentBorderThicknessForMinYEdge {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSlider
                                          identifier:@"Content Border Thickness (MinY Edge)"
                                            userInfo:nil
                                               label:@"Content Border Thickness (MinY Edge)"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        CGFloat value = [unretainedSelf.view.window contentBorderThicknessForEdge:NSRectEdgeMinY];
        
        return [ConfigurationSliderDescription descriptionWithSliderValue:value
                                                             minimumValue:0. maximumValue:50.
                                                               continuous:YES];
    }];
}

- (ConfigurationItemModel *)_makePreventsApplicationTerminationWhenModalItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                          identifier:@"Prevents Application Termination When Modal"
                                            userInfo:nil
                                               label:@"Prevents Application Termination When Modal"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return @(unretainedSelf.preventsApplicationTerminationWhenModal);
    }];
}

- (ConfigurationItemModel *)_makeAppearanceItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                          identifier:@"Appearance"
                                            userInfo:nil
                                               label:@"Appearance"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSArray<NSAppearanceName> *appearanceNames = @[
            NSAppearanceNameCandidateBar,
            NSAppearanceNameSystem,
            NSAppearanceNameAccessibilitySystem,
            NSAppearanceNameAqua,
            NSAppearanceNameLightContent,
            NSAppearanceNameVibrantDark,
            NSAppearanceNameVibrantLight,
            NSAppearanceNameFunctionRow,
            NSAppearanceNameControlStrip,
            NSAppearanceNameTouchBarCustomizationPalette,
            NSAppearanceNameControlStripCustomizationPalette,
            NSAppearanceNameMediumLight,
            NSAppearanceNameDarkAqua,
            NSAppearanceNameAccessibilityAqua,
            NSAppearanceNameAccessibilityDarkAqua,
            NSAppearanceNameAccessibilityVibrantLight,
            NSAppearanceNameAccessibilityVibrantDark,
            NSAppearanceNameAccessibilityMediumLight,
            NSAppearanceNameVibrantLightVisibleBezels,
            NSAppearanceNameAquaVisibleBezels,
            NSAppearanceNameVibrantDarkVisibleBezels,
            NSAppearanceNameDarkAquaVisibleBezels,
            NSAppearanceNameAccessibilityGraphiteDarkAqua
        ];
        
        return [ConfigurationPopUpButtonDescription descriptionWithTitles:appearanceNames
                                                           selectedTitles:@[unretainedSelf.appearance.name]
                                                     selectedDisplayTitle:unretainedSelf.appearance.name];
    }];
}

- (ConfigurationItemModel *)_makeWindowNumberItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeLabel
                                          identifier:@"Window Number"
                                            userInfo:nil
                                               label:[NSString stringWithFormat:@"Window Number (%ld)", self.view.window.windowNumber]
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
}

- (ConfigurationItemModel *)_makeWindowNumbersWithOptionsItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                          identifier:@"Window Numbers With Options"
                                            userInfo:nil
                                               label:@"Window Numbers With Options"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSUInteger count;
        NSWindowNumberListOptions *allOptions = allNSWindowNumberListOptions(&count);
        
        auto optionTitlesVector = std::views::iota(allOptions, allOptions + count)
        | std::views::transform([](NSWindowNumberListOptions *ptr) -> NSWindowNumberListOptions { return *ptr; })
        | std::views::transform([](NSWindowNumberListOptions option) -> NSString * {
            return NSStringFromNSWindowNumberListOptions(option);
        })
        | std::ranges::to<std::vector<NSString *>>();
        
        return [ConfigurationPopUpButtonDescription descriptionWithTitles:[NSArray arrayWithObjects:optionTitlesVector.data() count:optionTitlesVector.size()]
                                                           selectedTitles:@[]
                                                     selectedDisplayTitle:nil];
    }];
}

- (ConfigurationItemModel *)_makeDeviceDescriptionItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Device Description"
                                            userInfo:nil
                                               label:@"Device Description"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
}

- (ConfigurationItemModel *)_makeCanBecomeVisibleWithoutLoginItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                          identifier:@"Can Become Visible Without Login"
                                            userInfo:nil
                                               label:@"Can Become Visible Without Login"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return @(unretainedSelf.view.window.canBecomeVisibleWithoutLogin);
    }];
}

- (ConfigurationItemModel *)_makeSharingTypeItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                          identifier:@"Sharing Type"
                                            userInfo:nil
                                               label:@"Sharing Type"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSUInteger count;
        NSWindowSharingType *allTypes = allNSWindowSharingTypes(&count);
        
        auto titlesVector = std::views::iota(allTypes, allTypes + count)
        | std::views::transform([](NSWindowSharingType *ptr) { return *ptr; })
        | std::views::transform([](NSWindowSharingType type) {
            return NSStringFromNSWindowSharingType(type);
        })
        | std::ranges::to<std::vector<NSString *>>();
        
        NSWindowSharingType selectedType = unretainedSelf.view.window.sharingType;
        
        return [ConfigurationPopUpButtonDescription descriptionWithTitles:[NSArray arrayWithObjects:titlesVector.data() count:titlesVector.size()]
                                                           selectedTitles:@[NSStringFromNSWindowSharingType(selectedType)]
                                                     selectedDisplayTitle:NSStringFromNSWindowSharingType(selectedType)];
    }];
}

- (ConfigurationItemModel *)_makeDisplayLinkItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                          identifier:@"Display Link"
                                            userInfo:nil
                                               label:@"Display Link"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        CADisplayLink * _Nullable displayLink = unretainedSelf.displayLink;
        if (displayLink == nil) {
            return @(NO);
        }
        
        return @(!displayLink.paused);
    }];
}

- (void)_didTriggerDisplayLink:(CADisplayLink *)sender {
    if (_lastTimestamp == 0.0) {
        _lastTimestamp = sender.timestamp;
    }
    
    double a = fmod((sender.timestamp - _lastTimestamp), 4.0) / 4.0;
    
    if (a <= 0.5) {
        a *= 2.0;
    } else {
        a = 2.0 - (a * 2.0);
    }
    
    a = 0.3 + a * (1.0 / 0.7);
    
    self.view.window.alphaValue = a;
}


#pragma mark - Items 2

- (void)didTriggerReloadButtonWithConfigurationView:(ConfigurationView *)configurationView {
    [self _reload];
}

- (BOOL)configurationView:(ConfigurationView *)configurationView didTriggerActionWithItemModel:(ConfigurationItemModel *)itemModel newValue:(nonnull id<NSCopying>)newValue {
    NSWindow *window = self.view.window;
    NSString *identifier = itemModel.identifier;
    
    if ([identifier isEqualToString:@"Style Mask"]) {
        NSWindowStyleMask incomingStyleMask = NSWindowStyleMaskFromString(static_cast<NSString *>(newValue));
        NSWindowStyleMask styleMask = window.styleMask;
        
        if (styleMask & incomingStyleMask) {
            styleMask &= ~incomingStyleMask;
        } else {
            styleMask |= incomingStyleMask;
        }
        
        window.styleMask = styleMask;
        return YES;
    } else if ([identifier isEqualToString:@"Toggle Full Screen"]) {
        [window toggleFullScreen:nil];
        return YES;
    } else if ([identifier isEqualToString:@"Alpha Value"]) {
#if CGFLOAT_IS_DOUBLE
        window.alphaValue = static_cast<NSNumber *>(newValue).doubleValue;
#else
        window.alphaValue = static_cast<NSNumber *>(newValue).floatValue;
#endif
        return NO;
    } else if ([identifier isEqualToString:@"Background Color"]) {
        window.backgroundColor = static_cast<NSColor *>(newValue);
        return NO;
    } else if ([identifier isEqualToString:@"Color Spaces"]) {
        auto title = static_cast<NSString *>(newValue);
        
        BOOL found = NO;
        for (NSColorSpace *colorSpace in NSColorSpace.ma_allColorSpaces) {
            if ([colorSpace.localizedName isEqualToString:title] or [colorSpace.description isEqualToString:title]) {
                window.colorSpace = colorSpace;
                found = YES;
                break;
            }
        }
        
        if (!found) {
            // or colorSpace = nil
            window.colorSpace = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(window, sel_registerName("_defaultColorSpaceForScreen"));
        }
        return YES;
    } else if ([identifier isEqualToString:@"Dynamic Depth Limit"]) {
        [window setDynamicDepthLimit:static_cast<NSNumber *>(newValue).boolValue];
        [self _reload];
        return NO;
    } else if ([identifier isEqualToString:@"Depth Limit"]) {
        window.depthLimit = NSWindowDepthFromString(static_cast<NSString *>(newValue));
        [self _reload];
        return NO;
    } else if ([identifier isEqualToString:@"Default Depth Limit"]) {
        window.depthLimit = NSWindow.defaultDepthLimit;
        [self _reload];
        return NO;
    } else if ([identifier isEqualToString:@"Window Depth Alert"]) {
        NSWindowDepth windowDepth = NSWindowDepthFromString(static_cast<NSString *>(newValue));
        NSInteger bitsPerPixel = NSBitsPerPixelFromDepth(windowDepth);
        NSInteger bitsPerSample = NSBitsPerSampleFromDepth(windowDepth);
        NSColorSpaceName colorSpaceName = NSColorSpaceFromDepth(windowDepth);
        BOOL planar = NSPlanarFromDepth(windowDepth);
        
        NSAlert *alert = [NSAlert new];
        alert.alertStyle = NSAlertStyleInformational;
        alert.messageText = static_cast<NSString *>(newValue);
        alert.informativeText = [NSString stringWithFormat:@"bitsPerPixel: %ld\nbitsPerSample: %ld\ncolorSpaceName: %@\nplanar: %@", bitsPerPixel, bitsPerSample, colorSpaceName, (planar ? @"YES" : @"NO")];
        
        [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
            
        }];
        [alert release];
        
        return NO;
    } else if ([identifier isEqualToString:@"Can Hide"]) {
        window.canHide = static_cast<NSNumber *>(newValue).boolValue;
        return NO;
    } else if ([identifier isEqualToString:@"Hides On Deactivate"]) {
        window.hidesOnDeactivate = static_cast<NSNumber *>(newValue).boolValue;
        return NO;
    } else if ([identifier isEqualToString:@"Collection Behavior"]) {
        auto title = static_cast<NSString *>(newValue);
        auto behavior = NSWindowCollectionBehaviorFromString(title);
        
        if (window.collectionBehavior & behavior) {
            window.collectionBehavior = (window.collectionBehavior & ~behavior);
        } else {
            window.collectionBehavior = (window.collectionBehavior | behavior);
        }
        
        return YES;
    } else if ([identifier isEqualToString:@"Opaque"]) {
        window.opaque = static_cast<NSNumber *>(newValue).boolValue;
        [self _reload];
        return NO;
    } else if ([identifier isEqualToString:@"Has Shadow"]) {
        window.hasShadow = static_cast<NSNumber *>(newValue).boolValue;
        [self _reload];
        return NO;
    } else if ([identifier isEqualToString:@"Invalidate Shadow"]) {
        [window invalidateShadow];
        return NO;
    } else if ([identifier isEqualToString:@"Autorecalculates Content Border Thickness"]) {
        auto title = static_cast<NSString *>(newValue);
        NSRectEdge edge = NSRectEdgeFromString(title);
        
        if ([window autorecalculatesContentBorderThicknessForEdge:edge]) {
            [window setAutorecalculatesContentBorderThickness:NO forEdge:edge];
        } else {
            [window setAutorecalculatesContentBorderThickness:YES forEdge:edge];
        }
        
        [self _reload];
        return NO;
    } else if ([identifier isEqualToString:@"Content Border Thickness (MinY Edge)"]) {
        auto value = static_cast<NSNumber *>(newValue);
        
#if CGFLOAT_IS_DOUBLE
        [window setContentBorderThickness:value.doubleValue forEdge:NSRectEdgeMinY];
#else
        [window setContentBorderThickness:value.floatValue forEdge:NSRectEdgeMinY];
#endif
        
        id _auxiliaryStorage;
        assert(object_getInstanceVariable(window, "_auxiliaryStorage", reinterpret_cast<void **>(&_auxiliaryStorage)) != NULL);
        
        return NO;
    } else if ([identifier isEqualToString:@"Prevents Application Termination When Modal"]) {
        auto value = static_cast<NSNumber *>(newValue);
        self.preventsApplicationTerminationWhenModal = value.boolValue;
        
        NSAlert *alert = [NSAlert new];
        alert.alertStyle = NSAlertStyleInformational;
        alert.messageText = @"Alert";
        
        [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
            
        }];
        
        for (NSWindow *sheet in window.sheets) {
            sheet.preventsApplicationTerminationWhenModal = value.boolValue;
        }
        
        [alert release];
        
        [self _reload];
        return NO;
    } else if ([identifier isEqualToString:@"Appearance"]) {
        auto value = static_cast<NSString *>(newValue);
        [self willChangeValueForKey:@"effectiveAppearance"];
        self.appearance = [NSAppearance appearanceNamed:value];
        [self didChangeValueForKey:@"effectiveAppearance"];
        
        [self _reload];
        return NO;
    } else if ([identifier isEqualToString:@"Window Numbers With Options"]) {
        auto value = static_cast<NSString *>(newValue);
        NSWindowNumberListOptions options = NSWindowNumberListOptionsFromString(value);
        NSArray<NSNumber *> *windowNumbersWithOptions = [NSWindow windowNumbersWithOptions:options];
        
        NSAlert *alert = [NSAlert new];
        alert.alertStyle = NSAlertStyleInformational;
        alert.messageText = [NSString stringWithFormat:@"Window Numbers (%@)", NSStringFromNSWindowNumberListOptions(options)];
        alert.informativeText = [windowNumbersWithOptions componentsJoinedByString:@", "];
        
        [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
            
        }];
        
        [alert release];
        return NO;
    } else if ([identifier isEqualToString:@"Device Description"]) {
        NSDictionary<NSDeviceDescriptionKey, id> *deviceDescription = window.deviceDescription;
        
        NSAlert *alert = [NSAlert new];
        alert.alertStyle = NSAlertStyleInformational;
        alert.messageText = @"Device Description";
        alert.informativeText = deviceDescription.description;
        
        [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
            
        }];
        
        [alert release];
        return NO;
    } else if ([identifier isEqualToString:@"Can Become Visible Without Login"]) {
        auto value = static_cast<NSNumber *>(newValue);
        window.canBecomeVisibleWithoutLogin = value.boolValue;
        return YES;
    } else if ([identifier isEqualToString:@"Sharing Type"]) {
        auto title = static_cast<NSString *>(newValue);
        NSWindowSharingType type = NSWindowSharingTypeFromString(title);
        window.sharingType = type;
        [self _reload];
        return NO;
    } else if ([identifier isEqualToString:@"Display Link"]) {
        auto boolValue = static_cast<NSNumber *>(newValue).boolValue;
        
        if (CADisplayLink *displayLink = self.displayLink) {
            displayLink.paused = !boolValue;
            
            if (!boolValue) {
                window.alphaValue = 1.;
            }
        } else {
            assert(boolValue);
            CADisplayLink *_displayLink = [window displayLinkWithTarget:self selector:@selector(_didTriggerDisplayLink:)];
            self.displayLink = _displayLink;
            [_displayLink addToRunLoop:NSRunLoop.currentRunLoop forMode:NSRunLoopCommonModes];
        }
        
        [self _reload];
        return NO;
    } else {
        abort();
    }
#pragma mark - Actions
}

@end
