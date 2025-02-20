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
#import "NSStringFromNSModalResponse.h"
#import "MainWindowController.h"
#import "RectSlidersView.h"
#import "UnsafeDebouncer.h"
#include <math.h>
#import "NSStringFromNSEventModifierFlags.h"
#import "WindowDemoView.h"
#import "NSStringFromNSWindowLevel.h"
#import "WindowDemoSetFrameUsingNameView.h"
#import "WindowDemoWindow.h"
#import "NSStringFromNSWindowOrderingMode.h"
#import "ActionResolver.h"
#import "WindowButtonsView.h"
#import "NSStringFromNSWindowToolbarStyle.h"
#import "NSStringFromNSTitlebarSeparatorStyle.h"
#import "NSStringFromNSUserInterfaceLayoutDirection.h"
#import "WindowDemoTitlebarAccessoryViewController.h"
#import "NSStringFromNSWindowUserTabbingPreference.h"
#import <CoreFoundation/CoreFoundation.h>
#import "NSStringFromNSWindowTabbingMode.h"

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

APPKIT_EXTERN NSNotificationName const NSAppleNoRedisplayAppearancePreferenceChanged;

@interface WindowDemoViewController () <ConfigurationViewDelegate, NSAppearanceCustomization, NSToolbarDelegate> {
    double _lastTimestamp;
}
@property (retain, nonatomic, readonly, getter=_ownView) WindowDemoView *ownView;
@property (retain, nonatomic, readonly, getter=_configurationView) ConfigurationView *configurationView;
@property (retain, nonatomic, readonly, getter=_toolbar) NSToolbar *toolbar;
@property (copy, nonatomic, nullable, getter=_stageChangedDate, setter=_setStageChangedDate:) NSDate *stageChangedDate;
@property (assign, nonatomic, getter=_preventsApplicationTerminationWhenModal, setter=_setPreventsApplicationTerminationWhenModal:) BOOL preventsApplicationTerminationWhenModal;
@property (retain, nonatomic, nullable, getter=_displayLink, setter=_setDisplayLink:) CADisplayLink *displayLink;
@property (retain, nonatomic, readonly, getter=_reloadWhenFrameChangedDebouncer) UnsafeDebouncer *reloadWhenFrameChangedDebouncer;
@property (assign, nonatomic, getter=_animationResizeTimeRect, setter=_setAnimationResizeTimeRect:) NSRect animationResizeTimeRect;
@property (retain, nonatomic, readonly, getter=_windowDefaultButton) NSButton *windowDefaultButton;
@property (retain, nonatomic, getter=_windowFieldEditorScrollView, setter=_setWindowFieldEditorScrollView:) NSScrollView *windowFieldEditorScrollView;
@end

@implementation WindowDemoViewController
@synthesize ownView = _ownView;
@synthesize configurationView = _configurationView;
@synthesize toolbar = _toolbar;
@synthesize appearance = _appearance;
@synthesize windowDefaultButton = _windowDefaultButton;
@synthesize windowFieldEditorScrollView = _windowFieldEditorScrollView;

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
    [NSDistributedNotificationCenter.defaultCenter removeObserver:self];
    [_ownView release];
    [_configurationView release];
    [_toolbar release];
    [_stageChangedDate release];
    [_appearance release];
    [_displayLink invalidate];
    [_displayLink release];
    [_reloadWhenFrameChangedDebouncer cancelPendingBlock];
    [_reloadWhenFrameChangedDebouncer release];
    [_windowDefaultButton release];
    [_windowFieldEditorScrollView release];
    
    if (NSWindow *window = self.view.window) {
        [window removeObserver:self forKeyPath:@"contentLayoutRect"];
        [window removeObserver:self forKeyPath:@"tabGroup"];
    }
    
    [super dealloc];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    BOOL responds = [super respondsToSelector:aSelector];
    
    if (!responds) {
        NSLog(@"%s", sel_getName(aSelector));
    }
    
    return responds;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentLayoutRect"]) {
        if ([object isKindOfClass:[NSWindow class]]) {
            assert([self.view.window isEqual:object]);
    //        [self.configurationView reconfigureItemModelsWithIdentifiers:@[@"Content Layout Rect"]];
            [self.reloadWhenFrameChangedDebouncer scheduleBlock:^(BOOL cancelled) {
                if (cancelled) return;
                [self _reload];
            }];
            return;
        }
    } else if ([keyPath isEqualToString:@"tabGroup"]) {
        if ([object isKindOfClass:[NSWindow class]]) {
            assert([self.view.window isEqual:object]);
            
            if (NSWindowTabGroup *oldTabGroup = change[NSKeyValueChangeOldKey]) {
                if (![oldTabGroup isKindOfClass:[NSNull class]]) {
                    [oldTabGroup removeObserver:self forKeyPath:@"windows"];
                }
            }
            
            NSWindowTabGroup *newTabGroup = change[NSKeyValueChangeNewKey];
            if (newTabGroup == nil) newTabGroup = self.view.window.tabGroup;
            if ([newTabGroup isKindOfClass:[NSNull class]]) newTabGroup = self.view.window.tabGroup;
            
            if (newTabGroup != nil) {
                [newTabGroup addObserver:self forKeyPath:@"windows" options:NSKeyValueObservingOptionNew context:NULL];
                [self _reconfigureTabItemModels];
            }
            
            return;
        }
    } else if ([keyPath isEqual:@"windows"]) {
        if ([object isKindOfClass:[NSWindowTabGroup class]]) {
            assert([self.view.window.tabGroup isEqual:object]);
            [self _reconfigureTabItemModels];
            return;
        }
    }
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (NSAppearance *)effectiveAppearance {
    return self.appearance;
}

- (void)loadView {
    self.view = self.ownView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UnsafeDebouncer *reloadWhenFrameChangedDebouncer = [[UnsafeDebouncer alloc] initWithTimeInterval:1. modes:@[NSRunLoopCommonModes, NSEventTrackingRunLoopMode]];
    _reloadWhenFrameChangedDebouncer = reloadWhenFrameChangedDebouncer;
    
    self.preventsApplicationTerminationWhenModal = YES;
    self.appearance = [NSAppearance currentDrawingAppearance];
    
    ConfigurationView *configurationView = self.configurationView;
    configurationView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    configurationView.frame = self.ownView.bounds;
    [self.ownView addSubview:configurationView];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_didChangeWindowActiveSpace:) name:MA_NSWindowActiveSpaceDidChangeNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_didChangeActiveSpace:) name:NSWorkspaceActiveSpaceDidChangeNotification object:NSWorkspace.sharedWorkspace];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_rectSlidersViewDidChangeValue:) name:RectSlidersViewDidChangeValueNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_didResizeWindow:) name:NSWindowDidResizeNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_didMoveWindow:) name:NSWindowDidMoveNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_didEndSheet:) name:NSWindowDidEndSheetNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_didChangeOcclusionState:) name:NSWindowDidChangeOcclusionStateNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_didChangeUserDefaults:) name:NSUserDefaultsDidChangeNotification object:NSUserDefaults.standardUserDefaults];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_windowDidBecomeKey:) name:NSWindowDidBecomeKeyNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_windowDidResignKey:) name:NSWindowDidResignKeyNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_windowDidBecomeMain:) name:NSWindowDidBecomeMainNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_windowDidResignMain:) name:NSWindowDidResignMainNotification object:nil];
    
    [NSDistributedNotificationCenter.defaultCenter addObserver:self
                                                      selector:@selector(_didChangeAppearancePreference:)
                                                          name:NSAppleNoRedisplayAppearancePreferenceChanged
                                                        object:nil];
}

- (void)_viewDidMoveToWindow:(NSWindow * _Nullable)newWindow fromWindow:(NSWindow * _Nullable)oldWindow {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL, id, id)>(objc_msgSendSuper2)(&superInfo, _cmd, newWindow, oldWindow);
    [self _reload];
    
    if (oldWindow) {
        oldWindow.appearanceSource = nil;
        [oldWindow removeObserver:self forKeyPath:@"contentLayoutRect"];
        [oldWindow removeObserver:self forKeyPath:@"tabGroup"];
        oldWindow.toolbar = nil;
        oldWindow.defaultButtonCell = nil;
    }
    
    if (newWindow) {
        newWindow.appearanceSource = self;
        [newWindow addObserver:self forKeyPath:@"contentLayoutRect" options:NSKeyValueObservingOptionNew context:NULL];
        [newWindow addObserver:self forKeyPath:@"tabGroup" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:NULL];
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

- (void)_rectSlidersViewDidChangeValue:(NSNotification *)notification {
    RectSlidersConfiguration *configuration = notification.userInfo[RectSlidersConfigurationKey];
    
    NSValue *selfValue = configuration.userInfo[@"selfValue"];
    if (selfValue == nil) return;
    if (self != selfValue.pointerValue) return;
    
    NSString *action = configuration.userInfo[@"action"];
    BOOL isTracking = static_cast<NSNumber *>(notification.userInfo[RectSlidersIsTrackingKey]).boolValue;
    
    if ([action isEqualToString:@"setFrame:display:animate:"]) {
        [self.view.window setFrame:configuration.rect display:NO animate:NO];
    } else if ([action isEqualToString:@"setFrameOrigin:"]) {
        [self.view.window setFrameOrigin:configuration.rect.origin];
    } else if ([action isEqualToString:@"setFrameTopLeftPoint:"]) {
        [self.view.window setFrameTopLeftPoint:configuration.rect.origin];
    } else if ([action isEqualToString:@"constrainFrameRect:toScreen:"]) {
        NSRect finalRect = [self.view.window constrainFrameRect:configuration.rect toScreen:nil];
        NSLog(@"Height : %lf", NSHeight(finalRect));
    } else if ([action isEqualToString:@"cascadeTopLeftFromPoint:"]) {
        NSPoint point = [self.view.window cascadeTopLeftFromPoint:configuration.rect.origin];
    } else if ([action isEqualToString:@"animationResizeTimeRect"]) {
        self.animationResizeTimeRect = configuration.rect;
        [self.configurationView reconfigureItemModelsWithIdentifiers:@[@"Animation Resize Time"]];
    } else if ([action isEqualToString:@"aspectRatio"]) {
        self.view.window.aspectRatio = configuration.rect.size;
        [self.configurationView reconfigureItemModelsWithIdentifiers:@[@"Aspect Ratio", @"Resize Increments", @"Content Aspect Ratio"]];
    } else if ([action isEqualToString:@"resizeIncrements"]) {
        self.view.window.resizeIncrements = configuration.rect.size;
        [self.configurationView reconfigureItemModelsWithIdentifiers:@[@"Aspect Ratio", @"Resize Increments", @"Content Aspect Ratio"]];
    } else if ([action isEqualToString:@"contentAspectRatio"]) {
        self.view.window.contentAspectRatio = configuration.rect.size;
        [self.configurationView reconfigureItemModelsWithIdentifiers:@[@"Aspect Ratio", @"Resize Increments", @"Content Aspect Ratio"]];
    } else if ([action isEqualToString:@"minSize"]) {
        self.view.window.minSize = configuration.rect.size;
        if (!isTracking) {
            [self.configurationView reconfigureItemModelsWithIdentifiers:@[@"Max Size"]];
        }
    } else if ([action isEqualToString:@"maxSize"]) {
        self.view.window.maxSize = configuration.rect.size;
        if (!isTracking) {
            [self.configurationView reconfigureItemModelsWithIdentifiers:@[@"Min Size"]];
        }
    } else if ([action isEqualToString:@"contentMinSize"]) {
        self.view.window.contentMinSize = configuration.rect.size;
        if (!isTracking) {
            [self.configurationView reconfigureItemModelsWithIdentifiers:@[@"Content Max Size"]];
        }
    } else if ([action isEqualToString:@"contentMaxSize"]) {
        self.view.window.contentMaxSize = configuration.rect.size;
        if (!isTracking) {
            [self.configurationView reconfigureItemModelsWithIdentifiers:@[@"Content Min Size"]];
        }
    } else if ([action isEqualToString:@"setContentSize:"]) {
        [self.view.window setContentSize:configuration.rect.size];
        [self.configurationView reconfigureItemModelsWithIdentifiers:@[@"Frame", @"contentRectForFrameRect:"]];
    } else if ([action isEqualToString:@"minFullScreenContentSize"]) {
        self.view.window.minFullScreenContentSize = configuration.rect.size;
        [self.configurationView reconfigureItemModelsWithIdentifiers:@[@"Max Full Screen Content Size"]];
    } else if ([action isEqualToString:@"maxFullScreenContentSize"]) {
        self.view.window.maxFullScreenContentSize = configuration.rect.size;
        [self.configurationView reconfigureItemModelsWithIdentifiers:@[@"Min Full Screen Content Size"]];
    } else {
        abort();
    }
}

- (void)_didResizeWindow:(NSNotification *)notification {
    NSWindow *window = self.view.window;
    if (window == nil) return;
    if (![notification.object isEqual:window]) return;
    
    [self.reloadWhenFrameChangedDebouncer scheduleBlock:^(BOOL cancelled) {
        if (cancelled) return;
        [self _reload];
    }];
}

- (void)_didMoveWindow:(NSNotification *)notification {
    NSWindow *window = self.view.window;
    if (window == nil) return;
    if (![notification.object isEqual:window]) return;
    
    [self.reloadWhenFrameChangedDebouncer scheduleBlock:^(BOOL cancelled) {
        if (cancelled) return;
        [self _reload];
    }];
}

- (void)_didEndSheet:(NSNotification *)notification {
    [self _reload];
}

- (void)_didChangeOcclusionState:(NSNotification *)notification {
    NSWindow *window = self.view.window;
    if (window == nil) return;
    if (![notification.object isEqual:window]) return;
    
    [self.configurationView reconfigureItemModelsWithIdentifiers:@[@"Occlusion State"]];
}

- (void)_didChangeUserDefaults:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.reloadWhenFrameChangedDebouncer scheduleBlock:^(BOOL cancelled) {
            [self.configurationView reconfigureItemModelsWithIdentifiers:@[@"String With Saved Frame"]];
        }];
    });
}

- (void)_windowDidBecomeKey:(NSNotification *)notification {
    NSWindow *window = self.view.window;
    if (window == nil) return;
    if (![notification.object isEqual:window]) return;
    
    [self.configurationView reconfigureItemModelsWithIdentifiers:@[@"Key Window"]];
}

- (void)_windowDidResignKey:(NSNotification *)notification {
    NSWindow *window = self.view.window;
    if (window == nil) return;
    if (![notification.object isEqual:window]) return;
    
    [self.configurationView reconfigureItemModelsWithIdentifiers:@[@"Key Window"]];
}

- (void)_windowDidBecomeMain:(NSNotification *)notification {
    NSWindow *window = self.view.window;
    if (window == nil) return;
    if (![notification.object isEqual:window]) return;
    
    [self.configurationView reconfigureItemModelsWithIdentifiers:@[@"Main Window"]];
}

- (void)_windowDidResignMain:(NSNotification *)notification {
    NSWindow *window = self.view.window;
    if (window == nil) return;
    if (![notification.object isEqual:window]) return;
    
    [self.configurationView reconfigureItemModelsWithIdentifiers:@[@"Main Window"]];
}

- (void)_didChangeAppearancePreference:(NSNotification *)notification {
    reinterpret_cast<void (*)(Class, SEL)>(objc_msgSend)([NSWindow class], sel_registerName("_updateTabbingModePreference"));
    [self.configurationView reconfigureItemModelsWithIdentifiers:@[@"User Tabbing Preference"]];
}

- (WindowDemoView *)_ownView {
    if (auto ownView = _ownView) return ownView;
    
    WindowDemoView *ownView = [WindowDemoView new];
    
    _ownView = ownView;
    return ownView;
}

- (ConfigurationView *)_configurationView {
    if (auto configurationView = _configurationView) return configurationView;
    
    ConfigurationView *configurationView = [ConfigurationView new];
    configurationView.delegate = self;
    configurationView.showBlendedBackground = NO;
    
    _configurationView = configurationView;
    return configurationView;
}

- (NSToolbar *)_toolbar {
    if (auto toolbar = _toolbar) return toolbar;
    
    NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:@"WindowDemo Toolbar"];
    toolbar.delegate = self;
    toolbar.allowsUserCustomization = YES;
    toolbar.displayMode = NSToolbarDisplayModeIconAndLabel;
    
    _toolbar = toolbar;
    return toolbar;
}

- (NSButton *)_windowDefaultButton {
    if (auto windowDefaultButton = _windowDefaultButton) return windowDefaultButton;
    
    NSButton *windowDefaultButton = [NSButton buttonWithImage:[NSImage imageWithSystemSymbolName:@"apple.intelligence"
                                                                        accessibilityDescription:nil]
                                                       target:nil
                                                       action:nil];
    
    ActionResolver *resolver = [ActionResolver resolver:^(id  _Nonnull sender) {
        NSLog(@"Clicked windowDefaultButton!");
    }];
    [resolver setupControl:windowDefaultButton];
    
    _windowDefaultButton = [windowDefaultButton retain];
    return windowDefaultButton;
}

- (void)_reload {
    NSDiffableDataSourceSnapshot *snapshot = [NSDiffableDataSourceSnapshot new];
    [snapshot appendSectionsWithIdentifiers:@[[NSNull null]]];
    
#pragma mark - Items 1
    [snapshot appendItemsWithIdentifiers:@[
        [self _makeTabGroupWindowsItemModel],
        [self _makeTabGroupTabBarVisibleItemModel],
        [self _makeTabGroupOverviewVisibleItemModel],
        [self _makeTabGroupIdentifierItemModel],
        [self _makeTabbedWindowsItemModel],
        [self _makeAddTabbedWindowOrderedItemModel],
        [self _makeTabbingIdentifierItemModel],
        [self _makeToggleTabBarItemModel],
        [self _makeTabbingModeItemModel],
        [self _makeTabImageItemModel],
        [self _makeTabShowIconItemModel],
        [self _makeTabAccessoryViewItemModel],
        [self _makeTabTooltipItemModel],
        [self _makeTabTitleItemModel],
        [self _makeUserTabbingPreferenceItemModel],
        [self _makeAllowsAutomaticWindowTabbingItemModel],
        [self _makeTitlebarAccessoryViewControllersItemModel],
        [self _makeRemoveTitlebarAccessoryViewControllerAtIndexItemModel],
        [self _makeInsertTitlebarAccessoryViewControllerItemModel],
        [self _makeAddTitlebarAccessoryViewControllerItemModel],
        [self _makeWindowTitlebarLayoutDirectionItemModel],
        [self _makeTitlebarSeparatorStyleItemModel],
        [self _makeToolbarStyleItemModel],
        [self _makeTitlebarAppearsTransparentItemModel],
//        [self _makeShowsToolbarButtonItemModel],
        [self _makeStandardWindowButtonItemModel],
        [self _makePushCrosshairCursorMenuItemModel],
        [self _makeResetCursorRectsItemModel],
        [self _makeInvalidateCursorRectsForViewItemModel],
        [self _makeDiscardCursorRectsItemModel],
        [self _makeCursorRectsEnabledItemModel],
        [self _makeExcludedFromWindowsMenuItemModel],
        [self _makeEndEditingForItemModel],
        [self _makeFieldEditorForObjectItemModel],
        [self _makeDisableKeyEquivalentForDefaultButtonCellItemModel],
        [self _makeEnableKeyEquivalentForDefaultButtonCellItemModel],
        [self _makeDefaultButtonCellItemModel],
        [self _makeParentWindowItemModel],
        [self _makeRemoveChildWindowItemModel],
        [self _makeAddChildWindowOrderedItemModel],
        [self _makeRunToolbarCustomizationPaletteItemModel],
        [self _makeToggleToolbarShownItemModel],
        [self _makeToolbarItemModel],
        [self _makeMakeMainWindowItemModel],
        [self _makeMainWindowItemModel],
        [self _makeCanBecomeMainWindowItemModel],
        [self _makeMakeKeyAndOrderFrontItemModel],
        [self _makeMakeKeyWindowItemModel],
        [self _makeCanBecomeKeyWindowItemModel],
        [self _makeKeyWindowItemModel],
        [self _makeSetFrameFromStringItemModel],
        [self _makeStringWithSavedFrameItemModel],
        [self _makeSaveFrameUsingNameItemModel],
        [self _makeSetFrameUsingNameItemModel],
        [self _makeFrameAutosaveNameItemModel],
        [self _makeOcclusionStateItemModel],
        [self _makeIsVisibleItemModel],
        [self _makeLevelItemModel],
        [self _makeOrderOutItemModel],
        [self _makeOrderBackItemModel],
        [self _makeOrderFrontItemModel],
        [self _makeOrderFrontRegardlessItemModel],
        [self _makeMinFullScreenContentSizeItemModel],
        [self _makeMaxFullScreenContentSizeItemModel],
        [self _makeContentLayoutRectItemModel],
        [self _makeContentLayoutGuideItemModel],
        [self _makeSetContentSizeItemModel],
        [self _makeContentMinSizeItemModel],
        [self _makeContentMaxSizeItemModel],
        [self _makeInLiveResizeItemModel],
        [self _makePreservesContentDuringLiveResizeItemModel],
        [self _makeResizeFlagsItemModel],
        [self _makeZoomItemModel],
        [self _makePerformZoomItemModel],
        [self _makeMinSizeItemModel],
        [self _makeMaxSizeItemModel],
        [self _makeContentAspectRatioItemModel],
        [self _makeResizeIncrementsItemModel],
        [self _makeAspectRatioItemModel],
        [self _makeAnimationResizeTimeItemModel],
        [self _makeCascadeTopLeftFromPointItemModel],
        [self _makeConstrainFrameRectToScreenItemModel],
        [self _makeSetFrameTopLeftPointItemModel],
        [self _makeSetFrameOriginItemModel],
        [self _makeSetFrameDisplayAnimateItemModel],
        [self _makeContentRectForFrameRectItemModel],
        [self _makeFrameItemModel],
        [self _makeChildWindowsItemModel],
        [self _makeSheetsItemModel],
        [self _makeBeginCriticalSheetAndEndSheetItemModel],
        [self _makeBeginSheetAndEndSheetItemModel],
        [self _makeAttachedSheetAndIsSheetAndSheetParentItemModel],
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
    
    [self.configurationView applySnapshot:snapshot animatingDifferences:YES];
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
        return [ConfigurationButtonDescription descriptionWithTitle:@"Action"];
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
        return [ConfigurationButtonDescription descriptionWithTitle:@"Action"];
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
        return [ConfigurationButtonDescription descriptionWithTitle:@"Action"];
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
        return [ConfigurationButtonDescription descriptionWithTitle:@"Action"];
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

- (ConfigurationItemModel *)_makeAttachedSheetAndIsSheetAndSheetParentItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Attached Sheet & isSheet & sheetParent"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Attached Sheet (%p), isSheet, sheetParent", unretainedSelf.view.window.attachedSheet];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Action"];
    }];
}

- (ConfigurationItemModel *)_makeBeginSheetAndEndSheetItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Begin Sheet & End Sheet"
                                            userInfo:nil
                                               label:@"Begin Sheet & End Sheet"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Action"];
    }];
}

- (ConfigurationItemModel *)_makeBeginCriticalSheetAndEndSheetItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Begin Critical Sheet & End Sheet"
                                            userInfo:nil
                                               label:@"Begin Critical Sheet & End Sheet"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Action"];
    }];
}

- (ConfigurationItemModel *)_makeSheetsItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeLabel
                                          identifier:@"Sheets"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"%ld Sheets", unretainedSelf.view.window.sheets.count];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
}

- (ConfigurationItemModel *)_makeFrameItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeLabel
                                          identifier:@"Frame"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Frame : %@", NSStringFromRect(unretainedSelf.view.window.frame)];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
}

- (ConfigurationItemModel *)_makeContentRectForFrameRectItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeLabel
                                          identifier:@"contentRectForFrameRect:"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"contentRectForFrameRect : %@", NSStringFromRect([unretainedSelf.view.window contentRectForFrameRect:unretainedSelf.view.window.frame])];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
}

- (ConfigurationItemModel *)_makeSetFrameDisplayAnimateItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"setFrame:display:animate:"
                                            userInfo:nil
                                               label:@"setFrame:display:animate:"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSMenu *menu = [NSMenu new];
        
        NSMenuItem *menuItem = [NSMenuItem new];
        RectSlidersView *slidersView = [[RectSlidersView alloc] initWithFrame:NSMakeRect(0., 0., 300., 100.)];
        
        slidersView.configuration = [RectSlidersConfiguration configurationWithRect:unretainedSelf.view.window.frame
                                                                            minRect:NSMakeRect(0., 0., 300., 300.)
                                                                            maxRect:NSMakeRect(1000., 1000., 1000., 1000.)
                                                                           keyPaths:nil
                                                                           userInfo:@{
            @"selfValue": [NSValue value:reinterpret_cast<const void *>(&unretainedSelf) withObjCType:@encode(uintptr_t)],
            @"action": @"setFrame:display:animate:"
        }];
        
        menuItem.view = slidersView;
        [slidersView release];
        [menu addItem:menuItem];
        [menuItem release];
        
        ConfigurationButtonDescription *description = [ConfigurationButtonDescription descriptionWithTitle:@"Menu" menu:menu showsMenuAsPrimaryAction:YES];
        [menu release];
        
        return description;
    }];
}

- (ConfigurationItemModel *)_makeSetFrameOriginItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"setFrameOrigin:"
                                            userInfo:nil
                                               label:@"setFrameOrigin:"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSMenu *menu = [NSMenu new];
        
        NSMenuItem *menuItem = [NSMenuItem new];
        RectSlidersView *slidersView = [[RectSlidersView alloc] initWithFrame:NSMakeRect(0., 0., 300., 100.)];
        
        slidersView.configuration = [RectSlidersConfiguration configurationWithRect:unretainedSelf.view.window.frame
                                                                            minRect:NSMakeRect(0., 0., 300., 300.)
                                                                            maxRect:NSMakeRect(1000., 1000., 1000., 1000.)
                                                                           keyPaths:[NSSet setWithObjects:RectSlidersKeyPathX, RectSlidersKeyPathY, nil]
                                                                           userInfo:@{
            @"selfValue": [NSValue value:reinterpret_cast<const void *>(&unretainedSelf) withObjCType:@encode(uintptr_t)],
            @"action": @"setFrameOrigin:"
        }];
        
        menuItem.view = slidersView;
        [slidersView release];
        [menu addItem:menuItem];
        [menuItem release];
        
        ConfigurationButtonDescription *description = [ConfigurationButtonDescription descriptionWithTitle:@"Menu" menu:menu showsMenuAsPrimaryAction:YES];
        [menu release];
        
        return description;
    }];
}

- (ConfigurationItemModel *)_makeSetFrameTopLeftPointItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"setFrameTopLeftPoint:"
                                            userInfo:nil
                                               label:@"setFrameTopLeftPoint:"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSMenu *menu = [NSMenu new];
        
        NSMenuItem *menuItem = [NSMenuItem new];
        RectSlidersView *slidersView = [[RectSlidersView alloc] initWithFrame:NSMakeRect(0., 0., 300., 100.)];
        
        NSRect frame = unretainedSelf.view.window.frame;
        slidersView.configuration = [RectSlidersConfiguration configurationWithRect:NSOffsetRect(frame, 0., NSHeight(frame))
                                                                            minRect:NSMakeRect(0., 0., 300., 300.)
                                                                            maxRect:NSMakeRect(1000., 1000., 1000., 1000.)
                                                                           keyPaths:[NSSet setWithObjects:RectSlidersKeyPathX, RectSlidersKeyPathY, nil]
                                                                           userInfo:@{
            @"selfValue": [NSValue value:reinterpret_cast<const void *>(&unretainedSelf) withObjCType:@encode(uintptr_t)],
            @"action": @"setFrameTopLeftPoint:"
        }];
        
        menuItem.view = slidersView;
        [slidersView release];
        [menu addItem:menuItem];
        [menuItem release];
        
        ConfigurationButtonDescription *description = [ConfigurationButtonDescription descriptionWithTitle:@"Menu" menu:menu showsMenuAsPrimaryAction:YES];
        [menu release];
        
        return description;
    }];
}

- (ConfigurationItemModel *)_makeConstrainFrameRectToScreenItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"constrainFrameRect:toScreen:"
                                            userInfo:nil
                                               label:@"constrainFrameRect:toScreen:"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSMenu *menu = [NSMenu new];
        
        NSMenuItem *menuItem = [NSMenuItem new];
        RectSlidersView *slidersView = [[RectSlidersView alloc] initWithFrame:NSMakeRect(0., 0., 300., 100.)];
        
        slidersView.configuration = [RectSlidersConfiguration configurationWithRect:unretainedSelf.view.window.frame
                                                                            minRect:NSMakeRect(0., 0., 300., 300.)
                                                                            maxRect:NSMakeRect(10000., 10000., 10000., 10000.)
                                                                           keyPaths:[NSSet setWithObjects:RectSlidersKeyPathWidth, RectSlidersKeyPathHeight, nil]
                                                                           userInfo:@{
            @"selfValue": [NSValue value:reinterpret_cast<const void *>(&unretainedSelf) withObjCType:@encode(uintptr_t)],
            @"action": @"constrainFrameRect:toScreen:"
        }];
        
        menuItem.view = slidersView;
        [slidersView release];
        [menu addItem:menuItem];
        [menuItem release];
        
        ConfigurationButtonDescription *description = [ConfigurationButtonDescription descriptionWithTitle:@"Menu" menu:menu showsMenuAsPrimaryAction:YES];
        [menu release];
        
        return description;
    }];
}

- (ConfigurationItemModel *)_makeCascadeTopLeftFromPointItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Cascade Top Left From Point"
                                            userInfo:nil
                                               label:@"Cascade Top Left From Point"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSMenu *menu = [NSMenu new];
        
        NSMenuItem *menuItem = [NSMenuItem new];
        RectSlidersView *slidersView = [[RectSlidersView alloc] initWithFrame:NSMakeRect(0., 0., 300., 100.)];
        
        slidersView.configuration = [RectSlidersConfiguration configurationWithRect:NSZeroRect
                                                                            minRect:NSMakeRect(0., 0., 300., 300.)
                                                                            maxRect:NSMakeRect(1000., 1000., 1000., 1000.)
                                                                           keyPaths:nil
                                                                           userInfo:@{
            @"selfValue": [NSValue value:reinterpret_cast<const void *>(&unretainedSelf) withObjCType:@encode(uintptr_t)],
            @"action": @"cascadeTopLeftFromPoint:"
        }];
        
        menuItem.view = slidersView;
        [slidersView release];
        [menu addItem:menuItem];
        [menuItem release];
        
        ConfigurationButtonDescription *description = [ConfigurationButtonDescription descriptionWithTitle:@"Menu" menu:menu showsMenuAsPrimaryAction:YES];
        [menu release];
        
        return description;
    }];
}

- (ConfigurationItemModel *)_makeAnimationResizeTimeItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Animation Resize Time"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Animation Resize Time for rect (%@) : %lf", NSStringFromRect(unretainedSelf.animationResizeTimeRect), [unretainedSelf.view.window animationResizeTime:unretainedSelf.animationResizeTimeRect]];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSMenu *menu = [NSMenu new];
        
        NSMenuItem *menuItem = [NSMenuItem new];
        RectSlidersView *slidersView = [[RectSlidersView alloc] initWithFrame:NSMakeRect(0., 0., 300., 100.)];
        
        slidersView.configuration = [RectSlidersConfiguration configurationWithRect:unretainedSelf.animationResizeTimeRect
                                                                            minRect:NSMakeRect(0., 0., 300., 300.)
                                                                            maxRect:NSMakeRect(1000., 1000., 1000., 1000.)
                                                                           keyPaths:nil
                                                                           userInfo:@{
            @"selfValue": [NSValue value:reinterpret_cast<const void *>(&unretainedSelf) withObjCType:@encode(uintptr_t)],
            @"action": @"animationResizeTimeRect"
        }];
        
        menuItem.view = slidersView;
        [slidersView release];
        [menu addItem:menuItem];
        [menuItem release];
        
        ConfigurationButtonDescription *description = [ConfigurationButtonDescription descriptionWithTitle:@"Menu" menu:menu showsMenuAsPrimaryAction:YES];
        [menu release];
        
        return description;
    }];
}

- (ConfigurationItemModel *)_makeAspectRatioItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Aspect Ratio"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Aspect Ratio : %@", NSStringFromSize(unretainedSelf.view.window.aspectRatio)];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSMenu *menu = [NSMenu new];
        
        NSMenuItem *menuItem = [NSMenuItem new];
        RectSlidersView *slidersView = [[RectSlidersView alloc] initWithFrame:NSMakeRect(0., 0., 300., 100.)];
        
        NSSize aspectRatio = unretainedSelf.view.window.aspectRatio;
        slidersView.configuration = [RectSlidersConfiguration configurationWithRect:NSMakeRect(0., 0., aspectRatio.width, aspectRatio.height)
                                                                            minRect:NSMakeRect(0., 0., 0.1, 0.1)
                                                                            maxRect:NSMakeRect(0., 0., 1., 1.)
                                                                           keyPaths:[NSSet setWithObjects:RectSlidersKeyPathWidth, RectSlidersKeyPathHeight, nil]
                                                                           userInfo:@{
            @"selfValue": [NSValue value:reinterpret_cast<const void *>(&unretainedSelf) withObjCType:@encode(uintptr_t)],
            @"action": @"aspectRatio"
        }];
        
        menuItem.view = slidersView;
        [slidersView release];
        [menu addItem:menuItem];
        [menuItem release];
        
        ConfigurationButtonDescription *description = [ConfigurationButtonDescription descriptionWithTitle:@"Reset (or menu)" menu:menu showsMenuAsPrimaryAction:NO];
        [menu release];
        
        return description;
    }];
}

- (ConfigurationItemModel *)_makeResizeIncrementsItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Resize Increments"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Resize Increments : %@", NSStringFromSize(unretainedSelf.view.window.resizeIncrements)];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSMenu *menu = [NSMenu new];
        
        NSMenuItem *menuItem = [NSMenuItem new];
        RectSlidersView *slidersView = [[RectSlidersView alloc] initWithFrame:NSMakeRect(0., 0., 300., 100.)];
        
        NSSize resizeIncrements = unretainedSelf.view.window.resizeIncrements;
        slidersView.configuration = [RectSlidersConfiguration configurationWithRect:NSMakeRect(0., 0., resizeIncrements.width, resizeIncrements.height)
                                                                            minRect:NSMakeRect(0., 0., 1., 1.)
                                                                            maxRect:NSMakeRect(0., 0., 1000., 1000.)
                                                                           keyPaths:[NSSet setWithObjects:RectSlidersKeyPathWidth, RectSlidersKeyPathHeight, nil]
                                                                           userInfo:@{
            @"selfValue": [NSValue value:reinterpret_cast<const void *>(&unretainedSelf) withObjCType:@encode(uintptr_t)],
            @"action": @"resizeIncrements"
        }];
        
        menuItem.view = slidersView;
        [slidersView release];
        [menu addItem:menuItem];
        [menuItem release];
        
        ConfigurationButtonDescription *description = [ConfigurationButtonDescription descriptionWithTitle:@"Reset (or menu)" menu:menu showsMenuAsPrimaryAction:NO];
        [menu release];
        
        return description;
    }];
}

- (ConfigurationItemModel *)_makeContentAspectRatioItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Content Aspect Ratio"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Content Aspect Ratio : %@", NSStringFromSize(unretainedSelf.view.window.contentAspectRatio)];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSMenu *menu = [NSMenu new];
        
        NSMenuItem *menuItem = [NSMenuItem new];
        RectSlidersView *slidersView = [[RectSlidersView alloc] initWithFrame:NSMakeRect(0., 0., 300., 100.)];
        
        NSSize contentAspectRatio = unretainedSelf.view.window.contentAspectRatio;
        slidersView.configuration = [RectSlidersConfiguration configurationWithRect:NSMakeRect(0., 0., contentAspectRatio.width, contentAspectRatio.height)
                                                                            minRect:NSMakeRect(0., 0., 0.1, 0.1)
                                                                            maxRect:NSMakeRect(0., 0., 1., 1.)
                                                                           keyPaths:[NSSet setWithObjects:RectSlidersKeyPathWidth, RectSlidersKeyPathHeight, nil]
                                                                           userInfo:@{
            @"selfValue": [NSValue value:reinterpret_cast<const void *>(&unretainedSelf) withObjCType:@encode(uintptr_t)],
            @"action": @"contentAspectRatio"
        }];
        
        menuItem.view = slidersView;
        [slidersView release];
        [menu addItem:menuItem];
        [menuItem release];
        
        ConfigurationButtonDescription *description = [ConfigurationButtonDescription descriptionWithTitle:@"Reset (or menu)" menu:menu showsMenuAsPrimaryAction:NO];
        [menu release];
        
        return description;
    }];
}

- (ConfigurationItemModel *)_makeMinSizeItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Min Size"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Min Size : %@", NSStringFromSize(unretainedSelf.view.window.minSize)];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSMenu *menu = [NSMenu new];
        
        NSMenuItem *menuItem = [NSMenuItem new];
        RectSlidersView *slidersView = [[RectSlidersView alloc] initWithFrame:NSMakeRect(0., 0., 300., 100.)];
        
        NSSize minSize = unretainedSelf.view.window.minSize;
        NSSize maxSize = unretainedSelf.view.window.maxSize;
        
        slidersView.configuration = [RectSlidersConfiguration configurationWithRect:NSMakeRect(0., 0., minSize.width, minSize.height)
                                                                            minRect:NSZeroRect
                                                                            maxRect:NSMakeRect(0., 0., (maxSize.width == FLT_MAX) ? 3000. : maxSize.width, (maxSize.height == FLT_MAX) ? 3000. : maxSize.height)
                                                                           keyPaths:[NSSet setWithObjects:RectSlidersKeyPathWidth, RectSlidersKeyPathHeight, nil]
                                                                           userInfo:@{
            @"selfValue": [NSValue value:reinterpret_cast<const void *>(&unretainedSelf) withObjCType:@encode(uintptr_t)],
            @"action": @"minSize"
        }];
        
        menuItem.view = slidersView;
        [slidersView release];
        [menu addItem:menuItem];
        [menuItem release];
        
        ConfigurationButtonDescription *description = [ConfigurationButtonDescription descriptionWithTitle:@"Sliders" menu:menu showsMenuAsPrimaryAction:YES];
        [menu release];
        
        return description;
    }];
}

- (ConfigurationItemModel *)_makeMaxSizeItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Max Size"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Max Size : %@", NSStringFromSize(unretainedSelf.view.window.maxSize)];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSMenu *menu = [NSMenu new];
        
        NSMenuItem *menuItem = [NSMenuItem new];
        RectSlidersView *slidersView = [[RectSlidersView alloc] initWithFrame:NSMakeRect(0., 0., 300., 100.)];
        
        NSSize minSize = unretainedSelf.view.window.minSize;
        NSSize maxSize = unretainedSelf.view.window.maxSize;
        
        slidersView.configuration = [RectSlidersConfiguration configurationWithRect:NSMakeRect(0., 0., maxSize.width, maxSize.height)
                                                                            minRect:NSMakeRect(0., 0., minSize.width, minSize.height)
                                                                            maxRect:NSMakeRect(0., 0., 3000., 3000.)
                                                                           keyPaths:[NSSet setWithObjects:RectSlidersKeyPathWidth, RectSlidersKeyPathHeight, nil]
                                                                           userInfo:@{
            @"selfValue": [NSValue value:reinterpret_cast<const void *>(&unretainedSelf) withObjCType:@encode(uintptr_t)],
            @"action": @"maxSize"
        }];
        
        menuItem.view = slidersView;
        [slidersView release];
        [menu addItem:menuItem];
        [menuItem release];
        
        ConfigurationButtonDescription *description = [ConfigurationButtonDescription descriptionWithTitle:@"Sliders" menu:menu showsMenuAsPrimaryAction:YES];
        [menu release];
        
        return description;
    }];
}

- (ConfigurationItemModel *)_makePerformZoomItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Perform Zoom"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Perform Zoom (Zoomed : %@)", unretainedSelf.view.window.zoomed ? @"YES" : @"NO"];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeZoomItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Zoom"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Zoom (Zoomed : %@)", unretainedSelf.view.window.zoomed ? @"YES" : @"NO"];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

// command 같은 Key를 누른채 Resize 해보면 값이 나옴
- (ConfigurationItemModel *)_makeResizeFlagsItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeLabel
                                          identifier:@"Resize Flags"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Resize Flags : %@", NSStringFromNSEventModifierFlags(unretainedSelf.view.window.resizeFlags)];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
}

// https://x.com/_silgen_name/status/1891516058374492537
- (ConfigurationItemModel *)_makePreservesContentDuringLiveResizeItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                          identifier:@"Preserves Content During Live Resize"
                                            userInfo:nil
                                               label:@"Preserves Content During Live Resize (Don't Use)"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return @(unretainedSelf.view.window.preservesContentDuringLiveResize);
    }];
}

- (ConfigurationItemModel *)_makeInLiveResizeItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeLabel
                                          identifier:@"In Live Resize"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"In Live Resize : %@", unretainedSelf.view.window.inLiveResize ? @"YES" : @"NO"];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
}

- (ConfigurationItemModel *)_makeContentMinSizeItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Content Min Size"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Content Min Size : %@", NSStringFromSize(unretainedSelf.view.window.contentMinSize)];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSMenu *menu = [NSMenu new];
        
        NSMenuItem *menuItem = [NSMenuItem new];
        RectSlidersView *slidersView = [[RectSlidersView alloc] initWithFrame:NSMakeRect(0., 0., 300., 100.)];
        
        NSSize contentMinSize = unretainedSelf.view.window.contentMinSize;
        NSSize contentMaxSize = unretainedSelf.view.window.contentMaxSize;
        slidersView.configuration = [RectSlidersConfiguration configurationWithRect:NSMakeRect(0., 0., (contentMinSize.width == FLT_MAX) ? 0. : contentMinSize.width, (contentMinSize.height == FLT_MAX) ? 0. : contentMinSize.height)
                                                                            minRect:NSMakeRect(0., 0., 100., 100.)
                                                                            maxRect:NSMakeRect(0., 0., (contentMaxSize.width == FLT_MAX) ? 3000. : contentMaxSize.width, (contentMaxSize.height == FLT_MAX) ? 3000. : contentMaxSize.height)
                                                                           keyPaths:[NSSet setWithObjects:RectSlidersKeyPathWidth, RectSlidersKeyPathHeight, nil]
                                                                           userInfo:@{
            @"selfValue": [NSValue value:reinterpret_cast<const void *>(&unretainedSelf) withObjCType:@encode(uintptr_t)],
            @"action": @"contentMinSize"
        }];
        
        menuItem.view = slidersView;
        [slidersView release];
        [menu addItem:menuItem];
        [menuItem release];
        
        ConfigurationButtonDescription *description = [ConfigurationButtonDescription descriptionWithTitle:@"Menu" menu:menu showsMenuAsPrimaryAction:YES];
        [menu release];
        
        return description;
    }];
}

- (ConfigurationItemModel *)_makeContentMaxSizeItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Content Max Size"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Content Max Size : %@", NSStringFromSize(unretainedSelf.view.window.contentMinSize)];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSMenu *menu = [NSMenu new];
        
        NSMenuItem *menuItem = [NSMenuItem new];
        RectSlidersView *slidersView = [[RectSlidersView alloc] initWithFrame:NSMakeRect(0., 0., 300., 100.)];
        
        NSSize contentMinSize = unretainedSelf.view.window.contentMinSize;
        NSSize contentMaxSize = unretainedSelf.view.window.contentMaxSize;
        slidersView.configuration = [RectSlidersConfiguration configurationWithRect:NSMakeRect(0., 0., (contentMaxSize.width == FLT_MAX) ? 0. : contentMaxSize.width, (contentMaxSize.height == FLT_MAX) ? 0. : contentMaxSize.height)
                                                                            minRect:NSMakeRect(0., 0., (contentMinSize.width == FLT_MAX) ? 0. : contentMinSize.width, (contentMinSize.height == FLT_MAX) ? 0. : contentMinSize.height)
                                                                            maxRect:NSMakeRect(0., 0., 3000., 3000.)
                                                                           keyPaths:[NSSet setWithObjects:RectSlidersKeyPathWidth, RectSlidersKeyPathHeight, nil]
                                                                           userInfo:@{
            @"selfValue": [NSValue value:reinterpret_cast<const void *>(&unretainedSelf) withObjCType:@encode(uintptr_t)],
            @"action": @"contentMaxSize"
        }];
        
        menuItem.view = slidersView;
        [slidersView release];
        [menu addItem:menuItem];
        [menuItem release];
        
        ConfigurationButtonDescription *description = [ConfigurationButtonDescription descriptionWithTitle:@"Menu" menu:menu showsMenuAsPrimaryAction:YES];
        [menu release];
        
        return description;
    }];
}

- (ConfigurationItemModel *)_makeSetContentSizeItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Content Size"
                                            userInfo:nil
                                               label:@"Content Size"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSMenu *menu = [NSMenu new];
        
        NSMenuItem *menuItem = [NSMenuItem new];
        RectSlidersView *slidersView = [[RectSlidersView alloc] initWithFrame:NSMakeRect(0., 0., 300., 100.)];
        
        NSSize contentSize = [unretainedSelf.view.window contentRectForFrameRect:unretainedSelf.view.window.frame].size;
        slidersView.configuration = [RectSlidersConfiguration configurationWithRect:NSMakeRect(0., 0., contentSize.width, contentSize.height)
                                                                            minRect:NSMakeRect(0., 0., 100., 100.)
                                                                            maxRect:NSMakeRect(0., 0., 3000., 3000.)
                                                                           keyPaths:[NSSet setWithObjects:RectSlidersKeyPathWidth, RectSlidersKeyPathHeight, nil]
                                                                           userInfo:@{
            @"selfValue": [NSValue value:reinterpret_cast<const void *>(&unretainedSelf) withObjCType:@encode(uintptr_t)],
            @"action": @"setContentSize:"
        }];
        
        menuItem.view = slidersView;
        [slidersView release];
        [menu addItem:menuItem];
        [menuItem release];
        
        ConfigurationButtonDescription *description = [ConfigurationButtonDescription descriptionWithTitle:@"Menu" menu:menu showsMenuAsPrimaryAction:YES];
        [menu release];
        
        return description;
    }];
}

- (ConfigurationItemModel *)_makeContentLayoutGuideItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeLabel
                                          identifier:@"Content Layout Guide"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Content Layout Guide : %@", unretainedSelf.view.window.contentLayoutGuide];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
}

- (ConfigurationItemModel *)_makeContentLayoutRectItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeLabel
                                          identifier:@"Content Layout Rect"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Content Layout Rect : %@", NSStringFromRect(unretainedSelf.view.window.contentLayoutRect)];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
}

- (ConfigurationItemModel *)_makeMinFullScreenContentSizeItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Min Full Screen Content Size"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Min Full Screen Content Size : %@", NSStringFromSize(unretainedSelf.view.window.minFullScreenContentSize)];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSMenu *menu = [NSMenu new];
        
        NSMenuItem *menuItem = [NSMenuItem new];
        RectSlidersView *slidersView = [[RectSlidersView alloc] initWithFrame:NSMakeRect(0., 0., 300., 100.)];
        
        NSSize minFullScreenContentSize = unretainedSelf.view.window.minFullScreenContentSize;
        NSSize maxFullScreenContentSize = unretainedSelf.view.window.maxFullScreenContentSize;
        slidersView.configuration = [RectSlidersConfiguration configurationWithRect:NSMakeRect(0., 0., (minFullScreenContentSize.width == FLT_MAX) ? 0. : minFullScreenContentSize.width, (minFullScreenContentSize.height == FLT_MAX) ? 0. : minFullScreenContentSize.height)
                                                                            minRect:NSMakeRect(0., 0., 100., 100.)
                                                                            maxRect:NSMakeRect(0., 0., (maxFullScreenContentSize.width == FLT_MAX) ? 3000. : maxFullScreenContentSize.width, (maxFullScreenContentSize.height == FLT_MAX) ? 3000. : maxFullScreenContentSize.height)
                                                                           keyPaths:[NSSet setWithObjects:RectSlidersKeyPathWidth, RectSlidersKeyPathHeight, nil]
                                                                           userInfo:@{
            @"selfValue": [NSValue value:reinterpret_cast<const void *>(&unretainedSelf) withObjCType:@encode(uintptr_t)],
            @"action": @"minFullScreenContentSize"
        }];
        
        menuItem.view = slidersView;
        [slidersView release];
        [menu addItem:menuItem];
        [menuItem release];
        
        ConfigurationButtonDescription *description = [ConfigurationButtonDescription descriptionWithTitle:@"Menu" menu:menu showsMenuAsPrimaryAction:YES];
        [menu release];
        
        return description;
    }];
}

- (ConfigurationItemModel *)_makeMaxFullScreenContentSizeItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Max Full Screen Content Size"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Max Full Screen Content Size : %@", NSStringFromSize(unretainedSelf.view.window.maxFullScreenContentSize)];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSMenu *menu = [NSMenu new];
        
        NSMenuItem *menuItem = [NSMenuItem new];
        RectSlidersView *slidersView = [[RectSlidersView alloc] initWithFrame:NSMakeRect(0., 0., 300., 100.)];
        
        NSSize minFullScreenContentSize = unretainedSelf.view.window.minFullScreenContentSize;
        NSSize maxFullScreenContentSize = unretainedSelf.view.window.maxFullScreenContentSize;
        slidersView.configuration = [RectSlidersConfiguration configurationWithRect:NSMakeRect(0., 0., (maxFullScreenContentSize.width == FLT_MAX) ? 0. : maxFullScreenContentSize.width, (maxFullScreenContentSize.height == FLT_MAX) ? 0. : maxFullScreenContentSize.height)
                                                                            minRect:NSMakeRect(0., 0., (minFullScreenContentSize.width == FLT_MAX) ? 0. : minFullScreenContentSize.width, (minFullScreenContentSize.height == FLT_MAX) ? 0. : minFullScreenContentSize.height)
                                                                            maxRect:NSMakeRect(0., 0., 3000., 3000.)
                                                                           keyPaths:[NSSet setWithObjects:RectSlidersKeyPathWidth, RectSlidersKeyPathHeight, nil]
                                                                           userInfo:@{
            @"selfValue": [NSValue value:reinterpret_cast<const void *>(&unretainedSelf) withObjCType:@encode(uintptr_t)],
            @"action": @"maxFullScreenContentSize"
        }];
        
        menuItem.view = slidersView;
        [slidersView release];
        [menu addItem:menuItem];
        [menuItem release];
        
        ConfigurationButtonDescription *description = [ConfigurationButtonDescription descriptionWithTitle:@"Menu" menu:menu showsMenuAsPrimaryAction:YES];
        [menu release];
        
        return description;
    }];
}

- (ConfigurationItemModel *)_makeOrderOutItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Order Out"
                                            userInfo:nil
                                               label:@"Order Out"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeOrderBackItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Order Back"
                                            userInfo:nil
                                               label:@"Order Back"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeOrderFrontItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Order Front"
                                            userInfo:nil
                                               label:@"Order Front"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeOrderFrontRegardlessItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Order Front Regardless"
                                            userInfo:nil
                                               label:@"Order Front Regardless"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeLevelItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                          identifier:@"Level"
                                            userInfo:nil
                                               label:@"Level"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSUInteger count;
        NSWindowLevel *allLevels = allNSWindowLevels(&count);
        
        auto levelTitlesVector = std::views::iota(allLevels, allLevels + count)
        | std::views::transform([](NSWindowLevel *levelPtr) -> NSString * {
            return NSStringFromNSWindowLevel(*levelPtr);
        })
        | std::ranges::to<std::vector<NSString *>>();
        
        NSArray<NSString *> *levelTitles = [[NSArray alloc] initWithObjects:levelTitlesVector.data() count:levelTitlesVector.size()];
        NSString *selectedLevelTitle = NSStringFromNSWindowLevel(unretainedSelf.view.window.level);
        
        ConfigurationPopUpButtonDescription *description = [ConfigurationPopUpButtonDescription descriptionWithTitles:levelTitles
                                                                                                       selectedTitles:@[selectedLevelTitle]
                                                                                                 selectedDisplayTitle:selectedLevelTitle];
        [levelTitles release];
        
        return description;
    }];
}

- (ConfigurationItemModel *)_makeIsVisibleItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                          identifier:@"Is Visible"
                                            userInfo:nil
                                               label:@"Is Visible"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return @(unretainedSelf.view.window.visible);
    }];
}

- (ConfigurationItemModel *)_makeOcclusionStateItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeLabel
                                          identifier:@"Occlusion State"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        // https://developer.apple.com/library/archive/documentation/Performance/Conceptual/power_efficiency_guidelines_osx/WorkWhenVisible.html
        return [NSString stringWithFormat:@"Occlusion State : %@", ((unretainedSelf.view.window.occlusionState & NSWindowOcclusionStateVisible) == 0) ? @"Not Visible" : @"Visible"];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
}

- (ConfigurationItemModel *)_makeFrameAutosaveNameItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Frame Autosave Name"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Frame Autosave Name : %@", unretainedSelf.view.window.frameAutosaveName];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeSetFrameUsingNameItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Set Frame Using Name"
                                            userInfo:nil
                                               label:@"Set Frame Using Name"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeSaveFrameUsingNameItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Save Frame Using Name"
                                            userInfo:nil
                                               label:@"Save Frame Using Name"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeStringWithSavedFrameItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeLabel
                                          identifier:@"String With Saved Frame"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        NSWindowPersistableFrameDescriptor stringWithSavedFrame = unretainedSelf.view.window.stringWithSavedFrame;
        return [NSString stringWithFormat:@"String With Saved Frame : %@", stringWithSavedFrame];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
}

- (ConfigurationItemModel *)_makeSetFrameFromStringItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Set Frame From String"
                                            userInfo:nil
                                               label:@"Set Frame From String"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeKeyWindowItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeLabel
                                          identifier:@"Key Window"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Key Window : %@", unretainedSelf.view.window.keyWindow ? @"YES" : @"NO"];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
}

- (ConfigurationItemModel *)_makeCanBecomeKeyWindowItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeLabel
                                          identifier:@"Can Become Key Window"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Can Become Key Window : %@", unretainedSelf.view.window.canBecomeKeyWindow ? @"YES" : @"NO"];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
}

- (ConfigurationItemModel *)_makeMakeKeyWindowItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Make Key Window"
                                            userInfo:nil
                                               label:@"Make Key Window after 3 seconds"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeMakeKeyAndOrderFrontItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Make Key And Order Front"
                                            userInfo:nil
                                               label:@"Make Key And Order Front after 3 seconds"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeMainWindowItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeLabel
                                          identifier:@"Main Window"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Main Window : %@", unretainedSelf.view.window.mainWindow ? @"YES" : @"NO"];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
}

- (ConfigurationItemModel *)_makeCanBecomeMainWindowItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeLabel
                                          identifier:@"Can Become Main Window"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Can Become Main Window : %@", unretainedSelf.view.window.canBecomeMainWindow ? @"YES" : @"NO"];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
}

- (ConfigurationItemModel *)_makeMakeMainWindowItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Make Main Window"
                                            userInfo:nil
                                               label:@"Make Main Window after 3 seconds"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeToolbarItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                          identifier:@"Toolbar"
                                            userInfo:nil
                                               label:@"Toolbar"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return @(unretainedSelf.view.window.toolbar != nil);
    }];
}

- (ConfigurationItemModel *)_makeToggleToolbarShownItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Toggle Toolbar Shown"
                                            userInfo:nil
                                               label:@"Toggle Toolbar Shown"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeRunToolbarCustomizationPaletteItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Run Toolbar Customization Palette"
                                            userInfo:nil
                                               label:@"Run Toolbar Customization Palette"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeChildWindowsItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeLabel
                                          identifier:@"Child Windows"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Child Windows (%ld)", unretainedSelf.view.window.childWindows.count];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
}

- (ConfigurationItemModel *)_makeAddChildWindowOrderedItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                          identifier:@"Add Child Window Ordered"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Add Child Window Ordered : %ld child windows", unretainedSelf.view.window.childWindows.count];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSUInteger count;
        NSWindowOrderingMode *allModes = allNSWindowOrderingModes(&count);
        
        auto titlesVector = std::views::iota(allModes, allModes + count)
        | std::views::transform([](NSWindowOrderingMode *modePtr) {
            return NSStringFromNSWindowOrderingMode(*modePtr);
        })
        | std::ranges::to<std::vector<NSString *>>();
        
        NSArray<NSString *> *titles = [[NSArray alloc] initWithObjects:titlesVector.data() count:titlesVector.size()];
        ConfigurationPopUpButtonDescription *description = [ConfigurationPopUpButtonDescription descriptionWithTitles:titles selectedTitles:@[] selectedDisplayTitle:nil];
        [titles release];
        
        return description;
    }];
}

- (ConfigurationItemModel *)_makeRemoveChildWindowItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Remove Child Window"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Remove Child Window : %ld child windows", unretainedSelf.view.window.childWindows.count];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSMenu *menu = [NSMenu new];
        
        NSArray<__kindof NSWindow *> *childWindows = unretainedSelf.view.window.childWindows;
        
        for (NSWindow *childWindow in childWindows) {
            NSMenuItem *item = [NSMenuItem new];
            item.title = childWindow.description;
            ActionResolver *resolver = [ActionResolver resolver:^(id  _Nonnull sender) {
                [unretainedSelf.view.window removeChildWindow:childWindow];
                [unretainedSelf _reconfigureSheetsAndChildWindowsItemModels];
            }];
            [resolver setupMenuItem:item];
            [menu addItem:item];
            [item release];
        }
        
        ConfigurationButtonDescription *description = [ConfigurationButtonDescription descriptionWithTitle:@"Menu" menu:menu showsMenuAsPrimaryAction:YES];
        [menu release];
        
        return description;
    }];
}

- (ConfigurationItemModel *)_makeParentWindowItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeLabel
                                          identifier:@"Parent Window"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Parent Window : %@", unretainedSelf.view.window.parentWindow];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
}

- (ConfigurationItemModel *)_makeDefaultButtonCellItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                          identifier:@"Default Button Cell"
                                            userInfo:nil
                                               label:@"Default Button Cell"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return @(unretainedSelf.view.window.defaultButtonCell != nil);
    }];
}

- (ConfigurationItemModel *)_makeEnableKeyEquivalentForDefaultButtonCellItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Enable Key Equivalent For Default Button Cell"
                                            userInfo:nil
                                               label:@"Enable Key Equivalent For Default Button Cell"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeDisableKeyEquivalentForDefaultButtonCellItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Disable Key Equivalent For Default Button Cell"
                                            userInfo:nil
                                               label:@"Disable Key Equivalent For Default Button Cell"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeFieldEditorForObjectItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                          identifier:@"Field Editor"
                                            userInfo:nil
                                               label:@"Field Editor"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return @(unretainedSelf.windowFieldEditorScrollView != nil);
    }];
}

- (ConfigurationItemModel *)_makeEndEditingForItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"End Editing"
                                            userInfo:nil
                                               label:@"End Editing"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeExcludedFromWindowsMenuItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                          identifier:@"Excluded From Windows Menu"
                                            userInfo:nil
                                               label:@"Excluded From Windows Menu"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return @(unretainedSelf.view.window.excludedFromWindowsMenu);
    }];
}

- (ConfigurationItemModel *)_makeCursorRectsEnabledItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                          identifier:@"Cursor Rects Enabled"
                                            userInfo:nil
                                               label:@"Cursor Rects Enabled"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return @(unretainedSelf.view.window.areCursorRectsEnabled);
    }];
}

- (ConfigurationItemModel *)_makeDiscardCursorRectsItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Discard Cursor Rects"
                                            userInfo:nil
                                               label:@"Discard Cursor Rects (Does nothing)"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeInvalidateCursorRectsForViewItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Invalidate Cursor Rects For View"
                                            userInfo:nil
                                               label:@"Invalidate Cursor Rects For View"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeResetCursorRectsItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Reset Cursor Rects"
                                            userInfo:nil
                                               label:@"Reset Cursor Rects"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makePushCrosshairCursorMenuItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Add Cursor Rect"
                                            userInfo:nil
                                               label:@"Add Cursor Rect"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeStandardWindowButtonItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Standard Window Button"
                                            userInfo:nil
                                               label:@"Standard Window Button"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeShowsToolbarButtonItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                          identifier:@"Shows Toolbar Button"
                                            userInfo:nil
                                               label:@"Shows Toolbar Button (deprecated)"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return @(unretainedSelf.view.window.showsToolbarButton);
    }];
}

- (ConfigurationItemModel *)_makeTitlebarAppearsTransparentItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                          identifier:@"Titlebar Appears Transparent"
                                            userInfo:nil
                                               label:@"Titlebar Appears Transparent"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return @(unretainedSelf.view.window.titlebarAppearsTransparent);
    }];
}

- (ConfigurationItemModel *)_makeToolbarStyleItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                          identifier:@"Toolbar Style"
                                            userInfo:nil
                                               label:@"Toolbar Style"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSUInteger count;
        NSWindowToolbarStyle *allStyles = allNSWindowToolbarStyles(&count);
        
        auto titlesVector = std::views::iota(allStyles, allStyles + count)
        | std::views::transform([](NSWindowToolbarStyle *ptr) {
            return NSStringFromNSWindowToolbarStyle(*ptr);
        })
        | std::ranges::to<std::vector<NSString *>>();
        
        NSArray<NSString *> *titles = [[NSArray alloc] initWithObjects:titlesVector.data() count:titlesVector.size()];
        NSString *selectedTitle = NSStringFromNSWindowToolbarStyle(unretainedSelf.view.window.toolbarStyle);
        
        ConfigurationPopUpButtonDescription *description = [ConfigurationPopUpButtonDescription descriptionWithTitles:titles selectedTitles:@[selectedTitle] selectedDisplayTitle:selectedTitle];
        [titles release];
        
        return description;
    }];
}

- (ConfigurationItemModel *)_makeTitlebarSeparatorStyleItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                          identifier:@"Titlebar Separator Style"
                                            userInfo:nil
                                               label:@"Titlebar Separator Style"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSUInteger count;
        NSTitlebarSeparatorStyle *allStyles = allNSTitlebarSeparatorStyles(&count);
        
        auto titlesVector = std::views::iota(allStyles, allStyles + count)
        | std::views::transform([](NSTitlebarSeparatorStyle *ptr) {
            return NSStringFromNSTitlebarSeparatorStyle(*ptr);
        })
        | std::ranges::to<std::vector<NSString *>>();
        
        NSArray<NSString *> *titles = [[NSArray alloc] initWithObjects:titlesVector.data() count:titlesVector.size()];
        NSString *selectedTitle = NSStringFromNSTitlebarSeparatorStyle(unretainedSelf.view.window.titlebarSeparatorStyle);
        
        ConfigurationPopUpButtonDescription *description = [ConfigurationPopUpButtonDescription descriptionWithTitles:titles selectedTitles:@[selectedTitle] selectedDisplayTitle:selectedTitle];
        [titles release];
        
        return description;
    }];
}

- (ConfigurationItemModel *)_makeWindowTitlebarLayoutDirectionItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeLabel
                                          identifier:@"Window Titlebar Layout Direction"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Window Titlebar Layout Direction : %@", NSStringFromNSUserInterfaceLayoutDirection(unretainedSelf.view.window.windowTitlebarLayoutDirection)];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
}

- (ConfigurationItemModel *)_makeAddTitlebarAccessoryViewControllerItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Add Titlebar Accessory View Controller"
                                            userInfo:nil
                                               label:@"Add Titlebar Accessory View Controller"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeInsertTitlebarAccessoryViewControllerItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                          identifier:@"Insert Titlebar Accessory View Controller"
                                            userInfo:nil
                                               label:@"Insert Titlebar Accessory View Controller"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSInteger count = unretainedSelf.view.window.titlebarAccessoryViewControllers.count;
        
        auto titlesVector = std::views::iota(0, count + 1)
        | std::views::transform([](NSInteger index) {
            return @(index).stringValue;
        })
        | std::ranges::to<std::vector<NSString *>>();
        
        NSArray<NSString *> *titles = [[NSArray alloc] initWithObjects:titlesVector.data() count:titlesVector.size()];
        ConfigurationPopUpButtonDescription *description = [ConfigurationPopUpButtonDescription descriptionWithTitles:titles selectedTitles:@[] selectedDisplayTitle:nil];
        [titles release];
        
        return description;
    }];
}

- (ConfigurationItemModel *)_makeRemoveTitlebarAccessoryViewControllerAtIndexItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                          identifier:@"Remove Titlebar Accessory View Controller"
                                            userInfo:nil
                                               label:@"Remove Titlebar Accessory View Controller"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSInteger count = unretainedSelf.view.window.titlebarAccessoryViewControllers.count;
        
        auto titlesVector = std::views::iota(0, count)
        | std::views::transform([](NSInteger index) {
            return @(index).stringValue;
        })
        | std::ranges::to<std::vector<NSString *>>();
        
        NSArray<NSString *> *titles = [[NSArray alloc] initWithObjects:titlesVector.data() count:titlesVector.size()];
        ConfigurationPopUpButtonDescription *description = [ConfigurationPopUpButtonDescription descriptionWithTitles:titles selectedTitles:@[] selectedDisplayTitle:nil];
        [titles release];
        
        return description;
    }];
}

- (ConfigurationItemModel *)_makeTitlebarAccessoryViewControllersItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeLabel
                                          identifier:@"Titlebar Accessory View Controllers"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Titlebar Accessory View Controllers : %ld", unretainedSelf.view.window.titlebarAccessoryViewControllers.count];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
}

- (ConfigurationItemModel *)_makeAllowsAutomaticWindowTabbingItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                          identifier:@"Allows Automatic Window Tabbing"
                                            userInfo:nil
                                               label:@"Allows Automatic Window Tabbing"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return @(NSWindow.allowsAutomaticWindowTabbing);
    }];
}

- (ConfigurationItemModel *)_makeUserTabbingPreferenceItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeLabel
                                          identifier:@"User Tabbing Preference"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        NSWindowUserTabbingPreference userTabbingPreference = NSWindow.userTabbingPreference;
        
        return [NSString stringWithFormat:@"User Tabbing Preference : %@", NSStringFromNSWindowUserTabbingPreference(userTabbingPreference)];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
}

- (ConfigurationItemModel *)_makeTabTitleItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Tab Title"
                                            userInfo:nil labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Tab Title : %@", unretainedSelf.view.window.tab.title];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeTabTooltipItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Tab Tooltip"
                                            userInfo:nil labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Tab Tooltip : %@", unretainedSelf.view.window.tab.toolTip];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeTabAccessoryViewItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                          identifier:@"Tab Accessory View"
                                            userInfo:nil
                                               label:@"Tab Accessory View"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return @(unretainedSelf.view.window.tab.accessoryView != nil);
    }];
}

- (ConfigurationItemModel *)_makeTabShowIconItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                          identifier:@"Tab Show Icon"
                                            userInfo:nil
                                               label:@"Tab Show Icon"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        BOOL showIcon = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(unretainedSelf.view.window.tab, sel_registerName("showIcon"));
        return @(showIcon);
    }];
}

- (ConfigurationItemModel *)_makeTabImageItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                          identifier:@"Tab Image"
                                            userInfo:nil
                                               label:@"Tab Image"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSImage *image = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(unretainedSelf.view.window.tab, sel_registerName("image"));
        return @(image != nil);
    }];
}

- (ConfigurationItemModel *)_makeTabbingModeItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                          identifier:@"Tabbing Mode"
                                            userInfo:nil
                                               label:@"Tabbing Mode"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSUInteger count;
        NSWindowTabbingMode *allModes = allNSWindowTabbingModes(&count);
        
        auto titles = std::views::iota(allModes, allModes + count)
        | std::views::transform([](NSWindowTabbingMode *ptr) {
            return NSStringFromNSWindowTabbingMode(*ptr);
        })
        | std::ranges::to<std::vector<NSString *>>();
        
        NSString *selectedTitle = NSStringFromNSWindowTabbingMode(unretainedSelf.view.window.tabbingMode);
        
        return [ConfigurationPopUpButtonDescription descriptionWithTitles:[NSArray arrayWithObjects:titles.data() count:titles.size()]
                                                           selectedTitles:@[selectedTitle]
                                                     selectedDisplayTitle:selectedTitle];
    }];
}

- (ConfigurationItemModel *)_makeToggleTabBarItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Toggle Tab Bar"
                                            userInfo:nil
                                               label:@"Toggle Tab Bar"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeTabbingIdentifierItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Tabbing Identifier"
                                            userInfo:nil
                                               label:@"Tabbing Identifier"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeAddTabbedWindowOrderedItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                          identifier:@"Add Tabbed Window Ordered"
                                            userInfo:nil
                                               label:@"Add Tabbed Window Ordered"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSUInteger count;
        NSWindowOrderingMode *allModes = allNSWindowOrderingModes(&count);
        
        auto titlesVector = std::views::iota(allModes, allModes + count)
        | std::views::transform([](NSWindowOrderingMode *ptr) {
            return NSStringFromNSWindowOrderingMode(*ptr);
        })
        | std::ranges::to<std::vector<NSString *>>();
        
        return [ConfigurationPopUpButtonDescription descriptionWithTitles:[NSArray arrayWithObjects:titlesVector.data() count:titlesVector.size()]
                                                           selectedTitles:@[]
                                                     selectedDisplayTitle:nil];
    }];
}

- (ConfigurationItemModel *)_makeTabbedWindowsItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                          identifier:@"Tabbed Windows"
                                            userInfo:nil
                                               label:@"Tabbed Windows"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSArray<NSWindow *> *tabbedWindows = unretainedSelf.view.window.tabbedWindows;
        NSMutableArray<NSString *> *titles = [[NSMutableArray alloc] initWithCapacity:tabbedWindows.count];
        for (NSWindow *window in tabbedWindows) {
            [titles addObject:[NSString stringWithFormat:@"(NOP) %@", window.description]];
        }
        
        ConfigurationPopUpButtonDescription *description = [ConfigurationPopUpButtonDescription descriptionWithTitles:titles selectedTitles:@[] selectedDisplayTitle:nil];
        [titles release];
        
        return description;
    }];
}

- (ConfigurationItemModel *)_makeTabGroupIdentifierItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeLabel
                                          identifier:@"Tab Group Identifier"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        /*
         -[NSWindow tabGroup]을 시도하면 값이 없을 때 즉석으로 tabGroup을 생성하며, KVO에 의해 즉시 Reconfigure Data Source가 발생한다.
         Cell을 생성하는 도중에 Data Source를 수정하게 되므로, -_windowStackController을 통해 tabGroup의 생성을 방지한다.
         https://x.com/_silgen_name/status/1892477372970258793
         */
        
//        __kindof NSWindowTabGroup *tabGroup = unretainedSelf.view.window.tabGroup;
        __kindof NSWindowTabGroup *tabGroup = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(unretainedSelf.view.window, sel_registerName("_windowStackController"));
        
        return [NSString stringWithFormat:@"Tab Group Identifier : %@", tabGroup.identifier];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
}

- (ConfigurationItemModel *)_makeTabGroupOverviewVisibleItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                          identifier:@"Tab Group Overview Visible"
                                            userInfo:nil
                                               label:@"Tab Group Overview Visible"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        __kindof NSWindowTabGroup *tabGroup = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(unretainedSelf.view.window, sel_registerName("_windowStackController"));
        
        return @(tabGroup.overviewVisible);
    }];
}

- (ConfigurationItemModel *)_makeTabGroupTabBarVisibleItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeLabel
                                          identifier:@"Tab Group Tab Bar Visible"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        __kindof NSWindowTabGroup *tabGroup = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(unretainedSelf.view.window, sel_registerName("_windowStackController"));
        return [NSString stringWithFormat:@"Tab Group Tab Bar Visible : %@", tabGroup.tabBarVisible ? @"YES" : @"NO"];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
}

- (ConfigurationItemModel *)_makeTabGroupWindowsItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                          identifier:@"Tab Group Windows"
                                            userInfo:nil
                                       label:@"Tab Group Windows"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        __kindof NSWindowTabGroup *tabGroup = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(unretainedSelf.view.window, sel_registerName("_windowStackController"));
        NSArray<NSWindow *> *tabbedWindows = tabGroup.windows;
        NSMutableArray<NSString *> *titles = [[NSMutableArray alloc] initWithCapacity:tabbedWindows.count];
        for (NSWindow *window in tabbedWindows) {
            [titles addObject:[NSString stringWithFormat:@"(NOP) %@", window.description]];
        }
        
        ConfigurationPopUpButtonDescription *description = [ConfigurationPopUpButtonDescription descriptionWithTitles:titles selectedTitles:@[] selectedDisplayTitle:nil];
        [titles release];
        
        return description;
    }];
}


#pragma mark - Items 2

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

- (void)_didTriggerTestToolbarItem:(NSToolbarItem *)sender {
    NSLog(@"%s", __func__);
}

- (void)_reconfigureSheetsAndChildWindowsItemModels {
    [self.configurationView reconfigureItemModelsWithIdentifiers:@[@"Attached Sheet & isSheet & sheetParent", @"Sheets", @"Child Windows", @"Add Child Window Ordered", @"Remove Child Window"]];
}

- (void)_reconfigureTabItemModels {
    [self.configurationView reconfigureItemModelsWithIdentifiers:@[@"Tabbed Windows", @"Tab Group Identifier", @"Tab Group Overview Visible", @"Tab Group Tab Bar Visible", @"Tab Group Windows"]];
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
    return @[
        @"Test Item"
    ];
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
    return [self toolbarAllowedItemIdentifiers:toolbar];
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSToolbarItemIdentifier)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
    if ([itemIdentifier isEqualToString:@"Test Item"]) {
        NSToolbarItem *item = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
        item.label = @"Test";
        item.image = [NSImage imageWithSystemSymbolName:@"apple.intelligence" accessibilityDescription:nil];
        item.target = self;
        item.action = @selector(_didTriggerTestToolbarItem:);
        return [item autorelease];
    } else {
        abort();
    }
}

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
    } else if ([identifier isEqualToString:@"Attached Sheet & isSheet & sheetParent"]) {
        NSAlert *alert = [NSAlert new];
        alert.alertStyle = NSAlertStyleInformational;
        alert.messageText = @"Alert";
        
        [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {}];
        
        __kindof NSPanel *_panel = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(alert, sel_registerName("_panel"));
        alert.informativeText = [NSString stringWithFormat:@"isSheet : %@\nsheetParent : %p", _panel.isSheet ? @"YES" : @"NO", _panel.sheetParent];
        [alert release];
        
        [self _reconfigureSheetsAndChildWindowsItemModels];
        return NO;
    } else if ([identifier isEqualToString:@"Begin Sheet & End Sheet"]) {
        NSAlert *alert = [NSAlert new];
        alert.alertStyle = NSAlertStyleInformational;
        alert.messageText = @"Alert";
        
        [alert layout];
        
        __kindof NSPanel *_panel = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(alert, sel_registerName("_panel"));
        [window beginSheet:_panel completionHandler:^(NSModalResponse returnCode) {}];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [window endSheet:_panel];
        });
        
        [alert release];
        
        [self _reconfigureSheetsAndChildWindowsItemModels];
        return NO;
    } else if ([identifier isEqualToString:@"Begin Critical Sheet & End Sheet"]) {
        {
            NSAlert *alert = [NSAlert new];
            alert.alertStyle = NSAlertStyleInformational;
            alert.messageText = @"Normal Alert";
            
            [alert layout];
            
            __kindof NSPanel *_panel = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(alert, sel_registerName("_panel"));
            [window beginSheet:_panel completionHandler:^(NSModalResponse returnCode) {}];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [window endSheet:_panel];
            });
            
            [alert release];
        }
        {
            NSAlert *alert = [NSAlert new];
            alert.alertStyle = NSAlertStyleInformational;
            alert.messageText = @"Critical Alert";
            
            [alert layout];
            
            __kindof NSPanel *_panel = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(alert, sel_registerName("_panel"));
            [window beginCriticalSheet:_panel completionHandler:^(NSModalResponse returnCode) {}];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [window endSheet:_panel];
            });
            
            [alert release];
        }
        
        [self _reconfigureSheetsAndChildWindowsItemModels];
        return NO;
    } else if ([identifier isEqualToString:@"Aspect Ratio"] or [identifier isEqualToString:@"Resize Increments"] or [identifier isEqualToString:@"Content Aspect Ratio"]) {
        window.aspectRatio = NSZeroSize;
        window.contentAspectRatio = NSZeroSize;
        window.resizeIncrements = NSMakeSize(1., 1.);
        [configurationView reconfigureItemModelsWithIdentifiers:@[@"Aspect Ratio", @"Resize Increments", @"Content Aspect Ratio"]];
        return NO;
    } else if ([identifier isEqualToString:@"Perform Zoom"]) {
        [window performZoom:nil];
        return YES;
    } else if ([identifier isEqualToString:@"Zoom"]) {
        [window zoom:nil];
        return YES;
    } else if ([identifier isEqualToString:@"Preserves Content During Live Resize"]) {
        BOOL boolValue = static_cast<NSNumber *>(newValue).boolValue;
        window.preservesContentDuringLiveResize = boolValue;
        return YES;
    } else if ([identifier isEqualToString:@"Order Out"]) {
        [window orderOut:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [window orderFront:nil];
        });
        return NO;
    } else if ([identifier isEqualToString:@"Order Back"]) {
        [window orderBack:nil];
        return NO;
    } else if ([identifier isEqualToString:@"Order Front"]) {
        [window orderFront:nil];
        return NO;
    } else if ([identifier isEqualToString:@"Order Front Regardless"]) {
        [window orderFrontRegardless];
        return NO;
    } else if ([identifier isEqualToString:@"Level"]) {
        auto incomingLevel = NSWindowLevelFromString(static_cast<NSString *>(newValue));
        window.level = incomingLevel;
        return YES;
    } else if ([identifier isEqualToString:@"Is Visible"]) {
        BOOL boolValue = static_cast<NSNumber *>(newValue).boolValue;
        [window setIsVisible:boolValue];
        if (!boolValue) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [window setIsVisible:YES];
                [self.configurationView reconfigureItemModelsWithIdentifiers:@[@"Is Visible"]];
            });
        }
        return NO;
    } else if ([identifier isEqualToString:@"Frame Autosave Name"]) {
        NSWindowFrameAutosaveName frameAutosaveName = window.frameAutosaveName;
        
        NSAlert *alert = [NSAlert new];
        alert.messageText = @"Frame Autosave Name";
        
        [alert addButtonWithTitle:@"OK"];
        [alert addButtonWithTitle:@"Cancel"];
        
        NSTextField *textField = [NSTextField new];
        if (frameAutosaveName == nil) {
            textField.stringValue = @"";
        } else {
            textField.stringValue = frameAutosaveName;
        }
        
        [textField sizeToFit];
        textField.frame = NSMakeRect(0., 0., 300., NSHeight(textField.frame));
        
        alert.accessoryView = textField;
        
        ConfigurationView *configurationView = self.configurationView;
        
        [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
            if (returnCode != NSAlertFirstButtonReturn) {
                NSLog(@"Cancelled");
                return;
            }
            
            NSString *stringValue = textField.stringValue;
            if (stringValue.length == 0) {
                NSLog(@"Not set");
                return;
            }
            
            BOOL result = [window setFrameAutosaveName:stringValue];
            
            // Resizable하지 않을 경우
            assert(result);
            
            [configurationView reconfigureItemModelsWithIdentifiers:@[@"Frame Autosave Name"]];
        }];
        
        [textField release];
        [alert release];
        
        return NO;
    } else if ([identifier isEqualToString:@"Set Frame Using Name"]) {
        NSWindowFrameAutosaveName frameAutosaveName = window.frameAutosaveName;
        
        NSAlert *alert = [NSAlert new];
        alert.messageText = @"Set Frame Using Name";
        
        WindowDemoSetFrameUsingNameView *accessoryView = [WindowDemoSetFrameUsingNameView new];
        accessoryView.autosaveName = frameAutosaveName;
        alert.accessoryView = accessoryView;
        
        NSButton *okButton = [alert addButtonWithTitle:@"OK"];
        [alert addButtonWithTitle:@"Cancel"];
        
        alert.window.defaultButtonCell = okButton.cell;
        
        [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
            if (returnCode != NSAlertFirstButtonReturn) {
                NSLog(@"Cancelled");
                return;
            }
            
            NSString *stringValue = accessoryView.autosaveName;
            if (stringValue.length == 0) {
                NSLog(@"Not set");
                return;
            }
            
            [window setFrameUsingName:stringValue force:accessoryView.force];
        }];
        
        [accessoryView release];
        [alert release];
        
        return NO;
    } else if ([identifier isEqualToString:@"Save Frame Using Name"]) {
        NSWindowFrameAutosaveName frameAutosaveName = window.frameAutosaveName;
        
        NSAlert *alert = [NSAlert new];
        alert.messageText = @"Save Frame Using Name";
        
        [alert addButtonWithTitle:@"OK"];
        [alert addButtonWithTitle:@"Cancel"];
        
        NSTextField *textField = [NSTextField new];
        if (frameAutosaveName == nil) {
            textField.stringValue = @"";
        } else {
            textField.stringValue = frameAutosaveName;
        }
        
        [textField sizeToFit];
        textField.frame = NSMakeRect(0., 0., 300., NSHeight(textField.frame));
        
        alert.accessoryView = textField;
        
        [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
            if (returnCode != NSAlertFirstButtonReturn) {
                NSLog(@"Cancelled");
                return;
            }
            
            NSString *stringValue = textField.stringValue;
            if (stringValue.length == 0) {
                NSLog(@"Not set");
                return;
            }
            
            [window saveFrameUsingName:stringValue];
        }];
        
        [textField release];
        [alert release];
        
        return NO;
    } else if ([identifier isEqualToString:@"Set Frame From String"]) {
        NSWindowFrameAutosaveName frameAutosaveName = window.frameAutosaveName;
        
        NSAlert *alert = [NSAlert new];
        alert.messageText = @"Set Frame From String";
        
        [alert addButtonWithTitle:@"OK"];
        [alert addButtonWithTitle:@"Cancel"];
        
        NSTextField *textField = [NSTextField new];
        if (frameAutosaveName == nil) {
            textField.stringValue = @"";
        } else {
            textField.stringValue = frameAutosaveName;
        }
        
        [textField sizeToFit];
        textField.frame = NSMakeRect(0., 0., 300., NSHeight(textField.frame));
        
        id<NSObject> observation = [NSNotificationCenter.defaultCenter addObserverForName:NSControlTextDidChangeNotification
                                                                                   object:textField
                                                                                    queue:nil
                                                                               usingBlock:^(NSNotification * _Nonnull notification) {
            NSLog(@"%@", notification);
        }];
        
        static void *key = &key;
        objc_setAssociatedObject(alert, key, observation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        alert.accessoryView = textField;
        
        [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
            if (returnCode != NSAlertFirstButtonReturn) {
                NSLog(@"Cancelled");
                return;
            }
            
            NSString *stringValue = textField.stringValue;
            if (stringValue.length == 0) {
                NSLog(@"Not set");
                return;
            }
            
            // TODO
        }];
        
        [textField release];
        [alert release];
        
        return NO;
    } else if ([identifier isEqualToString:@"Make Key Window"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [window makeKeyWindow];
            [self.configurationView reconfigureItemModelsWithIdentifiers:@[@"Key Window", @"Main Window"]];
        });
        return NO;
    } else if ([identifier isEqualToString:@"Make Key And Order Front"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [window makeKeyAndOrderFront:nil];
            [self.configurationView reconfigureItemModelsWithIdentifiers:@[@"Key Window", @"Main Window"]];
        });
        return NO;
    } else if ([identifier isEqualToString:@"Make Main Window"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [window makeMainWindow];
            [self.configurationView reconfigureItemModelsWithIdentifiers:@[@"Key Window", @"Main Window"]];
        });
        return NO;
    } else if ([identifier isEqualToString:@"Toolbar"]) {
        BOOL boolValue = static_cast<NSNumber *>(newValue).boolValue;
        if (boolValue) {
            window.toolbar = self.toolbar;
        } else {
            window.toolbar = nil;
        }
        return NO;
    } else if ([identifier isEqualToString:@"Toggle Toolbar Shown"]) {
        [window toggleToolbarShown:nil];
        return NO;
    } else if ([identifier isEqualToString:@"Run Toolbar Customization Palette"]) {
        [window runToolbarCustomizationPalette:nil];
        return NO;
    } else if ([identifier isEqualToString:@"Add Child Window Ordered"]) {
        auto title = static_cast<NSString *>(newValue);
        NSWindowOrderingMode mode = NSWindowOrderingModeFromString(title);
        
        WindowDemoWindow *childWindow = [WindowDemoWindow new];
        [window addChildWindow:childWindow ordered:mode];
        [childWindow release];
        [self _reconfigureSheetsAndChildWindowsItemModels];
        return NO;
    } else if ([identifier isEqualToString:@"Default Button Cell"]) {
        BOOL boolValue = static_cast<NSNumber *>(newValue).boolValue;
        NSButton *windowDefaultButton = self.windowDefaultButton;
        
        if (boolValue) {
            assert(windowDefaultButton.superview == nil);
            
            [self.view addSubview:windowDefaultButton];
            windowDefaultButton.translatesAutoresizingMaskIntoConstraints = NO;
            [NSLayoutConstraint activateConstraints:@[
                [windowDefaultButton.centerXAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.centerXAnchor],
                [windowDefaultButton.centerYAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.centerYAnchor]
            ]];
            
            window.defaultButtonCell = windowDefaultButton.cell;
        } else {
            window.defaultButtonCell = nil;
            [windowDefaultButton removeFromSuperview];
        }
        
        return NO;
    } else if ([identifier isEqualToString:@"Enable Key Equivalent For Default Button Cell"]) {
//        [window enableKeyEquivalentForDefaultButtonCell];
        reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(window, sel_registerName("_enableEnablingKeyEquivalentForDefaultButtonCell"));
        return NO;
    } else if ([identifier isEqualToString:@"Disable Key Equivalent For Default Button Cell"]) {
        //        [window disableKeyEquivalentForDefaultButtonCell];
        reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(window, sel_registerName("_disableEnablingKeyEquivalentForDefaultButtonCell"));
        return NO;
    } else if ([identifier isEqualToString:@"Field Editor"]) {
        BOOL boolValue = static_cast<NSNumber *>(newValue).boolValue;
        
        if (boolValue) {
            assert(self.windowFieldEditorScrollView == nil);
            NSScrollView *windowFieldEditorScrollView = [NSScrollView new];
            self.windowFieldEditorScrollView = windowFieldEditorScrollView;
            
            __kindof NSText *fieldEditor = [window fieldEditor:YES forObject:nil];
            windowFieldEditorScrollView.documentView = fieldEditor;
            
            windowFieldEditorScrollView.drawsBackground = YES;
            
            [self.view addSubview:windowFieldEditorScrollView];
            windowFieldEditorScrollView.translatesAutoresizingMaskIntoConstraints = NO;
            [NSLayoutConstraint activateConstraints:@[
                [windowFieldEditorScrollView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
                [windowFieldEditorScrollView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
                [windowFieldEditorScrollView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:0.5],
                [windowFieldEditorScrollView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:0.5]
            ]];
        } else {
            NSScrollView *windowFieldEditorScrollView = self.windowFieldEditorScrollView;
            assert(windowFieldEditorScrollView != nil);
            [windowFieldEditorScrollView removeFromSuperview];
            self.windowFieldEditorScrollView = nil;
        }
        
        return NO;
    } else if ([identifier isEqualToString:@"End Editing"]) {
        [window endEditingFor:nil];
        return NO;
    } else if ([identifier isEqualToString:@"Excluded From Windows Menu"]) {
        BOOL boolValue = static_cast<NSNumber *>(newValue).boolValue;
        window.excludedFromWindowsMenu = boolValue;
        return NO;
    } else if ([identifier isEqualToString:@"Cursor Rects Enabled"]) {
        BOOL boolValue = static_cast<NSNumber *>(newValue).boolValue;
        
        if (boolValue) {
            [window enableCursorRects];
        } else {
            [window disableCursorRects];
        }
        
        return NO;
    } else if ([identifier isEqualToString:@"Discard Cursor Rects"]) {
        [window discardCursorRects];
        return NO;
    } else if ([identifier isEqualToString:@"Invalidate Cursor Rects For View"]) {
        [window invalidateCursorRectsForView:self.view];
        return NO;
    } else if ([identifier isEqualToString:@"Reset Cursor Rects"]) {
        [window resetCursorRects];
        return NO;
    } else if ([identifier isEqualToString:@"Add Cursor Rect"]) {
        [self.view addCursorRect:self.view.bounds cursor:NSCursor.crosshairCursor];
        return NO;
    } else if ([identifier isEqualToString:@"Standard Window Button"]) {
        NSAlert *alert = [NSAlert new];
        alert.messageText = @"Standard Window Button";
        
        WindowButtonsView *accessoryView = [[WindowButtonsView alloc] initWithFrame:NSMakeRect(0., 0., 300., 200.)];
        alert.accessoryView = accessoryView;
        [accessoryView release];
        
        [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
            
        }];
        
        [alert release];
        return NO;
    } else if ([identifier isEqualToString:@"Shows Toolbar Button"]) {
        BOOL boolValue = static_cast<NSNumber *>(newValue).boolValue;
        window.showsToolbarButton = boolValue;
        return NO;
    } else if ([identifier isEqualToString:@"Titlebar Appears Transparent"]) {
        BOOL boolValue = static_cast<NSNumber *>(newValue).boolValue;
        window.titlebarAppearsTransparent = boolValue;
        
        if (boolValue && ((window.styleMask & NSWindowStyleMaskFullSizeContentView) == 0)) {
            window.styleMask |= NSWindowStyleMaskFullSizeContentView;
            [self.configurationView reconfigureItemModelsWithIdentifiers:@[@"Style Mask"]];
            
            NSAlert *alert = [NSAlert new];
            alert.messageText = @"Information";
            alert.informativeText = @"NSWindowStyleMaskFullSizeContentView was added.";
            
            [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
                
            }];
            
            [alert release];
        }
        
        return NO;
    } else if ([identifier isEqualToString:@"Toolbar Style"]) {
        NSString *title = static_cast<NSString *>(newValue);
        NSWindowToolbarStyle style = NSWindowToolbarStyleFromString(title);
        window.toolbarStyle = style;
        return YES;
    } else if ([identifier isEqualToString:@"Titlebar Separator Style"]) {
        NSString *title = static_cast<NSString *>(newValue);
        NSTitlebarSeparatorStyle style = NSTitlebarSeparatorStyleFromString(title);
        window.titlebarSeparatorStyle = style;
        return YES;
    } else if ([identifier isEqualToString:@"Add Titlebar Accessory View Controller"]) {
        WindowDemoTitlebarAccessoryViewController *accessoryViewController = [WindowDemoTitlebarAccessoryViewController new];
        [window addTitlebarAccessoryViewController:accessoryViewController];
        [accessoryViewController release];
        [configurationView reconfigureItemModelsWithIdentifiers:@[@"Insert Titlebar Accessory View Controller", @"Remove Titlebar Accessory View Controller", @"Titlebar Accessory View Controllers"]];
        return NO;
    } else if ([identifier isEqualToString:@"Insert Titlebar Accessory View Controller"]) {
        NSString *title = static_cast<NSString *>(newValue);
        NSInteger index = title.integerValue;
        WindowDemoTitlebarAccessoryViewController *accessoryViewController = [WindowDemoTitlebarAccessoryViewController new];
        [window insertTitlebarAccessoryViewController:accessoryViewController atIndex:index];
        [accessoryViewController release];
        [configurationView reconfigureItemModelsWithIdentifiers:@[@"Insert Titlebar Accessory View Controller", @"Remove Titlebar Accessory View Controller", @"Titlebar Accessory View Controllers"]];
        return NO;
    } else if ([identifier isEqualToString:@"Remove Titlebar Accessory View Controller"]) {
        NSString *title = static_cast<NSString *>(newValue);
        NSInteger index = title.integerValue;
        WindowDemoTitlebarAccessoryViewController *accessoryViewController = [WindowDemoTitlebarAccessoryViewController new];
        [window removeTitlebarAccessoryViewControllerAtIndex:index];
        [accessoryViewController release];
        [configurationView reconfigureItemModelsWithIdentifiers:@[@"Insert Titlebar Accessory View Controller", @"Remove Titlebar Accessory View Controller", @"Titlebar Accessory View Controllers"]];
        return NO;
    } else if ([identifier isEqualToString:@"Allows Automatic Window Tabbing"]) {
        BOOL boolValue = static_cast<NSNumber *>(newValue).boolValue;
        NSWindow.allowsAutomaticWindowTabbing = boolValue;
        return NO;
    } else if ([identifier isEqualToString:@"Tab Title"]) {
        NSAlert *alert = [NSAlert new];
        NSTextField *textField = [NSTextField new];
        [textField sizeToFit];
        textField.frame = NSMakeRect(0., 0., 300., NSHeight(textField.frame));
        
        NSWindowTab *windowTab = window.tab;
        textField.stringValue = windowTab.title;
        
        alert.accessoryView = textField;
        
        [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
            windowTab.title = textField.stringValue;
            [configurationView reconfigureItemModelsWithIdentifiers:@[@"Tab Title"]];
        }];
        
        [alert release];
        return NO;
    } else if ([identifier isEqualToString:@"Tab Tooltip"]) {
        NSAlert *alert = [NSAlert new];
        NSTextField *textField = [NSTextField new];
        
        NSWindowTab *windowTab = window.tab;
        textField.stringValue = windowTab.toolTip;
        [textField sizeToFit];
        textField.frame = NSMakeRect(0., 0., 300., NSHeight(textField.frame));
        
        alert.accessoryView = textField;
        
        [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
            windowTab.toolTip = textField.stringValue;
            [configurationView reconfigureItemModelsWithIdentifiers:@[@"Tab Tooltip"]];
        }];
        
        [alert release];
        return NO;
    } else if ([identifier isEqualToString:@"Tab Accessory View"]) {
        BOOL boolValue = static_cast<NSNumber *>(newValue).boolValue;
        
        NSWindowTab *windowTab = window.tab;
        if (boolValue) {
            assert(windowTab.accessoryView == nil);
            NSImage *image = [NSImage imageWithSystemSymbolName:@"apple.intelligence" accessibilityDescription:nil];
            NSImageView *imageView = [NSImageView new];
            imageView.image = image;
            windowTab.accessoryView = imageView;
            [imageView release];
        } else {
            assert(windowTab.accessoryView != nil);
            windowTab.accessoryView = nil;
        }
        
        return NO;
    } else if ([identifier isEqualToString:@"Tab Show Icon"]) {
        BOOL boolValue = static_cast<NSNumber *>(newValue).boolValue;
        reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(window.tab, sel_registerName("setShowIcon:"), boolValue);
        return NO;
    } else if ([identifier isEqualToString:@"Tab Image"]) {
        BOOL boolValue = static_cast<NSNumber *>(newValue).boolValue;
        
        NSWindowTab *windowTab = window.tab;
        if (boolValue) {
            NSImage *image = [NSImage imageWithSystemSymbolName:@"apple.writing.tools" accessibilityDescription:nil];
            reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(windowTab, sel_registerName("setImage:"), image);
        } else {
            reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(windowTab, sel_registerName("setImage:"), nil);
        }
        
        return NO;
    } else if ([identifier isEqualToString:@"Tabbing Mode"]) {
        NSString *title = static_cast<NSString *>(newValue);
        NSWindowTabbingMode mode = NSWindowTabbingModeFromString(title);
        window.tabbingMode = mode;
        return YES;
    } else if ([identifier isEqualToString:@"Toggle Tab Bar"]) {
        [window toggleTabBar:nil];
        [self _reconfigureTabItemModels];
        return NO;
    } else if ([identifier isEqualToString:@"Tabbing Identifier"]) {
        NSAlert *alert = [NSAlert new];
        
        NSTextField *textField = [NSTextField new];
        textField.stringValue = window.tabbingIdentifier;
        [textField sizeToFit];
        textField.frame = NSMakeRect(0., 0., 300., NSHeight(textField.frame));
        
        alert.accessoryView = textField;
        
        [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
            NSString *stringValue = textField.stringValue;
            if (stringValue.length == 0) {
                NSLog(@"Do nothing.");
                return;
            }
            
            window.tabbingIdentifier = textField.stringValue;
            [configurationView reconfigureItemModelsWithIdentifiers:@[@"Tabbing Identifier"]];
        }];
        
        [alert release];
        return NO;
    } else if ([identifier isEqualToString:@"Add Tabbed Window Ordered"]) {
        NSString *title = static_cast<NSString *>(newValue);
        NSWindowOrderingMode mode = NSWindowOrderingModeFromString(title);
        
        WindowDemoWindow *newWindow = [WindowDemoWindow new];
        [window addTabbedWindow:newWindow ordered:mode];
        [newWindow release];
        
        return NO;
    } else if ([identifier isEqualToString:@"Tabbed Windows"]) {
        return NO;
    } else if ([identifier isEqualToString:@"Tab Group Overview Visible"]) {
        BOOL boolValue = static_cast<NSNumber *>(newValue).boolValue;
        
        NSWindowTabGroup *tabGroup = window.tabGroup;
        tabGroup.overviewVisible = boolValue;
        return NO;
    } else if ([identifier isEqualToString:@"Tab Group Windows"]) {
        return NO;
    } else {
        abort();
    }
#pragma mark - Actions
}

@end
