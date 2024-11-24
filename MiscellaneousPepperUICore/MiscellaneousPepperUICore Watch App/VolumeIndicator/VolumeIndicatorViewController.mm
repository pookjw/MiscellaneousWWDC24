//
//  VolumeIndicatorViewController.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 8/5/24.
//

#import "VolumeIndicatorViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>
#include <dlfcn.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

@implementation VolumeIndicatorViewController

+ (void)load {
    assert(dlopen("/System/Library/PrivateFrameworks/NanoMediaUI.framework/NanoMediaUI", RTLD_NOW) != NULL);
    assert(dlopen("/System/Library/PrivateFrameworks/NanoAudioControl.framework/NanoAudioControl", RTLD_NOW) != NULL);
    [self class];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [[self class] allocWithZone:zone];
}

+ (Class)class {
    static Class isa;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class _isa = objc_allocateClassPair(objc_lookUpClass("SPViewController"), "_VolumeIndicatorViewController", 0);
        
        IMP respondsToSelector = class_getMethodImplementation(self, @selector(respondsToSelector:));
        assert(class_addMethod(_isa, @selector(respondsToSelector:), respondsToSelector, NULL));
        
        IMP viewDidLoad = class_getMethodImplementation(self, @selector(viewDidLoad));
        assert(class_addMethod(_isa, @selector(viewDidLoad), viewDidLoad, NULL));
        
        IMP volumeIndicatorDidAdjustVolume = class_getMethodImplementation(self, @selector(volumeIndicatorDidAdjustVolume:));
        assert(class_addMethod(_isa, @selector(volumeIndicatorDidAdjustVolume:), volumeIndicatorDidAdjustVolume, NULL));
        
        IMP volumeIndicatorDidBeginAdjustingVolume = class_getMethodImplementation(self, @selector(volumeIndicatorDidBeginAdjustingVolume:));
        assert(class_addMethod(_isa, @selector(volumeIndicatorDidBeginAdjustingVolume:), volumeIndicatorDidBeginAdjustingVolume, NULL));
        
        IMP volumeIndicatorDidEndAdjustingVolume = class_getMethodImplementation(self, @selector(volumeIndicatorDidEndAdjustingVolume:));
        assert(class_addMethod(_isa, @selector(volumeIndicatorDidEndAdjustingVolume:), volumeIndicatorDidEndAdjustingVolume, NULL));
        
        IMP volumeIndicatorWasTapped = class_getMethodImplementation(self, @selector(volumeIndicatorWasTapped:));
        assert(class_addMethod(_isa, @selector(volumeIndicatorWasTapped:), volumeIndicatorWasTapped, NULL));
        
        assert(class_addProtocol(_isa, NSProtocolFromString(@"NMUVolumeIndicatorControlDelegate")));
        assert(class_addProtocol(_isa, NSProtocolFromString(@"NACVolumeControllerDelegate")));
        
        //
        
        objc_registerClassPair(_isa);
        
        isa = _isa;
    });
    
    return isa;
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
    
    id view = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("view"));
    
    id volumeIndicatorControl = [objc_lookUpClass("NMUVolumeIndicatorControl") new];
    
    id volumeController = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("NACVolumeControllerLocal") alloc], sel_registerName("initWithAudioCategory:"), @"Audio/Video");
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(volumeController, sel_registerName("setDelegate:"), self);
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(volumeIndicatorControl, sel_registerName("setVolumeController:"), volumeController);
    [volumeController release];
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(volumeIndicatorControl, sel_registerName("setDelegate:"), self);
    reinterpret_cast<void (*)(id, SEL, float)>(objc_msgSend)(volumeIndicatorControl, sel_registerName("setMaximumVolume:"), 0.7f);
    
    // Not working?
    reinterpret_cast<void (*)(id, SEL, float)>(objc_msgSend)(volumeIndicatorControl, sel_registerName("setEUVolumeLimit:"), 0.7f);
    
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(volumeIndicatorControl, sel_registerName("setTranslatesAutoresizingMaskIntoConstraints:"), NO);
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(view, sel_registerName("addSubview:"), volumeIndicatorControl);
    
    id view_layoutMarginsGuide = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(view, sel_registerName("layoutMarginsGuide"));
    
    id volumeIndicatorControl_centerYAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(volumeIndicatorControl, sel_registerName("centerYAnchor"));
    id view_centerYAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(view_layoutMarginsGuide, sel_registerName("centerYAnchor"));
    
    id volumeIndicatorControl_centerXAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(volumeIndicatorControl, sel_registerName("centerXAnchor"));
    id view_centerXAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(view_layoutMarginsGuide, sel_registerName("centerXAnchor"));
    
    id centerYConstraint = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)(volumeIndicatorControl_centerYAnchor, sel_registerName("constraintEqualToAnchor:"), view_centerYAnchor);
    
    id centerXConstraint = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)(volumeIndicatorControl_centerXAnchor, sel_registerName("constraintEqualToAnchor:"), view_centerXAnchor);
    
    reinterpret_cast<void (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("NSLayoutConstraint"), sel_registerName("activateConstraints:"), @[
        centerYConstraint, centerXConstraint
    ]);
    
    reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(volumeIndicatorControl, sel_registerName("becomeFirstResponder"));
    [volumeIndicatorControl release];
}

- (void)volumeIndicatorDidAdjustVolume:(id)volumeIndicator {
    float volume = reinterpret_cast<float (*)(id, SEL)>(objc_msgSend)(volumeIndicator, sel_registerName("volume"));
    NSLog(@"%lf", volume);
}

- (void)volumeIndicatorDidBeginAdjustingVolume:(id)volumeIndicator {
    
}

- (void)volumeIndicatorDidEndAdjustingVolume:(id)volumeIndicator {
    
}

- (void)volumeIndicatorWasTapped:(id)volumeIndicator {
    
}

@end
