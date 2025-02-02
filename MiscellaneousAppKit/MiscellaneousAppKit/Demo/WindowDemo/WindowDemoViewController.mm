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
#import "NSStringFromNSWindowDepth.h"
#import "NSStringFromNSWindowCollectionBehavior.h"
#import "NSWindow+MA_Category.h"

OBJC_EXPORT id objc_msgSendSuper2(void); /* objc_super superInfo = { self, [self class] }; */

@interface WindowDemoViewController () <ConfigurationViewDelegate>
@property (retain, nonatomic, readonly, getter=_configurationView) ConfigurationView *configurationView;
@end

@implementation WindowDemoViewController
@synthesize configurationView = _configurationView;

- (void)dealloc {
    [_configurationView release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.configurationView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_didChangeWindowActiveSpace:) name:MA_NSWindowActiveSpaceDidChangeNotification object:nil];
}

- (void)_viewDidMoveToWindow:(NSWindow * _Nullable)newWindow fromWindow:(NSWindow * _Nullable)oldWindow {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL, id, id)>(objc_msgSendSuper2)(&superInfo, _cmd, newWindow, oldWindow);
    [self _reload];
    
    if (newWindow) {
        
    }
}

- (void)_didChangeWindowActiveSpace:(NSNotification *)notification {
    if ([notification.object isEqual:self.view.window]) {
        NSAlert *alert = [NSAlert new];
        alert.messageText = @"Moved!";
        [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
            
        }];
        [alert release];
    }
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
    
    [snapshot appendItemsWithIdentifiers:@[
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
    
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
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
    } else if ([identifier isEqualToString:@"On Active Space"]) {
        [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:@"https://x.com/_silgen_name/status/1886001265156784253"]];
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
    } else {
        abort();
    }
}

@end
