//
//  EffectiveVisibilityView.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 8/4/24.
//

#import "EffectiveVisibilityView.h"
#import <UIKit/UIKit.h>
#import <objc/message.h>
#import <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

@implementation EffectiveVisibilityView

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
        Class _dynamicIsa = objc_allocateClassPair(objc_lookUpClass("UIView"), "_EffectiveVisibilityView", 0);
        
        IMP initWithFrame = class_getMethodImplementation(self, @selector(initWithFrame:));
        assert(class_addMethod(_dynamicIsa, @selector(initWithFrame:), initWithFrame, NULL));
        
        IMP dealloc = class_getMethodImplementation(self, @selector(dealloc));
        assert(class_addMethod(_dynamicIsa, @selector(dealloc), dealloc, NULL));
        
        IMP description = class_getMethodImplementation(self, @selector(description));
        assert(class_addMethod(_dynamicIsa, @selector(description), description, NULL));
        
        IMP alwaysOnUpdateFidelityDidChange = class_getMethodImplementation(self, @selector(alwaysOnUpdateFidelityDidChange:));
        assert(class_addMethod(_dynamicIsa, @selector(alwaysOnUpdateFidelityDidChange:), alwaysOnUpdateFidelityDidChange, NULL));
        
        assert(class_addIvar(_dynamicIsa, "_label", sizeof(id), sizeof(id), @encode(id)));
        assert(class_addIvar(_dynamicIsa, "_observer", sizeof(id), sizeof(id), @encode(id)));
        
        //
        
        dynamicIsa = _dynamicIsa;
    });
    
    return dynamicIsa;
}

- (instancetype)initWithFrame:(CGRect)frame {
    objc_super superInfo = { self, [self class] };
    self = reinterpret_cast<id (*)(objc_super *, SEL, CGRect)>(objc_msgSendSuper2)(&superInfo, _cmd, frame);
    
    if (self) {
        id label = [objc_lookUpClass("PUICHyphenatedLabel") new];
        
        reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(label, sel_registerName("setNumberOfLines:"), 0);
        reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(label, sel_registerName("setTextAlignment:"), 1);
        reinterpret_cast<void (*)(id, SEL, CGFloat)>(objc_msgSend)(label, sel_registerName("setMinimumScaleFactor:"), 0.1);
        reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(label, sel_registerName("setTranslatesAutoresizingMaskIntoConstraints:"), NO);
        
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("addSubview:"), label);
        
        id self_layoutMarginsGuide = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("layoutMarginsGuide"));
        
        id label_centerYAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(label, sel_registerName("centerYAnchor"));
        id self_centerYAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self_layoutMarginsGuide, sel_registerName("centerYAnchor"));
        
        id label_leadingAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(label, sel_registerName("leadingAnchor"));
        id self_leadingAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self_layoutMarginsGuide, sel_registerName("leadingAnchor"));
        
        id label_trailingAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(label, sel_registerName("trailingAnchor"));
        id self_trailingAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self_layoutMarginsGuide, sel_registerName("trailingAnchor"));
        
        id centerYConstraint = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)(label_centerYAnchor, sel_registerName("constraintEqualToAnchor:"), self_centerYAnchor);
        id leadingConstraint = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)(label_leadingAnchor, sel_registerName("constraintEqualToAnchor:"), self_leadingAnchor);
        id trailingConstraint = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)(label_trailingAnchor, sel_registerName("constraintEqualToAnchor:"), self_trailingAnchor);
        
        reinterpret_cast<void (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("NSLayoutConstraint"), sel_registerName("activateConstraints:"), @[
            centerYConstraint, leadingConstraint, trailingConstraint
        ]);
        
        object_setInstanceVariable(self, "_label", [label retain]);
        [label release];
        
        //
        
        id observer = reinterpret_cast<id (*)(id, SEL, id, id, SEL)>(objc_msgSend)(self, sel_registerName("registerForTraitChanges:withTarget:action:"), @[objc_lookUpClass("UITraitAlwaysOnUpdateFidelity")], self, @selector(alwaysOnUpdateFidelityDidChange:));
        object_setInstanceVariable(self, "_observer", [observer retain]);
        [observer release];
        
        [self update];
    }
    
    return self;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"
- (void)dealloc {
    id _label;
    object_getInstanceVariable(self, "_label", reinterpret_cast<void **>(&_label));
    [_label release];
    
    id _observer;
    object_getInstanceVariable(self, "_observer", reinterpret_cast<void **>(&_observer));
    [_observer release];
    
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
}
#pragma clang diagnostic pop

- (NSString *)description {
    return [NSString stringWithFormat:@"<%s: %p>", class_getName(self.class), self];
}

- (void)alwaysOnUpdateFidelityDidChange:(id)sender {
    [self update];
}

- (void)update __attribute__((objc_direct)) {
    id traitCollection = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("traitCollection"));
    
    NSInteger alwaysOnUpdateFidelity = reinterpret_cast<NSInteger (*)(id, SEL, Class)>(objc_msgSend)(traitCollection, sel_registerName("valueForNSIntegerTrait:"), objc_lookUpClass("UITraitAlwaysOnUpdateFidelity"));
    
    id _label;
    object_getInstanceVariable(self, "_label", reinterpret_cast<void **>(&_label));
    
    NSString *text;
    if (alwaysOnUpdateFidelity == 3) {
        text = @"On!";
    } else {
        text = @"Off!";
    }
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(_label, sel_registerName("setText:"), text);
}

@end
