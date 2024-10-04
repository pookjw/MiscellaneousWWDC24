//
//  WatchGesturesViewController.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 10/4/24.
//

#import "WatchGesturesViewController.h"
#import <UIKit/UIKit.h>
#import <objc/message.h>
#import <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

@implementation WatchGesturesViewController

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [[self dynamicIsa] allocWithZone:zone];
}

+ (Class)dynamicIsa {
    static Class dynamicIsa;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class _dynamicIsa = objc_allocateClassPair(objc_lookUpClass("SPViewController"), "_WatchGesturesViewController", 0);
        
        IMP dealloc = class_getMethodImplementation(self, @selector(dealloc));
        assert(class_addMethod(_dynamicIsa, @selector(dealloc), dealloc, NULL));
        
        IMP respondsToSelector = class_getMethodImplementation(self, @selector(respondsToSelector:));
        assert(class_addMethod(_dynamicIsa, @selector(respondsToSelector:), respondsToSelector, NULL));
        
        IMP loadView = class_getMethodImplementation(self, @selector(loadView));
        assert(class_addMethod(_dynamicIsa, @selector(loadView), loadView, NULL));
        
        IMP viewDidLoad = class_getMethodImplementation(self, @selector(viewDidLoad));
        assert(class_addMethod(_dynamicIsa, @selector(viewDidLoad), viewDidLoad, NULL));
        
        IMP foo = class_getMethodImplementation(self, @selector(foo:));
        assert(class_addMethod(_dynamicIsa, @selector(foo:), foo, NULL));
        
        IMP didTriggerInvalidActionBarButtonItem = class_getMethodImplementation(self, @selector(didTriggerInvalidActionBarButtonItem:));
        assert(class_addMethod(_dynamicIsa, @selector(didTriggerInvalidActionBarButtonItem:), didTriggerInvalidActionBarButtonItem, NULL));
        
        assert(class_addIvar(_dynamicIsa, "_label", sizeof(id), sizeof(id), @encode(id)));
        assert(class_addIvar(_dynamicIsa, "_observer", sizeof(id), sizeof(id), @encode(id)));
        
        //
        
        objc_registerClassPair(_dynamicIsa);
        
        dynamicIsa = _dynamicIsa;
    });
    
    return dynamicIsa;
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

- (BOOL)respondsToSelector:(SEL)aSelector {
    objc_super superInfo = { self, [self class] };
    BOOL responds = reinterpret_cast<BOOL (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
    
    if (!responds) {
        NSLog(@"%s", sel_getName(aSelector));
    }
    
    return responds;
}

- (void)loadView {
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setView:"), [self label]);
}

- (void)viewDidLoad {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
    
    id label = [self label];
    
    //
    
    id gesture = reinterpret_cast<id (*)(id, SEL, id, SEL)>(objc_msgSend)([objc_lookUpClass("_UIExternalTapGestureRecognizer") alloc], sel_registerName("initWithTarget:action:"), self, @selector(foo:));
    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(gesture, sel_registerName("setNumberOfTapsRequired:"), 2);
//    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(label, sel_registerName("addGestureRecognizer:"), gesture);
    [gesture release];
    
    //
    
    id configuration = reinterpret_cast<id (*)(id, SEL, NSUInteger, id)>(objc_msgSend)([objc_lookUpClass("WAGUIPrimaryGestureViewInteractionConfiguration") alloc], sel_registerName("initWithFormula:scrollingView:"), 0 /* or 1, 4(UIScrollView) */, nil);
//    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(configuration, sel_registerName("setDisableBlackOverlay:"), NO);
//    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(configuration, sel_registerName("setHighlightedViewRequiresSafeAreaInsets:"), YES);
    
    /*
     WAGUIGestureInteractionBarButtonItemHandler
     WAGUIGestureInteractionCollectionViewCellHandler
     WAGUIGestureInteractionCollectionViewHandler
     WAGUIGestureInteractionControlHandler
     WAGUIGestureInteractionTableViewHandler
     WAGUIGestureInteractionViewHandler
     WAGUIGestureInteractionHandler
     WatchGestureInteractionHandler
     PUICScrollGestureHandler
     */
    id handler = [objc_lookUpClass("WatchGestureInteractionHandler") new];
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(handler, sel_registerName("setActivationBlock:"), ^{
        NSString *text = [NSDate now].description;
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(label, sel_registerName("setText:"), text);
    });
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(handler, sel_registerName("setDidEndHighlighting:"), ^{
        abort();
    });
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(handler, sel_registerName("setFrameProvider:"), ^ CGRect (id view){
        abort();
    });
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(handler, sel_registerName("setRequiresHighlightedViewBlock:"), ^{
        // v16@?0@?<v@?>8
        abort();
    });
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(handler, sel_registerName("setViewProvider:"), ^ id{
        return label;
    });
    
    id interaction = reinterpret_cast<id (*)(id, SEL, id, id)>(objc_msgSend)([objc_lookUpClass("WAGUIPrimaryGestureViewInteraction") alloc], sel_registerName("initWithHandler:configuration:"), handler, configuration);
    
    [handler release];
    [configuration release];
    
    id view = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("view"));
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(view, sel_registerName("addInteraction:"), interaction);
//    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(interaction, sel_registerName("setDisabled:"), YES);
    [interaction release];
    
    //
    
    [self updateLabelCornerRadius];
    
    id observer = reinterpret_cast<id (*)(id, SEL, id, id)>(objc_msgSend)(self, sel_registerName("registerForTraitChanges:withHandler:"), @[objc_lookUpClass("UITraitDisplayCornerRadius")], ^(id traitEnvironment, id previousCollection) {
        [static_cast<WatchGesturesViewController *>(traitEnvironment) updateLabelCornerRadius];
    });
    
    assert(object_setInstanceVariable(self, "_observer", reinterpret_cast<void *>([observer retain])) != nullptr);
    
    //
    
    id invalidActionBarButtonItem = reinterpret_cast<id (*)(id, SEL, id, NSInteger, id, SEL)>(objc_msgSend)([objc_lookUpClass("UIBarButtonItem") alloc], sel_registerName("initWithImage:style:target:action:"), [UIImage systemImageNamed:@"scribble"], 0, self, @selector(didTriggerInvalidActionBarButtonItem:));
    id navigationItem = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("navigationItem"));
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(navigationItem, sel_registerName("setRightBarButtonItems:"), @[invalidActionBarButtonItem]);
    [invalidActionBarButtonItem release];
}

- (void)updateLabelCornerRadius __attribute__((objc_direct)) {
    id traitCollection = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("traitCollection"));
    CGFloat displayCornerRadius = reinterpret_cast<CGFloat (*)(id, SEL)>(objc_msgSend)(traitCollection, sel_registerName("displayCornerRadius"));
    
    id layer = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)([self label], sel_registerName("layer"));
    reinterpret_cast<void (*)(id, SEL, CGFloat)>(objc_msgSend)(layer, sel_registerName("setCornerRadius:"), displayCornerRadius);
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(layer, sel_registerName("setCornerCurve:"), @"continuous");
}

- (id)label __attribute__((objc_direct)) {
    id label = nil;
    assert(object_getInstanceVariable(self, "_label", reinterpret_cast<void **>(&label)));
    if (label != nil) {
        return label;
    }
    
    label = [objc_lookUpClass("UILabel") new];
    reinterpret_cast<void (*)(id, SEL, NSTextAlignment)>(objc_msgSend)(label, sel_registerName("setTextAlignment:"), NSTextAlignmentCenter);
    reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(label, sel_registerName("setNumberOfLines:"), 0);
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(label, sel_registerName("setText:"), @"Pending");
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(label, sel_registerName("setTextColor:"), UIColor.whiteColor);
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(label, sel_registerName("setBackgroundColor:"), UIColor.brownColor);
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(label, sel_registerName("setClipsToBounds:"), YES);
    
    object_setInstanceVariable(self, "_label", reinterpret_cast<void *>([label retain]));
    return [label autorelease];
}

- (void)foo:(id)sender {
    
}

- (void)didTriggerInvalidActionBarButtonItem:(id)sender {
    id view = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("view"));
    id window = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(view, sel_registerName("window"));
    id windowScene = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(window, sel_registerName("windowScene"));
    id _scene = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(windowScene, sel_registerName("_scene"));
    id watchGesturesActionSender = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(_scene, sel_registerName("watchGesturesActionSender"));
    
    id action = reinterpret_cast<id (*)(id, SEL, NSUInteger, id)>(objc_msgSend)([objc_lookUpClass("WAGUINegativeAction") alloc], sel_registerName("initWithType:tintColor:"), 1, nil);
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(watchGesturesActionSender, sel_registerName("sendWatchGesturesActions:"), [NSSet setWithObject:action]);
    [action release];
}

@end
