//
//  StatusBarTimeStyleViewController.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 8/4/24.
//

#import "StatusBarTimeStyleViewController.h"
#import <UIKit/UIKit.h>
#import <objc/message.h>
#import <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

// puic_statusBarBaseline, puic_statusBarLayoutMargins 아무것도 안 변함
// puic_statusBarAvailableWidth은 Status Bar가 가질 너비를 정할 수 있고, 너무 작으면 시계가 안 보임
@implementation StatusBarTimeStyleViewController

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
        Class _dynamicIsa = objc_allocateClassPair(objc_lookUpClass("SPViewController"), "_StatusBarTimeStyleViewController", 0);
        
        IMP description = class_getMethodImplementation(self, @selector(description));
        assert(class_addMethod(_dynamicIsa, @selector(description), description, NULL));
        
        IMP viewDidLoad = class_getMethodImplementation(self, @selector(viewDidLoad));
        assert(class_addMethod(_dynamicIsa, @selector(viewDidLoad), viewDidLoad, NULL));
        
        IMP puic_statusBarTimeStyle = class_getMethodImplementation(self, @selector(puic_statusBarTimeStyle));
        assert(class_addMethod(_dynamicIsa, @selector(puic_statusBarTimeStyle), puic_statusBarTimeStyle, NULL));
        
        IMP puic_statusBarLayoutMargins = class_getMethodImplementation(self, @selector(puic_statusBarLayoutMargins));
        assert(class_addMethod(_dynamicIsa, @selector(puic_statusBarLayoutMargins), puic_statusBarLayoutMargins, NULL));
        
        assert(class_addIvar(_dynamicIsa, "_mpu_puic_statusBarAlpha", sizeof(NSUInteger), sizeof(NSUInteger), @encode(NSUInteger)));
        
        //
        
        objc_registerClassPair(_dynamicIsa);
        
        dynamicIsa = _dynamicIsa;
    });
    
    return dynamicIsa;
}

- (void)viewDidLoad {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
    
    __weak auto weakSelf = self;
    
    id primaryAction = reinterpret_cast<id (*)(Class, SEL, id, id, id, id)>(objc_msgSend)(objc_lookUpClass("UIAction"), sel_registerName("actionWithTitle:image:identifier:handler:"), @"Toggle", nil, nil, ^(id) {
        [weakSelf toggle];
    });
    
    id button = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("UIButton"), sel_registerName("systemButtonWithPrimaryAction:"), primaryAction);
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(button, sel_registerName("setTranslatesAutoresizingMaskIntoConstraints:"), NO);
    
    //
    
    id view = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("view"));
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(view, sel_registerName("addSubview:"), button);
    
    id view_safeAreaLayoutGuide = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(view, sel_registerName("safeAreaLayoutGuide"));
    
    id view_topAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(view_safeAreaLayoutGuide, sel_registerName("topAnchor"));
    id view_leadingAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(view_safeAreaLayoutGuide, sel_registerName("leadingAnchor"));
    id view_trailingAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(view_safeAreaLayoutGuide, sel_registerName("trailingAnchor"));
    id view_bottomAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(view_safeAreaLayoutGuide, sel_registerName("bottomAnchor"));
    
    id button_topAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(button, sel_registerName("topAnchor"));
    id button_leadingAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(button, sel_registerName("leadingAnchor"));
    id button_trailingAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(button, sel_registerName("trailingAnchor"));
    id button_bottomAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(button, sel_registerName("bottomAnchor"));
    
    id topConstraint = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)(view_topAnchor, sel_registerName("constraintEqualToAnchor:"), button_topAnchor);
    id leadingConstraint = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)(view_leadingAnchor, sel_registerName("constraintEqualToAnchor:"), button_leadingAnchor);
    id trailingConstraint = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)(view_trailingAnchor, sel_registerName("constraintEqualToAnchor:"), button_trailingAnchor);
    id bottomConstraint = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)(view_bottomAnchor, sel_registerName("constraintEqualToAnchor:"), button_bottomAnchor);
    
    reinterpret_cast<void (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("NSLayoutConstraint"), sel_registerName("activateConstraints:"), @[
        topConstraint, leadingConstraint, trailingConstraint, bottomConstraint
    ]);
}

- (void)toggle __attribute__((objc_direct)) {
    NSUInteger _mpu_puic_statusBarAlpha;
    object_getInstanceVariable(self, "_mpu_puic_statusBarAlpha", reinterpret_cast<void **>(&_mpu_puic_statusBarAlpha));
    
    _mpu_puic_statusBarAlpha ^= 1;
    object_setInstanceVariable(self, "_mpu_puic_statusBarAlpha", reinterpret_cast<void *>(_mpu_puic_statusBarAlpha));
    
    id view = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("view"));
    id window = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(view, sel_registerName("window"));
    id windowScene = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(window, sel_registerName("windowScene"));
    id statusBarManager = ((id (*)(id, SEL))objc_msgSend)(windowScene, NSSelectorFromString(@"statusBarManager"));
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(statusBarManager, NSSelectorFromString(@"_updateStatusBarAppearanceSceneSettingsWithAnimationParameters:"), nil);
}

- (NSUInteger)puic_statusBarTimeStyle {
    NSUInteger _mpu_puic_statusBarAlpha;
    object_getInstanceVariable(self, "_mpu_puic_statusBarAlpha", reinterpret_cast<void **>(&_mpu_puic_statusBarAlpha));
    return _mpu_puic_statusBarAlpha;
}

- (NSDirectionalEdgeInsets)puic_statusBarLayoutMargins {
    return NSDirectionalEdgeInsetsMake(300., 300., 300., 300.);
}

@end
