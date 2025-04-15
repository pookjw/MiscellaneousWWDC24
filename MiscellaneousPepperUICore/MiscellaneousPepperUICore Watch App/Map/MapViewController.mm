//
//  MapViewController.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 4/15/25.
//

#import "MapViewController.h"
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <objc/message.h>
#import <objc/runtime.h>

// VKDebugSettings

OBJC_EXPORT id objc_msgSendSuper2(void);

namespace mpu_GEOConfigStorageCFProfile {
namespace getConfigValueForKey_countryCode_options_source_ {
id (*original)(id, SEL, id ,id, NSUInteger, NSInteger *);
id custom(id self, SEL _cmd, NSString *key, id contryCode, NSUInteger options, NSInteger *source) {
    NSLog(@"Foo: %@", key);
    if ([key isEqualToString:@"VKMLayoutEnabled_Flyover"]) {
        return @YES;
    } else if ([key isEqualToString:@"VKMLayoutEnabled_Navigation"]) {
        return @YES;
    } else if ([key isEqualToString:@"VKMLayoutEnabled_SPR"]) {
        return @YES;
//    } else if ([key isEqualToString:@"LockWatchFpsTo30hz"]) {
//        return @YES;
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
    } else if ([key isEqualToString:@"TopographicDisplayEnabled"]) {
        return @YES;
    } else if ([key isEqualToString:@"ShelbyvilleTerrain"]) {
        return @YES;
    } else if ([key isEqualToString:@"ShelbyvilleColorizedBuildings"]) {
        return @YES;
    } else if ([key isEqualToString:@"Maps298"]) {
        return @YES;
    } else if ([key containsString:@"Shelbyville"]) {
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


namespace mpu_GEOPlatform {
namespace supportsAdvancedMap {
BOOL (*original)(id, SEL);
BOOL custom(id self, SEL _cmd) {
    return YES;
}
void swizzle() {
    Method method = class_getInstanceMethod(objc_lookUpClass("GEOPlatform"), sel_registerName("supportsAdvancedMap"));
    original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}
}
namespace mapsFeatureFreedomEnabled {
BOOL (*original)(id, SEL);
BOOL custom(id self, SEL _cmd) {
    return YES;
}
void swizzle() {
    Method method = class_getInstanceMethod(objc_lookUpClass("GEOPlatform"), sel_registerName("mapsFeatureFreedomEnabled"));
    original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}
}
}

namespace mpu_VKPlatform {

namespace supports3DBuildings {
BOOL (*original)(id, SEL);
BOOL custom(id self, SEL _cmd) {
    return YES;
}
void swizzle() {
    Method method = class_getInstanceMethod(objc_lookUpClass("VKPlatform"), sel_registerName("supports3DBuildings"));
    original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}
}

namespace supports3DBuildingStrokes {
BOOL (*original)(id, SEL);
BOOL custom(id self, SEL _cmd) {
    return YES;
}
void swizzle() {
    Method method = class_getInstanceMethod(objc_lookUpClass("VKPlatform"), sel_registerName("supports3DBuildingStrokes"));
    original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}
}

namespace supportsHiResBuildings {
BOOL (*original)(id, SEL);
BOOL custom(id self, SEL _cmd) {
    return YES;
}
void swizzle() {
    Method method = class_getInstanceMethod(objc_lookUpClass("VKPlatform"), sel_registerName("supportsHiResBuildings"));
    original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}
}

namespace allows3DPuck {
BOOL (*original)(id, SEL);
BOOL custom(id self, SEL _cmd) {
    return YES;
}
void swizzle() {
    Method method = class_getInstanceMethod(objc_lookUpClass("VKPlatform"), sel_registerName("allows3DPuck"));
    original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}
}

namespace lowPerformanceDevice {
BOOL (*original)(id, SEL);
BOOL custom(id self, SEL _cmd) {
    return NO;
}
void swizzle() {
    Method method = class_getInstanceMethod(objc_lookUpClass("VKPlatform"), sel_registerName("lowPerformanceDevice"));
    original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}
}

namespace supportsBuildingShadows {
BOOL (*original)(id, SEL);
BOOL custom(id self, SEL _cmd) {
    return YES;
}
void swizzle() {
    Method method = class_getInstanceMethod(objc_lookUpClass("VKPlatform"), sel_registerName("supportsBuildingShadows"));
    original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}
}

namespace supportsARMode {
BOOL (*original)(id, SEL);
BOOL custom(id self, SEL _cmd) {
    return YES;
}
void swizzle() {
    Method method = class_getInstanceMethod(objc_lookUpClass("VKPlatform"), sel_registerName("supportsARMode"));
    original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}
}

namespace isIphone {
BOOL (*original)(id, SEL);
BOOL custom(id self, SEL _cmd) {
    return YES;
}
void swizzle() {
    Method method = class_getInstanceMethod(objc_lookUpClass("VKPlatform"), sel_registerName("isIphone"));
    original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}
}

namespace roadsWithSimpleLineMeshesAvailable {
BOOL (*original)(id, SEL);
BOOL custom(id self, SEL _cmd) {
    return NO;
}
void swizzle() {
    Method method = class_getInstanceMethod(objc_lookUpClass("VKPlatform"), sel_registerName("roadsWithSimpleLineMeshesAvailable"));
    original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}
}

}

/*
 dictionaryRepresentation
 */
namespace mpu_GGEOClientCapabilities {
namespace supportsAdvancedMap {
BOOL (*original)(id, SEL);
BOOL custom(id self, SEL _cmd) {
    return YES;
}
void swizzle() {
    Method method = class_getInstanceMethod(objc_lookUpClass("GEOClientCapabilities"), sel_registerName("supportsAdvancedMap"));
    original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}
}
}

namespace mpu_VKMapView {

namespace _globeIsEnabled {
BOOL (*original)(Class self, SEL _cmd);
BOOL custom(Class self, SEL _cmd) {
    return YES;
}
void swizzle() {
    Method method = class_getClassMethod(objc_lookUpClass("VKMapView"), sel_registerName("_globeIsEnabled"));
    assert(method != NULL);
    original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}
}

namespace _globeIsAvailable {
BOOL (*original)(Class self, SEL _cmd);
BOOL custom(Class self, SEL _cmd) {
    return YES;
}
void swizzle() {
    Method method = class_getClassMethod(objc_lookUpClass("VKMapView"), sel_registerName("_globeIsAvailable"));
    assert(method != NULL);
    original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}
}

namespace _elevatedGroundIsAvailable {
BOOL (*original)(Class self, SEL _cmd);
BOOL custom(Class self, SEL _cmd) {
    return YES;
}
void swizzle() {
    Method method = class_getClassMethod(objc_lookUpClass("VKMapView"), sel_registerName("_elevatedGroundIsAvailable"));
    assert(method != NULL);
    original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}
}

namespace _elevatedGroundIsEnabled {
BOOL (*original)(Class self, SEL _cmd);
BOOL custom(Class self, SEL _cmd) {
    return YES;
}
void swizzle() {
    Method method = class_getClassMethod(objc_lookUpClass("VKMapView"), sel_registerName("_elevatedGroundIsEnabled"));
    assert(method != NULL);
    original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}
}

namespace _colorizedBuildingsAllowed {
BOOL (*original)(id self, SEL _cmd);
BOOL custom(id self, SEL _cmd) {
    return YES;
}
void swizzle() {
    Method method = class_getInstanceMethod(objc_lookUpClass("VKMapView"), sel_registerName("_colorizedBuildingsAllowed"));
    assert(method != NULL);
    original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}
}

namespace setEnableColorizedBuildings_ {
void (*original)(id self, SEL _cmd, BOOL);
void custom(id self, SEL _cmd, BOOL flag) {
    original(self, _cmd, YES);
}
void swizzle() {
    Method method = class_getInstanceMethod(objc_lookUpClass("VKMapView"), sel_registerName("setEnableColorizedBuildings:"));
    assert(method != NULL);
    original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}
}

namespace _daVinciDataAvailable {
BOOL (*original)(id self, SEL _cmd);
BOOL custom(id self, SEL _cmd) {
    return YES;
}
void swizzle() {
    Method method = class_getInstanceMethod(objc_lookUpClass("VKMapView"), sel_registerName("_daVinciDataAvailable"));
    assert(method != NULL);
    original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}
}

//namespace canEnter3DMode {
//BOOL (*original)(id self, SEL _cmd);
//BOOL custom(id self, SEL _cmd) {
//    return NO;
//}
//void swizzle() {
//    Method method = class_getInstanceMethod(objc_lookUpClass("VKMapView"), sel_registerName("canEnter3DMode"));
//    assert(method != NULL);
//    original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
//    method_setImplementation(method, reinterpret_cast<IMP>(custom));
//}
//}

namespace canShowFlyover {
BOOL (*original)(id self, SEL _cmd);
BOOL custom(id self, SEL _cmd) {
    return YES;
}
void swizzle() {
    Method method = class_getInstanceMethod(objc_lookUpClass("VKMapView"), sel_registerName("canShowFlyover"));
    assert(method != NULL);
    original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}
}

}



namespace mpu_VKClassicGlobeCanva {

namespace flyoverAvailable {
BOOL (*original)(Class self, SEL _cmd);
BOOL custom(Class self, SEL _cmd) {
    return YES;
}
void swizzle() {
    Method method = class_getInstanceMethod(objc_lookUpClass("VKClassicGlobeCanvas"), sel_registerName("flyoverAvailable"));
    assert(method != NULL);
    original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}
}

}

namespace mpu_MKSystemController {

namespace supportsPitchAPI {
BOOL (*original)(Class self, SEL _cmd);
BOOL custom(Class self, SEL _cmd) {
    return YES;
}
void swizzle() {
    Method method = class_getInstanceMethod(objc_lookUpClass("MKSystemController"), sel_registerName("supportsPitchAPI"));
    assert(method != NULL);
    original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}
}

}

@implementation MapViewController

+ (void)load {
    mpu_GEOPlatform::supportsAdvancedMap::swizzle();
    mpu_GEOPlatform::mapsFeatureFreedomEnabled::swizzle();
    mpu_VKPlatform::supports3DBuildings::swizzle();
    mpu_VKPlatform::supports3DBuildingStrokes::swizzle();
    mpu_VKPlatform::supportsHiResBuildings::swizzle();
    mpu_VKPlatform::allows3DPuck::swizzle();
    mpu_VKPlatform::lowPerformanceDevice::swizzle();
    mpu_VKPlatform::supportsBuildingShadows::swizzle();
    mpu_VKPlatform::supportsARMode::swizzle();
    mpu_VKPlatform::isIphone::swizzle();
    mpu_VKPlatform::roadsWithSimpleLineMeshesAvailable::swizzle();
    mpu_GEOConfigStorageCFProfile::getConfigValueForKey_countryCode_options_source_::swizzle();
    mpu_VKMapView::_globeIsEnabled::swizzle();
    mpu_VKMapView::_globeIsAvailable::swizzle();
    mpu_VKMapView::_elevatedGroundIsAvailable::swizzle();
    mpu_VKMapView::_elevatedGroundIsEnabled::swizzle();
    mpu_VKMapView::_colorizedBuildingsAllowed::swizzle();
    mpu_VKMapView::setEnableColorizedBuildings_::swizzle();
    mpu_VKMapView::_daVinciDataAvailable::swizzle();
//    mpu_VKMapView::canEnter3DMode::swizzle();
    mpu_VKMapView::canShowFlyover::swizzle();
    mpu_VKClassicGlobeCanva::flyoverAvailable::swizzle();
    mpu_MKSystemController::supportsPitchAPI::swizzle();
    [self class];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [[self class] allocWithZone:zone];
}

+ (Class)class {
    static Class isa;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class _isa = objc_allocateClassPair(objc_lookUpClass("SPViewController"), "_MapViewController", 0);
        
        IMP respondsToSelector = class_getMethodImplementation(self, @selector(respondsToSelector:));
        assert(class_addMethod(_isa, @selector(respondsToSelector:), respondsToSelector, NULL));
        
        IMP loadView = class_getMethodImplementation(self, @selector(loadView));
        assert(class_addMethod(_isa, @selector(loadView), loadView, NULL));
        
        IMP viewDidLoad = class_getMethodImplementation(self, @selector(viewDidLoad));
        assert(class_addMethod(_isa, @selector(viewDidLoad), viewDidLoad, NULL));
        
        IMP menuBarButtonItemDidTrigger = class_getMethodImplementation(self, @selector(menuBarButtonItemDidTrigger:));
        assert(class_addMethod(_isa, @selector(menuBarButtonItemDidTrigger:), menuBarButtonItemDidTrigger, NULL));
        
        //        assert(class_addProtocol(_isa, NSProtocolFromString(@"PUICMenuViewControllerDelegate")));
        
        //
        
        objc_registerClassPair(_isa);
        
        isa = _isa;
    });
    
    return isa;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    objc_super superInfo = { self, [self class] };
    BOOL responds = reinterpret_cast<BOOL (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
    
    if (!responds) {
        NSLog(@"%s", sel_getName(aSelector));
    }
    
    return responds;
}

- (void)loadView {
    id mapView = [objc_lookUpClass("MKMapView") new];
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setView:"), mapView);
    [mapView release];
}

- (void)viewDidLoad {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
    
    id navigationItem = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("navigationItem"));
    
    id menuBarButtonItem = reinterpret_cast<id (*)(id, SEL, id, NSInteger, id, SEL)>(objc_msgSend)([objc_lookUpClass("UIBarButtonItem") alloc], sel_registerName("initWithImage:style:target:action:"), [UIImage systemImageNamed:@"line.3.horizontal"], 0, self, @selector(menuBarButtonItemDidTrigger:));
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(navigationItem, sel_registerName("setRightBarButtonItems:"), @[
        menuBarButtonItem
    ]);
    
    [menuBarButtonItem release];
    
    id view = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("view"));
    id camera = reinterpret_cast<id (*)(Class, SEL, CLLocationCoordinate2D, CLLocationDistance, CGFloat, CLLocationDirection)>(objc_msgSend)(objc_lookUpClass("MKMapCamera"), sel_registerName("cameraLookingAtCenterCoordinate:fromDistance:pitch:heading:"), CLLocationCoordinate2DMake(37.801734, -122.405793), 409.710641168369, 74.99999867197057, 173.3748958970743);
    reinterpret_cast<void (*)(id, SEL, id, BOOL)>(objc_msgSend)(view, sel_registerName("setCamera:animated:"), camera, YES);
    
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(view, sel_registerName("_setVectorKitConsoleEnabled:"), YES);
    
    id _mapView;
    assert(object_getInstanceVariable(view, "_mapView", (void **)&_mapView) != NULL);
    NSLog(@"%ld", reinterpret_cast<NSInteger (*)(id, SEL)>(objc_msgSend)(_mapView, sel_registerName("terrainMode")));
    reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(_mapView, sel_registerName("setTerrainMode:"), 2);
    
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(_mapView, sel_registerName("setEnableColorizedBuildings:"), YES);
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(_mapView, sel_registerName("setEnableBuildingHeights:"), YES);
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(_mapView, sel_registerName("setModernMapEnabled:"), YES);
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(_mapView, sel_registerName("setEnableGlobe:"), YES);
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(_mapView, sel_registerName("setEnableRoundedBuildings:"), YES);
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(_mapView, sel_registerName("setEnableAdvancedLighting:"), YES);
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(_mapView, sel_registerName("setShowsBuildings:"), YES);
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(_mapView, sel_registerName("setGesturing:"), YES);
    reinterpret_cast<void (*)(id, SEL, int)>(objc_msgSend)(_mapView, sel_registerName("setFlyoverMode:"), -1);
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(_mapView, sel_registerName("setIsPitchable:"), YES);
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(_mapView, sel_registerName("setShowsVenues:"), YES);
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(_mapView, sel_registerName("setShowsLiveEVData:"), YES);
    
    assert(reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(_mapView, sel_registerName("_modernMapAllowed")));
    assert(reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(_mapView, sel_registerName("_colorizedBuildingsAllowed")));
    
    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(_mapView, sel_registerName("enableColorizedBuildings"));
    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(_mapView, sel_registerName("enableGlobe"));
    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(_mapView, sel_registerName("enableRoundedBuildings"));
    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(_mapView, sel_registerName("enableAdvancedLighting"));
    
    
    NSLog(@"%ld", reinterpret_cast<NSInteger (*)(id, SEL)>(objc_msgSend)(_mapView, sel_registerName("currentMapMode")));
}

- (void)menuBarButtonItemDidTrigger:(id)sender {
    id view = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("view"));
    
    NSMutableArray *menuElements = [NSMutableArray new];
    
    {
        id action = reinterpret_cast<id (*)(id, SEL, id, id, id, id, NSInteger, NSInteger, NSUInteger, id)>(objc_msgSend)([objc_lookUpClass("PUICMenuAction") alloc], sel_registerName("initWithTitle:detail:image:identifier:style:state:attributes:handler:"), @"Book Passage", nil, nil, @"Book Passage", 0, 0, 0, ^(id action) {
            id camera = reinterpret_cast<id (*)(Class, SEL, CLLocationCoordinate2D, CLLocationDistance, CGFloat, CLLocationDirection)>(objc_msgSend)(objc_lookUpClass("MKMapCamera"), sel_registerName("cameraLookingAtCenterCoordinate:fromDistance:pitch:heading:"), CLLocationCoordinate2DMake(37.796043, -122.392914), 481.1949875514527, 69.99999967119774, 42.48784350129402);
            reinterpret_cast<void (*)(id, SEL, id, BOOL)>(objc_msgSend)(view, sel_registerName("setCamera:animated:"), camera, YES);
        });
        
        [menuElements addObject:action];
        [action release];
    }
    
    id menuViewController = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("PUICMenuViewController") alloc], sel_registerName("initWithMenuElements:"), menuElements);
    [menuElements release];
    
    reinterpret_cast<void (*)(id, SEL, id, BOOL, id)>(objc_msgSend)(self, sel_registerName("presentViewController:animated:completion:"), menuViewController, YES, nil);
    
    [menuViewController release];
}

@end
