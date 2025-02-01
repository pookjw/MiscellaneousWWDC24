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
    [self _reload];
    
    NSLog(@"%@", [NSColorSpace ma_allColorSpaces]);
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
        [self _makeStyleMaskItemModel],
        [self _makeToggleFullScreenItemModel],
        [self _makeAlphaValueItemModel],
        [self _makeBackgroundColorItemModel]
    ]
               intoSectionWithIdentifier:[NSNull null]];
    
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

//- (ConfigurationItemModel *)_makeColorSpaceItemModel {
//    __block auto unretainedSelf = self;
//    
//    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
//                                          identifier:@"Color Space"
//                                            userInfo:nil
//                                               label:@"Color Space"
//                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
//        return [ConfigurationPopUpButtonDescription descriptionWithTitles:@[
//            @"deviceGrayColorSpace"
//        ]
//                                                           selectedTitles:<#(nonnull NSArray<NSString *> *)#> selectedDisplayTitle:<#(NSString * _Nullable)#>]
//    }];
//}

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
    } else if ([identifier isEqualToString:@"Toggle Full Screen"]) {
        [window toggleFullScreen:nil];
    } else if ([identifier isEqualToString:@"Alpha Value"]) {
#if CGFLOAT_IS_DOUBLE
        window.alphaValue = static_cast<NSNumber *>(newValue).doubleValue;
#else
        window.alphaValue = static_cast<NSNumber *>(newValue).floatValue;
#endif
    } else if ([identifier isEqualToString:@"Background Color"]) {
        window.backgroundColor = static_cast<NSColor *>(newValue);
        window.colorSpace = NSColorSpace.deviceGrayColorSpace;
    } else {
        abort();
    }
    
    return YES;
}

@end
