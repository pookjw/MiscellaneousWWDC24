//
//  ButtonListenerViewController.m
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 12/14/24.
//

#import "ButtonListenerViewController.h"
#import <UIKit/UIKit.h>
#import <objc/message.h>
#import <objc/runtime.h>
#include <dlfcn.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

__attribute__((objc_direct_members))
@interface ButtonListenerViewController ()
@property (copy, nonatomic, readonly) NSArray *_registrations;
@property (retain, nonatomic, readonly) NSMutableArray<NSString *> *_histories;
@property (retain, nonatomic, readonly) id _cellRegistration;
@end

@implementation ButtonListenerViewController

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
        Class _isa = objc_allocateClassPair(objc_lookUpClass("PUICListCollectionViewController"), "_ButtonListenerViewController", 0);
        
        IMP initWithCollectionViewLayout = class_getMethodImplementation(self, @selector(initWithCollectionViewLayout:));
        assert(class_addMethod(_isa, @selector(initWithCollectionViewLayout:), initWithCollectionViewLayout, NULL));
        
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
        
        assert(class_addIvar(_isa, "__registrations", sizeof(id), sizeof(id), @encode(id)));
        assert(class_addIvar(_isa, "__histories", sizeof(id), sizeof(id), @encode(id)));
        assert(class_addIvar(_isa, "__cellRegistration", sizeof(id), sizeof(id), @encode(id)));
        
        //
        
        objc_registerClassPair(_isa);
        
        isa = _isa;
    });
    
    return isa;
}

- (instancetype)initWithCollectionViewLayout:(id)collectionViewLayout {
    objc_super superInfo = { self, [self class] };
    self = reinterpret_cast<id (*)(objc_super *, SEL, id)>(objc_msgSendSuper2)(&superInfo, _cmd, collectionViewLayout);
    
    if (self) {
        assert(object_setInstanceVariable(self, "__histories", reinterpret_cast<void *>([NSMutableArray new])));
    }
    
    return self;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"
- (void)dealloc {
    NSArray *__registrations;
    assert(object_getInstanceVariable(self, "__registrations", reinterpret_cast<void **>(&__registrations)));
    void *CarouselServices = dlopen("/System/Library/PrivateFrameworks/CarouselServices.framework/CarouselServices", RTLD_NOW);
    void *CSLSStopListeningForButtonEvents = dlsym(CarouselServices, "CSLSStopListeningForButtonEvents");
    
    for (id registration in __registrations) {
        reinterpret_cast<void (*)(id)>(CSLSStopListeningForButtonEvents)(registration);
    }
    
    [__registrations release];
    
    
    id __histories;
    assert(object_getInstanceVariable(self, "__histories", reinterpret_cast<void **>(&__histories)));
    [__histories release];
    
    id __cellRegistration;
    assert(object_getInstanceVariable(self, "__cellRegistration", reinterpret_cast<void **>(&__cellRegistration)));
    [__cellRegistration release];
    
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
}
#pragma clang diagnostic pop

- (void)viewDidLoad {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
    
    void *CarouselServices = dlopen("/System/Library/PrivateFrameworks/CarouselServices.framework/CarouselServices", RTLD_NOW);
    void *CSLSStartListeningForButtonEventsWithHandler = dlsym(CarouselServices, "CSLSStartListeningForButtonEventsWithHandler");
    
    NSMutableArray *registrations = [[NSMutableArray alloc] initWithCapacity:6];
    NSMutableArray<NSString *> *histories = self._histories;
    id collectionView = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("collectionView"));
    
    auto handler = ^(NSUInteger buttons, NSUInteger event){
        dispatch_async(dispatch_get_main_queue(), ^{
            reinterpret_cast<void (*)(id, SEL, id, id)>(objc_msgSend)(collectionView, sel_registerName("performBatchUpdates:completion:"), ^{
                NSString *item = [NSString stringWithFormat:@"%ld - %ld", buttons, event];
                [histories insertObject:item atIndex:0];
                
                NSIndexPath *indexPath = reinterpret_cast<id (*)(Class, SEL, NSInteger, NSInteger)>(objc_msgSend)([NSIndexPath class], sel_registerName("indexPathForItem:inSection:"), 0, 0);
                
                reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(collectionView, sel_registerName("insertItemsAtIndexPaths:"), @[indexPath]);
            },
                                                                      ^(BOOL finished) {
                
            });
        });
    };
    
    [registrations addObject:reinterpret_cast<id (*)(NSUInteger, NSUInteger, id)>(CSLSStartListeningForButtonEventsWithHandler)(0x1, 0x0, handler)];
    [registrations addObject:reinterpret_cast<id (*)(NSUInteger, NSUInteger, id)>(CSLSStartListeningForButtonEventsWithHandler)(0x1, 0x1, handler)];
    [registrations addObject:reinterpret_cast<id (*)(NSUInteger, NSUInteger, id)>(CSLSStartListeningForButtonEventsWithHandler)(0x1, 0x2, handler)];
    [registrations addObject:reinterpret_cast<id (*)(NSUInteger, NSUInteger, id)>(CSLSStartListeningForButtonEventsWithHandler)(0x1, 0x3, handler)];
    [registrations addObject:reinterpret_cast<id (*)(NSUInteger, NSUInteger, id)>(CSLSStartListeningForButtonEventsWithHandler)(0x1, 0x4, handler)];
    [registrations addObject:reinterpret_cast<id (*)(NSUInteger, NSUInteger, id)>(CSLSStartListeningForButtonEventsWithHandler)(0x1, 0x5, handler)];
    [registrations addObject:reinterpret_cast<id (*)(NSUInteger, NSUInteger, id)>(CSLSStartListeningForButtonEventsWithHandler)(0x1, 0x6, handler)];
    
    [registrations addObject:reinterpret_cast<id (*)(NSUInteger, NSUInteger, id)>(CSLSStartListeningForButtonEventsWithHandler)(0x2, 0x0, handler)];
    [registrations addObject:reinterpret_cast<id (*)(NSUInteger, NSUInteger, id)>(CSLSStartListeningForButtonEventsWithHandler)(0x2, 0x1, handler)];
    [registrations addObject:reinterpret_cast<id (*)(NSUInteger, NSUInteger, id)>(CSLSStartListeningForButtonEventsWithHandler)(0x2, 0x2, handler)];
    [registrations addObject:reinterpret_cast<id (*)(NSUInteger, NSUInteger, id)>(CSLSStartListeningForButtonEventsWithHandler)(0x2, 0x3, handler)];
    [registrations addObject:reinterpret_cast<id (*)(NSUInteger, NSUInteger, id)>(CSLSStartListeningForButtonEventsWithHandler)(0x2, 0x4, handler)];
    [registrations addObject:reinterpret_cast<id (*)(NSUInteger, NSUInteger, id)>(CSLSStartListeningForButtonEventsWithHandler)(0x2, 0x5, handler)];
    [registrations addObject:reinterpret_cast<id (*)(NSUInteger, NSUInteger, id)>(CSLSStartListeningForButtonEventsWithHandler)(0x2, 0x6, handler)];
    
    assert(object_setInstanceVariable(self, "__registrations", reinterpret_cast<void *>([registrations copy])));
    [registrations release];
    
    [self _cellRegistration];
}

- (NSArray *)_registrations {
    NSArray *__registrations;
    assert(object_getInstanceVariable(self, "__registrations", reinterpret_cast<void **>(&__registrations)));
    return __registrations;
}

- (NSMutableArray<NSNumber *> *)_histories {
    NSMutableArray<NSNumber *> *__histories;
    assert(object_getInstanceVariable(self, "__histories", reinterpret_cast<void **>(&__histories)));
    
    if (__histories == nil) {
        __histories = [NSMutableArray new];
        assert(object_setInstanceVariable(self, "__histories", reinterpret_cast<void *>([__histories retain])));
        
        [__histories autorelease];
    }
    
    return __histories;
}

- (id)_cellRegistration {
    id __cellRegistration;
    assert(object_getInstanceVariable(self, "__cellRegistration", reinterpret_cast<void **>(&__cellRegistration)));
    
    if (__cellRegistration == nil) {
        __cellRegistration = reinterpret_cast<id (*)(Class, SEL, Class, id)>(objc_msgSend)(objc_lookUpClass("UICollectionViewCellRegistration"), sel_registerName("registrationWithCellClass:configurationHandler:"), objc_lookUpClass("PUICListPlatterCell"), ^(id cell, NSIndexPath *indexPath, NSString *itemIdentifier) {
            id contentConfiguration = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("UIListContentConfiguration"), sel_registerName("_defaultInsetGroupedCellConfiguration"));
            
            reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(contentConfiguration, sel_registerName("setText:"), itemIdentifier);
            
            reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(cell, sel_registerName("setContentConfiguration:"), contentConfiguration);
        });
        
        assert(object_setInstanceVariable(self, "__cellRegistration", reinterpret_cast<void *>([__cellRegistration retain])));
    }
    
    return __cellRegistration;
}

- (NSInteger)numberOfSectionsInCollectionView:(id)collectionView {
    return 1;
}

- (NSInteger)collectionView:(id)collectionView numberOfItemsInSection:(NSInteger)section {
    return self._histories.count;
}

- (id)collectionView:(id)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id __cellRegistration;
    assert(object_getInstanceVariable(self, "__cellRegistration", reinterpret_cast<void **>(&__cellRegistration)));
    
    NSInteger item = reinterpret_cast<NSInteger (*)(id, SEL)>(objc_msgSend)(indexPath, sel_registerName("item"));
    
    id cell = reinterpret_cast<id (*)(id, SEL, id, id, id)>(objc_msgSend)(collectionView, sel_registerName("dequeueConfiguredReusableCellWithRegistration:forIndexPath:item:"), __cellRegistration, indexPath, self._histories[item]);
    
    return cell;
}

@end
