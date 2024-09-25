//
//  PickerViewController.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 8/3/24.
//

#import "PickerViewController.h"
#import <UIKit/UIKit.h>
#import <objc/message.h>
#import <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

@implementation PickerViewController

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
        Class _dynamicIsa = objc_allocateClassPair(objc_lookUpClass("SPViewController"), "_PickerViewController", 0);
        
        IMP respondsToSelector = class_getMethodImplementation(self, @selector(respondsToSelector:));
        assert(class_addMethod(_dynamicIsa, @selector(respondsToSelector:), respondsToSelector, NULL));
        
        IMP viewDidLoad = class_getMethodImplementation(self, @selector(viewDidLoad));
        assert(class_addMethod(_dynamicIsa, @selector(viewDidLoad), viewDidLoad, NULL));
        
        IMP numberOfItemsInPickerView = class_getMethodImplementation(self, @selector(numberOfItemsInPickerView:));
        assert(class_addMethod(_dynamicIsa, @selector(numberOfItemsInPickerView:), numberOfItemsInPickerView, NULL));
        
        IMP pickerView_viewForItemAtIndex = class_getMethodImplementation(self, @selector(pickerView:viewForItemAtIndex:));
        assert(class_addMethod(_dynamicIsa, @selector(pickerView:viewForItemAtIndex:), pickerView_viewForItemAtIndex, NULL));
        
        IMP pickerView_didSelectItemAtIndex = class_getMethodImplementation(self, @selector(pickerView:didSelectItemAtIndex:));
        assert(class_addMethod(_dynamicIsa, @selector(pickerView:didSelectItemAtIndex:), pickerView_didSelectItemAtIndex, NULL));
        
        objc_registerClassPair(_dynamicIsa);
        
        dynamicIsa = _dynamicIsa;
    });
    
    return dynamicIsa;
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
    
    NSMutableArray *arrangedSubviews = [[NSMutableArray alloc] initWithCapacity:3];
    
    for (NSUInteger style = 0; style < 3; style++) {
        id pickerView = reinterpret_cast<id (*)(id, SEL, NSInteger)>(objc_msgSend)([objc_lookUpClass("PUICPickerView") alloc], sel_registerName("initWithStyle:"), style);
        
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(pickerView, sel_registerName("setDataSource:"), self);
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(pickerView, sel_registerName("setDelegate:"), self);
        
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(pickerView, sel_registerName("setEditorBackgroundColor:"), [UIColor.blueColor colorWithAlphaComponent:0.3]);
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(pickerView, sel_registerName("setEditorGradientOverlayBaseColor:"), [UIColor.redColor colorWithAlphaComponent:0.3]);
        
        reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(pickerView, sel_registerName("setFocusStyle:"), 1);
        
        // ?
        //    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(pickerView, sel_registerName("setIndicatorMode:"), 0);
        
        //
        
        // ???
        //    UIImage *image = [UIImage imageNamed:@"image"];
        //    id imageView = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("UIImageView") alloc], sel_registerName("initWithImage:"), image);
        //    reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(imageView, sel_registerName("setContentMode:"), 2);
        //    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(imageView, sel_registerName("setClipsToBounds:"), YES);
        //    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(pickerView, sel_registerName("setCoordinatedImageViews:"), @[imageView]);
        //    [imageView release];
        
        [arrangedSubviews addObject:pickerView];
        [pickerView release];
    }
    
    //
    
    id stackView = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("UIStackView") alloc], sel_registerName("initWithArrangedSubviews:"), arrangedSubviews);
    [arrangedSubviews release];
    
    reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(stackView, sel_registerName("setAxis:"), 0);
    reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(stackView, sel_registerName("setDistribution:"), 1);
    reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(stackView, sel_registerName("setAlignment:"), 0);
    reinterpret_cast<void (*)(id, SEL, CGFloat)>(objc_msgSend)(stackView, sel_registerName("setSpacing:"), 8.);
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(stackView, sel_registerName("setTranslatesAutoresizingMaskIntoConstraints:"), NO);
    
    //
    
    id view = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("view"));
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(view, sel_registerName("addSubview:"), stackView);
    
    id view_safeAreaLayoutGuide = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(view, sel_registerName("safeAreaLayoutGuide"));
    
    id view_topAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(view_safeAreaLayoutGuide, sel_registerName("topAnchor"));
    id view_leadingAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(view_safeAreaLayoutGuide, sel_registerName("leadingAnchor"));
    id view_trailingAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(view_safeAreaLayoutGuide, sel_registerName("trailingAnchor"));
    id view_bottomAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(view_safeAreaLayoutGuide, sel_registerName("bottomAnchor"));
    
    id stackView_topAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(stackView, sel_registerName("topAnchor"));
    id stackView_leadingAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(stackView, sel_registerName("leadingAnchor"));
    id stackView_trailingAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(stackView, sel_registerName("trailingAnchor"));
    id stackView_bottomAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(stackView, sel_registerName("bottomAnchor"));
    
    id topConstraint = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)(view_topAnchor, sel_registerName("constraintEqualToAnchor:"), stackView_topAnchor);
    id leadingConstraint = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)(view_leadingAnchor, sel_registerName("constraintEqualToAnchor:"), stackView_leadingAnchor);
    id trailingConstraint = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)(view_trailingAnchor, sel_registerName("constraintEqualToAnchor:"), stackView_trailingAnchor);
    id bottomConstraint = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)(view_bottomAnchor, sel_registerName("constraintEqualToAnchor:"), stackView_bottomAnchor);
    
    reinterpret_cast<void (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("NSLayoutConstraint"), sel_registerName("activateConstraints:"), @[
        topConstraint, leadingConstraint, trailingConstraint, bottomConstraint
    ]);
    
    //
    
    [stackView release];
}

- (NSInteger)numberOfItemsInPickerView:(id)pickerView {
    return 100;
}

- (id)pickerView:(id)pickerView viewForItemAtIndex:(NSInteger)index {
    id label = [objc_lookUpClass("PUICHyphenatedLabel") new];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(label, sel_registerName("setText:"), @(index).stringValue);
    return [label autorelease];
}

- (void)pickerView:(id)pickerView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"%ld", index);
}

@end
