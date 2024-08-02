//
//  PageViewController.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 8/2/24.
//

#import "PageViewController.h"
#import <UIKit/UIKit.h>
#import <objc/message.h>
#import <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

@implementation PageViewController

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
        Class _dynamicIsa = objc_allocateClassPair(objc_lookUpClass("SPPUICPageViewController"), "_PageViewController", 0);
        
        IMP initWithNibName_bundle = class_getMethodImplementation(self, @selector(initWithNibName:bundle:));
        assert(class_addMethod(_dynamicIsa, @selector(initWithNibName:bundle:), initWithNibName_bundle, NULL));
        
        IMP dealloc = class_getMethodImplementation(self, @selector(dealloc));
        assert(class_addMethod(_dynamicIsa, @selector(dealloc), dealloc, NULL));
        
        IMP description = class_getMethodImplementation(self, @selector(description));
        assert(class_addMethod(_dynamicIsa, @selector(description), description, NULL));
        
        IMP viewDidLoad = class_getMethodImplementation(self, @selector(viewDidLoad));
        assert(class_addMethod(_dynamicIsa, @selector(viewDidLoad), viewDidLoad, NULL));
        
        dynamicIsa = _dynamicIsa;
    });
    
    return dynamicIsa;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    objc_super superInfo = { self, [self class] };
    self = reinterpret_cast<id (*)(objc_super *, SEL, NSUInteger, NSInteger, BOOL, NSInteger)>(objc_msgSendSuper2)(&superInfo, sel_registerName("initWithNavigationOrientation:titleBehavior:shouldPreloadChildViewControllers:pageTransform:"), 1, 0, NO, 0);
    
    if (self) {
        id cyanViewController = [objc_lookUpClass("SPViewController") new];
        id cyanView = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(cyanViewController, sel_registerName("view"));
        UIColor *systemCyanColor = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(UIColor.class, sel_registerName("systemCyanColor"));
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(cyanView, sel_registerName("setBackgroundColor:"), systemCyanColor);
        
        id pinkViewController = [objc_lookUpClass("SPViewController") new];
        id pinkView = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(pinkViewController, sel_registerName("view"));
        UIColor *systemPinkColor = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(UIColor.class, sel_registerName("systemPinkColor"));
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(pinkView, sel_registerName("setBackgroundColor:"), systemPinkColor);
        
        //
        
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setViewControllers:"), @[
            cyanViewController,
            pinkViewController
        ]);
        
        [cyanViewController release];
        [pinkViewController release];
        
        NSLog(@"%@", reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("viewControllers")));
    }
    
    return self;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"
- (void)dealloc {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
}
#pragma clang diagnostic pop

- (NSString *)description {
    return [NSString stringWithFormat:@"<%s: %p>", class_getName(self.class), self];
}

- (void)viewDidLoad {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
    
    id navigationItem = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("navigationItem"));
    
    // View Controller 바뀔 때마다 업데이트 해보기
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(navigationItem, sel_registerName("setTitle:"), @"Page!");
}

@end
