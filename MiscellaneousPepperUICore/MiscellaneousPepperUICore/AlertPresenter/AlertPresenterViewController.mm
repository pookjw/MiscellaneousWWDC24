//
//  AlertPresenterViewController.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 8/3/24.
//

#import "AlertPresenterViewController.h"
#import <UIKit/UIKit.h>
#import <objc/message.h>
#import <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

@implementation AlertPresenterViewController

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
        Class _dynamicIsa = objc_allocateClassPair(objc_lookUpClass("SPViewController"), "_AlertPresenterViewController", 0);
        
        IMP description = class_getMethodImplementation(self, @selector(description));
        assert(class_addMethod(_dynamicIsa, @selector(description), description, NULL));
        
        IMP loadView = class_getMethodImplementation(self, @selector(loadView));
        assert(class_addMethod(_dynamicIsa, @selector(loadView), loadView, NULL));
        
        IMP viewDidLoad = class_getMethodImplementation(self, @selector(viewDidLoad));
        assert(class_addMethod(_dynamicIsa, @selector(viewDidLoad), viewDidLoad, NULL));
        
        
        dynamicIsa = _dynamicIsa;
    });
    
    return dynamicIsa;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%s: %p>", class_getName(self.class), self];
}

- (void)loadView {
    __weak auto weakSelf = self;
    
    id primaryAction = reinterpret_cast<id (*)(Class, SEL, id, id, id, id)>(objc_msgSend)(objc_lookUpClass("UIAction"), sel_registerName("actionWithTitle:image:identifier:handler:"), @"Present", nil, nil, ^(id action) {
        [weakSelf presentAlert];
    });
    
    id button = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("PUICButton"), sel_registerName("systemButtonWithPrimaryAction:"), primaryAction);
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setView:"), button);
}

- (void)viewDidLoad {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
    
}

- (void)presentAlert __attribute__((objc_direct)) {
    id alertController = reinterpret_cast<id (*)(Class, SEL, id, id, NSInteger)>(objc_msgSend)(objc_lookUpClass("UIAlertController"), sel_registerName("alertControllerWithTitle:message:preferredStyle:"), @"Alert", @"Message", 1);
    
    id alertAction = reinterpret_cast<id (*)(Class, SEL, id, NSInteger, id)>(objc_msgSend)(objc_lookUpClass("UIAlertAction"), sel_registerName("actionWithTitle:style:handler:"), @"Done", 0, ^(id alertAction) {});
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(alertController, sel_registerName("addAction:"), alertAction);
    
    reinterpret_cast<void (*)(id, SEL, id, BOOL, id)>(objc_msgSend)(self, sel_registerName("presentViewController:animated:completion:"), alertController, YES, nil);
}

@end
