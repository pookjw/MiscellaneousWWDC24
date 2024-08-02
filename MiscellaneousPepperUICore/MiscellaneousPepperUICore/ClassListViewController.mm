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

OBJC_EXPORT id objc_msgSendSuper2(void);

@implementation ClassListViewController

+ (NSArray<Class> *)classes {
    return @[
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
        Class _dynamicIsa = objc_allocateClassPair(objc_lookUpClass("UIViewController"), "_ClassListViewController", 0);
        
        IMP dealloc = class_getMethodImplementation(self, @selector(dealloc));
        assert(class_addMethod(_dynamicIsa, @selector(dealloc), dealloc, NULL));
        
        IMP description = class_getMethodImplementation(self, @selector(description));
        assert(class_addMethod(_dynamicIsa, @selector(description), description, NULL));
        
        IMP loadView = class_getMethodImplementation(self, @selector(loadView));
        assert(class_addMethod(_dynamicIsa, @selector(loadView), loadView, NULL));
        
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
        
        assert(class_addIvar(_dynamicIsa, "_collectionView", sizeof(id), sizeof(id), @encode(id)));
        assert(class_addIvar(_dynamicIsa, "_cellRegistration", sizeof(id), sizeof(id), @encode(id)));
        
        dynamicIsa = _dynamicIsa;
    });
    
    return dynamicIsa;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"
- (void)dealloc {
    id _collectionView;
    object_getInstanceVariable(self, "_collectionView", reinterpret_cast<void **>(&_collectionView));
    [_collectionView release];
    
    id _cellRegistration;
    object_getInstanceVariable(self, "_cellRegistration", reinterpret_cast<void **>(&_cellRegistration));
    [_cellRegistration release];
    
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
}
#pragma clang diagnostic pop

- (NSString *)description {
    return [NSString stringWithFormat:@"<%s: %p>", class_getName(self.class), self];
}

- (void)loadView {
    id collectionViewLayout = [objc_lookUpClass("PUICListCollectionViewLayout") new];
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(collectionViewLayout, sel_registerName("setCurvesBottom:"), YES);
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(collectionViewLayout, sel_registerName("setCurvesTop:"), YES);
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(collectionViewLayout, sel_registerName("setDelegate:"), self);
    
    id collectionView = reinterpret_cast<id (*)(id, SEL, CGRect, id)>(objc_msgSend)([objc_lookUpClass("PUICListCollectionView") alloc], sel_registerName("initWithFrame:collectionViewLayout:"), CGRectNull, collectionViewLayout);
    [collectionViewLayout release];
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(collectionView, sel_registerName("setDelegate:"), self);
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(collectionView, sel_registerName("setDataSource:"), self);
    
    object_setInstanceVariable(self, "_collectionView", [collectionView retain]);
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setView:"), collectionView);
    [collectionView release];
    
    // PUICListPlatterCell
    
    id cellRegistration = reinterpret_cast<id (*)(Class, SEL, Class, id)>(objc_msgSend)(objc_lookUpClass("UICollectionViewCellRegistration"), sel_registerName("registrationWithCellClass:configurationHandler:"), objc_lookUpClass("PUICListPlatterCell"), ^(id cell, NSIndexPath *indexPath, Class itemIdentifier) {
        id contentConfiguration = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("UIListContentConfiguration"), sel_registerName("_defaultInsetGroupedCellConfiguration"));;
        
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(contentConfiguration, sel_registerName("setText:"), NSStringFromClass(itemIdentifier));
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(cell, sel_registerName("setContentConfiguration:"), contentConfiguration);
    });
    
    object_setInstanceVariable(self, "_cellRegistration", [cellRegistration retain]);
}

- (void)viewDidLoad {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
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
    
    reinterpret_cast<void (*)(id, SEL, id, BOOL)>(objc_msgSend)(collectionView, sel_registerName("deselectItemAtIndexPath:animated:"), indexPath, YES);
}

@end
