//
//  ViewController.mm
//  MiscellaneousMapKit
//
//  Created by Jinwoo Kim on 4/13/25.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <objc/message.h>
#import <objc/runtime.h>
#import "NSStringFromMKMapElevationStyle.h"
#import "NSStringFromMKUserTrackingMode.h"
#import "NSStringFromMKStandardMapEmphasisStyle.h"
#import "allMKPointOfInterestCategories.h"
#include <vector>
#include <ranges>
#include <dlfcn.h>

namespace mm_GEOConfigStorageCFProfile {
    namespace getConfigValueForKey_countryCode_options_source_ {
        id (*original)(id, SEL, id ,id, NSUInteger, NSInteger *);
        id custom(id self, SEL _cmd, NSString *key, id contryCode, NSUInteger options, NSInteger *source) {
            if ([key isEqualToString:@"DebugConsoleGestureEnabled"]) {
                return @YES;
            } else if ([key isEqualToString:@"ModernAppleLogo"]) {
                return @YES;
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

@interface ViewController ()
@property (retain, nonatomic, readonly, getter=_mapView) MKMapView *mapView;
@property (retain, nonatomic, readonly, getter=_menuBarButtonItem) UIBarButtonItem *menuBarButtonItem;
@property (retain, nonatomic, readonly, getter=_locationManager) CLLocationManager *locationManager;
@end

@implementation ViewController
@synthesize mapView = _mapView;
@synthesize menuBarButtonItem = _menuBarButtonItem;
@synthesize locationManager = _locationManager;

+ (void)load {
    mm_GEOConfigStorageCFProfile::getConfigValueForKey_countryCode_options_source_::swizzle();
}

- (void)dealloc {
    [_mapView release];
    [_menuBarButtonItem release];
    [_locationManager release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.mapView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.menuBarButtonItem;
    
    [self.locationManager requestWhenInUseAuthorization];
}

- (MKMapView *)_mapView {
    if (auto mapView = _mapView) return mapView;
    
    MKMapView *mapView = [MKMapView new];
    
    _mapView = mapView;
    return mapView;
}

- (UIBarButtonItem *)_menuBarButtonItem {
    if (auto menuBarButtonItem = _menuBarButtonItem) return menuBarButtonItem;
    
    UIBarButtonItem *menuBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"filemenu.and.selection"] menu:[self _makeMenu]];
    
    _menuBarButtonItem = menuBarButtonItem;
    return menuBarButtonItem;
}

- (CLLocationManager *)_locationManager {
    if (auto locationManager = _locationManager) return locationManager;
    
    CLLocationManager *locationManager = [CLLocationManager new];
    
    _locationManager = locationManager;
    return locationManager;
}

- (UIMenu *)_makeMenu {
    MKMapView *mapView = self.mapView;
    
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
                    | std::views::transform([standardMapConfiguration, mapView](const MKStandardMapEmphasisStyle *stylePtr) -> UIAction * {
                        const MKStandardMapEmphasisStyle style = *stylePtr;
                        
                        UIAction *action = [UIAction actionWithTitle:NSStringFromMKStandardMapEmphasisStyle(style)
                                                               image:nil
                                                          identifier:nil
                                                             handler:^(__kindof UIAction * _Nonnull action) {
                            auto copy = static_cast<MKStandardMapConfiguration *>([standardMapConfiguration copy]);
                            copy.emphasisStyle = style;
                            mapView.preferredConfiguration = copy;
                            [copy release];
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
                    NSArray<MKPointOfInterestCategory> *categories = allMKPointOfInterestCategories;
                    MKPointOfInterestFilter *pointOfInterestFilter = [standardMapConfiguration.pointOfInterestFilter copy];
                    if (pointOfInterestFilter == nil) pointOfInterestFilter = [[MKPointOfInterestFilter alloc] initExcludingCategories:@[]];
                    
                    NSMutableArray<UIAction *> *actions = [[NSMutableArray alloc] initWithCapacity:categories.count];
                    for (MKPointOfInterestCategory category in categories) {
                        UIAction *action = [UIAction actionWithTitle:category image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                            auto copy = static_cast<MKStandardMapConfiguration *>([standardMapConfiguration copy]);
                            
                            NSSet<MKPointOfInterestCategory> * _Nullable _excludedCategories;
                            assert(object_getInstanceVariable(pointOfInterestFilter, "_excludedCategories", (void **)&_excludedCategories) != NULL);
                            
                            NSArray<MKPointOfInterestCategory> *newExcludingCategories;
                            if (_excludedCategories == nil) {
                                newExcludingCategories = @[category];
                            } else {
                                newExcludingCategories = [_excludedCategories.allObjects arrayByAddingObject:category];
                            }
                            
                            MKPointOfInterestFilter *pointOfInterestFilter = [[MKPointOfInterestFilter alloc] initExcludingCategories:newExcludingCategories];
                            copy.pointOfInterestFilter = pointOfInterestFilter;
                            [pointOfInterestFilter release];
                            
                            mapView.preferredConfiguration = copy;
                            [copy release];
                        }];
                        
                        action.state = ([pointOfInterestFilter excludesCategory:category]) ? UIMenuElementStateOn : UIMenuElementStateOff;
                        [actions addObject:action];
                    }
                    
                    UIMenu *menu = [UIMenu menuWithTitle:@"Point Of Interest Filter (Exclude)" children:actions];
                    [actions release];
                    [children_3 addObject:menu];
                }
                
                {
                    BOOL showsTraffic = standardMapConfiguration.showsTraffic;
                    
                    UIAction *action = [UIAction actionWithTitle:@"Shows Traffic" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                        auto copy = static_cast<MKStandardMapConfiguration *>([standardMapConfiguration copy]);
                        copy.showsTraffic = !showsTraffic;
                        mapView.preferredConfiguration = copy;
                        [copy release];
                    }];
                    
                    action.state = showsTraffic ? UIMenuElementStateOn : UIMenuElementStateOff;
                    [children_3 addObject:action];
                }
                
                {
                    BOOL showsTopographicFeatures = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(standardMapConfiguration, sel_registerName("showsTopographicFeatures"));
                    
                    UIAction *action = [UIAction actionWithTitle:@"Shows Topographic Features" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                        auto copy = static_cast<MKStandardMapConfiguration *>([standardMapConfiguration copy]);
                        reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(copy, sel_registerName("setShowsTopographicFeatures:"), !showsTopographicFeatures);
                        mapView.preferredConfiguration = copy;
                        [copy release];
                    }];
                    
                    action.state = showsTopographicFeatures ? UIMenuElementStateOn : UIMenuElementStateOff;
                    [children_3 addObject:action];
                }
                
                {
                    BOOL showsHiking = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(standardMapConfiguration, sel_registerName("showsHiking"));
                    
                    UIAction *action = [UIAction actionWithTitle:@"Shows Hiking" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                        auto copy = static_cast<MKStandardMapConfiguration *>([standardMapConfiguration copy]);
                        reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(copy, sel_registerName("setShowsHiking:"), !showsHiking);
                        mapView.preferredConfiguration = copy;
                        [copy release];
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
                    | std::views::transform([preferredConfiguration, mapView](const MKMapElevationStyle *stylePtr) -> UIAction * {
                        const MKMapElevationStyle style = *stylePtr;
                        
                        UIAction *action = [UIAction actionWithTitle:NSStringFromMKMapElevationStyle(style)
                                                               image:nil
                                                          identifier:nil
                                                             handler:^(__kindof UIAction * _Nonnull action) {
                            MKMapConfiguration *configuration = [mapView.preferredConfiguration copy];
                            configuration.elevationStyle = style;
                            mapView.preferredConfiguration = configuration;
                            [configuration release];
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
                
                UIMenu *menu = [UIMenu menuWithTitle:@"MKMapConfiguration" children:children_3];
                [children_3 release];
                [children_2 addObject:menu];
            }
            
            UIMenu *menu = [UIMenu menuWithTitle:@"preferredConfiguration" children:children_2];
            [children_2 release];
            [children addObject:menu];
        }
        
        {
            BOOL isLocationConsoleEnabled = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(mapView, sel_registerName("isLocationConsoleEnabled"));
            
            UIAction *action = [UIAction actionWithTitle:@"Location Console Enabled" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(mapView, sel_registerName("setLocationConsoleEnabled:"), !isLocationConsoleEnabled);
            }];
            
            action.state = isLocationConsoleEnabled ? UIMenuElementStateOn : UIMenuElementStateOff;
            [children addObject:action];
        }
        
        {
            BOOL showsUserLocation = mapView.showsUserLocation;
            
            UIAction *action = [UIAction actionWithTitle:@"Shows User Location" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                mapView.showsUserLocation = !showsUserLocation;
            }];
            
            action.state = showsUserLocation ? UIMenuElementStateOn : UIMenuElementStateOff;
            [children addObject:action];
        }
        
        {
            NSUInteger count;
            const MKUserTrackingMode *allModes = allMKUserTrackingModes(&count);
            
            auto actionsVector = std::views::iota(allModes, allModes + count)
            | std::views::transform([mapView](const MKUserTrackingMode *modePtr) -> UIAction * {
                const MKUserTrackingMode mode = *modePtr;
                UIAction *action = [UIAction actionWithTitle:NSStringFromMKUserTrackingMode(mode)
                                                       image:nil
                                                  identifier:nil
                                                     handler:^(__kindof UIAction * _Nonnull action) {
                    [mapView setUserTrackingMode:mode animated:YES];
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
            }];
            
            action.state = _isVectorKitConsoleEnabled ? UIMenuElementStateOn : UIMenuElementStateOff;
            
            [children addObject:action];
        }
        
        {
            NSMutableArray<__kindof UIMenuElement *> *children_2 = [NSMutableArray new];
            
            {
                UIAction *action = [UIAction actionWithTitle:@"Move to Traffic Visible Location" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(33.9913623, -118.4614118);
                    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
                    MKCoordinateRegion region = MKCoordinateRegionMake(coord, span);
                    [mapView setRegion:region animated:YES];
                }];
                [children_2 addObject:action];
            }
            
            {
                UIAction *action = [UIAction actionWithTitle:@"LAX" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(33.942791, -118.410042);
                    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
                    MKCoordinateRegion region = MKCoordinateRegionMake(coord, span);
                    [mapView setRegion:region animated:YES];
                }];
                [children_2 addObject:action];
            }
            
            UIMenu *menu = [UIMenu menuWithTitle:@"Miscellaneous" children:children_2];
            [children_2 release];
            [children addObject:menu];
        }
        
        completion(children);
        [children release];
    }];
    
    return [UIMenu menuWithChildren:@[element]];
}

@end
