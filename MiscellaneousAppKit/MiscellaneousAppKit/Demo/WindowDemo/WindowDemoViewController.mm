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
#import "NSStringFromNSEventMask.h"
#import "WindowDemoPostEventView.h"
#import "WindowDemoMakeFirstResponderView.h"
#import "WindowDemoKeyViewDemoView.h"
#import "NSStringFromNSSelectionDirection.h"
#import "WindowDemoCalculateKeyViewLoopView.h"
#import "WindowDemoAcceptsMouseMovedEventsView.h"
#import "WindowDemoRestoration.h"
#import "NSStringFromNSWindowAnimationBehavior.h"
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>
#import "WindowDemoDragView.h"
#import "WindowDemoConvertingCoordinatesView.h"
#import "NSStringFromNSWindowTitleVisibility.h"
#import "WindowDemoValidRequestorView.h"
#import "WindowDemoAnchorAttributeForOrientationView.h"
#import "NSStringFromNSDisplayGamut.h"

OBJC_EXPORT id objc_msgSendSuper2(void); /* objc_super superInfo = { self, [self class] }; */

UT_EXPORT NSArray<UTType *> *_UTGetAllCoreTypesConstants(void);

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
@property (assign, nonatomic, getter=_initialFirstResponder, setter=_setInitialFirstResponder:) BOOL initialFirstResponder;
@property (retain, nonatomic, getter=_mouseLocationOutsideOfEventStreamTimer, setter=_setMouseLocationOutsideOfEventStreamTimer:) NSTimer *mouseLocationOutsideOfEventStreamTimer;
@property (assign, nonatomic, getter=_restorationValue, setter=_setRestorationValue:) double restorationValue;
@property (retain, nonatomic, readonly, getter=_dragView) WindowDemoDragView *dragView;
@end

@implementation WindowDemoViewController
@synthesize ownView = _ownView;
@synthesize configurationView = _configurationView;
@synthesize toolbar = _toolbar;
@synthesize appearance = _appearance;
@synthesize windowDefaultButton = _windowDefaultButton;
@synthesize windowFieldEditorScrollView = _windowFieldEditorScrollView;
@synthesize dragView = _dragView;

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
    [_dragView release];
    
    if (NSWindow *window = self.view.window) {
        [window removeObserver:self forKeyPath:@"contentLayoutRect"];
        [window removeObserver:self forKeyPath:@"tabGroup"];
        
        if (__kindof NSWindowTabGroup *tabGroup = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(window, sel_registerName("_windowStackController"))) {
            [tabGroup removeObserver:self forKeyPath:@"windows"];
            [tabGroup removeObserver:self forKeyPath:@"selectedWindow"];
        }
    }
    
    if (NSTimer *mouseLocationOutsideOfEventStreamTimer = self.mouseLocationOutsideOfEventStreamTimer) {
        [mouseLocationOutsideOfEventStreamTimer invalidate];
        [mouseLocationOutsideOfEventStreamTimer release];
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
                    [oldTabGroup removeObserver:self forKeyPath:@"selectedWindow"];
                }
            }
            
            NSWindowTabGroup *newTabGroup = change[NSKeyValueChangeNewKey];
            if (newTabGroup == nil) newTabGroup = self.view.window.tabGroup;
            if ([newTabGroup isKindOfClass:[NSNull class]]) newTabGroup = self.view.window.tabGroup;
            
            if (newTabGroup != nil) {
                [newTabGroup addObserver:self forKeyPath:@"windows" options:NSKeyValueObservingOptionNew context:NULL];
                [newTabGroup addObserver:self forKeyPath:@"selectedWindow" options:NSKeyValueObservingOptionNew context:NULL];
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
    } else if ([keyPath isEqualToString:@"selectedWindow"]) {
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

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder backgroundQueue:(NSOperationQueue *)queue {
    [super encodeRestorableStateWithCoder:coder backgroundQueue:queue];
    
    [queue addOperationWithBlock:^{
        [coder encodeDouble:self.restorationValue forKey:@"WindowDemoViewController.restorationValue"];
    }];
}

- (void)restoreStateWithCoder:(NSCoder *)coder {
    [super restoreStateWithCoder:coder];
    self.restorationValue = [coder decodeDoubleForKey:@"WindowDemoViewController.restorationValue"];
    [self.configurationView reconfigureItemModelsWithIdentifiers:@[@"Restoration Value"]];
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
    
    WindowDemoDragView *dropView = self.dragView;
    dropView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.ownView addSubview:dropView];
    [NSLayoutConstraint activateConstraints:@[
        [dropView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [dropView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [dropView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:0.5],
        [dropView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:0.5]
    ]];
    
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
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_windowDidMoveScreen:) name:NSWindowDidChangeScreenNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_windowDidDeminiaturize:) name:NSWindowDidDeminiaturizeNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_windowDidMiniaturize:) name:NSWindowDidMiniaturizeNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_windowWillMiniaturize:) name:NSWindowWillMiniaturizeNotification object:nil];
    
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

- (void)_windowDidMoveScreen:(NSNotification *)notification {
    [self.configurationView reconfigureItemModelsWithIdentifiers:@[@"Screen"]];
}

- (void)_windowDidDeminiaturize:(NSNotification *)notification {
    [self.configurationView reconfigureItemModelsWithIdentifiers:@[@"Miniaturized"]];
}

- (void)_windowDidMiniaturize:(NSNotification *)notification {
    [self.configurationView reconfigureItemModelsWithIdentifiers:@[@"Miniaturized"]];
}

- (void)_windowWillMiniaturize:(NSNotification *)notification {
    [self.configurationView reconfigureItemModelsWithIdentifiers:@[@"Miniaturized"]];
}

- (void)newWindowForTab:(id)sender {
    WindowDemoWindow *newWindow = [WindowDemoWindow new];
    [self.view.window.tabGroup addWindow:newWindow];
    [newWindow release];
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

- (WindowDemoDragView *)_dragView {
    if (auto dropView = _dragView) return dropView;
    
    WindowDemoDragView *dropView = [WindowDemoDragView new];
    dropView.hidden = YES;
    
    _dragView = dropView;
    return dropView;
}

- (void)_reload {
    NSDiffableDataSourceSnapshot *snapshot = [NSDiffableDataSourceSnapshot new];
    [snapshot appendSectionsWithIdentifiers:@[[NSNull null]]];
    
#pragma mark - Items 1
    [snapshot appendItemsWithIdentifiers:@[
        [self _makeIsFloatingPanelItemModel],
        [self _makeIsModalPanelItemModel],
        [self _makeHasTitleBarItemModel],
        [self _makeHasCloseBoxItemModel],
        [self _makeCanRepresentDisplayGamutItemModel],
        [self _makeAnchorAttributeForOrientationItemModel],
        [self _makeVisualizeConstraintsItemModel],
        [self _makeLayoutIfNeededItemModel],
        [self _makeUpdateConstraintsIfNeededItemModel],
        [self _makeValidRequestorForSendTypeReturnTypeItemModel],
        [self _makeDataWithPDFInsideRectItemModel],
        [self _makeDataWithEPSInsideRectItemModel],
        [self _makePrintItemModel],
        [self _makeDockTileContentViewItemModel],
        [self _makeDockTileBadgeLabelItemModel],
        [self _makeDockTileShowsApplicationBadgeItemModel],
        [self _makeDockTileItemModel],
        [self _makeMiniwindowTitleItemModel],
        [self _makeMiniwindowImageItemModel],
        [self _makeDeminiaturizeItemModel],
        [self _makeMiniaturizeItemModel],
        [self _makePerformMiniaturizeItemModel],
        [self _makeMiniaturizedItemModel],
        [self _makeCloseItemModel],
        [self _makePerformCloseItemModel],
        [self _makeReleasedWhenClosedItemModel],
        [self _makeCenterItemModel],
        [self _makeMovableItemModel],
        [self _makeMovableByWindowBackgroundItemModel],
        [self _makeDisplaysWhenScreenProfileChangesItemModel],
        [self _makeDeepestScreenItemModel],
        [self _makeScreenItemModel],
        [self _makeRepresentedURLItemModel],
        [self _makeTitleVisibilityItemModel],
        [self _makeSubtitleItemModel],
        [self _makeTitleItemModel],
        [self _makeConvertRectToScreenItemModel],
        [self _makeConvertRectToBackingItemModel],
        [self _makeConvertRectFromScreenItemModel],
        [self _makeConvertRectFromBackingItemModel],
        [self _makeBackingAlignedRectItemModel],
        [self _makeBackingScaleFactorItemModel],
        [self _makeDocumentEditedItemModel],
        [self _makeRegisterForAllDraggedTypesItemModel],
        [self _makeDragViewVisibilityItemModel],
        [self _makeUnregisterDraggedTypes],
        [self _makeRegisterForDraggedTypesItemModel],
        [self _makeAnimationBehaviorItemModel],
        [self _makeAllowsConcurrentViewDrawingItemModel],
        [self _makeSnapshotRestorationItemModel],
        [self _makeRestorationNumberItemModel],
        [self _makeRestorableItemModel],
        [self _makeRestorationClassItemModel],
        [self _makeTrackEventsMatchingMaskTimeoutModeHandlerItemModel],
        [self _makeWindowNumberAtPointBelowWindowWithWindowNumberItemModel],
        [self _makeMouseLocationOutsideOfEventStreamItemModel],
        [self _makeIgnoresMouseEventsItemModel],
        [self _makeAcceptsMouseMovedEventsItemModel],
        [self _makeTransferWindowSharingToWindowItemModel],
        [self _makeHasActiveWindowSharingSessionItemModel],
        [self _makeAutorecalculatesKeyViewLoopItemModel],
        [self _makeKeyViewSelectionDirectionItemModel],
        [self _makeKeyViewItemModel],
        [self _makeMakeFirstResponderItemModel],
        [self _makeFirstResponderItemModel],
        [self _makeInitialFirstResponderItemModel],
        [self _makeTryToPerformWithItemModel],
        [self _makePostEventAtStartItemModel],
        [self _makeDiscardEventsMatchingMaskBeforeEventItemModel],
        [self _makeNextEventMatchingMaskUntilDateInModeDequeueItemModel],
        [self _makeNextEventMatchingMaskUntilDateInModeDequeue_Dequeue_ItemModel],
        [self _makeNextEventMatchingMaskItemModel],
        [self _makeCurrentEventItemModel],
        [self _makeAllowsToolTipsWhenApplicationIsInactiveItemModel],
        [self _makeToggleTabOverviewItemModel],
        [self _makeMoveTabToNewWindowItemModel],
        [self _makeSelectPreviousTabItemModel],
        [self _makeSelectNextTabItemModel],
        [self _makeMergeAllWindowsItemModel],
        [self _makeRemoveWindowItemModel],
        [self _makeTabGroupInsertWindowAtIndexItemModel],
        [self _makeTabGroupAddWindowItemModel],
        [self _makeTabGroupSelectedWindowItemModel],
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
        const NSWindowStyleMask *styleMasks = allNSWindowStyleMasks(&count);
        NSWindowStyleMask styleMask = unretainedSelf.view.window.styleMask;
        
        NSMutableArray<NSString *> *allTitles = [[NSMutableArray alloc] initWithCapacity:count];
        NSMutableArray<NSString *> *selectedTitles = [NSMutableArray new];
        
        for (const NSWindowStyleMask *_styleMaskPtr : std::views::iota(styleMasks, styleMasks + count)) {
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
            [titles release];
            return @"nil";
        }
        NSString *name = colorSpace.localizedName;
        if (name == nil) {
            [titles release];
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
        const NSWindowDepth *depths = allNSWindowDepths(&count);
        
        NSMutableArray<NSString *> *titles = [[NSMutableArray alloc] initWithCapacity:count];
        for (const NSWindowDepth *depthPtr : std::views::iota(depths, depths + count)) {
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
        const NSWindowDepth *depths = allNSWindowDepths(&count);
        
        NSMutableArray<NSString *> *titles = [[NSMutableArray alloc] initWithCapacity:count];
        for (const NSWindowDepth *depthPtr : std::views::iota(depths, depths + count)) {
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
        const NSRectEdge *allEdges = allNSRectEdges(&count);
        
        auto titlesVector = std::views::iota(allEdges, allEdges + count)
        | std::views::transform([](const NSRectEdge *ptr) { return *ptr; })
        | std::views::transform([](const NSRectEdge edge) -> NSString * {
            return NSStringFromNSRectEdge(edge);
        })
        | std::ranges::to<std::vector<NSString *>>();
        
        auto selectedTitlesVector = std::views::iota(allEdges, allEdges + count)
        | std::views::transform([](const NSRectEdge *ptr) { return *ptr; })
        | std::views::filter([window = unretainedSelf.view.window](NSRectEdge edge) {
            return [window autorecalculatesContentBorderThicknessForEdge:edge];
        })
        | std::views::transform([](const NSRectEdge edge) -> NSString * {
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
        const NSWindowNumberListOptions *allOptions = allNSWindowNumberListOptions(&count);
        
        auto optionTitlesVector = std::views::iota(allOptions, allOptions + count)
        | std::views::transform([](const NSWindowNumberListOptions *ptr) -> const NSWindowNumberListOptions { return *ptr; })
        | std::views::transform([](const NSWindowNumberListOptions option) -> NSString * {
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
        const NSWindowSharingType *allTypes = allNSWindowSharingTypes(&count);
        
        auto titlesVector = std::views::iota(allTypes, allTypes + count)
        | std::views::transform([](const NSWindowSharingType *ptr) { return *ptr; })
        | std::views::transform([](const NSWindowSharingType type) {
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
        const NSWindowLevel *allLevels = allNSWindowLevels(&count);
        
        auto levelTitlesVector = std::views::iota(allLevels, allLevels + count)
        | std::views::transform([](const NSWindowLevel *levelPtr) -> NSString * {
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
        const NSWindowOrderingMode *allModes = allNSWindowOrderingModes(&count);
        
        auto titlesVector = std::views::iota(allModes, allModes + count)
        | std::views::transform([](const NSWindowOrderingMode *modePtr) {
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
        const NSWindowToolbarStyle *allStyles = allNSWindowToolbarStyles(&count);
        
        auto titlesVector = std::views::iota(allStyles, allStyles + count)
        | std::views::transform([](const NSWindowToolbarStyle *ptr) {
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
        const NSTitlebarSeparatorStyle *allStyles = allNSTitlebarSeparatorStyles(&count);
        
        auto titlesVector = std::views::iota(allStyles, allStyles + count)
        | std::views::transform([](const NSTitlebarSeparatorStyle *ptr) {
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
        const NSWindowTabbingMode *allModes = allNSWindowTabbingModes(&count);
        
        auto titles = std::views::iota(allModes, allModes + count)
        | std::views::transform([](const NSWindowTabbingMode *ptr) {
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
        const NSWindowOrderingMode *allModes = allNSWindowOrderingModes(&count);
        
        auto titlesVector = std::views::iota(allModes, allModes + count)
        | std::views::transform([](const NSWindowOrderingMode *ptr) {
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

- (ConfigurationItemModel *)_makeTabGroupSelectedWindowItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Tab Group Selected Window"
                                            userInfo:nil
                                               label:@"Tab Group Selected Window"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSMenu *menu = [NSMenu new];
        
        __kindof NSWindowTabGroup *tabGroup = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(unretainedSelf.view.window, sel_registerName("_windowStackController"));
        
        for (NSWindow *window in tabGroup.windows) {
            NSMenuItem *item = [NSMenuItem new];
            item.title = window.description;
            item.state = ([window isEqual:tabGroup.selectedWindow]) ? NSControlStateValueOn : NSControlStateValueOff;
            
            __block auto unreaintedWindow = window;
            ActionResolver *resolver = [ActionResolver resolver:^(id  _Nonnull sender) {
                tabGroup.selectedWindow = unreaintedWindow;
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

- (ConfigurationItemModel *)_makeTabGroupAddWindowItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Tab Group Add Window"
                                            userInfo:nil
                                               label:@"Tab Group Add Window"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeTabGroupInsertWindowAtIndexItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                          identifier:@"Tab Group Insert Window At Index"
                                            userInfo:nil
                                               label:@"Tab Group Insert Window At Index"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        __kindof NSWindowTabGroup *tabGroup = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(unretainedSelf.view.window, sel_registerName("_windowStackController"));
        NSInteger windowsCount = tabGroup.windows.count;
        
        auto titlesVector = std::views::iota(0, windowsCount + 1)
        | std::views::transform([](NSInteger index) {
            return @(index).stringValue;
        })
        | std::ranges::to<std::vector<NSString *>>();
        
        return [ConfigurationPopUpButtonDescription descriptionWithTitles:[NSArray arrayWithObjects:titlesVector.data() count:titlesVector.size()]
                                                           selectedTitles:@[]
                                                     selectedDisplayTitle:nil];
    }];
}

- (ConfigurationItemModel *)_makeRemoveWindowItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Tab Group Remove Window"
                                            userInfo:nil
                                               label:@"Tab Group Remove Window"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSMenu *menu = [NSMenu new];
        
        __kindof NSWindowTabGroup *tabGroup = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(unretainedSelf.view.window, sel_registerName("_windowStackController"));
        
        for (NSWindow *window in tabGroup.windows) {
            NSMenuItem *item = [NSMenuItem new];
            item.title = window.description;
            
            __block auto unreaintedWindow = window;
            ActionResolver *resolver = [ActionResolver resolver:^(id  _Nonnull sender) {
                [tabGroup removeWindow:unreaintedWindow];
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

- (ConfigurationItemModel *)_makeMergeAllWindowsItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Merge All Windows"
                                            userInfo:nil
                                               label:@"Merge All Windows"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeSelectNextTabItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Select Next Tab"
                                            userInfo:nil
                                               label:@"Select Next Tab"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeSelectPreviousTabItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Select Previous Tab"
                                            userInfo:nil
                                               label:@"Select Previous Tab"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeMoveTabToNewWindowItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Move Tab To New Window"
                                            userInfo:nil
                                               label:@"Move Tab To New Window"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeToggleTabOverviewItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Toggle Tab Overview"
                                            userInfo:nil
                                               label:@"Toggle Tab Overview"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeAllowsToolTipsWhenApplicationIsInactiveItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                          identifier:@"Allows ToolTips When Application Is Inactive"
                                            userInfo:nil
                                               label:@"Allows ToolTips When Application Is Inactive"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return @(unretainedSelf.view.window.allowsToolTipsWhenApplicationIsInactive);
    }];
}

- (ConfigurationItemModel *)_makeCurrentEventItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Current Event"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Current Event : %@", unretainedSelf.view.window.currentEvent];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Reload"];
    }];
}

- (ConfigurationItemModel *)_makeNextEventMatchingMaskItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                          identifier:@"Next Event Matching Mask"
                                            userInfo:nil
                                               label:@"Next Event Matching Mask"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSUInteger count;
        const NSEventMask *allMasks = allNSEventMasks(&count);
        
        auto titlesVetor = std::views::iota(allMasks, allMasks + count)
        | std::views::transform([](const NSEventMask *ptr) {
            return NSStringFromNSEventMask(*ptr);
        })
        | std::ranges::to<std::vector<NSString *>>();
        
        return [ConfigurationPopUpButtonDescription descriptionWithTitles:[NSArray arrayWithObjects:titlesVetor.data() count:titlesVetor.size()] selectedTitles:@[] selectedDisplayTitle:nil];
    }];
}

- (ConfigurationItemModel *)_makeNextEventMatchingMaskUntilDateInModeDequeueItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                          identifier:@"Next Event Matching Mask Until Date In Mode Dequeue"
                                            userInfo:nil
                                               label:@"Next Event Matching Mask Until Date In Mode Dequeue"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSUInteger count;
        const NSEventMask *allMasks = allNSEventMasks(&count);
        
        auto titlesVetor = std::views::iota(allMasks, allMasks + count)
        | std::views::transform([](const NSEventMask *ptr) {
            return NSStringFromNSEventMask(*ptr);
        })
        | std::ranges::to<std::vector<NSString *>>();
        
        return [ConfigurationPopUpButtonDescription descriptionWithTitles:[NSArray arrayWithObjects:titlesVetor.data() count:titlesVetor.size()] selectedTitles:@[] selectedDisplayTitle:nil];
    }];
}

- (ConfigurationItemModel *)_makeNextEventMatchingMaskUntilDateInModeDequeue_Dequeue_ItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                          identifier:@"Next Event Matching Mask Until Date In Mode Dequeue (Dequeue)"
                                            userInfo:nil
                                               label:@"Next Event Matching Mask Until Date In Mode Dequeue (Dequeue)"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSUInteger count;
        const NSEventMask *allMasks = allNSEventMasks(&count);
        
        auto titlesVetor = std::views::iota(allMasks, allMasks + count)
        | std::views::transform([](const NSEventMask *ptr) {
            return NSStringFromNSEventMask(*ptr);
        })
        | std::ranges::to<std::vector<NSString *>>();
        
        return [ConfigurationPopUpButtonDescription descriptionWithTitles:[NSArray arrayWithObjects:titlesVetor.data() count:titlesVetor.size()] selectedTitles:@[] selectedDisplayTitle:nil];
    }];
}

- (ConfigurationItemModel *)_makeDiscardEventsMatchingMaskBeforeEventItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                          identifier:@"Next Event Matching Mask Until Date In Mode Dequeue (Dequeue) + Discard Events Matching Mask Before Event"
                                            userInfo:nil
                                               label:@"Next Event Matching Mask Until Date In Mode Dequeue (Dequeue) + Discard Events Matching Mask Before Event"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSUInteger count;
        const NSEventMask *allMasks = allNSEventMasks(&count);
        
        auto titlesVetor = std::views::iota(allMasks, allMasks + count)
        | std::views::transform([](const NSEventMask *ptr) {
            return NSStringFromNSEventMask(*ptr);
        })
        | std::ranges::to<std::vector<NSString *>>();
        
        return [ConfigurationPopUpButtonDescription descriptionWithTitles:[NSArray arrayWithObjects:titlesVetor.data() count:titlesVetor.size()] selectedTitles:@[] selectedDisplayTitle:nil];
    }];
}

- (ConfigurationItemModel *)_makePostEventAtStartItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Post Event At Start"
                                            userInfo:nil
                                               label:@"Post Event At Start"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeTryToPerformWithItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                          identifier:@"Try To Perform With"
                                            userInfo:nil
                                               label:@"Try To Perform With"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        WindowDemoWindow *window = static_cast<WindowDemoWindow *>(unretainedSelf.view.window);
        return @(window.tryToPerformEnabled);
    }];
}

- (ConfigurationItemModel *)_makeInitialFirstResponderItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                          identifier:@"Initial First Responder"
                                            userInfo:nil
                                               label:@"Initial First Responder"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return @(unretainedSelf.initialFirstResponder);
    }];
}

- (ConfigurationItemModel *)_makeFirstResponderItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeLabel
                                          identifier:@"First Responder"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"First Responder : %@", unretainedSelf.view.window.firstResponder];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
}

- (ConfigurationItemModel *)_makeMakeFirstResponderItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Make First Responder"
                                            userInfo:nil
                                               label:@"Make First Responder"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeKeyViewItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Key View"
                                            userInfo:nil
                                               label:@"Key View"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeKeyViewSelectionDirectionItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeLabel
                                          identifier:@"Key View Selection Direction"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Key View Selection Direction : %@", NSStringFromNSSelectionDirection(unretainedSelf.view.window.keyViewSelectionDirection)];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
}

- (ConfigurationItemModel *)_makeAutorecalculatesKeyViewLoopItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Autorecalculates Key View Loop"
                                            userInfo:nil
                                               label:@"Autorecalculates Key View Loop"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeHasActiveWindowSharingSessionItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeLabel
                                          identifier:@"Has Active Window Sharing Session"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Has Active Window Sharing Session : %@", unretainedSelf.view.window.hasActiveWindowSharingSession ? @"YES" : @"NO"];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
}

- (ConfigurationItemModel *)_makeTransferWindowSharingToWindowItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Transfer Window Sharing To Window"
                                            userInfo:nil
                                               label:@"Transfer Window Sharing To Window"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSMenu *menu = [NSMenu new];
        
        for (NSWindow *window in NSApp.windows) {
            NSMenuItem *item = [NSMenuItem new];
            item.title = window.description;
            
            if ([window isEqual:unretainedSelf.view.window]) {
                item.enabled = NO;
            } else {
                item.enabled = YES;
                
                __block auto unretainedWindow = unretainedSelf.view.window;
                ActionResolver *resolver = [ActionResolver resolver:^(id  _Nonnull sender) {
                    [unretainedWindow transferWindowSharingToWindow:window completionHandler:^(NSError * _Nullable error) {
                        assert(error == nil);
                    }];
                }];
                [resolver setupMenuItem:item];
            }
            
            [menu addItem:item];
            [item release];
        }
        
        ConfigurationButtonDescription *description = [ConfigurationButtonDescription descriptionWithTitle:@"Menu" menu:menu showsMenuAsPrimaryAction:YES];
        [menu release];
        
        return description;
    }];
}

- (ConfigurationItemModel *)_makeAcceptsMouseMovedEventsItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Accepts Mouse Moved Events"
                                            userInfo:nil
                                               label:@"Accepts Mouse Moved Events"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeIgnoresMouseEventsItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                          identifier:@"Ignores Mouse Events"
                                            userInfo:nil
                                               label:@"Ignores Mouse Events (Disable after 3 seconds)"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return @(unretainedSelf.view.window.ignoresMouseEvents);
    }];
}

- (ConfigurationItemModel *)_makeMouseLocationOutsideOfEventStreamItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                          identifier:@"Mouse Location Outside Of Event Stream"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Mouse Location Outside Of Event Stream : %@", NSStringFromPoint(unretainedSelf.view.window.mouseLocationOutsideOfEventStream)];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return @(unretainedSelf.mouseLocationOutsideOfEventStreamTimer != nil);
    }];
}

- (ConfigurationItemModel *)_makeWindowNumberAtPointBelowWindowWithWindowNumberItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                          identifier:@"Window Number At Point Below Window With Window Number"
                                            userInfo:nil
                                               label:@"Window Number At Point Below Window With Window Number"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSArray<NSWindow *> *windows = NSApp.windows;
        NSMutableArray<NSString *> *titles = [[NSMutableArray alloc] initWithCapacity:windows.count];
        
        for (NSWindow *window in windows) {
            NSRect frame = window.frame;
            
            if ((NSWidth(frame) <= 0.) or (NSHeight(frame) <= 0.)) {
                [titles addObject:[NSString stringWithFormat:@"%@ (No Size)", window]];
                continue;
            }
            
            NSPoint centerPoint = NSMakePoint(NSMidX(frame), NSMidY(frame));
            NSInteger windowNumber = window.windowNumber;
            NSInteger output = [NSWindow windowNumberAtPoint:centerPoint belowWindowWithWindowNumber:0];
            
            NSUInteger tryCount = 0;
            while ((windowNumber != output) and (tryCount++ < 30)) {
                output = [NSWindow windowNumberAtPoint:centerPoint belowWindowWithWindowNumber:output];
            }
            
            [titles addObject:[NSString stringWithFormat:@"%@, centerPoint : %@, windowNumber : %ld, output : %ld", window, NSStringFromPoint(centerPoint), window.windowNumber, output]];
        }
        
        ConfigurationPopUpButtonDescription *description = [ConfigurationPopUpButtonDescription descriptionWithTitles:titles selectedTitles:@[] selectedDisplayTitle:nil];
        [titles release];
        return description;
    }];
}

- (ConfigurationItemModel *)_makeTrackEventsMatchingMaskTimeoutModeHandlerItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                          identifier:@"Track Events Matching Mask Timeout Mode Handler"
                                            userInfo:nil
                                               label:@"Track Events Matching Mask Timeout Mode Handler"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSUInteger count;
        const NSEventMask *allMasks = allNSEventMasks(&count);
        
        auto titlesVector = std::views::iota(allMasks, allMasks + count)
        | std::views::transform([](const NSEventMask *ptr) {
            return NSStringFromNSEventMask(*ptr);
        })
        | std::ranges::to<std::vector<NSString *>>();
        
        return [ConfigurationPopUpButtonDescription descriptionWithTitles:[NSArray arrayWithObjects:titlesVector.data() count:titlesVector.size()]
                                                           selectedTitles:@[]
                                                     selectedDisplayTitle:nil];
    }];
}

- (ConfigurationItemModel *)_makeRestorationClassItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                          identifier:@"Restoration Class"
                                            userInfo:nil
                                               label:@"Restoration Class"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return @(unretainedSelf.view.window.restorationClass != nil);
    }];
}

- (ConfigurationItemModel *)_makeRestorableItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                          identifier:@"Restorable"
                                            userInfo:nil
                                               label:@"Restorable"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return @(unretainedSelf.view.window.restorable);
    }];
}

- (ConfigurationItemModel *)_makeRestorationNumberItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeStepper
                                          identifier:@"Restoration Value"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Restoration Value : %lf", unretainedSelf.restorationValue];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationStepperDescription descriptionWithStepperValue:unretainedSelf.restorationValue
                                                               minimumValue:0.
                                                               maximumValue:100.
                                                                  stepValue:5.
                                                                 continuous:YES
                                                                 autorepeat:YES
                                                                 valueWraps:YES];
    }];
}

- (ConfigurationItemModel *)_makeSnapshotRestorationItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                          identifier:@"Snapshot Restoration"
                                            userInfo:nil
                                               label:@"Snapshot Restoration"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        BOOL _isSnapshotRestorationEnabled = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(unretainedSelf.view.window, sel_registerName("_isSnapshotRestorationEnabled"));
        return @(_isSnapshotRestorationEnabled);
    }];
}

- (ConfigurationItemModel *)_makeAllowsConcurrentViewDrawingItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                          identifier:@"Allows Concurrent View Drawing"
                                            userInfo:nil
                                               label:@"Allows Concurrent View Drawing"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return @(unretainedSelf.view.window.allowsConcurrentViewDrawing);
    }];
}

- (ConfigurationItemModel *)_makeAnimationBehaviorItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                          identifier:@"Animation Behavior"
                                            userInfo:nil
                                               label:@"Animation Behavior (Ouder Out & Front after 3 seconds)"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSUInteger count;
        const NSWindowAnimationBehavior *allBehaviors = allNSWindowAnimationBehaviors(&count);
        
        auto titlesVector = std::views::iota(allBehaviors, allBehaviors + count)
        | std::views::transform([](const NSWindowAnimationBehavior *ptr) {
            return NSStringFromNSWindowAnimationBehavior(*ptr);
        })
        | std::ranges::to<std::vector<NSString *>>();
        
        NSString *selectedTitle = NSStringFromNSWindowAnimationBehavior(unretainedSelf.view.window.animationBehavior);
        
        return [ConfigurationPopUpButtonDescription descriptionWithTitles:[NSArray arrayWithObjects:titlesVector.data() count:titlesVector.size()]
                                                           selectedTitles:@[selectedTitle]
                                                     selectedDisplayTitle:selectedTitle];
    }];
}

// https://x.com/_silgen_name/status/1892978156069626217
- (ConfigurationItemModel *)_makeRegisterForDraggedTypesItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                          identifier:@"Register For Dragged Types"
                                            userInfo:nil
                                               label:@"Register For Dragged Types"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSArray<UTType *> *allTypes = _UTGetAllCoreTypesConstants();
        NSMutableArray<NSString *> *identifiers = [[NSMutableArray alloc] initWithCapacity:allTypes.count];
        for (UTType *type in allTypes) {
            [identifiers addObject:type.identifier];
        }
        
        NSMutableSet<NSString *> * _Nullable _dragTypes;
        assert(object_getInstanceVariable(unretainedSelf.view.window, "_dragTypes", reinterpret_cast<void **>(&_dragTypes)) != NULL);
        NSArray<NSString *> *registeredIdentfiers;
        if (_dragTypes != nil) {
            registeredIdentfiers = _dragTypes.allObjects;
        } else {
            registeredIdentfiers = @[];
        }
        
        ConfigurationPopUpButtonDescription *description = [ConfigurationPopUpButtonDescription descriptionWithTitles:identifiers selectedTitles:registeredIdentfiers selectedDisplayTitle:registeredIdentfiers.firstObject];
        [identifiers release];
        
        return description;
    }];
}

- (ConfigurationItemModel *)_makeUnregisterDraggedTypes {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Unregister Dragged Types"
                                            userInfo:nil
                                               label:@"Unregister Dragged Types"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeDragViewVisibilityItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                          identifier:@"Drag View Visibility"
                                            userInfo:nil
                                               label:@"Drag View Visibility"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return @(!unretainedSelf.dragView.hidden);
    }];
}

- (ConfigurationItemModel *)_makeRegisterForAllDraggedTypesItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Register For All Dragged Types"
                                            userInfo:nil
                                               label:@"Register For All Dragged Types"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeDocumentEditedItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                          identifier:@"Document Edited"
                                            userInfo:nil
                                               label:@"Document Edited"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return @(unretainedSelf.view.window.documentEdited);
    }];
}

- (ConfigurationItemModel *)_makeBackingScaleFactorItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeLabel
                                          identifier:@"Backing Scale Factor"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Backing Scale Factor : %lf", unretainedSelf.view.window.backingScaleFactor];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
}

- (ConfigurationItemModel *)_makeBackingAlignedRectItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Backing Aligned Rect"
                                            userInfo:nil
                                               label:@"Backing Aligned Rect"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Alert"];
    }];
}

- (ConfigurationItemModel *)_makeConvertRectFromBackingItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Convert Rect From Backing"
                                            userInfo:nil
                                               label:@"Convert Rect From Backing"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Alert"];
    }];
}

- (ConfigurationItemModel *)_makeConvertRectFromScreenItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Convert Rect From Screen"
                                            userInfo:nil
                                               label:@"Convert Rect From Screen"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Alert"];
    }];
}

- (ConfigurationItemModel *)_makeConvertRectToBackingItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Convert Rect To Backing"
                                            userInfo:nil
                                               label:@"Convert Rect To Backing"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Alert"];
    }];
}

- (ConfigurationItemModel *)_makeConvertRectToScreenItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Convert Rect To Screen"
                                            userInfo:nil
                                               label:@"Convert Rect To Screen"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Alert"];
    }];
}

- (ConfigurationItemModel *)_makeTitleItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Title"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Title : %@", unretainedSelf.view.window.title];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Alert"];
    }];
}

- (ConfigurationItemModel *)_makeSubtitleItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Subtitle"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Subtitle : %@", unretainedSelf.view.window.subtitle];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Alert"];
    }];
}

- (ConfigurationItemModel *)_makeTitleVisibilityItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                          identifier:@"Title Visibility"
                                            userInfo:nil
                                               label:@"Title Visibility"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSUInteger count;
        const NSWindowTitleVisibility *allVisibilities = allNSWindowTitleVisibilities(&count);
        
        auto titlesVector = std::views::iota(allVisibilities, allVisibilities + count)
        | std::views::transform([](const NSWindowTitleVisibility *ptr) {
            return NSStringFromNSWindowTitleVisibility(*ptr);
        })
        | std::ranges::to<std::vector<NSString *>>();
        
        NSString *selectedTitle = NSStringFromNSWindowTitleVisibility(unretainedSelf.view.window.titleVisibility);
        
        return [ConfigurationPopUpButtonDescription descriptionWithTitles:[NSArray arrayWithObjects:titlesVector.data() count:titlesVector.size()]
                                                           selectedTitles:@[selectedTitle]
                                                     selectedDisplayTitle:selectedTitle];
    }];
}

- (ConfigurationItemModel *)_makeRepresentedURLItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Represented URL"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Represented URL : %@", unretainedSelf.view.window.representedURL];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Alert"];
    }];
}

- (ConfigurationItemModel *)_makeScreenItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeLabel
                                          identifier:@"Screen"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Screen : %@", unretainedSelf.view.window.screen];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
}

- (ConfigurationItemModel *)_makeDeepestScreenItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Deepest Screen"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Deepest Screen (Reconfigure after 3 seconds) : %@", unretainedSelf.view.window.deepestScreen];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeDisplaysWhenScreenProfileChangesItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                          identifier:@"Displays When Screen Profile Changes"
                                            userInfo:nil
                                               label:@"Displays When Screen Profile Changes"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return @(unretainedSelf.view.window.displaysWhenScreenProfileChanges);
    }];
}

- (ConfigurationItemModel *)_makeMovableByWindowBackgroundItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                          identifier:@"Movable By Window Background"
                                            userInfo:nil
                                               label:@"Movable By Window Background"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return @(unretainedSelf.view.window.movableByWindowBackground);
    }];
}

- (ConfigurationItemModel *)_makeMovableItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                          identifier:@"Movable"
                                            userInfo:nil
                                               label:@"Movable"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return @(unretainedSelf.view.window.movable);
    }];
}

- (ConfigurationItemModel *)_makeCenterItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Center"
                                            userInfo:nil
                                               label:@"Center"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeReleasedWhenClosedItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                          identifier:@"Released When Closed"
                                            userInfo:nil
                                               label:@"Released When Closed"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return @(unretainedSelf.view.window.releasedWhenClosed);
    }];
}

- (ConfigurationItemModel *)_makePerformCloseItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Perform Close"
                                            userInfo:nil
                                               label:@"Perform Close"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeCloseItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Close"
                                            userInfo:nil
                                               label:@"Close"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeMiniaturizedItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeLabel
                                          identifier:@"Miniaturized"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Miniaturized : %@", unretainedSelf.view.window.miniaturized ? @"YES" : @"NO"];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
}

- (ConfigurationItemModel *)_makePerformMiniaturizeItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Perform Miniaturize"
                                            userInfo:nil
                                               label:@"Perform Miniaturize"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeMiniaturizeItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Miniaturize"
                                            userInfo:nil
                                               label:@"Miniaturize"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeDeminiaturizeItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Deminiaturize"
                                            userInfo:nil
                                               label:@"Deminiaturize (Miniaturize and Deminiaturize after 3 seconds)"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeMiniwindowImageItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                          identifier:@"Miniwindow Image"
                                            userInfo:nil
                                               label:@"Miniwindow Image"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return @(unretainedSelf.view.window.miniwindowImage != nil);
    }];
}

- (ConfigurationItemModel *)_makeMiniwindowTitleItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Miniwindow Title"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Miniwindow Title : %@", unretainedSelf.view.window.miniwindowTitle];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeDockTileItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeLabel
                                          identifier:@"Dock Title"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Dock Title : %@", unretainedSelf.view.window.dockTile];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
}

- (ConfigurationItemModel *)_makeDockTileShowsApplicationBadgeItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                          identifier:@"Dock Tile - Shows Application Badge"
                                            userInfo:nil
                                               label:@"Dock Tile - Shows Application Badge"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return @(unretainedSelf.view.window.dockTile.showsApplicationBadge);
    }];
}

- (ConfigurationItemModel *)_makeDockTileBadgeLabelItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Dock Tile - Badge Label"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Dock Tile - Badge Label : %@", unretainedSelf.view.window.dockTile.badgeLabel];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Alert"];
    }];
}

- (ConfigurationItemModel *)_makeDockTileContentViewItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                          identifier:@"Dock Tile - Content View"
                                            userInfo:nil
                                               label:@"Dock Tile - Content View"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return @(unretainedSelf.view.window.dockTile.contentView != nil);
    }];
}

- (ConfigurationItemModel *)_makePrintItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Print"
                                            userInfo:nil
                                               label:@"Print"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Print"];
    }];
}

- (ConfigurationItemModel *)_makeDataWithEPSInsideRectItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Data With EPS Inside Rect"
                                            userInfo:nil
                                               label:@"Data With EPS Inside Rect"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Print"];
    }];
}

- (ConfigurationItemModel *)_makeDataWithPDFInsideRectItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Data With PDF Inside Rect"
                                            userInfo:nil
                                               label:@"Data With PDF Inside Rect"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Print"];
    }];
}

- (ConfigurationItemModel *)_makeValidRequestorForSendTypeReturnTypeItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Valid Requestor For Send Type Return Type"
                                            userInfo:nil
                                               label:@"Valid Requestor For Send Type Return Type"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeUpdateConstraintsIfNeededItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Update Constraints If Needed"
                                            userInfo:nil
                                               label:@"Update Constraints If Needed"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeLayoutIfNeededItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Layout If Needed"
                                            userInfo:nil
                                               label:@"Layout If Needed"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeVisualizeConstraintsItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Visualize Constraints"
                                            userInfo:nil
                                               label:@"Visualize Constraints"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
}

- (ConfigurationItemModel *)_makeAnchorAttributeForOrientationItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Anchor Attribute For Orientation"
                                            userInfo:nil
                                               label:@"Anchor Attribute For Orientation"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Alert"];
    }];
}

- (ConfigurationItemModel *)_makeCanRepresentDisplayGamutItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                          identifier:@"Can Represent Display Gamut"
                                            userInfo:nil
                                               label:@"Can Represent Display Gamut"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSUInteger count;
        const NSDisplayGamut *allGamuts = allNSDisplayGamuts(&count);
        
        auto titleVector = std::views::iota(allGamuts, allGamuts + count)
        | std::views::transform([window = unretainedSelf.view.window](const NSDisplayGamut *ptr) {
            return [NSString stringWithFormat:@"%@ : %@", NSStringFromNSDisplayGamut(*ptr), [window canRepresentDisplayGamut:*ptr] ? @"Available" : @"Not Available"];
        })
        | std::ranges::to<std::vector<NSString *>>();
        
        return [ConfigurationPopUpButtonDescription descriptionWithTitles:[NSArray arrayWithObjects:titleVector.data() count:titleVector.size()]
                                                           selectedTitles:@[]
                                                     selectedDisplayTitle:nil];
    }];
}

- (ConfigurationItemModel *)_makeHasCloseBoxItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeLabel
                                          identifier:@"Has Close Box"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Has Close Box : %@", unretainedSelf.view.window.hasCloseBox ? @"YES" : @"NO"];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
}

- (ConfigurationItemModel *)_makeHasTitleBarItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeLabel
                                          identifier:@"Has Title Bar"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Has Title Bar : %@", unretainedSelf.view.window.hasTitleBar ? @"YES" : @"NO"];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
}

- (ConfigurationItemModel *)_makeIsModalPanelItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeLabel
                                          identifier:@"Is Modal Panel"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Is Modal Panel : %@", unretainedSelf.view.window.modalPanel ? @"YES" : @"NO"];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
}

- (ConfigurationItemModel *)_makeIsFloatingPanelItemModel {
    __block auto unretainedSelf = self;
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeLabel
                                          identifier:@"Is Floating Panel"
                                            userInfo:nil
                                       labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Is Floating Panel : %@", unretainedSelf.view.window.floatingPanel ? @"YES" : @"NO"];
    }
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
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
    [self.configurationView reconfigureItemModelsWithIdentifiers:@[@"Tabbed Windows", @"Tab Group Identifier", @"Tab Group Overview Visible", @"Tab Group Tab Bar Visible", @"Tab Group Windows", @"Tab Group Selected Window", @"Tab Group Insert Window At Index", @"Tab Group Remove Window"]];
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
        accessoryView.frame = NSMakeRect(0., 0., 300., accessoryView.fittingSize.height);
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
            [windowFieldEditorScrollView release];
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
    } else if ([identifier isEqualToString:@"Tab Group Add Window"]) {
        WindowDemoWindow *newWindow = [WindowDemoWindow new];
        [window.tabGroup addWindow:newWindow];
        [newWindow release];
        return NO;
    } else if ([identifier isEqualToString:@"Tab Group Insert Window At Index"]) {
        NSString *title = static_cast<NSString *>(newValue);
        NSInteger index = title.integerValue;
        
        WindowDemoWindow *newWindow = [WindowDemoWindow new];
        [window.tabGroup insertWindow:newWindow atIndex:index];
        [newWindow release];
        return NO;
    } else if ([identifier isEqualToString:@"Merge All Windows"]) {
        [window mergeAllWindows:nil];
        return NO;
    } else if ([identifier isEqualToString:@"Select Next Tab"]) {
        [window selectNextTab:nil];
        return NO;
    } else if ([identifier isEqualToString:@"Select Previous Tab"]) {
        [window selectPreviousTab:nil];
        return NO;
    } else if ([identifier isEqualToString:@"Move Tab To New Window"]) {
        [window moveTabToNewWindow:nil];
        return NO;
    } else if ([identifier isEqualToString:@"Toggle Tab Overview"]) {
        [window toggleTabOverview:nil];
        return NO;
    } else if ([identifier isEqualToString:@"Allows ToolTips When Application Is Inactive"]) {
        BOOL boolValue = static_cast<NSNumber *>(newValue).boolValue;
        window.allowsToolTipsWhenApplicationIsInactive = boolValue;
        return NO;
    } else if ([identifier isEqualToString:@"Current Event"]) {
        return YES;
    } else if ([identifier isEqualToString:@"Next Event Matching Mask"]) {
        NSString *title = static_cast<NSString *>(newValue);
        NSEventMask mask = NSEventMaskFromString(title);
        
        // [window nextEventMatchingMask:mask untilDate:[NSDate distantFuture] inMode:NSEventTrackingRunLoopMode dequeue:YES]
        NSEvent * _Nullable event = [window nextEventMatchingMask:mask];
        
        NSAlert *alert = [NSAlert new];
        alert.messageText = @"Result";
        alert.informativeText = event.description;
        
        [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
            
        }];
        [alert release];
        
        return NO;
    } else if ([identifier isEqualToString:@"Next Event Matching Mask Until Date In Mode Dequeue"]) {
        NSString *title = static_cast<NSString *>(newValue);
        NSEventMask mask = NSEventMaskFromString(title);
        
        // dequeue = NO이면 Waiting 상태에서 누른 Event가 다른 View에 전달되지만, YES는 전달되지 않고 소멸된다.
        NSEvent * _Nullable event = [window nextEventMatchingMask:mask untilDate:[NSDate.now dateByAddingTimeInterval:5.] inMode:NSEventTrackingRunLoopMode dequeue:NO];
        NSLog(@"%@", event);
        
        return NO;
    } else if ([identifier isEqualToString:@"Next Event Matching Mask Until Date In Mode Dequeue (Dequeue)"]) {
        NSString *title = static_cast<NSString *>(newValue);
        NSEventMask mask = NSEventMaskFromString(title);
        
        NSEvent * _Nullable event = [window nextEventMatchingMask:mask untilDate:[NSDate.now dateByAddingTimeInterval:5.] inMode:NSEventTrackingRunLoopMode dequeue:YES];
        NSLog(@"%@", event);
        
        return NO;
    } else if ([identifier isEqualToString:@"Next Event Matching Mask Until Date In Mode Dequeue (Dequeue) + Discard Events Matching Mask Before Event"]) {
        NSString *title = static_cast<NSString *>(newValue);
        NSEventMask mask = NSEventMaskFromString(title);
        
        // dequeue = NO이면 Waiting 상태에서 누른 Event가 다른 View에 전달되지만, YES는 전달되지 않고 소멸된다.
        NSEvent * _Nullable event = [window nextEventMatchingMask:mask untilDate:[NSDate.now dateByAddingTimeInterval:5.] inMode:NSEventTrackingRunLoopMode dequeue:NO];
        NSLog(@"%@", event);
        
        // 하지만 discard를 하면 즉시 소멸된다.
        // beforeEvent은 NSEvent의 시간을 가져와서, 이 이전에 생성된 모든 Event에 discard 한다는 것이다. (-[NSApplication(NSEventRouting) discardEventsMatchingMask:beforeEvent:])
        [window discardEventsMatchingMask:mask beforeEvent:nil];
        
        return NO;
    } else if ([identifier isEqualToString:@"Post Event At Start"]) {
        NSAlert *alert = [NSAlert new];
        WindowDemoPostEventView *accessoryView = [[WindowDemoPostEventView alloc] initWithFrame:NSMakeRect(0., 0., 300., 300.)];
        alert.accessoryView = accessoryView;
        [accessoryView release];
        
        alert.messageText = @"Drag!";
        
        [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
            
        }];
        [alert release];
        
        return NO;
    } else if ([identifier isEqualToString:@"Try To Perform With"]) {
        BOOL boolValue = static_cast<NSNumber *>(newValue).boolValue;
        static_cast<WindowDemoWindow *>(self.view.window).tryToPerformEnabled = boolValue;
        
        BOOL success = [window tryToPerform:@selector(cmdForTryToPerformWith:) with:nil];
        if (!success) {
            NSAlert *alert = [NSAlert new];
            alert.messageText = @"Alert";
            alert.informativeText = @"Not Responded...";
            
            [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
                
            }];
            
            [alert release];
        }
        
        return NO;
    } else if ([identifier isEqualToString:@"Initial First Responder"]) {
        BOOL boolValue = static_cast<NSNumber *>(newValue).boolValue;
        self.initialFirstResponder = boolValue;
        
        NSAlert *alert = [NSAlert new];
        
        alert.messageText = @"Title";
        
        NSTextField *textField_1 = [NSTextField new];
        NSTextField *textField_2 = [NSTextField new];
        
        NSStackView *stackView = [NSStackView new];
        [stackView addArrangedSubview:textField_1];
        [textField_1 release];
        [stackView addArrangedSubview:textField_2];
        stackView.orientation = NSUserInterfaceLayoutOrientationVertical;
        stackView.distribution = NSStackViewDistributionFillEqually;
        stackView.alignment = NSLayoutAttributeWidth;
        stackView.spacing = 0.;
        stackView.frame = NSMakeRect(0., 0., 300., stackView.fittingSize.height);
        
        alert.accessoryView = stackView;
        [stackView release];
        
        if (boolValue) {
            __kindof NSPanel *_panel = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(alert, sel_registerName("_panel"));
            _panel.initialFirstResponder = textField_2;
        }
        
        [textField_2 release];
        
        [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
            
        }];
        
        [alert release];
        return NO;
    } else if ([identifier isEqualToString:@"Make First Responder"]) {
        NSAlert *alert = [NSAlert new];
        
        WindowDemoMakeFirstResponderView *accessoryView = [WindowDemoMakeFirstResponderView new];
        accessoryView.frame = NSMakeRect(0., 0., 300., accessoryView.fittingSize.height);
        alert.accessoryView = accessoryView;
        [accessoryView release];
        
        [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
            
        }];
        [alert release];
        
        return NO;
    } else if ([identifier isEqualToString:@"Key View"]) {
        NSAlert *alert = [NSAlert new];
        
        WindowDemoKeyViewDemoView *accessoryView = [WindowDemoKeyViewDemoView new];
        accessoryView.frame = NSMakeRect(0., 0., 300., accessoryView.fittingSize.height);
        alert.accessoryView = accessoryView;
        [accessoryView release];
        
        [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
            
        }];
        [alert release];
        
        return NO;
    } else if ([identifier isEqualToString:@"Autorecalculates Key View Loop"]) {
        NSAlert *alert = [NSAlert new];
        
        WindowDemoCalculateKeyViewLoopView *accessoryView = [WindowDemoCalculateKeyViewLoopView new];
        accessoryView.frame = NSMakeRect(0., 0., 300., accessoryView.fittingSize.height);
        alert.accessoryView = accessoryView;
        [accessoryView release];
        
        [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
            
        }];
        [alert release];
        
        return NO;
    } else if ([identifier isEqualToString:@"Accepts Mouse Moved Events"]) {
        NSAlert *alert = [NSAlert new];
        
        WindowDemoAcceptsMouseMovedEventsView *accessoryView = [WindowDemoAcceptsMouseMovedEventsView new];
        accessoryView.frame = NSMakeRect(0., 0., 300., 300.);
        alert.accessoryView = accessoryView;
        [accessoryView release];
        
        [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
            
        }];
        [alert release];
        
        return NO;
    } else if ([identifier isEqualToString:@"Ignores Mouse Events"]) {
        BOOL boolValue = static_cast<NSNumber *>(newValue).boolValue;
        window.ignoresMouseEvents = boolValue;
        
        if (boolValue) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                window.ignoresMouseEvents = NO;
                [configurationView reconfigureItemModelsWithIdentifiers:@[@"Ignores Mouse Events"]];
            });
        }
        
        return NO;
    } else if ([identifier isEqualToString:@"Mouse Location Outside Of Event Stream"]) {
        BOOL boolValue = static_cast<NSNumber *>(newValue).boolValue;
        
        if (boolValue) {
            assert(self.mouseLocationOutsideOfEventStreamTimer == nil);
            self.mouseLocationOutsideOfEventStreamTimer = [NSTimer scheduledTimerWithTimeInterval:1.
                                                                                          repeats:YES
                                                                                            block:^(NSTimer * _Nonnull timer) {
                [configurationView reconfigureItemModelsWithIdentifiers:@[@"Mouse Location Outside Of Event Stream"]];
            }];
        } else {
            NSTimer *mouseLocationOutsideOfEventStreamTimer = self.mouseLocationOutsideOfEventStreamTimer;
            assert(mouseLocationOutsideOfEventStreamTimer != nil);
            [mouseLocationOutsideOfEventStreamTimer invalidate];
            self.mouseLocationOutsideOfEventStreamTimer = nil;
        }
        
        return NO;
    } else if ([identifier isEqualToString:@"Window Number At Point Below Window With Window Number"]) {
        return NO;
    } else if ([identifier isEqualToString:@"Track Events Matching Mask Timeout Mode Handler"]) {
        NSString *title = static_cast<NSString *>(newValue);
        NSEventMask eventMask = NSEventMaskFromString(title);
        
        [window trackEventsMatchingMask:eventMask
                                timeout:NSEventDurationForever
                                   mode:NSEventTrackingRunLoopMode
                                handler:^(NSEvent * _Nullable event, BOOL * _Nonnull stop) {
            NSAlert *alert = [NSAlert new];
            
            alert.messageText = @"Alert";
            alert.informativeText = event.description;
            
            [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
                
            }];
            
            [alert release];
            *stop = YES;
        }];
        
        return NO;
    } else if ([identifier isEqualToString:@"Restoration Class"]) {
        BOOL boolValue = static_cast<NSNumber *>(newValue).boolValue;
        
        if (boolValue) {
            assert(window.restorationClass == nil);
            window.restorationClass = [WindowDemoRestoration class];
        } else {
            assert(window.restorationClass != nil);
            window.restorationClass = nil;
        }
        
        return NO;
    } else if ([identifier isEqualToString:@"Restorable"]) {
        BOOL boolValue = static_cast<NSNumber *>(newValue).boolValue;
        window.restorable = boolValue;
        return NO;
    } else if ([identifier isEqualToString:@"Restoration Value"]) {
        double doubleValue = static_cast<NSNumber *>(newValue).doubleValue;
        self.restorationValue = doubleValue;
        [window invalidateRestorableState];
//        id sharedManager = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("NSPersistentUIManager"), sel_registerName("sharedManager"));
//        reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(sharedManager, sel_registerName("flushAllChanges"));
        return YES;
    } else if ([identifier isEqualToString:@"Snapshot Restoration"]) {
        BOOL boolValue = reinterpret_cast<NSNumber *>(newValue).boolValue;
        
        if (boolValue) {
            [window enableSnapshotRestoration];
        } else {
            [window disableSnapshotRestoration];
        }
        
        return YES;
    } else if ([identifier isEqualToString:@"Allows Concurrent View Drawing"]) {
        BOOL boolValue = reinterpret_cast<NSNumber *>(newValue).boolValue;
        window.allowsConcurrentViewDrawing = boolValue;
        return NO;
    } else if ([identifier isEqualToString:@"Animation Behavior"]) {
        NSString *title = reinterpret_cast<NSString *>(newValue);
        NSWindowAnimationBehavior behavior = NSWindowAnimationBehaviorFromString(title);
        window.animationBehavior = behavior;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [window orderOut:nil];
            [window orderFrontRegardless];
        });
        
        return NO;
    } else if ([identifier isEqualToString:@"Register For Dragged Types"]) {
        NSString *identifier = static_cast<NSString *>(newValue);
        
        NSMutableSet<NSString *> * _Nullable _dragTypes;
        assert(object_getInstanceVariable(window, "_dragTypes", reinterpret_cast<void **>(&_dragTypes)) != NULL);
        if ([_dragTypes containsObject:identifier]) {
            NSLog(@"Unregistering type is not supported on this item.");
            return NO;
        }
        
        [window registerForDraggedTypes:@[identifier]];
        
        return YES;
    } else if ([identifier isEqualToString:@"Unregister Dragged Types"]) {
        [window unregisterDraggedTypes];
        [configurationView reconfigureItemModelsWithIdentifiers:@[@"Register For Dragged Types"]];
        return NO;
    } else if ([identifier isEqualToString:@"Drag View Visibility"]) {
        BOOL boolValue = reinterpret_cast<NSNumber *>(newValue).boolValue;
        self.dragView.hidden = !boolValue;
        return NO;
    } else if ([identifier isEqualToString:@"Register For All Dragged Types"]) {
        NSArray<UTType *> *allTypes = _UTGetAllCoreTypesConstants();
        NSMutableArray<NSString *> *identifiers = [[NSMutableArray alloc] initWithCapacity:allTypes.count];
        for (UTType *type in allTypes) {
            [identifiers addObject:type.identifier];
        }
        [window registerForDraggedTypes:identifiers];
        [identifiers release];
        [configurationView reconfigureItemModelsWithIdentifiers:@[@"Register For Dragged Types"]];
        return NO;
    } else if ([identifier isEqualToString:@"Document Edited"]) {
        BOOL boolValue = reinterpret_cast<NSNumber *>(newValue).boolValue;
        window.documentEdited = boolValue;
        return NO;
    } else if ([identifier isEqualToString:@"Backing Aligned Rect"]) {
        NSAlert *alert = [NSAlert new];
        alert.messageText = @"Backing Aligned Rect";
        
        WindowDemoConvertingCoordinatesView *accessoryView = [WindowDemoConvertingCoordinatesView new];
        accessoryView.type = WindowDemoConvertingCoordinatesTypeBackingAlignedRect;
        accessoryView.frame = NSMakeRect(0., 0., 300., accessoryView.fittingSize.height);
        alert.accessoryView = accessoryView;
        [accessoryView release];
        
        [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
            
        }];
        [alert release];
        
        return NO;
    } else if ([identifier isEqualToString:@"Convert Rect From Backing"]) {
        NSAlert *alert = [NSAlert new];
        alert.messageText = @"Convert Rect From Backing";
        
        WindowDemoConvertingCoordinatesView *accessoryView = [WindowDemoConvertingCoordinatesView new];
        accessoryView.type = WindowDemoConvertingCoordinatesTypeConvertRectFromBacking;
        accessoryView.frame = NSMakeRect(0., 0., 300., accessoryView.fittingSize.height);
        alert.accessoryView = accessoryView;
        [accessoryView release];
        
        [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
            
        }];
        [alert release];
        
        return NO;
    } else if ([identifier isEqualToString:@"Convert Rect From Screen"]) {
        NSAlert *alert = [NSAlert new];
        alert.messageText = @"Convert Rect From Screen";
        
        WindowDemoConvertingCoordinatesView *accessoryView = [WindowDemoConvertingCoordinatesView new];
        accessoryView.type = WindowDemoConvertingCoordinatesTypeConvertRectFromScreen;
        accessoryView.frame = NSMakeRect(0., 0., 300., accessoryView.fittingSize.height);
        alert.accessoryView = accessoryView;
        [accessoryView release];
        
        [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
            
        }];
        [alert release];
        
        return NO;
    } else if ([identifier isEqualToString:@"Convert Rect To Backing"]) {
        NSAlert *alert = [NSAlert new];
        alert.messageText = @"Convert Rect To Backing";
        
        WindowDemoConvertingCoordinatesView *accessoryView = [WindowDemoConvertingCoordinatesView new];
        accessoryView.type = WindowDemoConvertingCoordinatesTypeConvertRectToBacking;
        accessoryView.frame = NSMakeRect(0., 0., 300., accessoryView.fittingSize.height);
        alert.accessoryView = accessoryView;
        [accessoryView release];
        
        [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
            
        }];
        [alert release];
        
        return NO;
    } else if ([identifier isEqualToString:@"Convert Rect To Screen"]) {
        NSAlert *alert = [NSAlert new];
        alert.messageText = @"Convert Rect To Screen";
        
        WindowDemoConvertingCoordinatesView *accessoryView = [WindowDemoConvertingCoordinatesView new];
        accessoryView.type = WindowDemoConvertingCoordinatesTypeConvertRectToScreen;
        accessoryView.frame = NSMakeRect(0., 0., 300., accessoryView.fittingSize.height);
        alert.accessoryView = accessoryView;
        [accessoryView release];
        
        [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
            
        }];
        [alert release];
        
        return NO;
    } else if ([identifier isEqualToString:@"Title"]) {
        NSAlert *alert = [NSAlert new];
        
        alert.messageText = @"Window Title";
        
        NSTextField *accessoryView = [NSTextField new];
        accessoryView.stringValue = window.title;
        accessoryView.frame = NSMakeRect(0., 0., 300., accessoryView.fittingSize.height);
        alert.accessoryView = accessoryView;
        
        [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
            window.title = accessoryView.stringValue;
            [configurationView reconfigureItemModelsWithIdentifiers:@[@"Title"]];
        }];
        [accessoryView release];
        [alert release];
        
        return NO;
    } else if ([identifier isEqualToString:@"Subtitle"]) {
        NSAlert *alert = [NSAlert new];
        
        alert.messageText = @"Window Subtitle";
        
        NSTextField *accessoryView = [NSTextField new];
        accessoryView.stringValue = window.subtitle;
        accessoryView.frame = NSMakeRect(0., 0., 300., accessoryView.fittingSize.height);
        alert.accessoryView = accessoryView;
        
        [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
            window.subtitle = accessoryView.stringValue;
            [configurationView reconfigureItemModelsWithIdentifiers:@[@"Subtitle"]];
        }];
        [accessoryView release];
        [alert release];
        
        return NO;
    } else if ([identifier isEqualToString:@"Title Visibility"]) {
        NSString *title = static_cast<NSString *>(newValue);
        window.titleVisibility = NSWindowTitleVisibilityFromString(title);
        return NO;
    } else if ([identifier isEqualToString:@"Represented URL"]) {
        NSAlert *alert = [NSAlert new];
        
        alert.messageText = @"Represented URL";
        
        NSTextField *accessoryView = [NSTextField new];
        
        if (NSURL *representedURL = window.representedURL) {
            accessoryView.stringValue = representedURL.path;
        } else {
            accessoryView.stringValue = @"";
        }
        
        accessoryView.frame = NSMakeRect(0., 0., 300., accessoryView.fittingSize.height);
        alert.accessoryView = accessoryView;
        
        [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
            NSString *stringValue = accessoryView.stringValue;
            
            if (stringValue.length == 0) {
                window.representedURL = nil;
            } else {
                window.representedURL = [NSURL fileURLWithPath:stringValue];
            }
            
            [configurationView reconfigureItemModelsWithIdentifiers:@[@"Represented URL"]];
        }];
        [accessoryView release];
        [alert release];
        
        return NO;
    } else if ([identifier isEqualToString:@"Deepest Screen"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [configurationView reconfigureItemModelsWithIdentifiers:@[@"Deepest Screen"]];
        });
        return NO;
    } else if ([identifier isEqualToString:@"Displays When Screen Profile Changes"]) {
        BOOL boolValue = static_cast<NSNumber *>(newValue).boolValue;
        window.displaysWhenScreenProfileChanges = boolValue;
        return NO;
    } else if ([identifier isEqualToString:@"Movable By Window Background"]) {
        BOOL boolValue = static_cast<NSNumber *>(newValue).boolValue;
        window.movableByWindowBackground = boolValue;
        return NO;
    } else if ([identifier isEqualToString:@"Movable"]) {
        BOOL boolValue = static_cast<NSNumber *>(newValue).boolValue;
        window.movable = boolValue;
        return NO;
    } else if ([identifier isEqualToString:@"Center"]) {
        [window center];
        return NO;
    } else if ([identifier isEqualToString:@"Released When Closed"]) {
        BOOL boolValue = static_cast<NSNumber *>(newValue).boolValue;
        window.releasedWhenClosed = boolValue;
        return NO;
    } else if ([identifier isEqualToString:@"Perform Close"]) {
        [window performClose:nil];
        return NO;
    } else if ([identifier isEqualToString:@"Close"]) {
        [window close];
        return NO;
    } else if ([identifier isEqualToString:@"Perform Miniaturize"]) {
        [window performMiniaturize:nil];
        return NO;
    } else if ([identifier isEqualToString:@"Miniaturize"]) {
        [window miniaturize:nil];
        return NO;
    } else if ([identifier isEqualToString:@"Deminiaturize"]) {
        [window miniaturize:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [window deminiaturize:nil];
        });
        
        return NO;
    } else if ([identifier isEqualToString:@"Miniwindow Image"]) {
        BOOL boolValue = static_cast<NSNumber *>(newValue).boolValue;
        
        if (boolValue) {
            assert(window.miniwindowImage == nil);
            NSURL *url = [NSBundle.mainBundle URLForResource:@"popcorns" withExtension:UTTypePNG.preferredFilenameExtension];
            assert(url != nil);
            NSImage *image = [[NSImage alloc] initWithContentsOfURL:url];
            assert(image != nil);
            
            window.miniwindowImage = image;
            [image release];
        } else {
            assert(window.miniwindowImage != nil);
            window.miniwindowImage = nil;
        }
        
        [configurationView reconfigureItemModelsWithIdentifiers:@[@"Dock Tile - Content View"]];
        return NO;
    } else if ([identifier isEqualToString:@"Miniwindow Title"]) {
        NSAlert *alert = [NSAlert new];
        
        alert.messageText = @"Miniwindow Title";
        
        NSTextField *accessoryView = [NSTextField new];
        accessoryView.stringValue = window.miniwindowTitle;
        accessoryView.frame = NSMakeRect(0., 0., 300., accessoryView.fittingSize.height);
        alert.accessoryView = accessoryView;
        
        [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
            window.miniwindowTitle = accessoryView.stringValue;
            [configurationView reconfigureItemModelsWithIdentifiers:@[@"Miniwindow Title"]];
        }];
        [accessoryView release];
        [alert release];
        
        return NO;
    } else if ([identifier isEqualToString:@"Dock Tile - Shows Application Badge"]) {
        BOOL boolValue = static_cast<NSNumber *>(newValue).boolValue;
        window.dockTile.showsApplicationBadge = boolValue;
        return NO;
    } else if ([identifier isEqualToString:@"Dock Tile - Badge Label"]) {
        NSAlert *alert = [NSAlert new];
        
        alert.messageText = @"Dock Tile - Badge Label";
        
        NSTextField *accessoryView = [NSTextField new];
        
        if (NSString *badgeLabel = window.dockTile.badgeLabel) {
            accessoryView.stringValue = badgeLabel;
        } else {
            accessoryView.stringValue = @"";
        }
        
        accessoryView.frame = NSMakeRect(0., 0., 300., accessoryView.fittingSize.height);
        alert.accessoryView = accessoryView;
        
        [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
            NSString *stringValue = accessoryView.stringValue;
            
            if (stringValue.length == 0) {
                window.dockTile.badgeLabel = nil;
            } else {
                window.dockTile.badgeLabel = stringValue;
            }
            
            [configurationView reconfigureItemModelsWithIdentifiers:@[@"Dock Tile - Badge Label"]];
        }];
        [accessoryView release];
        [alert release];
        
        return NO;
    } else if ([identifier isEqualToString:@"Dock Tile - Content View"]) {
        BOOL boolValue = static_cast<NSNumber *>(newValue).boolValue;
        
        if (boolValue) {
            assert(window.dockTile.contentView == nil);
            NSURL *url = [NSBundle.mainBundle URLForResource:@"popcorns" withExtension:UTTypePNG.preferredFilenameExtension];
            assert(url != nil);
            NSImage *image = [[NSImage alloc] initWithContentsOfURL:url];
            assert(image != nil);
            
            NSImageView *imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(0., 0., window.dockTile.size.width, window.dockTile.size.height)];
            imageView.image = image;
            [image release];
            window.dockTile.contentView = imageView;
            [window.dockTile display];
            [imageView release];
        } else {
            assert(window.dockTile.contentView != nil);
            window.dockTile.contentView = nil;
        }
        
        [configurationView reconfigureItemModelsWithIdentifiers:@[@"Miniwindow Image"]];
        return NO;
    } else if ([identifier isEqualToString:@"Print"]) {
        [window print:nil];
        return NO;
    } else if ([identifier isEqualToString:@"Data With EPS Inside Rect"]) {
        NSSize size = window.frame.size;
        NSData *data = [window dataWithEPSInsideRect:NSMakeRect(0., 0., size.width, size.height)];
        
        NSSavePanel *savePanel = [NSSavePanel new];
        
        savePanel.allowedContentTypes = @[[UTType typeWithIdentifier:@"com.adobe.encapsulated-postscript"]];
        
        [savePanel beginSheetModalForWindow:window completionHandler:^(NSModalResponse result) {
            NSURL *URL = savePanel.URL;
            NSError * _Nullable error = nil;
            [data writeToURL:URL options:0 error:&error];
            assert(error == nil);
        }];
        [savePanel release];
        
        /*
         EPS는 더 이상 사용할 수 없다.
         */
//        NSEPSImageRep *rep = [[NSEPSImageRep alloc] initWithData:data];
//        assert(rep != nil);
//        [rep release];
        
//        NSImage *image = [[NSImage alloc] initWithData:data];
//        assert(image != nil);
//        
//        NSAlert *alert = [NSAlert new];
//        alert.messageText = @"Data With EPS Inside Rect";
//        
//        NSImageView *imageView = [NSImageView new];
//        imageView.image = image;
//        
//        NSSize imageSize = image.size;
//        [image release];
//        imageView.frame = NSMakeRect(0., 0., imageSize.width, imageSize.height);
//        alert.accessoryView = imageView;
//        [imageView release];
//        
//        [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
//            
//        }];
//        [alert release];
        
        return NO;
    } else if ([identifier isEqualToString:@"Data With PDF Inside Rect"]) {NSSize size = window.frame.size;
        NSData *data = [window dataWithPDFInsideRect:NSMakeRect(0., 0., size.width, size.height)];
        NSImage *image = [[NSImage alloc] initWithData:data];
        assert(image != nil);
        
        NSAlert *alert = [NSAlert new];
        alert.messageText = @"Data With PDF Inside Rect";
        
        NSImageView *imageView = [NSImageView new];
        imageView.image = image;
        
        NSSize imageSize = image.size;
        [image release];
        imageView.frame = NSMakeRect(0., 0., imageSize.width, imageSize.height);
        alert.accessoryView = imageView;
        [imageView release];
        
        [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
            
        }];
        [alert release];
        
        return NO;
    } else if ([identifier isEqualToString:@"Valid Requestor For Send Type Return Type"]) {
        NSAlert *alert = [NSAlert new];
        alert.messageText = @"Valid Requestor For Send Type Return Type";
        
        WindowDemoValidRequestorView *accessoryView = [WindowDemoValidRequestorView new];
        accessoryView.frame = NSMakeRect(0., 0., 300., accessoryView.fittingSize.height);
        alert.accessoryView = accessoryView;
        [accessoryView release];
        
        [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
            
        }];
        [alert release];
        
        return NO;
    } else if ([identifier isEqualToString:@"Update Constraints If Needed"]) {
        //        id _auxiliaryStorage;
        //        assert(object_getInstanceVariable(window, "_auxiliaryStorage", reinterpret_cast<void **>(&_auxiliaryStorage)) != NULL);
        //
        //        unsigned int ivarsCount;
        //        Ivar *ivars = class_copyIvarList([_auxiliaryStorage class], &ivarsCount);
        //
        //        Ivar *ivarPtr = std::ranges::find_if(ivars, ivars + ivarsCount, [](Ivar ivar) {
        //            auto name = ivar_getName(ivar);
        //            return std::strcmp(name, "_auxWFlags") == 0;
        //        });
        //
        //        assert(*ivarPtr != NULL);
        //        ptrdiff_t offset = ivar_getOffset(*ivarPtr);
        //        free(ivars);
        //
        //        offset += 0x8;
        //
        //        uintptr_t base = reinterpret_cast<uintptr_t>(_auxiliaryStorage);
        //        uint64_t value = *reinterpret_cast<uint64_t *>(base + offset);
        //        value |= (1ULL << 54);
        
        [window updateConstraintsIfNeeded];
        return NO;
    } else if ([identifier isEqualToString:@"Layout If Needed"]) {
        [window layoutIfNeeded];
        return NO;
    } else if ([identifier isEqualToString:@"Visualize Constraints"]) {
        __block void (^block)(NSView *view);
        block = ^(NSView *view) {
            [window visualizeConstraints:view.constraints];
            
            for (NSView *subview in view.subviews) {
                block(subview);
            }
        };
        
        block(window.contentView);
        return NO;
    } else if ([identifier isEqualToString:@"Anchor Attribute For Orientation"]) {
        NSAlert *alert = [NSAlert new];
        
        alert.messageText = @"Anchor Attribute For Orientation";
        alert.informativeText = @"???";
        
        WindowDemoAnchorAttributeForOrientationView *accessoryView = [WindowDemoAnchorAttributeForOrientationView new];
        accessoryView.frame = NSMakeRect(0., 0., 300., accessoryView.fittingSize.height);
        alert.accessoryView = accessoryView;
        [accessoryView release];
        
        [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
            
        }];
        [alert release];
        
        return NO;
    } else if ([identifier isEqualToString:@"Can Represent Display Gamut"]) {
        return NO;
    } else {
        abort();
    }
#pragma mark - Actions
}

@end
