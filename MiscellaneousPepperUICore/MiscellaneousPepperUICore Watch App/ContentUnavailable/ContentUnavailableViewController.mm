//
//  ContentUnavailableViewController.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 8/6/24.
//

#import "ContentUnavailableViewController.h"
#import <UIKit/UIKit.h>
#import <Symbols/Symbols.h>
#import <objc/message.h>
#import <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

@implementation ContentUnavailableViewController

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
        Class _dynamicIsa = objc_allocateClassPair(objc_lookUpClass("SPViewController"), "_ContentUnavailableViewController", 0);
        
        IMP loadView = class_getMethodImplementation(self, @selector(loadView));
        assert(class_addMethod(_dynamicIsa, @selector(loadView), loadView, NULL));
        
        IMP viewDidLoad = class_getMethodImplementation(self, @selector(viewDidLoad));
        assert(class_addMethod(_dynamicIsa, @selector(viewDidLoad), viewDidLoad, NULL));
        
        IMP didTriggerToggleBarButtonItem = class_getMethodImplementation(self, @selector(didTriggerToggleBarButtonItem:));
        assert(class_addMethod(_dynamicIsa, @selector(didTriggerToggleBarButtonItem:), didTriggerToggleBarButtonItem, NULL));
        
        //
        
        objc_registerClassPair(_dynamicIsa);
        
        dynamicIsa = _dynamicIsa;
    });
    
    return dynamicIsa;
}

- (void)loadView {
    id contentUnavailableView = [objc_lookUpClass("PUICContentUnavailableView") new];
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(contentUnavailableView, sel_registerName("setTitle:"), @"Title!");
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(contentUnavailableView, sel_registerName("setMessage:"), @"Message!");
    
    UIImageSymbolConfiguration *configuration = [UIImageSymbolConfiguration configurationWithPaletteColors:@[
        reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(UIColor.class, sel_registerName("systemPinkColor")),
        reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(UIColor.class, sel_registerName("systemGreenColor"))
    ]];
    
    //
    
    UIImage *image = [UIImage systemImageNamed:@"fan.desk" withConfiguration:configuration];
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(contentUnavailableView, sel_registerName("setImage:"), image);
    
    id imageView = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(contentUnavailableView, sel_registerName("imageView"));
    NSSymbolRotateEffect *effect = [[NSSymbolRotateEffect rotateClockwiseEffect] effectWithByLayer];
    NSSymbolEffectOptions *options = [NSSymbolEffectOptions optionsWithRepeatBehavior:[NSSymbolEffectOptionsRepeatBehavior behaviorContinuous]];
    reinterpret_cast<void (*)(id, SEL, id, id)>(objc_msgSend)(imageView, sel_registerName("addSymbolEffect:options:"), effect, options);
    
    //
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(contentUnavailableView, sel_registerName("setButtonTitle:"), @"Button");
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(contentUnavailableView, sel_registerName("setButtonAction:"), ^{
        NSLog(@"Button!");
    });
    
    //
    
    // 안 되는듯
    reinterpret_cast<void (*)(id, SEL, CGFloat)>(objc_msgSend)(contentUnavailableView, sel_registerName("setScrollViewMinimumTopInset:"), 150.);
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setView:"), contentUnavailableView);
    [contentUnavailableView release];
}

- (void)viewDidLoad {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
    
    id navigationItem = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("navigationItem"));
    
    id toggleBarButtonItem = reinterpret_cast<id (*)(id, SEL, id, NSInteger, id, SEL)>(objc_msgSend)([objc_lookUpClass("UIBarButtonItem") alloc], sel_registerName("initWithImage:style:target:action:"), [UIImage systemImageNamed:@"poweroutlet.type.a"], 0, self, @selector(didTriggerToggleBarButtonItem:));
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(navigationItem, sel_registerName("setRightBarButtonItems:"), @[
        toggleBarButtonItem
    ]);
    
    [toggleBarButtonItem release];
}

- (void)didTriggerToggleBarButtonItem:(id)sender {
    id contentUnavailableView = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("view"));
    
    BOOL centerContentVertically = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(contentUnavailableView, sel_registerName("centerContentVertically"));
    
    // 안 되는듯
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(contentUnavailableView, sel_registerName("setCenterContentVertically:"), centerContentVertically ^ 1);
}

@end
