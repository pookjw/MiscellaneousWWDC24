//
//  UIScrollView+VolumeControl.mm
//  VoluemKeyPad
//
//  Created by Jinwoo Kim on 7/6/24.
//

#import "UIScrollView+VolumeControl.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface _VCPhysicalButtonInteractionHelper : NSObject
@property (weak, readonly, nonatomic) UIScrollView *scrollView;
@property (retain, nonatomic) id<UIInteraction> physicalButtonInteraction;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@end

@implementation _VCPhysicalButtonInteractionHelper

+ (void)load {
    class_addProtocol(self, NSProtocolFromString(@"_UIPhysicalButtonInteractionDelegate"));
}

- (instancetype)initWithScrollView:(UIScrollView *)scrollView {
    if (self = [super init]) {
        _scrollView = scrollView;
        
//        NSSet *configurations = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("_UIPhysicalButtonConfiguration"), sel_registerName("_volumeConfigurations"));
//        NSSet *configurations = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("AVCaptureEventInteraction"), sel_registerName("_captureButtonsConfigurationSet"));
//        id configurations = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("_UIPhysicalButtonConfiguration"), sel_registerName("_ringerButtonDynamicActionConfiguration"));
        NSSet *configurations = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("_UIPhysicalButtonConfiguration"), sel_registerName("_cameraShutterConfigurations"));
        
        id<UIInteraction> physicalButtonInteraction = reinterpret_cast<id (*)(id, SEL, id, id)>(objc_msgSend)([objc_lookUpClass("_UIPhysicalButtonInteraction") alloc], sel_registerName("initWithConfigurations:delegate:"), configurations, self);
        
        reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(physicalButtonInteraction, sel_registerName("_setEnabled:"), YES);
        [scrollView addInteraction:physicalButtonInteraction];
        
        self.physicalButtonInteraction = physicalButtonInteraction;
        [physicalButtonInteraction release];
    }
    
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)vc_finalize {
    id<UIInteraction> physicalButtonInteraction = self.physicalButtonInteraction;
    
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(physicalButtonInteraction, sel_registerName("_setEnabled:"), NO);
    [self.scrollView removeInteraction:physicalButtonInteraction];
}

- (void)_physicalButtonInteraction:(id)arg1 handleAction:(id)arg2 withActiveActions:(id)arg3 {
    NSLog(@"%@", arg2);
}

@end

@interface UIScrollView (VolumeControl_Private)
@property (class, readonly, nonatomic) void *_vc_helperAssociationKey;
@end

@implementation UIScrollView (VolumeControl_Private)

+ (void *)_vc_helperAssociationKey {
    static void *key = &key;
    return key;
}

- (void)_vc_enableVerticalScrollWithVolumeButtons {
    _VCPhysicalButtonInteractionHelper *helper = [[_VCPhysicalButtonInteractionHelper alloc] initWithScrollView:self];
    objc_setAssociatedObject(self, [UIScrollView _vc_helperAssociationKey], helper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [helper release];
}

- (void)_vc_disableVerticalScrollWithVolumeButtons {
    _VCPhysicalButtonInteractionHelper *helper = objc_getAssociatedObject(self, [UIScrollView _vc_helperAssociationKey]);
    [helper vc_finalize];
    objc_setAssociatedObject(self, [UIScrollView _vc_helperAssociationKey], nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UIScrollView (VolumeControl)

- (void)vc_setVerticalScrollWithVolumeButtonsEnabled:(BOOL)verticalScrollWithVolumeButtonsEnabled {
    BOOL isEnabled = objc_getAssociatedObject(self, [UIScrollView _vc_helperAssociationKey]) != NULL;
    
    if (verticalScrollWithVolumeButtonsEnabled) {
        if (!isEnabled) {
            [self _vc_enableVerticalScrollWithVolumeButtons];
        }
    } else {
        if (isEnabled) {
            [self _vc_disableVerticalScrollWithVolumeButtons];
        }
    }
}

- (BOOL)vc_isVerticalScrollWithVolumeButtonsEnabled {
    return objc_getAssociatedObject(self, [UIScrollView _vc_helperAssociationKey]) != NULL;
}

@end
