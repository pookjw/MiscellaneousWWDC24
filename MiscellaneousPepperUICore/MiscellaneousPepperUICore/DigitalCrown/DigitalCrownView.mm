//
//  DigitalCrownView.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 8/1/24.
//

#import "DigitalCrownView.h"
#import <objc/message.h>
#import <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

namespace _PUICCrownIndicatorWindow {
namespace isInternalWindow {
BOOL (*original)(id, SEL);
BOOL custom(id self, SEL _cmd) {
    return NO;
}
void swizzle() {
    Method method = class_getInstanceMethod(objc_lookUpClass("PUICCrownIndicatorWindow"), sel_registerName("isInternalWindow"));
    original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}
}
}

//

@implementation DigitalCrownView

+ (void)load {
    _PUICCrownIndicatorWindow::isInternalWindow::swizzle();
    [self dynamicIsa];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [[self dynamicIsa] allocWithZone:zone];
}

+ (Class)dynamicIsa {
    static Class dynamicIsa;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class _dynamicIsa = objc_allocateClassPair(objc_lookUpClass("UIView"), "_DigitalCrownView", 0);
        
        IMP initWithFrame= class_getMethodImplementation(self, @selector(initWithFrame:));
        assert(class_addMethod(_dynamicIsa, @selector(initWithFrame:), initWithFrame, NULL));
        
        IMP dealloc = class_getMethodImplementation(self, @selector(dealloc));
        assert(class_addMethod(_dynamicIsa, @selector(dealloc), dealloc, NULL));
        
        IMP description = class_getMethodImplementation(self, @selector(description));
        assert(class_addMethod(_dynamicIsa, @selector(description), description, NULL));
        
        IMP respondsToSelector = class_getMethodImplementation(self, @selector(respondsToSelector:));
        assert(class_addMethod(_dynamicIsa, @selector(respondsToSelector:), respondsToSelector, NULL));
        
        IMP canBecomeFirstResponder = class_getMethodImplementation(self, @selector(canBecomeFirstResponder));
        assert(class_addMethod(_dynamicIsa, @selector(canBecomeFirstResponder), canBecomeFirstResponder, NULL));
        
        IMP _wheelChangedWithEvent = class_getMethodImplementation(self, @selector(_wheelChangedWithEvent:));
        assert(class_addMethod(_dynamicIsa, @selector(_wheelChangedWithEvent:), _wheelChangedWithEvent, NULL));
        
        IMP crownInputSequencerOffsetDidChange = class_getMethodImplementation(self, @selector(crownInputSequencerOffsetDidChange:));
        assert(class_addMethod(_dynamicIsa, @selector(crownInputSequencerOffsetDidChange:), crownInputSequencerOffsetDidChange, NULL));
        
        IMP isFirstResponderForSequencer = class_getMethodImplementation(self, @selector(isFirstResponderForSequencer:));
        assert(class_addMethod(_dynamicIsa, @selector(isFirstResponderForSequencer:), isFirstResponderForSequencer, NULL));
        
        IMP crownInputSequencer_shouldRubberBandAtBoundary = class_getMethodImplementation(self, @selector(crownInputSequencer:shouldRubberBandAtBoundary:));
        assert(class_addMethod(_dynamicIsa, @selector(crownInputSequencer:shouldRubberBandAtBoundary:), crownInputSequencer_shouldRubberBandAtBoundary, NULL));
        
        IMP crownInputSequencerWillBecomeIdle_withCrownVelocity_targetOffset = class_getMethodImplementation(self, @selector(crownInputSequencerWillBecomeIdle:withCrownVelocity:targetOffset:));
        assert(class_addMethod(_dynamicIsa, @selector(crownInputSequencerWillBecomeIdle:withCrownVelocity:targetOffset:), crownInputSequencerWillBecomeIdle_withCrownVelocity_targetOffset, NULL));
        
        assert(class_addIvar(_dynamicIsa, "_crownInputSequencer", sizeof(id), sizeof(id), @encode(id)));
        assert(class_addIvar(_dynamicIsa, "_label", sizeof(id), sizeof(id), @encode(id)));
        
        assert(class_addProtocol(_dynamicIsa, NSProtocolFromString(@"PUICCrownInputSequencerDelegate")));
//        assert(class_addProtocol(_dynamicIsa, NSProtocolFromString(@"PUICCrownInputSequencerDetentsDataSource")));
        assert(class_addProtocol(_dynamicIsa, NSProtocolFromString(@"PUICCrownInputSequencerDataSource")));
//        assert(class_addProtocol(_dynamicIsa, NSProtocolFromString(@"PUICCrownInputSequencerMetricsDelegate")));
        
        dynamicIsa = _dynamicIsa;
    });
    
    return dynamicIsa;
}

- (instancetype)initWithFrame:(CGRect)frame {
    objc_super superInfo = { self, [self class] };
    self = reinterpret_cast<id (*)(objc_super *, SEL, CGRect)>(objc_msgSendSuper2)(&superInfo, _cmd, frame);
    
    if (self) {
        id crownInputSequencer = [objc_lookUpClass("PUICCrownInputSequencer") new];
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(crownInputSequencer, sel_registerName("setView:"), self);
        
        // Start~End 범위를 초과할 때 초기화 할지 말지
        reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(crownInputSequencer, sel_registerName("setContinuous:"), YES);
        
        // 이렇게 해야 Haptic 재생이 됨
        reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(crownInputSequencer, sel_registerName("setMinorDetentsEnabled:"), YES);
        reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(crownInputSequencer, sel_registerName("setRubberBandingEnabled:"), YES);
        reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(crownInputSequencer, sel_registerName("setRubberBandHapticsLocation:"), 3);
        
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(crownInputSequencer, sel_registerName("setDelegate:"), self);
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(crownInputSequencer, sel_registerName("setDataSource:"), self);
//        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(crownInputSequencer, sel_registerName("setMetricsDelegate:"), self);
        
        // detent API는 deprecated 인듯 작동 안함. -crownInputSequencerWillBecomeIdle:withCrownVelocity:targetOffset:에서 구현해야함
        // -[PUICCrownInputSequencer setActiveDetentChangeHapticEnabled:]에서 아무것도 안하는 것을 보아 더 이상 안 쓰이는 것으로 추정
//        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(crownInputSequencer, sel_registerName("setDetentsDataSource:"), self);
//        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(crownInputSequencer, sel_registerName("setStaticDetents:"), @[
//            reinterpret_cast<id (*)(Class, SEL, CGFloat)>(objc_msgSend)(objc_lookUpClass("PUICCrownInputSequencerDetent"), sel_registerName("detentWithOffset:"), 1.0)
//        ]);
        
        reinterpret_cast<void (*)(id, SEL, double)>(objc_msgSend)(crownInputSequencer, sel_registerName("setStart:"), 0.0);
        reinterpret_cast<void (*)(id, SEL, double)>(objc_msgSend)(crownInputSequencer, sel_registerName("setEnd:"), 10.0);
        
        /*
         0 : Automatic (1)
         1 : Always Visible
         2 : Hide When Idle
         */
        reinterpret_cast<void (*)(id, SEL, long)>(objc_msgSend)(crownInputSequencer, sel_registerName("setCrownIndicatorMode:"), 2);
        reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(crownInputSequencer, sel_registerName("setCrownIndicatorVisible:"), YES);
        
//        reinterpret_cast<void (*)(id, SEL, CGFloat)>(objc_msgSend)(crownInputSequencer, sel_registerName("setDecelerationRate:"), 0.5);
        
        reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(crownInputSequencer, sel_registerName("setMinorDetentsEnabled:"), NO);
//        reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(crownInputSequencer, sel_registerName("setWantsCrownIndicatorStyledForTouchInput:"), YES);
//        reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(crownInputSequencer, sel_registerName("setSmoothingEnabled:"), YES);
        
        // 안 되나?
        id accLabel = [objc_lookUpClass("UILabel") new];
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(accLabel, sel_registerName("setText:"), @"Acc");
        reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(accLabel, sel_registerName("sizeToFit"));
        id crownIndicatorContext = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(crownInputSequencer, sel_registerName("crownIndicatorContext"));
        reinterpret_cast<void (*)(id, SEL, id, CGFloat, BOOL, BOOL)>(objc_msgSend)(crownIndicatorContext, sel_registerName("setAccessoryView:withPadding:autoHide:animated:"), accLabel, 8.0, YES, YES);
        [accLabel release];
        
        //
        
        object_setInstanceVariable(self, "_crownInputSequencer", [crownInputSequencer retain]);
        [crownInputSequencer release];
        
        //
        
        id label = [objc_lookUpClass("UILabel") new];
        reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(label, sel_registerName("setNumberOfLines:"), 0);
        reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(label, sel_registerName("setTextAlignment:"), 1);
        reinterpret_cast<void (*)(id, SEL, CGFloat)>(objc_msgSend)(label, sel_registerName("setMinimumScaleFactor:"), 0.1);
        reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(label, sel_registerName("setTranslatesAutoresizingMaskIntoConstraints:"), NO);
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("addSubview:"), label);
        
        id view_layoutMarginsGuide = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("layoutMarginsGuide"));
        
        id label_centerYAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(label, sel_registerName("centerYAnchor"));
        id view_centerYAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(view_layoutMarginsGuide, sel_registerName("centerYAnchor"));
        
        id label_leadingAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(label, sel_registerName("leadingAnchor"));
        id view_leadingAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(view_layoutMarginsGuide, sel_registerName("leadingAnchor"));
        
        id label_trailingAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(label, sel_registerName("trailingAnchor"));
        id view_trailingAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(view_layoutMarginsGuide, sel_registerName("trailingAnchor"));
        
        id centerYConstraint = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)(label_centerYAnchor, sel_registerName("constraintEqualToAnchor:"), view_centerYAnchor);
        id leadingConstraint = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)(label_leadingAnchor, sel_registerName("constraintEqualToAnchor:"), view_leadingAnchor);
        id trailingConstraint = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)(label_trailingAnchor, sel_registerName("constraintEqualToAnchor:"), view_trailingAnchor);
        
        reinterpret_cast<void (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("NSLayoutConstraint"), sel_registerName("activateConstraints:"), @[
            centerYConstraint, leadingConstraint, trailingConstraint
        ]);
        
        object_setInstanceVariable(self, "_label", [label retain]);
        [label release];
        
        //
        
        [self updateLabelWithCrownInputSequencer:crownInputSequencer];
    }
    
    return self;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"
- (void)dealloc {
    id _crownInputSequencer;
    object_getInstanceVariable(self, "_crownInputSequencer", reinterpret_cast<void **>(&_crownInputSequencer));
    [_crownInputSequencer release];
    
    id _label;
    object_getInstanceVariable(self, "_label", reinterpret_cast<void **>(&_label));
    [_label release];
    
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

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)_wheelChangedWithEvent:(id)event {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL, id)>(objc_msgSendSuper2)(&superInfo, _cmd, event);
    
    id _crownInputSequencer;
    object_getInstanceVariable(self, "_crownInputSequencer", reinterpret_cast<void **>(&_crownInputSequencer));
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(_crownInputSequencer, sel_registerName("updateWithCrownInputEvent:"), event);
}

- (void)updateLabelWithCrownInputSequencer:(id)crownInputSequencer __attribute__((objc_direct)) {
    CGFloat offset = reinterpret_cast<CGFloat (*)(id, SEL)>(objc_msgSend)(crownInputSequencer, sel_registerName("offset"));
    
    // -vecloty는 -averageCrownVelocity만 호출하므로 같은 값임
    CGFloat averageCrownVelocity = reinterpret_cast<CGFloat (*)(id, SEL)>(objc_msgSend)(crownInputSequencer, sel_registerName("averageCrownVelocity"));
    
    NSString *text = [NSString stringWithFormat:@"Offset: %lf\nVelocity: %lf", offset, averageCrownVelocity];
    
    id _label;
    object_getInstanceVariable(self, "_label", reinterpret_cast<void **>(&_label));
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(_label, sel_registerName("setText:"), text);
}

- (void)crownInputSequencerOffsetDidChange:(id)crownInputSequencer {
    [self updateLabelWithCrownInputSequencer:crownInputSequencer];
}

- (_Bool)isFirstResponderForSequencer:(id)arg1 {
    return YES;
}

- (void)crownInputSequencerWillBecomeIdle:(id)arg1 withCrownVelocity:(CGFloat)arg2 targetOffset:(CGFloat *)arg3 {
    CGFloat offset = reinterpret_cast<CGFloat (*)(id, SEL)>(objc_msgSend)(arg1, sel_registerName("offset"));
    
    // arg2은 nan이 나옴
    CGFloat velocity = reinterpret_cast<CGFloat (*)(id, SEL)>(objc_msgSend)(arg1, sel_registerName("velocity"));
    
    if (velocity > 0) {
        *arg3 = ceil(offset);
    } else {
        *arg3 = floor(offset);
    }
}

- (BOOL)crownInputSequencer:(id)arg1 shouldRubberBandAtBoundary:(long)arg2 {
    return YES;
}

@end
