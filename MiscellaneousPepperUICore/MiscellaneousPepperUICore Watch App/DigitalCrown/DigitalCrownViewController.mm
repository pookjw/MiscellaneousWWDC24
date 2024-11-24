//
//  DigitalCrownViewController.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 8/1/24.
//

#import "DigitalCrownViewController.h"
#import "DigitalCrownView.h"
#import <UIKit/UIKit.h>
#import <objc/message.h>
#import <objc/runtime.h>

/*
 PUICButton (PUICButtonTypePill, PUICButtonTypePetitePill) +buttonWithType:
 PUICHapticFeedback
 PUICPageIndicatorView
 PUICMaterialPageIndicatorView
 PUICActionViewController
 PUICQuickboardViewController
 ArouetButton
 ArouetBlinkingButton
 
 CollectionView
 PUICListCollectionViewController
 PUICListCollectionViewLayout
 PUICListCollectionView
 PUICListPlatterCell
 SearchController
 
 NMUNowPlayingTracklistViewController
 NMUCircularProgressView
 NMUContentUnavailableView
 NMUAddToPlaylistViewController
 */

OBJC_EXPORT id objc_msgSendSuper2(void);

@implementation DigitalCrownViewController

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
        Class _isa = objc_allocateClassPair(objc_lookUpClass("SPViewController"), "_DigitalCrownViewController", 0);
        
        IMP dealloc = class_getMethodImplementation(self, @selector(dealloc));
        assert(class_addMethod(_isa, @selector(dealloc), dealloc, NULL));
        
        IMP loadView = class_getMethodImplementation(self, @selector(loadView));
        assert(class_addMethod(_isa, @selector(loadView), loadView, NULL));
        
        IMP viewDidLoad = class_getMethodImplementation(self, @selector(viewDidLoad));
        assert(class_addMethod(_isa, @selector(viewDidLoad), viewDidLoad, NULL));
        
        IMP didTriggerFlashIndicatorBarButtonItem = class_getMethodImplementation(self, @selector(didTriggerFlashIndicatorBarButtonItem:));
        assert(class_addMethod(_isa, @selector(didTriggerFlashIndicatorBarButtonItem:), didTriggerFlashIndicatorBarButtonItem, NULL));
        
        objc_registerClassPair(_isa);
        
        isa = _isa;
    });
    
    return isa;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"
- (void)dealloc {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
}
#pragma clang diagnostic pop

- (void)loadView {
    DigitalCrownView *view = [DigitalCrownView new];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setView:"), view);
    [view release];
}

- (void)viewDidLoad {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
    
    id navigationItem = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("navigationItem"));
    
    id flashIndicatorBarButtonItem = reinterpret_cast<id (*)(id, SEL, id, NSInteger, id, SEL)>(objc_msgSend)([objc_lookUpClass("UIBarButtonItem") alloc], sel_registerName("initWithImage:style:target:action:"), [UIImage systemImageNamed:@"flashlight.off.fill"], 0, self, @selector(didTriggerFlashIndicatorBarButtonItem:));
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(navigationItem, sel_registerName("setRightBarButtonItems:"), @[
        flashIndicatorBarButtonItem
    ]);
    
    [flashIndicatorBarButtonItem release];
    
    id view = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("view"));
    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(view, sel_registerName("becomeFirstResponder"));
}

- (void)didTriggerFlashIndicatorBarButtonItem:(id)sender {
    id view = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("view"));
    id _crownInputSequencer;
    object_getInstanceVariable(view, "_crownInputSequencer", reinterpret_cast<void **>(&_crownInputSequencer));
    id crownIndicatorContext = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(_crownInputSequencer, sel_registerName("crownIndicatorContext"));
    
    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(crownIndicatorContext, sel_registerName("flashCrownIndicator"));
}

@end
