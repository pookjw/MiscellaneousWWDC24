//
//  ClassListViewController.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 8/1/24.
//

#import "ClassListViewController.h"
#import <UIKit/UIKit.h>
#import <objc/message.h>
#import <objc/runtime.h>
#import "DigitalCrownViewController.h"
#import "PageViewController.h"
#import "SlidersViewController.h"
#import "AlertPresenterViewController.h"
#import "SheetPresenterViewController.h"
#import "PickerViewController.h"
#import "ActivityIndicatorViewController.h"
#import "TimeOffsetInputViewController.h"
#import "QuickboardNumberPadViewController.h"
#import "SwitchViewController.h"
#import "CompositionPresenterViewController.h"
#import "MessagePresenterViewController.h"
#import "StatusBarPlacementViewController.h"
#import "StatusBarItemViewController.h"
#import "StatusBarAlphaViewController.h"
#import "StatusBarTimeStyleViewController.h"
#import "AlwaysOnViewController.h"
#import "NetworkActivityIndicatorVisibleViewController.h"
#import "DisablesSleepGestureViewController.h"
#import "WantsAutorotationViewController.h"
#import "VideoPlayerViewController.h"
#import "VolumeIndicatorViewController.h"
#import "NotificationPresenterViewController.h"
#import "ContentUnavailableViewController.h"
#import "MenuPresenterViewController.h"
#import "MenuViewController.h"
#import "PhotoPickerPresenterViewController.h"
#import "GradientMetalViewController.h"
#import "SafariViewPresenterViewController.h"
#import "WatchGesturesViewController.h"
#import "WatchConnectivityViewController.h"
#import "SwiftUIViewController.h"

#warning CarouselUIServices

OBJC_EXPORT id objc_msgSendSuper2(void);

@implementation ClassListViewController

+ (NSArray<Class> *)classes {
    return @[
        SwiftUIViewController.class,
        WatchConnectivityViewController.class,
        WatchGesturesViewController.class,
        SafariViewPresenterViewController.class,
        AlwaysOnViewController.class,
        GradientMetalViewController.class,
        PhotoPickerPresenterViewController.class,
        MenuViewController.class,
        MenuPresenterViewController.class,
        ContentUnavailableViewController.class,
        NotificationPresenterViewController.class,
        VolumeIndicatorViewController.class,
        VideoPlayerViewController.class,
        WantsAutorotationViewController.class,
        DisablesSleepGestureViewController.class,
        NetworkActivityIndicatorVisibleViewController.class,
//        AlwaysOnViewController.class,
        StatusBarTimeStyleViewController.class,
        StatusBarAlphaViewController.class,
        StatusBarItemViewController.class,
        StatusBarPlacementViewController.class,
        MessagePresenterViewController.class,
        CompositionPresenterViewController.class,
        SwitchViewController.class,
        QuickboardNumberPadViewController.class,
        TimeOffsetInputViewController.class,
        ActivityIndicatorViewController.class,
        PickerViewController.class,
        SheetPresenterViewController.class,
        AlertPresenterViewController.class,
        SlidersViewController.class,
        PageViewController.class,
        DigitalCrownViewController.class
    ];
}

+ (void)load {
    [self dynamicIsa];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [[self dynamicIsa] allocWithZone:zone];
}

+ (Class)dynamicIsa {
    static Class dynamicIsa;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class _dynamicIsa = objc_allocateClassPair(objc_lookUpClass("PUICListCollectionViewController"), "_ClassListViewController", 0);
        
        IMP dealloc = class_getMethodImplementation(self, @selector(dealloc));
        assert(class_addMethod(_dynamicIsa, @selector(dealloc), dealloc, NULL));
        
        IMP viewDidLoad = class_getMethodImplementation(self, @selector(viewDidLoad));
        assert(class_addMethod(_dynamicIsa, @selector(viewDidLoad), viewDidLoad, NULL));
        
        IMP numberOfSectionsInCollectionView = class_getMethodImplementation(self, @selector(numberOfSectionsInCollectionView:));
        assert(class_addMethod(_dynamicIsa, @selector(numberOfSectionsInCollectionView:), numberOfSectionsInCollectionView, NULL));
        
        IMP collectionView_numberOfItemsInSection = class_getMethodImplementation(self, @selector(collectionView:numberOfItemsInSection:));
        assert(class_addMethod(_dynamicIsa, @selector(collectionView:numberOfItemsInSection:), collectionView_numberOfItemsInSection, NULL));
        
        IMP collectionView_cellForItemAtIndexPath = class_getMethodImplementation(self, @selector(collectionView:cellForItemAtIndexPath:));
        assert(class_addMethod(_dynamicIsa, @selector(collectionView:cellForItemAtIndexPath:), collectionView_cellForItemAtIndexPath, NULL));
        
        IMP collectionView_didSelectItemAtIndexPath = class_getMethodImplementation(self, @selector(collectionView:didSelectItemAtIndexPath:));
        assert(class_addMethod(_dynamicIsa, @selector(collectionView:didSelectItemAtIndexPath:), collectionView_didSelectItemAtIndexPath, NULL));
        
        assert(class_addIvar(_dynamicIsa, "_cellRegistration", sizeof(id), sizeof(id), @encode(id)));
        
        objc_registerClassPair(_dynamicIsa);
        
        dynamicIsa = _dynamicIsa;
    });
    
    return dynamicIsa;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"
- (void)dealloc {
    id _cellRegistration;
    object_getInstanceVariable(self, "_cellRegistration", reinterpret_cast<void **>(&_cellRegistration));
    [_cellRegistration release];
    
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
}
#pragma clang diagnostic pop

- (void)viewDidLoad {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
    
    id cellRegistration = reinterpret_cast<id (*)(Class, SEL, Class, id)>(objc_msgSend)(objc_lookUpClass("UICollectionViewCellRegistration"), sel_registerName("registrationWithCellClass:configurationHandler:"), objc_lookUpClass("PUICListPlatterCell"), ^(id cell, NSIndexPath *indexPath, Class itemIdentifier) {
        id contentConfiguration = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("UIListContentConfiguration"), sel_registerName("_defaultInsetGroupedCellConfiguration"));;
        
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(contentConfiguration, sel_registerName("setText:"), NSStringFromClass(itemIdentifier));
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(cell, sel_registerName("setContentConfiguration:"), contentConfiguration);
    });
    
    object_setInstanceVariable(self, "_cellRegistration", [cellRegistration retain]);
    
    //
    
    id viewController = [[ClassListViewController classes][0] new];
    
    id navigationController = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("navigationController"));
    reinterpret_cast<void (*)(id, SEL, id, BOOL)>(objc_msgSend)(navigationController, sel_registerName("pushViewController:animated:"), viewController, YES);
    [viewController release];
}

- (NSInteger)numberOfSectionsInCollectionView:(id)collectionView {
    return 1;
}

- (NSInteger)collectionView:(id)collectionView numberOfItemsInSection:(NSInteger)section {
    return [ClassListViewController classes].count;
}

- (id)collectionView:(id)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id _cellRegistration;
    object_getInstanceVariable(self, "_cellRegistration", reinterpret_cast<void **>(&_cellRegistration));
    
    NSInteger item = reinterpret_cast<NSInteger (*)(id, SEL)>(objc_msgSend)(indexPath, sel_registerName("item"));
    
    id cell = reinterpret_cast<id (*)(id, SEL, id, id, id)>(objc_msgSend)(collectionView, sel_registerName("dequeueConfiguredReusableCellWithRegistration:forIndexPath:item:"), _cellRegistration, indexPath, [ClassListViewController classes][item]);
    
    return cell;
}

- (void)collectionView:(id)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger item = reinterpret_cast<NSInteger (*)(id, SEL)>(objc_msgSend)(indexPath, sel_registerName("item"));
    id viewController = [[ClassListViewController classes][item] new];
    
    id navigationController = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("navigationController"));
    reinterpret_cast<void (*)(id, SEL, id, BOOL)>(objc_msgSend)(navigationController, sel_registerName("pushViewController:animated:"), viewController, YES);
    [viewController release];
}

@end
