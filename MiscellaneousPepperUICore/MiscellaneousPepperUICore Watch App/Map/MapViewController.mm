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
    mpu_GEOPlatform::mapsFeatureFreedomEnabled::swizzle();
    mpu_VKPlatform::supports3DBuildings::swizzle();
    mpu_VKMapView::_globeIsEnabled::swizzle();
    mpu_VKMapView::_globeIsAvailable::swizzle();
    mpu_VKMapView::_elevatedGroundIsAvailable::swizzle();
    mpu_VKMapView::_elevatedGroundIsEnabled::swizzle();
    mpu_VKMapView::_colorizedBuildingsAllowed::swizzle();
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
    id camera = reinterpret_cast<id (*)(Class, SEL, CLLocationCoordinate2D, CLLocationDistance, CGFloat, CLLocationDirection)>(objc_msgSend)(objc_lookUpClass("MKMapCamera"), sel_registerName("cameraLookingAtCenterCoordinate:fromDistance:pitch:heading:"), CLLocationCoordinate2DMake(37.334606, -122.009102), 409.710641168369, 74.99999867197057, 173.3748958970743);
    reinterpret_cast<void (*)(id, SEL, id, BOOL)>(objc_msgSend)(view, sel_registerName("setCamera:animated:"), camera, YES);
    
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(view, sel_registerName("_setVectorKitConsoleEnabled:"), YES);
    
    id _mapView;
    assert(object_getInstanceVariable(view, "_mapView", (void **)&_mapView) != NULL);
    reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(_mapView, sel_registerName("setTerrainMode:"), 2);
    
//    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(_mapView, sel_registerName("setEnableColorizedBuildings:"), YES);
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(_mapView, sel_registerName("setEnableGlobe:"), YES);
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(_mapView, sel_registerName("setShowsBuildings:"), YES);
    
//    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(_mapView, sel_registerName("enableColorizedBuildings"));
    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(_mapView, sel_registerName("enableGlobe"));
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
