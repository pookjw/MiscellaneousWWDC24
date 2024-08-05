//
//  VideoPlayerViewController.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 8/5/24.
//

#import "VideoPlayerViewController.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>
#import <objc/message.h>
#import <objc/runtime.h>
#import <CoreMedia/CoreMedia.h>
#import "MyAVSlider.h"
#import "NSObject+KeyValueObservation.h"

namespace mpu_AVPlayerViewController {
namespace _showOrHidePlaybackControlsView {
void *context = &context;
void (*original)(id, SEL);
void custom(id self, SEL _cmd) {
    if (objc_getAssociatedObject(self, context) == NULL) {
        original(self, _cmd);
    }
}
void swizzle() {
    Method method = class_getInstanceMethod(objc_lookUpClass("AVPlayerViewController"), sel_registerName("_showOrHidePlaybackControlsView"));
    original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}
}
}

OBJC_EXPORT id objc_msgSendSuper2(void);

@implementation VideoPlayerViewController

+ (void)load {
    mpu_AVPlayerViewController::_showOrHidePlaybackControlsView::swizzle();
    [self dynamicIsa];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [[self dynamicIsa] allocWithZone:zone];
}

+ (Class)dynamicIsa {
    static Class dynamicIsa;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class _dynamicIsa = objc_allocateClassPair(objc_lookUpClass("SPViewController"), "_VideoPlayerViewController", 0);
        
        IMP dealloc = class_getMethodImplementation(self, @selector(dealloc));
        assert(class_addMethod(_dynamicIsa, @selector(dealloc), dealloc, NULL));
        
        IMP description = class_getMethodImplementation(self, @selector(description));
        assert(class_addMethod(_dynamicIsa, @selector(description), description, NULL));
        
        IMP loadView = class_getMethodImplementation(self, @selector(loadView));
        assert(class_addMethod(_dynamicIsa, @selector(loadView), loadView, NULL));
        
        IMP viewDidLoad = class_getMethodImplementation(self, @selector(viewDidLoad));
        assert(class_addMethod(_dynamicIsa, @selector(viewDidLoad), viewDidLoad, NULL));
        
        IMP slider_didTapTouchTarget = class_getMethodImplementation(self, @selector(slider:didTapTouchTarget:));
        assert(class_addMethod(_dynamicIsa, @selector(slider:didTapTouchTarget:), slider_didTapTouchTarget, NULL));
        
        IMP rateSliderValueChanged = class_getMethodImplementation(self, @selector(rateSliderValueChanged:));
        assert(class_addMethod(_dynamicIsa, @selector(rateSliderValueChanged:), rateSliderValueChanged, NULL));
        
        assert(class_addProtocol(_dynamicIsa, NSProtocolFromString(@"PUICSliderDelegate")));
        assert(class_addIvar(_dynamicIsa, "_playerRateObservation", sizeof(id), sizeof(id), @encode(id)));
        
        dynamicIsa = _dynamicIsa;
    });
    
    return dynamicIsa;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"
- (void)dealloc {
    id _playerRateObservation;
    object_getInstanceVariable(self, "_playerRateObservation", reinterpret_cast<void **>(&_playerRateObservation));
    [_playerRateObservation release];
    
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
}
#pragma clang diagnostic pop

- (NSString *)description {
    return [NSString stringWithFormat:@"<%s: %p>", class_getName(self.class), self];
}

- (void)loadView {
    __weak auto weakSelf = self;
    
    id primaryAction = reinterpret_cast<id (*)(Class, SEL, id, id, id, id)>(objc_msgSend)(objc_lookUpClass("UIAction"), sel_registerName("actionWithTitle:image:identifier:handler:"), @"Present", nil, nil, ^(id action) {
        [weakSelf presentViewController];
    });
    
    id button = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("PUICButton"), sel_registerName("systemButtonWithPrimaryAction:"), primaryAction);
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setView:"), button);
}

- (void)viewDidLoad {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
    
}

- (void)presentViewController __attribute__((objc_direct)) {
    id playerViewController = [objc_lookUpClass("AVPlayerViewController") new];
    
    //
    
    NSURL *URL = [NSBundle.mainBundle URLForResource:@"0" withExtension:UTTypeMPEG4Movie.preferredFilenameExtension];
    AVPlayer *player = [[AVPlayer alloc] initWithURL:URL];
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(playerViewController, sel_registerName("setPlayer:"), player);
    [player release];
    
    //
    
    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(playerViewController, sel_registerName("loadViewIfNeeded"));
    
    id _playbackControlsViewController;
    object_getInstanceVariable(playerViewController, "_playbackControlsViewController", reinterpret_cast<void **>(&_playbackControlsViewController));
    
    id controlsView = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(_playbackControlsViewController, sel_registerName("view"));
    
    id _scrubber;
    object_getInstanceVariable(_playbackControlsViewController, "_scrubber", reinterpret_cast<void **>(&_scrubber));
    
    id rateSlider = [MyAVSlider new];
    
    //
    
    KeyValueObservation *playerRateObservation = [player observeValueForKeyPath:@"rate" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew changeHandler:^(id  _Nonnull object, NSDictionary * _Nonnull changes) {
        reinterpret_cast<void (*)(id, SEL, float, BOOL)>(objc_msgSend)(rateSlider, sel_registerName("setValue:animated:"), static_cast<AVPlayer *>(object).rate, NO);
    }];
    
    
    id _playerRateObservation;
    object_getInstanceVariable(self, "_playerRateObservation", reinterpret_cast<void **>(&_playerRateObservation));
    [_playerRateObservation release];
    object_setInstanceVariable(self, "_playerRateObservation", [playerRateObservation retain]);
    
    //
    
    reinterpret_cast<void (*)(id, SEL, float)>(objc_msgSend)(rateSlider, sel_registerName("setMinimumValue:"), 0.f);
    reinterpret_cast<void (*)(id, SEL, float)>(objc_msgSend)(rateSlider, sel_registerName("setMaximumValue:"), 2.f);
    reinterpret_cast<void (*)(id, SEL, id, SEL, NSUInteger)>(objc_msgSend)(rateSlider, sel_registerName("addTarget:action:forControlEvents:"), self, @selector(rateSliderValueChanged:), 1 << 12);
    
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(rateSlider, sel_registerName("setShouldAutomaticallAdjustValueOnTouch:"), NO);
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(rateSlider, sel_registerName("setDelegate:"), self);
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(rateSlider, sel_registerName("setTranslatesAutoresizingMaskIntoConstraints:"), NO);
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(controlsView, sel_registerName("addSubview:"), rateSlider);
    
    id _scrubber_topAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(_scrubber, sel_registerName("topAnchor"));
    id _scrubber_leadingAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(_scrubber, sel_registerName("leadingAnchor"));
    id _scrubber_trailingAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(_scrubber, sel_registerName("trailingAnchor"));
    
    id rateSlider_bottomAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(rateSlider, sel_registerName("bottomAnchor"));
    id rateSlider_leadingAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(rateSlider, sel_registerName("leadingAnchor"));
    id rateSlider_trailingAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(rateSlider, sel_registerName("trailingAnchor"));
    
    reinterpret_cast<void (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("NSLayoutConstraint"), sel_registerName("activateConstraints:"), @[
        reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)(_scrubber_topAnchor, sel_registerName("constraintEqualToAnchor:"), rateSlider_bottomAnchor),
        reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)(_scrubber_leadingAnchor, sel_registerName("constraintEqualToAnchor:"), rateSlider_leadingAnchor),
        reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)(_scrubber_trailingAnchor, sel_registerName("constraintEqualToAnchor:"), rateSlider_trailingAnchor)
    ]);
    
    [rateSlider release];
    
    //
    
    id contentOverlayView = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(playerViewController, sel_registerName("contentOverlayView"));
    
    id puicSwitch = [objc_lookUpClass("PUICSwitch") new];
    
    reinterpret_cast<void (*)(id, SEL, BOOL, BOOL)>(objc_msgSend)(puicSwitch, sel_registerName("setOn:animated:"), YES, NO);
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(puicSwitch, sel_registerName("setTranslatesAutoresizingMaskIntoConstraints:"), NO);
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(contentOverlayView, sel_registerName("addSubview:"), puicSwitch);
    
    id contentOverlayView_layoutMarginsGuide = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(contentOverlayView, sel_registerName("layoutMarginsGuide"));
    
    id puicSwitch_centerYAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(puicSwitch, sel_registerName("centerYAnchor"));
    id contentOverlayView_centerYAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(contentOverlayView_layoutMarginsGuide, sel_registerName("centerYAnchor"));
    
    id puicSwitch_centerXAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(puicSwitch, sel_registerName("centerXAnchor"));
    id contentOverlayView_centerXAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(contentOverlayView_layoutMarginsGuide, sel_registerName("centerXAnchor"));
    
    id centerYConstraint = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)(puicSwitch_centerYAnchor, sel_registerName("constraintEqualToAnchor:"), contentOverlayView_centerYAnchor);
    
    id centerXConstraint = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)(puicSwitch_centerXAnchor, sel_registerName("constraintEqualToAnchor:"), contentOverlayView_centerXAnchor);
    
    reinterpret_cast<void (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("NSLayoutConstraint"), sel_registerName("activateConstraints:"), @[
        centerYConstraint, centerXConstraint
    ]);
    
    [puicSwitch release];
    
    //
    
    reinterpret_cast<void (*)(id, SEL, CGFloat)>(objc_msgSend)(controlsView, sel_registerName("setAlpha:"), 1.);
    objc_setAssociatedObject(playerViewController, mpu_AVPlayerViewController::_showOrHidePlaybackControlsView::context, [NSNull null], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    reinterpret_cast<void (*)(id, SEL, id, BOOL, id)>(objc_msgSend)(self, sel_registerName("presentViewController:animated:completion:"), playerViewController, YES, nil);
    [playerViewController release];
}

- (void)slider:(id)slider didTapTouchTarget:(NSInteger)touchTarget {
    id playbackControlsViewController = [self playbackControlsViewController];
    
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(playbackControlsViewController, sel_registerName("setIsInteractivelyScrubbing:"), NO);
    reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(slider, sel_registerName("becomeFirstResponder"));
}

- (void)rateSliderValueChanged:(id)sender {
    float value = reinterpret_cast<float (*)(id, SEL)>(objc_msgSend)(sender, sel_registerName("value"));
    
    id playerViewController = [self playerViewController];
    AVPlayer *player = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(playerViewController, sel_registerName("player"));
    
    if (CMTimeCompare(player.currentItem.currentTime, player.currentItem.duration) == 0) {
        [player seekToTime:kCMTimeZero toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
            player.rate = value;
        }];
    } else {
        player.rate = value;
    }
}

- (id)playerViewController __attribute__((objc_direct)) {
    id presentedViewController = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("presentedViewController"));
    
    if (![presentedViewController isKindOfClass:objc_lookUpClass("AVPlayerViewController")]) return nil;
    
    return presentedViewController;
}

- (id)playbackControlsViewController __attribute__((objc_direct)) {
    id playerViewController = [self playerViewController];
    
    id _playbackControlsViewController;
    object_getInstanceVariable(playerViewController, "_playbackControlsViewController", reinterpret_cast<void **>(&_playbackControlsViewController));
    
    return _playbackControlsViewController;
}

@end
