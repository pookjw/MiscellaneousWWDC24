//
//  PhotoPickerPresenterViewController.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 8/6/24.
//

#import "PhotoPickerPresenterViewController.h"
#import <UIKit/UIKit.h>
#import <PhotosUI/PhotosUI.h>
#import <objc/message.h>
#import <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

@implementation PhotoPickerPresenterViewController

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
        Class _isa = objc_allocateClassPair(objc_lookUpClass("SPViewController"), "_PhotoPickerPresenterViewController", 0);
        
        IMP loadView = class_getMethodImplementation(self, @selector(loadView));
        assert(class_addMethod(_isa, @selector(loadView), loadView, NULL));
        
        IMP picker_didFinishPicking = class_getMethodImplementation(self, @selector(picker:didFinishPicking:));
        assert(class_addMethod(_isa, @selector(picker:didFinishPicking:), picker_didFinishPicking, NULL));
        
        assert(class_addProtocol(_isa, NSProtocolFromString(@"PHPickerViewControllerDelegate")));
        
        //
        
        objc_registerClassPair(_isa);
        
        isa = _isa;
    });
    
    return isa;
}

- (void)loadView {
    __weak auto weakSelf = self;
    
    id primaryAction = reinterpret_cast<id (*)(Class, SEL, id, id, id, id)>(objc_msgSend)(objc_lookUpClass("UIAction"), sel_registerName("actionWithTitle:image:identifier:handler:"), @"Present", nil, nil, ^(id) {
        [weakSelf present];
    });
    
    id button = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("UIButton"), sel_registerName("systemButtonWithPrimaryAction:"), primaryAction);
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setView:"), button);
}

- (void)present __attribute__((objc_direct)) {
    id sharedPhotoLibrary = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("PHPhotoLibrary"), sel_registerName("sharedPhotoLibrary"));
    
    id configuration = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("PHPickerConfiguration") alloc], sel_registerName("initWithPhotoLibrary:"), sharedPhotoLibrary);
    reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(configuration, sel_registerName("setSelectionLimit:"), 1);
    
    // watchOS에서는 안 됨
//    reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(configuration, sel_registerName("setMode:"), 1);
    
    id viewController = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("PHPickerViewController") alloc], sel_registerName("initWithConfiguration:"), configuration);
    [configuration release];
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(viewController, sel_registerName("setDelegate:"), self);
    
    reinterpret_cast<void (*)(id, SEL, id, BOOL, id)>(objc_msgSend)(self, sel_registerName("presentViewController:animated:completion:"), viewController, YES, nil);
    [viewController release];
}

- (void)picker:(id)picker didFinishPicking:(NSArray *)results; {
    NSLog(@"%@", results);
    
    reinterpret_cast<void (*)(id, SEL, BOOL, id)>(objc_msgSend)(picker, sel_registerName("dismissViewControllerAnimated:completion:"), YES, nil);
}

@end
