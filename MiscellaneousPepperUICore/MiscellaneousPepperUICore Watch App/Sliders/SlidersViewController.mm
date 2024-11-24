//
//  SlidersViewController.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 8/3/24.
//

#import "SlidersViewController.h"
#import <UIKit/UIKit.h>
#import <objc/message.h>
#import <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

@implementation SlidersViewController

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
        Class _isa = objc_allocateClassPair(objc_lookUpClass("SPViewController"), "_SlidersViewController", 0);
        
        IMP dealloc = class_getMethodImplementation(self, @selector(dealloc));
        assert(class_addMethod(_isa, @selector(dealloc), dealloc, NULL));
        
        IMP loadView = class_getMethodImplementation(self, @selector(loadView));
        assert(class_addMethod(_isa, @selector(loadView), loadView, NULL));
        
        IMP respondsToSelector = class_getMethodImplementation(self, @selector(respondsToSelector:));
        assert(class_addMethod(_isa, @selector(respondsToSelector:), respondsToSelector, NULL));
        
        IMP viewDidLoad = class_getMethodImplementation(self, @selector(viewDidLoad));
        assert(class_addMethod(_isa, @selector(viewDidLoad), viewDidLoad, NULL));
        
        IMP uiSliderValueChanged = class_getMethodImplementation(self, @selector(uiSliderValueChanged:));
        assert(class_addMethod(_isa, @selector(uiSliderValueChanged:), uiSliderValueChanged, NULL));
        
        IMP puicSliderValueChanged = class_getMethodImplementation(self, @selector(puicSliderValueChanged:));
        assert(class_addMethod(_isa, @selector(puicSliderValueChanged:), puicSliderValueChanged, NULL));
        
        IMP sliderDidBeginCrownInteraction = class_getMethodImplementation(self, @selector(sliderDidBeginCrownInteraction:));
        assert(class_addMethod(_isa, @selector(sliderDidBeginCrownInteraction:), sliderDidBeginCrownInteraction, NULL));
        
        IMP slider_didTapTouchTarget = class_getMethodImplementation(self, @selector(slider:didTapTouchTarget:));
        assert(class_addMethod(_isa, @selector(slider:didTapTouchTarget:), slider_didTapTouchTarget, NULL));
        
        IMP sliderDidEndCrownInteraction = class_getMethodImplementation(self, @selector(sliderDidEndCrownInteraction:));
        assert(class_addMethod(_isa, @selector(sliderDidEndCrownInteraction:), sliderDidEndCrownInteraction, NULL));
        
        IMP sliderDidRequestFocus = class_getMethodImplementation(self, @selector(sliderDidRequestFocus:));
        assert(class_addMethod(_isa, @selector(sliderDidRequestFocus:), sliderDidRequestFocus, NULL));
        
        //
        
        assert(class_addProtocol(_isa, NSProtocolFromString(@"PUICSliderDelegate")));
        
        assert(class_addIvar(_isa, "_uiSlider", sizeof(id), sizeof(id), @encode(id)));
        assert(class_addIvar(_isa, "_puicSlider", sizeof(id), sizeof(id), @encode(id)));
        
        //
        
        objc_registerClassPair(_isa);
        
        isa = _isa;
    });
    
    return isa;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"
- (void)dealloc {
    id _uiSlider;
    object_getInstanceVariable(self, "_uiSlider", reinterpret_cast<void **>(&_uiSlider));
    [_uiSlider release];
    
    id _puicSlider;
    object_getInstanceVariable(self, "_puicSlider", reinterpret_cast<void **>(&_puicSlider));
    [_puicSlider release];
    
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
}
#pragma clang diagnostic pop

- (BOOL)respondsToSelector:(SEL)aSelector {
    objc_super superInfo = { self, [self class] };
    BOOL responds = reinterpret_cast<BOOL (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
    
    if (!responds) {
        NSLog(@"%s", sel_getName(aSelector));
    }
    
    return responds;
}

- (void)loadView {
    id uiSlider = [objc_lookUpClass("UISlider") new];
    
    reinterpret_cast<void (*)(id, SEL, float)>(objc_msgSend)(uiSlider, sel_registerName("setMinimumValue:"), 0.f);
    reinterpret_cast<void (*)(id, SEL, float)>(objc_msgSend)(uiSlider, sel_registerName("setMaximumValue:"), 1.f);
    reinterpret_cast<void (*)(id, SEL, float, BOOL)>(objc_msgSend)(uiSlider, sel_registerName("setValue:animated:"), 0.5f, NO);
    reinterpret_cast<void (*)(id, SEL, id, SEL, NSUInteger)>(objc_msgSend)(uiSlider, sel_registerName("addTarget:action:forControlEvents:"), self, @selector(uiSliderValueChanged:), 1 << 12);
    
    //
    
    // sliderStyle
    //  - 0 : Default
    //  - 1 : Step
    //  - 2 : Circular
    id puicSlider = reinterpret_cast<id (*)(id, SEL, NSInteger)>(objc_msgSend)([objc_lookUpClass("PUICSlider") alloc], sel_registerName("initWithSliderStyle:"), 1);
    
    reinterpret_cast<void (*)(id, SEL, float)>(objc_msgSend)(puicSlider, sel_registerName("setMinimumValue:"), 0.f);
    reinterpret_cast<void (*)(id, SEL, float)>(objc_msgSend)(puicSlider, sel_registerName("setMaximumValue:"), 1.f);
    reinterpret_cast<void (*)(id, SEL, id, SEL, NSUInteger)>(objc_msgSend)(puicSlider, sel_registerName("addTarget:action:forControlEvents:"), self, @selector(puicSliderValueChanged:), 1 << 12);
    reinterpret_cast<void (*)(id, SEL, float, BOOL)>(objc_msgSend)(puicSlider, sel_registerName("setValue:animated:"), 0.5f, NO);
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(puicSlider, sel_registerName("setDelegate:"), self);
    
    UIImage *minusImage = [UIImage systemImageNamed:@"minus"];
    id minimumValueView = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("UIImageView") alloc], sel_registerName("initWithImage:"), minusImage);
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(puicSlider, sel_registerName("setMinimumValueView:"), minimumValueView);
    [minimumValueView release];
    
    UIImage *plusImage = [UIImage systemImageNamed:@"plus"];
    id maximumValueView = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("UIImageView") alloc], sel_registerName("initWithImage:"), plusImage);
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(puicSlider, sel_registerName("setMaximumValueView:"), maximumValueView);
    [maximumValueView release];
    
    // 안 되는듯
    UIImage *balloonImage = [UIImage systemImageNamed:@"balloon.fill"];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(puicSlider, sel_registerName("setCompactAccessoryImage:"), balloonImage);
    
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(puicSlider, sel_registerName("setHapticFeedbackEnabled:"), YES);
    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(puicSlider, sel_registerName("setNumberOfSteps:"), 4);
    
    // 터치로 값 조정할지 말지
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(puicSlider, sel_registerName("setShouldAutomaticallAdjustValueOnTouch:"), NO);
    
    //
    
    id stackView = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("UIStackView") alloc], sel_registerName("initWithArrangedSubviews:"), @[uiSlider, puicSlider]);
    
    reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(stackView, sel_registerName("setAxis:"), 1);
    reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(stackView, sel_registerName("setDistribution:"), 1);
    reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(stackView, sel_registerName("setAlignment:"), 0);
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setView:"), stackView);
    [stackView release];
    
    object_setInstanceVariable(self, "_uiSlider", [uiSlider retain]);
    [uiSlider release];
    object_setInstanceVariable(self, "_puicSlider", [puicSlider retain]);
    [puicSlider release];
}

- (void)viewDidLoad {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
    
    //
    
    
}

- (void)uiSliderValueChanged:(id)sender {
    float value = reinterpret_cast<float (*)(id, SEL)>(objc_msgSend)(sender, sel_registerName("value"));
    
    id _puicSlider;
    object_getInstanceVariable(self, "_puicSlider", reinterpret_cast<void **>(&_puicSlider));
    
    reinterpret_cast<void (*)(id, SEL, float, BOOL)>(objc_msgSend)(_puicSlider, sel_registerName("setValue:animated:"), value, YES);
}

- (void)puicSliderValueChanged:(id)sender {
    float value = reinterpret_cast<float (*)(id, SEL)>(objc_msgSend)(sender, sel_registerName("value"));
    
    id _uiSlider;
    object_getInstanceVariable(self, "_uiSlider", reinterpret_cast<void **>(&_uiSlider));
    
    reinterpret_cast<void (*)(id, SEL, float, BOOL)>(objc_msgSend)(_uiSlider, sel_registerName("setValue:animated:"), value, YES);
}

- (void)sliderDidBeginCrownInteraction:(id)slider {
    
}

- (void)slider:(id)slider didTapTouchTarget:(NSInteger)touchTarget {
    NSLog(@"%ld", touchTarget);
    
    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(slider, sel_registerName("becomeFirstResponder"));
}

- (void)sliderDidEndCrownInteraction:(id)slider {
    
}

- (void)sliderDidRequestFocus:(id)slider {
    
}

@end
