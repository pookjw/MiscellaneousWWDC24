//
//  AlwaysOnViewController.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 8/4/24.
//

#import "AlwaysOnViewController.h"
#import "EffectiveVisibilityView.h"
#import <UIKit/UIKit.h>
#import <objc/message.h>
#import <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

struct CAFrameRateRange {
  float minimum;
  float maximum;
  float preferred;
};

// https://developer.apple.com/documentation/watchos-apps/designing-your-app-for-the-always-on-state/

@implementation AlwaysOnViewController

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
        Class _isa = objc_allocateClassPair(objc_lookUpClass("SPViewController"), "_AlwaysOnViewController", 0);
        
        IMP dealloc = class_getMethodImplementation(self, @selector(dealloc));
        assert(class_addMethod(_isa, @selector(dealloc), dealloc, NULL));
        
        IMP loadView = class_getMethodImplementation(self, @selector(loadView));
        assert(class_addMethod(_isa, @selector(loadView), loadView, NULL));
        
        IMP viewDidLoad = class_getMethodImplementation(self, @selector(viewDidLoad));
        assert(class_addMethod(_isa, @selector(viewDidLoad), viewDidLoad, NULL));
        
        IMP _effectiveControllersForAlwaysOnTimelines = class_getMethodImplementation(self, @selector(_effectiveControllersForAlwaysOnTimelines));
        assert(class_addMethod(_isa, @selector(_effectiveControllersForAlwaysOnTimelines), _effectiveControllersForAlwaysOnTimelines, NULL));
        
        IMP _timelinesForDateInterval = class_getMethodImplementation(self, @selector(_timelinesForDateInterval:));
        assert(class_addMethod(_isa, @selector(_timelinesForDateInterval:), _timelinesForDateInterval, NULL));
        
        IMP didReceiveEffectiveVisibilityDidChangeNotification = class_getMethodImplementation(self, @selector(didReceiveEffectiveVisibilityDidChangeNotification:));
        assert(class_addMethod(_isa, @selector(didReceiveEffectiveVisibilityDidChangeNotification:), didReceiveEffectiveVisibilityDidChangeNotification, NULL));
        
        IMP didReceiveEnvironmentFrontmostScreenOffDidChangeNotification = class_getMethodImplementation(self, @selector(didReceiveEnvironmentFrontmostScreenOffDidChangeNotification:));
        assert(class_addMethod(_isa, @selector(didReceiveEnvironmentFrontmostScreenOffDidChangeNotification:), didReceiveEnvironmentFrontmostScreenOffDidChangeNotification, NULL));
        
        IMP puic_didEnterAlwaysOn = class_getMethodImplementation(self, @selector(puic_didEnterAlwaysOn));
        assert(class_addMethod(_isa, @selector(puic_didEnterAlwaysOn), puic_didEnterAlwaysOn, NULL));
        
        IMP puic_didExitAlwaysOn = class_getMethodImplementation(self, @selector(puic_didExitAlwaysOn));
        assert(class_addMethod(_isa, @selector(puic_didExitAlwaysOn), puic_didExitAlwaysOn, NULL));
        
        IMP puic_willEnterAlwaysOn = class_getMethodImplementation(self, @selector(puic_willEnterAlwaysOn));
        assert(class_addMethod(_isa, @selector(puic_willEnterAlwaysOn), puic_willEnterAlwaysOn, NULL));
        
        IMP puic_willExitAlwaysOn = class_getMethodImplementation(self, @selector(puic_willExitAlwaysOn));
        assert(class_addMethod(_isa, @selector(puic_willExitAlwaysOn), puic_willExitAlwaysOn, NULL));
        
        assert(class_addIvar(_isa, "_stackView", sizeof(id), sizeof(id), @encode(id)));
        assert(class_addIvar(_isa, "_updatLinkLabel", sizeof(id), sizeof(id), @encode(id)));
        assert(class_addIvar(_isa, "_effectiveVisibilityView", sizeof(id), sizeof(id), @encode(id)));
        assert(class_addIvar(_isa, "_updateLink", sizeof(id), sizeof(id), @encode(id)));
        
        //
        
        objc_registerClassPair(_isa);
        
        isa = _isa;
    });
    
    return isa;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"
- (void)dealloc {
    id _updatLinkLabel;
    object_getInstanceVariable(self, "_updatLinkLabel", reinterpret_cast<void **>(&_updatLinkLabel));
    [_updatLinkLabel release];
    
    EffectiveVisibilityView *_effectiveVisibilityView;
    object_getInstanceVariable(self, "_effectiveVisibilityView", reinterpret_cast<void **>(&_effectiveVisibilityView));
    [_effectiveVisibilityView release];
    
    id _updateLink;
    object_getInstanceVariable(self, "_updateLink", reinterpret_cast<void **>(&_updateLink));
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(_updateLink, sel_registerName("setEnabled:"), NO);
    [_updateLink release];
    
    [NSNotificationCenter.defaultCenter removeObserver:self name:@"PUICApplicationEffectiveVisibilityDidChangeNotification" object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:@"PUICApplicationEnvironmentFrontmostScreenOffDidChangeNotification" object:nil];
    
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
}
#pragma clang diagnostic pop

- (void)loadView {
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setView:"), [self stackView]);
}

- (void)viewDidLoad {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
    
    // 또는 +[PUICAlwaysOnEnvironment alwaysOnSupported]
    BOOL _alwaysOnSupported = reinterpret_cast<BOOL (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("_UIBacklightEnvironment"), sel_registerName("_alwaysOnSupported"));
    
    // PUICApplicationSupportsAlwaysOn 또는 WKSupportsAlwaysOnDisplay (둘 중 하나만 1이면 됨)
    assert(_alwaysOnSupported);
    
    //
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(didReceiveEffectiveVisibilityDidChangeNotification:)
                                               name:@"PUICApplicationEffectiveVisibilityDidChangeNotification"
                                             object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(didReceiveEnvironmentFrontmostScreenOffDidChangeNotification:)
                                               name:@"PUICApplicationEnvironmentFrontmostScreenOffDidChangeNotification"
                                             object:nil];
    
    //
    
    id view = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("view"));
    id updatLinkLabel = [self updatLinkLabel];
    
    id updateLink = reinterpret_cast<id (*)(Class, SEL, id, id)>(objc_msgSend)(objc_lookUpClass("UIUpdateLink"), sel_registerName("updateLinkForView:actionHandler:"), view, ^(id updateLink) {
        id currentUpdateInfo = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(updateLink, sel_registerName("currentUpdateInfo"));
        NSTimeInterval modelTime = reinterpret_cast<NSTimeInterval (*)(id, SEL)>(objc_msgSend)(currentUpdateInfo, sel_registerName("modelTime"));
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(updatLinkLabel, sel_registerName("setText:"), @(modelTime).stringValue);
    });
    
    CAFrameRateRange preferredFrameRateRange = reinterpret_cast<CAFrameRateRange (*)(id, SEL)>(objc_msgSend)(updateLink, sel_registerName("preferredFrameRateRange"));
    preferredFrameRateRange.maximum = 60;
    preferredFrameRateRange.minimum = 1;
    preferredFrameRateRange.preferred = 60;
    reinterpret_cast<void (*)(id, SEL, CAFrameRateRange)>(objc_msgSend)(updateLink, sel_registerName("setPreferredFrameRateRange:"), preferredFrameRateRange);
    
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(updateLink, sel_registerName("setRequiresContinuousUpdates:"), YES);
//    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(updateLink, sel_registerName("setWantsLowLatencyEventDispatch:"), YES);
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(updateLink, sel_registerName("setEnabled:"), YES);
    
    object_setInstanceVariable(self, "_updateLink", reinterpret_cast<void *>([updateLink retain]));
}

- (NSArray *)_effectiveControllersForAlwaysOnTimelines {
    return @[self];
}

- (NSArray *)_timelinesForDateInterval:(NSTimeInterval)dateInternal {
    /*
     BLSAlwaysOnTimeline
     BLSAlwaysOnFrequencyPerMinuteTimeline
     BLSAlwaysOnPeriodicTimeline
     BLSAlwaysOnExplicitEntriesTimeline
     */
    
    id timeline = reinterpret_cast<id (*)(id, SEL, NSTimeInterval, id, id, id)>(objc_msgSend)([objc_lookUpClass("BLSAlwaysOnPeriodicTimeline") alloc], sel_registerName("initWithUpdateInterval:startDate:identifier:configure:"), 1.0, [NSDate dateWithTimeIntervalSince1970:dateInternal], @"Foo", ^(id unconfiguredEntry, id entry){
        // x1 = BLSAlwaysOnTimelineUnconfiguredEntry *
        // x2 = BLSAlwaysOnTimelineEntry *
    });
    
    return @[timeline];
}

- (void)didReceiveEffectiveVisibilityDidChangeNotification:(NSNotification *)notification {
    id sharedPUICApplication = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("PUICApplication"), sel_registerName("sharedPUICApplication"));
    NSUInteger puic_effectiveVisibility = reinterpret_cast<NSUInteger (*)(id, SEL)>(objc_msgSend)(sharedPUICApplication, sel_registerName("puic_effectiveVisibility"));
    NSLog(@"%ld", puic_effectiveVisibility);
}

- (void)didReceiveEnvironmentFrontmostScreenOffDidChangeNotification:(NSNotification *)notification {
    NSLog(@"%@", notification);
}

- (void)puic_didEnterAlwaysOn {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
}

- (void)puic_didExitAlwaysOn {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
}

- (void)puic_willEnterAlwaysOn {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
}

- (void)puic_willExitAlwaysOn {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
}

- (id)stackView __attribute__((objc_direct)) {
    id stackView = nil;
    assert(object_getInstanceVariable(self, "_stackView", reinterpret_cast<void **>(&stackView)) != nullptr);
    if (stackView != nil) {
        return stackView;
    }
    
    stackView = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("UIStackView") alloc], sel_registerName("initWithArrangedSubviews:"), @[[self updatLinkLabel], [self effectiveVisibilityView]]);
    
    reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(stackView, sel_registerName("setAxis:"), 1);
    reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(stackView, sel_registerName("setAlignment:"), 0);
    reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(stackView, sel_registerName("setDistribution:"), 1);
    
    object_setInstanceVariable(self, "_stackView", reinterpret_cast<void *>([stackView retain]));
    return [stackView autorelease];
}

- (id)updatLinkLabel __attribute__((objc_direct)) {
    id updatLinkLabel = nil;
    assert(object_getInstanceVariable(self, "_updatLinkLabel", reinterpret_cast<void **>(&updatLinkLabel)));
    if (updatLinkLabel != nil) {
        return updatLinkLabel;
    }
    
    updatLinkLabel = [objc_lookUpClass("UILabel") new];
    reinterpret_cast<void (*)(id, SEL, NSTextAlignment)>(objc_msgSend)(updatLinkLabel, sel_registerName("setTextAlignment:"), NSTextAlignmentCenter);
    
    object_setInstanceVariable(self, "_updatLinkLabel", reinterpret_cast<void *>([updatLinkLabel retain]));
    return [updatLinkLabel autorelease];
}

- (EffectiveVisibilityView *)effectiveVisibilityView __attribute__((objc_direct)) {
    EffectiveVisibilityView *effectiveVisibilityView = nil;
    assert(object_getInstanceVariable(self, "_effectiveVisibilityView", reinterpret_cast<void **>(&effectiveVisibilityView)));
    if (effectiveVisibilityView != nil) {
        return effectiveVisibilityView;
    }
    
    effectiveVisibilityView = [EffectiveVisibilityView new];
    
    object_setInstanceVariable(self, "_effectiveVisibilityView", reinterpret_cast<void *>([effectiveVisibilityView retain]));
    return [effectiveVisibilityView autorelease];
    
}

@end
