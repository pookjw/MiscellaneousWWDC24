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
        
        IMP respondsToSelector = class_getMethodImplementation(self, @selector(respondsToSelector:));
        assert(class_addMethod(_dynamicIsa, @selector(respondsToSelector:), respondsToSelector, NULL));
        
        IMP viewDidLoad = class_getMethodImplementation(self, @selector(viewDidLoad));
        assert(class_addMethod(_dynamicIsa, @selector(viewDidLoad), viewDidLoad, NULL));
        
        IMP didTriggerNextBarButtonItem = class_getMethodImplementation(self, @selector(didTriggerNextBarButtonItem:));
        assert(class_addMethod(_dynamicIsa, @selector(didTriggerNextBarButtonItem:), didTriggerNextBarButtonItem, NULL));
        
        IMP pageViewController_didChangeToIndex = class_getMethodImplementation(self, @selector(pageViewController:didChangeToIndex:));
        assert(class_addMethod(_dynamicIsa, @selector(pageViewController:didChangeToIndex:), pageViewController_didChangeToIndex, NULL));
        
        IMP collectionView_didSelectItemAtIndexPath = class_getMethodImplementation(self, @selector(collectionView:didSelectItemAtIndexPath:));
        assert(class_addMethod(_dynamicIsa, @selector(collectionView:didSelectItemAtIndexPath:), collectionView_didSelectItemAtIndexPath, NULL));
        
        //
        
//        assert(class_addProtocol(_dynamicIsa, NSProtocolFromString(@"PUICStatusBarCubicContainerDataSource")));
        
        dynamicIsa = _dynamicIsa;
    });
    
    return dynamicIsa;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    objc_super superInfo = { self, [self class] };
    
    // navigationOrientation
    //  - 0 : Horizontal
    //  - 1 : Vertical
    
    // pageTransform
    //  - 0 : Blur When Vertical
    //  - 1 : None
    self = reinterpret_cast<id (*)(objc_super *, SEL, NSUInteger, NSInteger, BOOL, NSInteger)>(objc_msgSendSuper2)(&superInfo, sel_registerName("initWithNavigationOrientation:titleBehavior:shouldPreloadChildViewControllers:pageTransform:"), 1, 0, NO, 0);
    
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
        
        //
        
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setDelegate:"), self);
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

- (BOOL)respondsToSelector:(SEL)aSelector {
    objc_super superInfo = { self, [self class] };
    BOOL responds = reinterpret_cast<BOOL (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
    
    if (!responds) {
        NSLog(@"%s", sel_getName(aSelector));
    }
    
    return responds;
}

- (void)viewDidLoad {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
    
    id navigationItem = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("navigationItem"));
    
    NSInteger currentIndex = reinterpret_cast<NSInteger (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("currentIndex"));
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(navigationItem, sel_registerName("setTitle:"), [NSNumber numberWithInteger:currentIndex].stringValue);
    
    //
    
    id nextBarButtonItem = reinterpret_cast<id (*)(id, SEL, id, NSInteger, id, SEL)>(objc_msgSend)([objc_lookUpClass("UIBarButtonItem") alloc], sel_registerName("initWithImage:style:target:action:"), [UIImage systemImageNamed:@"opticid"], 0, self, @selector(didTriggerNextBarButtonItem:));
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(navigationItem, sel_registerName("setRightBarButtonItems:"), @[
        nextBarButtonItem
    ]);
    
    [nextBarButtonItem release];
    
    //
    
    // ??
//    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(self, sel_registerName("setAvoidsContentScrollViewLoop:"), YES);
    
    //
    
    // 안 되는듯?
    // -[PUICCarouselBackgroundView setBackgroundView:allowsVibrancy:forIndexPath:]에서 backgroundsForIndexPaths (ivar)이 비어 있어서 아무것도 안함
    
//    UIImage *image = [UIImage imageNamed:@"image"];
//    id imageView = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("UIImageView") alloc], sel_registerName("initWithImage:"), image);
//    reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(imageView, sel_registerName("setContentMode:"), 2);
//    reinterpret_cast<void (*)(id, SEL, id, BOOL, NSUInteger)>(objc_msgSend)(self, sel_registerName("setBackgroundView:allowsVibrancy:atPageIndex:"), imageView, YES, 1);
//    [imageView release];
    
    //
    
    // 안 되는듯?
//    id verticalModeCubicTitleView = reinterpret_cast<id (*)(id, SEL, CGRect)>(objc_msgSend)([objc_lookUpClass("PUICStatusBarCubicContainer") alloc], sel_registerName("initWithFrame:"), CGRectMake(0., 0., 100., 100.));
//    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(verticalModeCubicTitleView, sel_registerName("setDataSource:"), self);
//    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(verticalModeCubicTitleView, sel_registerName("setBackgroundColor:"), UIColor.whiteColor);
//    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setVerticalModeCubicTitleView:"), verticalModeCubicTitleView);
//    [verticalModeCubicTitleView release];
}

- (void)didTriggerNextBarButtonItem:(id)sender {
    NSInteger currentIndex = reinterpret_cast<NSInteger (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("currentIndex"));
    
    NSArray *viewControllers = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("viewControllers"));
    
    if (currentIndex + 1 < viewControllers.count) {
        reinterpret_cast<void (*)(id, SEL, NSInteger, BOOL)>(objc_msgSend)(self, sel_registerName("setCurrentIndex:animated:"), currentIndex + 1, YES);
    } else {
        reinterpret_cast<void (*)(id, SEL, NSInteger, BOOL)>(objc_msgSend)(self, sel_registerName("setCurrentIndex:animated:"), 0, YES);
    }
}

- (void)pageViewController:(id)pageViewController didChangeToIndex:(NSInteger)index {
    id navigationItem = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("navigationItem"));
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(navigationItem, sel_registerName("setTitle:"), [NSNumber numberWithInteger:index].stringValue);
}

- (void)collectionView:(id)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@", indexPath);
}

@end
