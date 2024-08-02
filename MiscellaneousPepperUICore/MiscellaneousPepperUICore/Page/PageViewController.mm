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
    self = reinterpret_cast<id (*)(objc_super *, SEL, NSUInteger, NSInteger, BOOL, NSInteger)>(objc_msgSendSuper2)(&superInfo, sel_registerName("initWithNavigationOrientation:titleBehavior:shouldPreloadChildViewControllers:pageTransform:"), 1, 1, NO, 1);
    
    if (self) {
        id cyanViewController = [objc_lookUpClass("SPViewController") new];
        id cyanView = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(cyanViewController, sel_registerName("view"));
        UIColor *systemCyanColor = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(UIColor.class, sel_registerName("systemCyanColor"));
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(cyanView, sel_registerName("setBackgroundColor:"), systemCyanColor);
        
        //
        
        id pinkViewController = [objc_lookUpClass("SPViewController") new];
        id pinkView = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(pinkViewController, sel_registerName("view"));
        UIColor *systemPinkColor = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(UIColor.class, sel_registerName("systemPinkColor"));
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(pinkView, sel_registerName("setBackgroundColor:"), systemPinkColor);
        
        //
        
        id yellowGreenViewController = [objc_lookUpClass("SPViewController") new];
        id yellowView = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(yellowGreenViewController, sel_registerName("view"));
        UIColor *systemYellowColor = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(UIColor.class, sel_registerName("systemYellowColor"));
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(yellowView, sel_registerName("setBackgroundColor:"), systemYellowColor);
        
        id greenView = [objc_lookUpClass("UIView") new];
        UIColor *systemGreenColor = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(UIColor.class, sel_registerName("systemGreenColor"));
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(greenView, sel_registerName("setBackgroundColor:"), systemGreenColor);
        reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(greenView, sel_registerName("setTranslatesAutoresizingMaskIntoConstraints:"), NO);
        
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(yellowView, sel_registerName("addSubview:"), greenView);
        
        id yellowView_safeAreaLayoutGuide = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(yellowView, sel_registerName("safeAreaLayoutGuide"));
        
        id yellowView_topAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(yellowView_safeAreaLayoutGuide, sel_registerName("topAnchor"));
        id yellowView_leadingAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(yellowView_safeAreaLayoutGuide, sel_registerName("leadingAnchor"));
        id yellowView_trailingAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(yellowView_safeAreaLayoutGuide, sel_registerName("trailingAnchor"));
        id yellowView_bottomAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(yellowView_safeAreaLayoutGuide, sel_registerName("bottomAnchor"));
        
        id greenView_topAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(greenView, sel_registerName("topAnchor"));
        id greenView_leadingAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(greenView, sel_registerName("leadingAnchor"));
        id greenView_trailingAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(greenView, sel_registerName("trailingAnchor"));
        id greenView_bottomAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(greenView, sel_registerName("bottomAnchor"));
        
        id topConstraint = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)(yellowView_topAnchor, sel_registerName("constraintEqualToAnchor:"), greenView_topAnchor);
        id leadingConstraint = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)(yellowView_leadingAnchor, sel_registerName("constraintEqualToAnchor:"), greenView_leadingAnchor);
        id trailingConstraint = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)(yellowView_trailingAnchor, sel_registerName("constraintEqualToAnchor:"), greenView_trailingAnchor);
        id bottomConstraint = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)(yellowView_bottomAnchor, sel_registerName("constraintEqualToAnchor:"), greenView_bottomAnchor);
        
        reinterpret_cast<void (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("NSLayoutConstraint"), sel_registerName("activateConstraints:"), @[
            topConstraint, leadingConstraint, trailingConstraint, bottomConstraint
        ]);
        
        [greenView release];
        
        //
        
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setViewControllers:"), @[
            cyanViewController,
            pinkViewController,
            yellowGreenViewController
        ]);
        
        [cyanViewController release];
        [pinkViewController release];
        [yellowGreenViewController release];
        
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
