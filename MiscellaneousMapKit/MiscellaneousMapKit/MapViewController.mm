//
//  MapViewController.mm
//  MiscellaneousMapKit
//
//  Created by Jinwoo Kim on 4/13/25.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import <objc/message.h>
#import <objc/runtime.h>
#import "NSStringFromMKMapElevationStyle.h"
#import "NSStringFromMKUserTrackingMode.h"
#import "NSStringFromMKStandardMapEmphasisStyle.h"
#import "allMKPointOfInterestCategories.h"
#import "UIMenuElement+CP_NumberOfLines.h"
#import "KeyValueObserver.h"
#import "WindowObservingInteraction.h"
#include <vector>
#include <ranges>
#include <dlfcn.h>

MK_EXTERN MKMapRect const MKMapRectForCoordinateRegion(MKCoordinateRegion region);
UIKIT_EXTERN NSNotificationName const UIPresentationControllerDismissalTransitionDidEndNotification;
OBJC_EXPORT id objc_msgSendSuper2(void); /* objc_super superInfo = { self, [self class] }; */

namespace mm_GEOConfigStorageCFProfile {
namespace getConfigValueForKey_countryCode_options_source_ {
id (*original)(id, SEL, id ,id, NSUInteger, NSInteger *);
id custom(id self, SEL _cmd, NSString *key, id contryCode, NSUInteger options, NSInteger *source) {
    if ([key isEqualToString:@"VKMLayoutEnabled_Flyover"]) {
        return @YES;
    } else if ([key isEqualToString:@"VKMLayoutEnabled_Navigation"]) {
        return @YES;
    } else if ([key isEqualToString:@"VKMLayoutEnabled_SPR"]) {
        return @YES;
    } else if ([key isEqualToString:@"LockWatchFpsTo30hz"]) {
        return @YES;
    } else if ([key hasPrefix:@"Shelbyville"]) {
        return @YES;
    } else if ([key hasPrefix:@"AllowNonSupportedDeviceAdvancedMap"]) {
        return @YES;
    } else if ([key isEqualToString:@"EnableFlyoverUnification"]) {
        return @YES;
    } else if ([key isEqualToString:@"ElevatedPolygonsEnabled"]) {
        return @YES;
    } else if ([key isEqualToString:@"ARDebugMinimapShowBuildings"]) {
        return @YES;
//    } else if ([key isEqualToString:@"ShowLabelCounts"]) {
//        return @YES;
    } else if ([key isEqualToString:@"EnableVerboseLayoutReasonLogging"]) {
        return @YES;
    } else if ([key isEqualToString:@"SSAODemoButtonEnabled"]) {
        return @YES;
    } else if ([key isEqualToString:@"NavCameraDebugPage"]) {
        return @YES;
    } else if ([key isEqualToString:@"EnableVerboseEntityLogging"]) {
        return @YES;
    } else if ([key isEqualToString:@"EnableVerboseLayoutReasonLogging"]) {
        return @YES;
    } else if ([key isEqualToString:@"DisplayAllLabelsInARDebugString"]) {
        return @YES;
        
//    } else if ([key isEqualToString:@"NavCameraEnableOverlay"]) {
//        return @YES;
//    } else if ([key isEqualToString:@"NavCameraEnableLegend"]) {
//        return @YES;
//    } else if ([key isEqualToString:@"DisableMSAA"]) {
//        return @YES;
//    } else if ([key isEqualToString:@"TopographicDisplayEnabled"]) {
//        return @NO;
    } else {
        return original(self, _cmd, key, contryCode, options, source);
    }
}
void swizzle() {
    Method method = class_getInstanceMethod(objc_lookUpClass("GEOConfigStorageCFProfile"), sel_registerName("getConfigValueForKey:countryCode:options:source:"));
    original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}
}
}

@interface MapViewController () <MKMapViewDelegate>
@property (retain, nonatomic, readonly, getter=_mapView) MKMapView *mapView;
@property (retain, nonatomic, readonly, getter=_mkMenuBarButtonItem) UIBarButtonItem *mkMenuBarButtonItem;
@property (retain, nonatomic, readonly, getter=_vkMenuBarButtonItem) UIBarButtonItem *vkMenuBarButtonItem;
@property (retain, nonatomic, readonly, getter=_locationManager) CLLocationManager *locationManager;

@property (retain, nonatomic, nullable, getter=_menuObserver, setter=_setMenuObserver:) KeyValueObserver *menuObserver;
@end

@implementation MapViewController
@synthesize mapView = _mapView;
@synthesize mkMenuBarButtonItem = _mkMenuBarButtonItem;
@synthesize vkMenuBarButtonItem = _vkMenuBarButtonItem;
@synthesize locationManager = _locationManager;

+ (void)load {
//    mm_GEOConfigStorageCFProfile::getConfigValueForKey_countryCode_options_source_::swizzle();
}

- (void)dealloc {
    [_mapView release];
    [_mkMenuBarButtonItem release];
    [_vkMenuBarButtonItem release];
    [_locationManager release];
    [_menuObserver invalidate];
    [_menuObserver release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.mapView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItems = @[self.mkMenuBarButtonItem, self.vkMenuBarButtonItem];
    
    [self.locationManager requestWhenInUseAuthorization];
    [self _presentMkMenu];
    
    
    id _mapView;
    assert(object_getInstanceVariable(self.mapView, "_mapView", (void **)&_mapView) != NULL);
    
//    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(_mapView, sel_registerName("setEnableColorizedBuildings:"), YES);
//    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(_mapView, sel_registerName("setEnableBuildingHeights:"), YES);
//    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(_mapView, sel_registerName("setModernMapEnabled:"), YES);
//    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(_mapView, sel_registerName("setEnableGlobe:"), YES);
//    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(_mapView, sel_registerName("setEnableRoundedBuildings:"), YES);
//    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(_mapView, sel_registerName("setEnableAdvancedLighting:"), YES);
//    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(_mapView, sel_registerName("setShowsBuildings:"), YES);
//    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(_mapView, sel_registerName("setShowsVenues:"), YES);
//    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(_mapView, sel_registerName("setShowsLiveEVData:"), YES);
//    assert(reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(_mapView, sel_registerName("_modernMapAllowed")));
    
//    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(_mapView, sel_registerName("enableColorizedBuildings"));
//    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(_mapView, sel_registerName("enableGlobe"));
//    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(_mapView, sel_registerName("enableRoundedBuildings"));
//    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(_mapView, sel_registerName("enableAdvancedLighting"));
}

- (void)_setMenuObserver:(KeyValueObserver *)menuObserver {
    [_menuObserver invalidate];
    [_menuObserver release];
    _menuObserver = [menuObserver retain];
}

- (MKMapView *)_mapView {
    if (auto mapView = _mapView) return mapView;
    
    MKMapView *mapView = [MKMapView new];
    mapView.delegate = self;
    
    _mapView = mapView;
    return mapView;
}

- (UIBarButtonItem *)_mkMenuBarButtonItem {
    if (auto mkMenuBarButtonItem = _mkMenuBarButtonItem) return mkMenuBarButtonItem;
    
    UIBarButtonItem *mkMenuBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"filemenu.and.selection"] menu:[self _makeMkMenu]];
    
    _mkMenuBarButtonItem = mkMenuBarButtonItem;
    return mkMenuBarButtonItem;
}

- (UIBarButtonItem *)_vkMenuBarButtonItem {
    if (auto vkMenuBarButtonItem  = _vkMenuBarButtonItem ) return vkMenuBarButtonItem ;
    
    UIBarButtonItem *vkMenuBarButtonItem  = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"ladybug.fill"] menu:[self _makeVkMenu]];
    
    _vkMenuBarButtonItem  = vkMenuBarButtonItem ;
    return vkMenuBarButtonItem ;
}

- (CLLocationManager *)_locationManager {
    if (auto locationManager = _locationManager) return locationManager;
    
    CLLocationManager *locationManager = [CLLocationManager new];
    
    _locationManager = locationManager;
    return locationManager;
}

- (UIMenu *)_makeMkMenu {
    MKMapView *mapView = self.mapView;
    __weak auto weakSelf = self;
    
    UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
        NSMutableArray<__kindof UIMenuElement *> *children = [NSMutableArray new];
        
        {
            __kindof MKMapConfiguration *preferredConfiguration = mapView.preferredConfiguration;
            NSMutableArray<__kindof UIMenuElement *> *children_2 = [NSMutableArray new];
            
            {
                NSArray<Class> *supportedClasses = @[
                    [MKStandardMapConfiguration class],
                    [MKHybridMapConfiguration class],
                    [MKImageryMapConfiguration class],
                    objc_lookUpClass("_MKCartographicMapConfiguration")
                ];
                
                NSMutableArray<UIAction *> *actions = [[NSMutableArray alloc] initWithCapacity:supportedClasses.count];
                for (Class _class in supportedClasses) {
                    UIAction *action = [UIAction actionWithTitle:NSStringFromClass(_class)
                                                           image:nil
                                                      identifier:nil
                                                         handler:^(__kindof UIAction * _Nonnull action) {
                        __kindof MKMapConfiguration *newConfiguration;
                        if (_class == [MKStandardMapConfiguration class]) {
                            newConfiguration = [[MKStandardMapConfiguration alloc] initWithElevationStyle:preferredConfiguration.elevationStyle];
                        } else if (_class == [MKHybridMapConfiguration class]) {
                            newConfiguration = [[MKHybridMapConfiguration alloc] initWithElevationStyle:preferredConfiguration.elevationStyle];
                        } else if (_class == [MKImageryMapConfiguration class]) {
                            newConfiguration = [[MKImageryMapConfiguration alloc] initWithElevationStyle:preferredConfiguration.elevationStyle];
                        } else if (_class == objc_lookUpClass("_MKCartographicMapConfiguration")) {
                            newConfiguration = [objc_lookUpClass("_MKCartographicMapConfiguration") new];
                        } else {
                            abort();
                        }
                        
                        mapView.preferredConfiguration = newConfiguration;
                        [newConfiguration release];
                        
                        [weakSelf _presentMkMenu];
                    }];
                    
                    action.state = ([preferredConfiguration isKindOfClass:_class]) ? UIMenuElementStateOn : UIMenuElementStateOff;
                    [actions addObject:action];
                }
                
                UIMenu *menu = [UIMenu menuWithTitle:@"Configuration Type" children:actions];
                [actions release];
                menu.subtitle = NSStringFromClass([preferredConfiguration class]);
                [children_2 addObject:menu];
            }
            
            if ([preferredConfiguration isKindOfClass:[MKStandardMapConfiguration class]]) {
                auto standardMapConfiguration = static_cast<MKStandardMapConfiguration *>(preferredConfiguration);
                
                NSMutableArray<__kindof UIMenuElement *> *children_3 = [NSMutableArray new];
                
                {
                    NSUInteger count;
                    const MKStandardMapEmphasisStyle *allStyles = allMKStandardMapEmphasisStyles(&count);
                    
                    auto actionsVector = std::views::iota(allStyles, allStyles + count)
                    | std::views::transform([standardMapConfiguration, mapView, weakSelf](const MKStandardMapEmphasisStyle *stylePtr) -> UIAction * {
                        const MKStandardMapEmphasisStyle style = *stylePtr;
                        
                        UIAction *action = [UIAction actionWithTitle:NSStringFromMKStandardMapEmphasisStyle(style)
                                                               image:nil
                                                          identifier:nil
                                                             handler:^(__kindof UIAction * _Nonnull action) {
                            auto copy = static_cast<MKStandardMapConfiguration *>([standardMapConfiguration copy]);
                            copy.emphasisStyle = style;
                            mapView.preferredConfiguration = copy;
                            [copy release];
                            
                            [weakSelf _presentMkMenu];
                        }];
                        
                        action.state = (standardMapConfiguration.emphasisStyle == style) ? UIMenuElementStateOn : UIMenuElementStateOff;
                        return action;
                    })
                    | std::ranges::to<std::vector<UIAction *>>();
                    
                    NSArray<UIAction *> *actions = [[NSArray alloc] initWithObjects:actionsVector.data() count:actionsVector.size()];
                    UIMenu *menu = [UIMenu menuWithTitle:@"Emphasis Style" children:actions];
                    [actions release];
                    menu.subtitle = NSStringFromMKStandardMapEmphasisStyle(standardMapConfiguration.emphasisStyle);
                    [children_3 addObject:menu];
                }
                
                {
                    BOOL showsHiking = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(standardMapConfiguration, sel_registerName("showsHiking"));
                    
                    UIAction *action = [UIAction actionWithTitle:@"Shows Hiking" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                        auto copy = static_cast<MKStandardMapConfiguration *>([standardMapConfiguration copy]);
                        reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(copy, sel_registerName("setShowsHiking:"), !showsHiking);
                        mapView.preferredConfiguration = copy;
                        [copy release];
                        
                        [weakSelf _presentMkMenu];
                    }];
                    
                    action.state = showsHiking ? UIMenuElementStateOn : UIMenuElementStateOff;
                    [children_3 addObject:action];
                }
                
                {
                    BOOL _allowsTerrainModePromotion = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(standardMapConfiguration, sel_registerName("_allowsTerrainModePromotion"));
                    
                    UIAction *action = [UIAction actionWithTitle:@"Allows Terrain Mode Promotion" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    }];
                    
                    action.state = _allowsTerrainModePromotion ? UIMenuElementStateOn : UIMenuElementStateOff;
                    action.attributes = UIMenuElementAttributesDisabled;
                    [children_3 addObject:action];
                }
                
                UIMenu *menu = [UIMenu menuWithTitle:NSStringFromClass([MKHybridMapConfiguration class]) children:children_3];
                [children_3 release];
                [children_2 addObject:menu];
            }
            
            {
                NSMutableArray<__kindof UIMenuElement *> *children_3 = [NSMutableArray new];
                
                {
                    NSUInteger count;
                    const MKMapElevationStyle *styles = allMKMapElevationStyles(&count);
                    auto actionsVector = std::views::iota(styles, styles + count)
                    | std::views::transform([preferredConfiguration, mapView, weakSelf](const MKMapElevationStyle *stylePtr) -> UIAction * {
                        const MKMapElevationStyle style = *stylePtr;
                        
                        UIAction *action = [UIAction actionWithTitle:NSStringFromMKMapElevationStyle(style)
                                                               image:nil
                                                          identifier:nil
                                                             handler:^(__kindof UIAction * _Nonnull action) {
                            MKMapConfiguration *configuration = [mapView.preferredConfiguration copy];
                            configuration.elevationStyle = style;
                            mapView.preferredConfiguration = configuration;
                            [configuration release];
                            
                            [weakSelf _presentMkMenu];
                        }];
                        
                        action.state = (preferredConfiguration.elevationStyle == style) ? UIMenuElementStateOn : UIMenuElementStateOff;
                        return action;
                    })
                    | std::ranges::to<std::vector<UIAction *>>();
                    
                    NSArray<UIAction *> *actionsArray = [[NSArray alloc] initWithObjects:actionsVector.data() count:actionsVector.size()];
                    UIMenu *menu = [UIMenu menuWithTitle:@"Elevation Style" children:actionsArray];
                    [actionsArray release];
                    [children_3 addObject:menu];
                }
                
                if ([preferredConfiguration respondsToSelector:@selector(setPointOfInterestFilter:)]) {
                    NSArray<MKPointOfInterestCategory> *categories = allMKPointOfInterestCategories;
                    MKPointOfInterestFilter *pointOfInterestFilter = [reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(preferredConfiguration, @selector(pointOfInterestFilter)) copy];
                    if (pointOfInterestFilter == nil) pointOfInterestFilter = [[MKPointOfInterestFilter alloc] initExcludingCategories:@[]];
                    
                    NSMutableArray<UIAction *> *actions = [[NSMutableArray alloc] initWithCapacity:categories.count];
                    for (MKPointOfInterestCategory category in categories) {
                        UIAction *action = [UIAction actionWithTitle:category image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                            auto copy = static_cast<MKMapConfiguration *>([preferredConfiguration copy]);
                            
                            NSSet<MKPointOfInterestCategory> * _Nullable _excludedCategories;
                            assert(object_getInstanceVariable(pointOfInterestFilter, "_excludedCategories", (void **)&_excludedCategories) != NULL);
                            
                            NSArray<MKPointOfInterestCategory> *newExcludingCategories;
                            if (_excludedCategories == nil) {
                                newExcludingCategories = @[category];
                            } else {
                                newExcludingCategories = [_excludedCategories.allObjects arrayByAddingObject:category];
                            }
                            
                            MKPointOfInterestFilter *pointOfInterestFilter = [[MKPointOfInterestFilter alloc] initExcludingCategories:newExcludingCategories];
                            reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(copy, @selector(setPointOfInterestFilter:), pointOfInterestFilter);
                            [pointOfInterestFilter release];
                            
                            mapView.preferredConfiguration = copy;
                            [copy release];
                            
                            [weakSelf _presentMkMenu];
                        }];
                        
                        action.state = ([pointOfInterestFilter excludesCategory:category]) ? UIMenuElementStateOn : UIMenuElementStateOff;
                        [actions addObject:action];
                    }
                    
                    [pointOfInterestFilter release];
                    
                    UIMenu *menu = [UIMenu menuWithTitle:@"Point Of Interest Filter (Exclude)" children:actions];
                    [actions release];
                    [children_3 addObject:menu];
                }
                
                if ([preferredConfiguration respondsToSelector:@selector(setShowsTraffic:)]) {
                    BOOL showsTraffic = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(preferredConfiguration, @selector(showsTraffic));
                    
                    UIAction *action = [UIAction actionWithTitle:@"Shows Traffic" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                        auto copy = static_cast<MKMapConfiguration *>([preferredConfiguration copy]);
                        reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(copy, @selector(setShowsTraffic:), !showsTraffic);
                        mapView.preferredConfiguration = copy;
                        [copy release];
                        
                        [weakSelf _presentMkMenu];
                    }];
                    
                    action.state = showsTraffic ? UIMenuElementStateOn : UIMenuElementStateOff;
                    [children_3 addObject:action];
                }
                
                
                if ([preferredConfiguration respondsToSelector:sel_registerName("showsTopographicFeatures")]) {
                    BOOL showsTopographicFeatures = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(preferredConfiguration, sel_registerName("showsTopographicFeatures"));
                    
                    UIAction *action = [UIAction actionWithTitle:@"Shows Topographic Features" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                        auto copy = static_cast<MKStandardMapConfiguration *>([preferredConfiguration copy]);
                        reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(copy, sel_registerName("setShowsTopographicFeatures:"), !showsTopographicFeatures);
                        mapView.preferredConfiguration = copy;
                        [copy release];
                        
                        [weakSelf _presentMkMenu];
                    }];
                    
                    action.state = showsTopographicFeatures ? UIMenuElementStateOn : UIMenuElementStateOff;
                    [children_3 addObject:action];
                }
                
                UIMenu *menu = [UIMenu menuWithTitle:@"MKMapConfiguration" children:children_3];
                [children_3 release];
                [children_2 addObject:menu];
            }
            
            UIMenu *menu = [UIMenu menuWithTitle:@"preferredConfiguration" children:children_2];
            [children_2 release];
            [children addObject:menu];
        }
        
        {
            BOOL zoomEnabled = mapView.zoomEnabled;
            
            UIAction *action = [UIAction actionWithTitle:@"Zoom Enabled" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                mapView.zoomEnabled = !zoomEnabled;
                [weakSelf _presentMkMenu];
            }];
            action.state = zoomEnabled ? UIMenuElementStateOn : UIMenuElementStateOff;
            [children addObject:action];
        }
        
        {
            BOOL scrollEnabled = mapView.scrollEnabled;
            
            UIAction *action = [UIAction actionWithTitle:@"Scroll Enabled" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                mapView.scrollEnabled = !scrollEnabled;
                [weakSelf _presentMkMenu];
            }];
            action.state = scrollEnabled ? UIMenuElementStateOn : UIMenuElementStateOff;
            [children addObject:action]; 
        }
        
        {
            BOOL rotateEnabled = mapView.rotateEnabled;
            
            UIAction *action = [UIAction actionWithTitle:@"Rotate Enabled" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                mapView.rotateEnabled = !rotateEnabled;
                [weakSelf _presentMkMenu];
            }];
            action.state = rotateEnabled ? UIMenuElementStateOn : UIMenuElementStateOff;
            [children addObject:action]; 
        }
        
        {
            BOOL isLocationConsoleEnabled = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(mapView, sel_registerName("isLocationConsoleEnabled"));
            
            UIAction *action = [UIAction actionWithTitle:@"Location Console Enabled" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(mapView, sel_registerName("setLocationConsoleEnabled:"), !isLocationConsoleEnabled);
                [weakSelf _presentMkMenu];
            }];
            
            action.state = isLocationConsoleEnabled ? UIMenuElementStateOn : UIMenuElementStateOff;
            [children addObject:action];
        }
        
        {
            BOOL showsUserLocation = mapView.showsUserLocation;
            
            UIAction *action = [UIAction actionWithTitle:@"Shows User Location" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                mapView.showsUserLocation = !showsUserLocation;
                [weakSelf _presentMkMenu];
            }];
            
            action.state = showsUserLocation ? UIMenuElementStateOn : UIMenuElementStateOff;
            [children addObject:action];
        }
        
        {
            NSUInteger count;
            const MKUserTrackingMode *allModes = allMKUserTrackingModes(&count);
            
            auto actionsVector = std::views::iota(allModes, allModes + count)
            | std::views::transform([mapView, weakSelf](const MKUserTrackingMode *modePtr) -> UIAction * {
                const MKUserTrackingMode mode = *modePtr;
                UIAction *action = [UIAction actionWithTitle:NSStringFromMKUserTrackingMode(mode)
                                                       image:nil
                                                  identifier:nil
                                                     handler:^(__kindof UIAction * _Nonnull action) {
                    [mapView setUserTrackingMode:mode animated:YES];
                    [weakSelf _presentMkMenu];
                }];
                
                action.state = (mapView.userTrackingMode == mode) ? UIMenuElementStateOn : UIMenuElementStateOff;
                return action;
            })
            | std::ranges::to<std::vector<UIAction *>>();
            
            NSArray<UIAction *> *actions = [[NSArray alloc] initWithObjects:actionsVector.data() count:actionsVector.size()];
            UIMenu *menu = [UIMenu menuWithTitle:@"User Tracking Mode" children:actions];
            [actions release];
            menu.subtitle = NSStringFromMKUserTrackingMode(mapView.userTrackingMode);
            [children addObject:menu];
        }
        
        {
            BOOL _isVectorKitConsoleEnabled = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(mapView, sel_registerName("_isVectorKitConsoleEnabled"));
            
            UIAction *action = [UIAction actionWithTitle:@"Vector Kit Console Enabled" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(mapView, sel_registerName("_setVectorKitConsoleEnabled:"), !_isVectorKitConsoleEnabled);
                [weakSelf _presentMkMenu];
            }];
            
            action.state = _isVectorKitConsoleEnabled ? UIMenuElementStateOn : UIMenuElementStateOff;
            
            [children addObject:action];
        }
        
        {
            NSMutableArray<__kindof UIMenuElement *> *children_2 = [NSMutableArray new];
            
            {
                CLLocationCoordinate2D center = mapView.region.center;
                
                UIAction *action = [UIAction actionWithTitle:@"Center" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    UIPasteboard.generalPasteboard.string = [NSString stringWithFormat:@"%lf, %lf", center.latitude, center.longitude];
                    [weakSelf _presentMkMenu];
                }];
                
                action.subtitle = [NSString stringWithFormat:@"latitude : %lf, longitude : %lf", center.latitude, center.longitude];
                
                [children_2 addObject:action];
            }
            
            {
                MKCoordinateSpan span = mapView.region.span;
                
                UIAction *action = [UIAction actionWithTitle:@"Span" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    UIPasteboard.generalPasteboard.string = [NSString stringWithFormat:@"%lf, %lf", span.latitudeDelta, span.longitudeDelta];
                    [weakSelf _presentMkMenu];
                }];
                
                action.subtitle = [NSString stringWithFormat:@"latitudeDelta : %lf, longitudeDelta : %lf", span.latitudeDelta, span.longitudeDelta];
                
                [children_2 addObject:action];
            }
            
            {
                MKMapRect mapRect = MKMapRectForCoordinateRegion(mapView.region);
                
                UIAction *action = [UIAction actionWithTitle:@"Map Rect" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                }];
                
                action.subtitle = [NSString stringWithFormat:@"{{%lf, %lf}, {%lf, %lf}}", mapRect.origin.x, mapRect.origin.y, mapRect.size.width, mapRect.size.height];
                action.attributes = UIMenuElementAttributesDisabled;
                action.cp_overrideNumberOfSubtitleLines = 0;
                
                [children_2 addObject:action];
            }
            
            {
                UIAction *action = [UIAction actionWithTitle:@"Traffic Visible Location" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(37.8042483, -122.2840628);
                    MKCoordinateSpan span = MKCoordinateSpanMake(0.03, 0.03);
                    MKCoordinateRegion region = MKCoordinateRegionMake(coord, span);
                    [mapView setRegion:region animated:YES];
                    
                    [weakSelf _presentMkMenu];
                }];
                [children_2 addObject:action];
            }
            
            {
                UIAction *action = [UIAction actionWithTitle:@"LAX" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(33.942791, -118.410042);
                    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
                    MKCoordinateRegion region = MKCoordinateRegionMake(coord, span);
                    [mapView setRegion:region animated:YES];
                    
                    [weakSelf _presentMkMenu];
                }];
                [children_2 addObject:action];
            }
            
            {
                UIAction *action = [UIAction actionWithTitle:@"Coit Tower" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(37.802409, -122.405843);
                    MKCoordinateSpan span = MKCoordinateSpanMake(0.001, 0.001);
                    MKCoordinateRegion region = MKCoordinateRegionMake(coord, span);
                    [mapView setRegion:region animated:YES];
                    
                    [weakSelf _presentMkMenu];
                }];
                [children_2 addObject:action];
            }
            
            {
                UIAction *action = [UIAction actionWithTitle:@"Book Passage" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(37.7958181, -122.3959085);
                    MKCoordinateSpan span = MKCoordinateSpanMake(0.001, 0.001);
                    MKCoordinateRegion region = MKCoordinateRegionMake(coord, span);
                    [mapView setRegion:region animated:YES];
                    
                    [weakSelf _presentMkMenu];
                }];
                [children_2 addObject:action];
            }
            
            {
                if (mapView.showsUserLocation) {
                    UIAction *action = [UIAction actionWithTitle:@"Set Region with User Location" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                        CLLocationCoordinate2D coord = mapView.userLocation.location.coordinate;;
                        MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
                        MKCoordinateRegion region = MKCoordinateRegionMake(coord, span);
                        [mapView setRegion:region animated:YES];
                        
                        [weakSelf _presentMkMenu];
                    }];
                    [children_2 addObject:action];
                } else {
                    UIAction *action = [UIAction actionWithTitle:@"Set Region with User Location" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    }];
                    action.attributes = UIMenuElementAttributesDisabled;
                    action.subtitle = @"Requires showsUserLocation = YES";
                    [children_2 addObject:action];
                }
            }
            
            UIMenu *menu = [UIMenu menuWithTitle:@"Region" children:children_2];
            [children_2 release];
            [children addObject:menu];
        }
        
        {
            CLLocationCoordinate2D centerCoordinate = mapView.centerCoordinate;
            
            UIAction *action = [UIAction actionWithTitle:@"Center Coordinate" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                UIPasteboard.generalPasteboard.string = [NSString stringWithFormat:@"%lf %lf", centerCoordinate.latitude, centerCoordinate.longitude];
                [weakSelf _presentMkMenu];
            }];
            
            action.subtitle = [NSString stringWithFormat:@"latitude : %lf, longitude : %lf", centerCoordinate.latitude, centerCoordinate.longitude];
            
            [children addObject:action];
        }
        
        {
            NSMutableArray<__kindof UIMenuElement *> *children_2 = [NSMutableArray new];
            
            {
                UIAction *action = [UIAction actionWithTitle:NSStringFromClass([MKPlacemark class]) image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:mapView.centerCoordinate];
                    [mapView addAnnotation:placemark];
                    [placemark release];
                    
                    [weakSelf _presentMkMenu];
                }];
                [children_2 addObject:action];
            }
            
            {
                UIAction *action = [UIAction actionWithTitle:NSStringFromClass([MKUserLocation class]) image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    MKUserLocation *userLocation = [MKUserLocation new];
                    [mapView addAnnotation:userLocation];
                    [userLocation release];
                    
                    [weakSelf _presentMkMenu];
                }];
                [children_2 addObject:action];
            }
            
            {
                NSArray<id<MKAnnotation>> *annotations = mapView.annotations;
                NSMutableArray<__kindof UIMenuElement *> *children_3 = [[NSMutableArray alloc] initWithCapacity:annotations.count];
                
                for (id<MKAnnotation> annotation in annotations) {
                    __kindof UIMenuElement *element;
                    
                    if ([annotation isKindOfClass:[MKPlacemark class]]) {
                        UIAction *action = [UIAction actionWithTitle:NSStringFromClass([MKPlacemark class]) image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                            [mapView removeAnnotation:annotation];
                            [weakSelf _presentMkMenu];
                        }];
                        action.attributes = UIMenuElementAttributesDestructive;
                        action.subtitle = [annotation description];
                        action.cp_overrideNumberOfSubtitleLines = 0;
                        
                        element = action;
                    } else if ([annotation isKindOfClass:[MKUserLocation class]]) {
                        auto casted = static_cast<MKUserLocation *>(annotation);
                        
                        NSMutableArray<__kindof UIMenuElement *> *children_4 = [NSMutableArray new];
                        
                        {
                            UIAction *action = [UIAction actionWithTitle:@"Location" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                            }];
                            action.attributes = UIMenuElementAttributesDisabled;
                            action.subtitle = casted.location.description;
                            action.cp_overrideNumberOfSubtitleLines = 0;
                            [children_4 addObject:action];
                        }
                        
                        {
                            UIAction *action = [UIAction actionWithTitle:@"Updating" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                            }];
                            action.attributes = UIMenuElementAttributesDisabled;
                            action.subtitle = casted.updating ? @"YES" : @"NO";
                            [children_4 addObject:action];
                        }
                        
                        {
                            UIAction *action = [UIAction actionWithTitle:@"Heading" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                            }];
                            action.attributes = UIMenuElementAttributesDisabled;
                            action.subtitle = casted.heading.description;
                            [children_4 addObject:action];
                        }
                        
                        {
                            UIAction *action = [UIAction actionWithTitle:@"Title" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Title" message:nil preferredStyle:UIAlertControllerStyleAlert];
                                [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                                    textField.text = casted.title;
                                }];
                                
                                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                    [weakSelf _presentMkMenu];
                                }];
                                [alertController addAction:cancelAction];
                                
                                UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                    UIAlertController *_alertController = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(action, sel_registerName("_alertController"));
                                    casted.title = _alertController.textFields.firstObject.text;
                                    [weakSelf _presentMkMenu];
                                }];
                                [alertController addAction:doneAction];
                                
                                [weakSelf presentViewController:alertController animated:YES completion:nil];
                            }];
                            action.subtitle = casted.title;
                            [children_4 addObject:action];
                        }
                        
                        {
                            UIAction *action = [UIAction actionWithTitle:@"Subtitle" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Subtitle" message:nil preferredStyle:UIAlertControllerStyleAlert];
                                [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                                    textField.text = casted.subtitle;
                                }];
                                
                                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                    [weakSelf _presentMkMenu];
                                }];
                                [alertController addAction:cancelAction];
                                
                                UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                    UIAlertController *_alertController = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(action, sel_registerName("_alertController"));
                                    casted.subtitle = _alertController.textFields.firstObject.text;
                                    [weakSelf _presentMkMenu];
                                }];
                                [alertController addAction:doneAction];
                                
                                [weakSelf presentViewController:alertController animated:YES completion:nil];
                            }];
                            action.subtitle = casted.subtitle;
                            [children_4 addObject:action];
                        }
                        
                        {
                            UIAction *action = [UIAction actionWithTitle:@"Remove" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                                [mapView removeAnnotation:annotation];
                                [weakSelf _presentMkMenu];
                            }];
                            action.attributes = UIMenuOptionsDestructive;
                            [children_4 addObject:action];
                        }
                        
                        UIMenu *menu = [UIMenu menuWithTitle:NSStringFromClass([MKUserLocation class]) children:children_4];
                        [children_4 release];
                        menu.subtitle = casted.description;
                        element = menu;
                    } else {
                        abort();
                    }
                    
                    [children_3 addObject:element];
                }
                
                UIMenu *menu = [UIMenu menuWithTitle:@"" image:nil identifier:nil options:UIMenuOptionsDisplayInline children:children_3];
                [children_3 release];
                [children_2 addObject:menu];
            }
            
            UIMenu *menu = [UIMenu menuWithTitle:@"Annotations" children:children_2];
            [children_2 release];
            [children addObject:menu];
        }
        
        {
            NSMutableArray<__kindof UIMenuElement *> *children_2 = [NSMutableArray new];
            MKMapCamera *camera = mapView.camera;
            
            {
                UIAction *action = [UIAction actionWithTitle:@"Center Coordinate" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    UIPasteboard.generalPasteboard.string = [NSString stringWithFormat:@"%lf, %lf", camera.centerCoordinate.latitude, camera.centerCoordinate.longitude];
                    [weakSelf _presentMkMenu];
                }];
                action.subtitle = [NSString stringWithFormat:@"%lf, %lf", camera.centerCoordinate.latitude, camera.centerCoordinate.longitude];
                [children_2 addObject:action];
            }
            
            {
                UIAction *action = [UIAction actionWithTitle:@"Heading" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    UIPasteboard.generalPasteboard.string = @(camera.heading).stringValue;
                    [weakSelf _presentMkMenu];
                }];
                action.subtitle = @(camera.heading).stringValue;
                [children_2 addObject:action];
            }
            
            {
                UIAction *action = [UIAction actionWithTitle:@"Center Coordinate Distance" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    UIPasteboard.generalPasteboard.string = @(camera.centerCoordinateDistance).stringValue;
                    [weakSelf _presentMkMenu];
                }];
                action.subtitle = @(camera.centerCoordinateDistance).stringValue;
                [children_2 addObject:action];
            }
            
            {
                UIAction *action = [UIAction actionWithTitle:@"Pitch" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    UIPasteboard.generalPasteboard.string = @(camera.pitch).stringValue;
                    [weakSelf _presentMkMenu];
                }];
                action.subtitle = @(camera.pitch).stringValue;
                [children_2 addObject:action];
            }
            
            {
                UIAction *action = [UIAction actionWithTitle:@"Coit Tower" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    MKMapCamera *camera = [MKMapCamera cameraLookingAtCenterCoordinate:CLLocationCoordinate2DMake(37.801734, -122.405793)
                                                                          fromDistance:409.7106411683691
                                                                                 pitch:74.99999867197057
                                                                               heading:173.3748958970743];
                    [mapView setCamera:camera animated:YES];
                    
                    [weakSelf _presentMkMenu];
                }];
                [children_2 addObject:action];
            }
            
            {
                UIAction *action = [UIAction actionWithTitle:@"Book Passage" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    MKMapCamera *camera = [MKMapCamera cameraLookingAtCenterCoordinate:CLLocationCoordinate2DMake(37.796043, -122.392914)
                                                                          fromDistance:481.1949875514527
                                                                                 pitch:69.99999967119774
                                                                               heading:42.48784350129402];
                    [mapView setCamera:camera animated:YES];
                    
                    [weakSelf _presentMkMenu];
                }];
                [children_2 addObject:action];
            }
            
            UIMenu *menu = [UIMenu menuWithTitle:@"Camera" children:children_2];
            [children_2 release];
            [children addObject:menu];
        }
        
        completion(children);
        [children release];
    }];
    
    return [UIMenu menuWithChildren:@[element]];
}

- (UIMenu *)_makeVkMenu {
    MKMapView *mapView = self.mapView;
    id vkMapView;
    assert(object_getInstanceVariable(self.mapView, "_mapView", (void **)&vkMapView) != NULL);
    
    __weak auto weakSelf = self;
    
    UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
        NSMutableArray<__kindof UIMenuElement *> *children = [NSMutableArray new];
        
        BOOL _globeIsEnabled = reinterpret_cast<BOOL (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("VKMapView"), sel_registerName("_globeIsEnabled"));
        if (_globeIsEnabled) {
            BOOL enableGlobe = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(vkMapView, sel_registerName("enableGlobe"));
            
            UIAction *action = [UIAction actionWithTitle:@"Globe" image:[UIImage systemImageNamed:@"globe.americas"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(vkMapView, sel_registerName("setEnableGlobe:"), !enableGlobe);
                [weakSelf _presentVkMenu];
            }];
            
            action.state = enableGlobe ? UIMenuElementStateOn : UIMenuElementStateOff;
            [children addObject:action];
        } else {
            UIAction *action = [UIAction actionWithTitle:@"Globe" image:[UIImage systemImageNamed:@"globe.americas"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            }];
            action.attributes = UIMenuElementAttributesDisabled;
            [children addObject:action];
        }
        
        {
            NSInteger currentTerrainMode = reinterpret_cast<NSInteger (*)(id, SEL)>(objc_msgSend)(vkMapView, sel_registerName("terrainMode"));
            auto actionsVector = std::views::iota(0, 4)
            | std::views::transform([vkMapView, weakSelf, currentTerrainMode](NSInteger terrainMode) -> UIAction * {
                UIAction *action = [UIAction actionWithTitle:@(terrainMode).stringValue image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(vkMapView, sel_registerName("setTerrainMode:"), terrainMode);
                }];
                
                action.state = (currentTerrainMode == terrainMode) ? UIMenuElementStateOn : UIMenuElementStateOff;
                return action;
            })
            | std::ranges::to<std::vector<UIAction *>>();
            
            NSArray<UIAction *> *actions = [[NSArray alloc] initWithObjects:actionsVector.data() count:actionsVector.size()];
            UIMenu *menu = [UIMenu menuWithTitle:@"Terrain Mode" children:actions];
            [actions release];
            menu.subtitle = @(currentTerrainMode).stringValue;
            [children addObject:menu];
        }
        
        completion(children);
        [children release];
    }];
    
    return [UIMenu menuWithChildren:@[element]];
}

- (void)_presentMkMenu {
    [self _presentMenuForBarButtonItem:self.mkMenuBarButtonItem];
}

- (void)_presentVkMenu {
    [self _presentMenuForBarButtonItem:self.vkMenuBarButtonItem];
}

- (void)_presentMenuForBarButtonItem:(UIBarButtonItem *)barButtonItem {
    __kindof UIControl * _Nullable buttonView = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(barButtonItem, sel_registerName("view"));
    
    auto handler_1 = ^{
        __kindof UIControl * _Nullable buttonView = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(barButtonItem, sel_registerName("view"));
        assert(buttonView != nil);
        
        auto handler_2 = ^{
            for (id<UIInteraction> interaction in buttonView.interactions) {
                if ([interaction isKindOfClass:objc_lookUpClass("_UIClickPresentationInteraction")]) {
                    UIContextMenuInteraction *contextMenuInteraction = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(interaction, sel_registerName("delegate"));
                    
                    auto handler_3 = ^{
                        reinterpret_cast<void (*)(id, SEL, CGPoint)>(objc_msgSend)(contextMenuInteraction, sel_registerName("_presentMenuAtLocation:"), CGPointZero);
                    };
                    
                    id _Nullable outgoingPresentation = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(contextMenuInteraction, sel_registerName("outgoingPresentation"));
                    
                    if (outgoingPresentation != nil) {
                        KeyValueObserver *observer = [[KeyValueObserver alloc] initWithObject:contextMenuInteraction forKeyPath:@"outgoingPresentation" options:NSKeyValueObservingOptionNew handler:^(KeyValueObserver * _Nonnull observer, NSString * _Nonnull keyPath, id  _Nonnull object, NSDictionary * _Nonnull change) {
                            if ([change[NSKeyValueChangeNewKey] isKindOfClass:[NSNull class]]) {
                                handler_3();
                                [observer invalidate];
                            }
                        }];
                        
                        self.menuObserver = observer;
                        [observer release];
                    } else {
                        handler_3();
                    }
                    
                    break;
                }
            }
        };
        
        
        if (buttonView.window == nil) {
            WindowObservingInteraction *interaction = [WindowObservingInteraction new];
            
            interaction.didMoveToWindow = ^(WindowObservingInteraction * _Nonnull interaction, UIWindow * _Nullable oldWindow, UIWindow * _Nullable newWindow) {
                if (newWindow != nil) {
                    [interaction.view removeInteraction:interaction];
                    handler_2();
                }
            };
            
            [buttonView addInteraction:interaction];
            [interaction release];
        } else {
            handler_2();
        }
    };
    
    if (buttonView == nil) {
        KeyValueObserver *observer = [[KeyValueObserver alloc] initWithObject:barButtonItem forKeyPath:@"view" options:NSKeyValueObservingOptionNew handler:^(KeyValueObserver * _Nonnull observer, NSString * _Nonnull keyPath, id _Nonnull object, NSDictionary * _Nonnull change) {
            if (![change[NSKeyValueChangeNewKey] isKindOfClass:[NSNull class]]) {
                handler_1();
                [observer invalidate];
            }
        }];
        
        self.menuObserver = observer;
        [observer release];
    } else {
        handler_1();
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    return nil;
}

@end
