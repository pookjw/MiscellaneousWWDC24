//
//  CarouselServicesListViewController.m
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 12/14/24.
//

#import "CarouselServicesListViewController.h"
#import <UIKit/UIKit.h>
#import <objc/message.h>
#import <objc/runtime.h>

#warning CarouselUIServices

OBJC_EXPORT id objc_msgSendSuper2(void);

@implementation CarouselServicesListViewController

+ (NSArray *)_allActions {
    return @[
        reinterpret_cast<id (*)(Class, SEL, id, id, id, id)>(objc_msgSend)(objc_lookUpClass("UIAction"), sel_registerName("actionWithTitle:image:identifier:handler:"), @"TEST", nil, nil, ^(id action) {
            NSLog(@"TEST");
        })
    ];
}

+ (void)load {
    [self class];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [[self class] allocWithZone:zone];
}

+ (Class)class {
    static Class isa;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class _isa = objc_allocateClassPair(objc_lookUpClass("PUICListCollectionViewController"), "_CarouselServicesListViewController", 0);
        
        IMP dealloc = class_getMethodImplementation(self, @selector(dealloc));
        assert(class_addMethod(_isa, @selector(dealloc), dealloc, NULL));
        
        IMP viewDidLoad = class_getMethodImplementation(self, @selector(viewDidLoad));
        assert(class_addMethod(_isa, @selector(viewDidLoad), viewDidLoad, NULL));
        
        IMP numberOfSectionsInCollectionView = class_getMethodImplementation(self, @selector(numberOfSectionsInCollectionView:));
        assert(class_addMethod(_isa, @selector(numberOfSectionsInCollectionView:), numberOfSectionsInCollectionView, NULL));
        
        IMP collectionView_numberOfItemsInSection = class_getMethodImplementation(self, @selector(collectionView:numberOfItemsInSection:));
        assert(class_addMethod(_isa, @selector(collectionView:numberOfItemsInSection:), collectionView_numberOfItemsInSection, NULL));
        
        IMP collectionView_cellForItemAtIndexPath = class_getMethodImplementation(self, @selector(collectionView:cellForItemAtIndexPath:));
        assert(class_addMethod(_isa, @selector(collectionView:cellForItemAtIndexPath:), collectionView_cellForItemAtIndexPath, NULL));
        
        IMP collectionView_didSelectItemAtIndexPath = class_getMethodImplementation(self, @selector(collectionView:didSelectItemAtIndexPath:));
        assert(class_addMethod(_isa, @selector(collectionView:didSelectItemAtIndexPath:), collectionView_didSelectItemAtIndexPath, NULL));
        
        assert(class_addIvar(_isa, "_cellRegistration", sizeof(id), sizeof(id), @encode(id)));
        
        objc_registerClassPair(_isa);
        
        isa = _isa;
    });
    
    return isa;
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
    
    id cellRegistration = reinterpret_cast<id (*)(Class, SEL, Class, id)>(objc_msgSend)(objc_lookUpClass("UICollectionViewCellRegistration"), sel_registerName("registrationWithCellClass:configurationHandler:"), objc_lookUpClass("PUICListPlatterCell"), ^(id cell, NSIndexPath *indexPath, id itemIdentifier) {
        id contentConfiguration = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("UIListContentConfiguration"), sel_registerName("_defaultInsetGroupedCellConfiguration"));;
        
        NSString *title = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(itemIdentifier, sel_registerName("title"));
        
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(contentConfiguration, sel_registerName("setText:"), title);
        
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(cell, sel_registerName("setContentConfiguration:"), contentConfiguration);
    });
    
    object_setInstanceVariable(self, "_cellRegistration", [cellRegistration retain]);
}

- (NSInteger)numberOfSectionsInCollectionView:(id)collectionView {
    return 1;
}

- (NSInteger)collectionView:(id)collectionView numberOfItemsInSection:(NSInteger)section {
    return [CarouselServicesListViewController _allActions].count;
}

- (id)collectionView:(id)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id _cellRegistration;
    object_getInstanceVariable(self, "_cellRegistration", reinterpret_cast<void **>(&_cellRegistration));
    
    NSInteger item = reinterpret_cast<NSInteger (*)(id, SEL)>(objc_msgSend)(indexPath, sel_registerName("item"));
    
    id cell = reinterpret_cast<id (*)(id, SEL, id, id, id)>(objc_msgSend)(collectionView, sel_registerName("dequeueConfiguredReusableCellWithRegistration:forIndexPath:item:"), _cellRegistration, indexPath, [CarouselServicesListViewController _allActions][item]);
    
    return cell;
}

- (void)collectionView:(id)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger item = reinterpret_cast<NSInteger (*)(id, SEL)>(objc_msgSend)(indexPath, sel_registerName("item"));
    id action = [CarouselServicesListViewController _allActions][item];
    
    reinterpret_cast<void (*)(id, SEL, id, id)>(objc_msgSend)(action, sel_registerName("performWithSender:target:"), nil, nil);
}

@end
