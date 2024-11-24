//
//  SheetPresenterViewController.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 8/3/24.
//

#import "SheetPresenterViewController.h"
#import <UIKit/UIKit.h>
#import <Symbols/Symbols.h>
#import <objc/message.h>
#import <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

@implementation SheetPresenterViewController

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
        Class _isa = objc_allocateClassPair(objc_lookUpClass("SPViewController"), "_SheetPresenterViewController", 0);
        
        IMP loadView = class_getMethodImplementation(self, @selector(loadView));
        assert(class_addMethod(_isa, @selector(loadView), loadView, NULL));
        
        IMP viewDidLoad = class_getMethodImplementation(self, @selector(viewDidLoad));
        assert(class_addMethod(_isa, @selector(viewDidLoad), viewDidLoad, NULL));
        
        IMP didTriggerPresentBarButtonItem = class_getMethodImplementation(self, @selector(didTriggerPresentBarButtonItem:));
        assert(class_addMethod(_isa, @selector(didTriggerPresentBarButtonItem:), didTriggerPresentBarButtonItem, NULL));
        
        IMP actionSheetController_didDismissWithActionAtIndexPath = class_getMethodImplementation(self, @selector(actionSheetController:didDismissWithActionAtIndexPath:));
        assert(class_addMethod(_isa, @selector(actionSheetController:didDismissWithActionAtIndexPath:), actionSheetController_didDismissWithActionAtIndexPath, NULL));
        
        IMP actionSheetController_didTapActionAtIndexPath = class_getMethodImplementation(self, @selector(actionSheetController:didTapActionAtIndexPath:));
        assert(class_addMethod(_isa, @selector(actionSheetController:didTapActionAtIndexPath:), actionSheetController_didTapActionAtIndexPath, NULL));
        
        IMP actionSheetController_willDismissWithActionAtIndexPath = class_getMethodImplementation(self, @selector(actionSheetController:willDismissWithActionAtIndexPath:));
        assert(class_addMethod(_isa, @selector(actionSheetController:willDismissWithActionAtIndexPath:), actionSheetController_willDismissWithActionAtIndexPath, NULL));
        
        IMP actionSheetController_willTapActionAtIndexPath = class_getMethodImplementation(self, @selector(actionSheetController:willTapActionAtIndexPath:));
        assert(class_addMethod(_isa, @selector(actionSheetController:willTapActionAtIndexPath:), actionSheetController_willTapActionAtIndexPath, NULL));
        
        IMP actionContentControllerCancel = class_getMethodImplementation(self, @selector(actionContentControllerCancel:));
        assert(class_addMethod(_isa, @selector(actionContentControllerCancel:), actionContentControllerCancel, NULL));
        
        assert(class_addProtocol(_isa, NSProtocolFromString(@"PUICActionSheetControllerDelegate")));
        
        objc_registerClassPair(_isa);
        
        isa = _isa;
    });
    
    return isa;
}

- (void)loadView {
    UIImage *image = [UIImage imageNamed:@"image"];
    id imageView = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("UIImageView") alloc], sel_registerName("initWithImage:"), image);
    reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(imageView, sel_registerName("setContentMode:"), 2);
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(imageView, sel_registerName("setClipsToBounds:"), YES);
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setView:"), imageView);
    [imageView release];
}

- (void)viewDidLoad {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
    
    id navigationItem = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("navigationItem"));
    
    id presentBarButtonItem = reinterpret_cast<id (*)(id, SEL, id, NSInteger, id, SEL)>(objc_msgSend)([objc_lookUpClass("UIBarButtonItem") alloc], sel_registerName("initWithImage:style:target:action:"), [UIImage systemImageNamed:@"fireworks"], 0, self, @selector(didTriggerPresentBarButtonItem:));
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(navigationItem, sel_registerName("setRightBarButtonItems:"), @[
        presentBarButtonItem
    ]);
    
    [presentBarButtonItem release];
}

- (void)didTriggerPresentBarButtonItem:(id)sender {
    id alertController = [objc_lookUpClass("PUICAlertSheetController") new];
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(alertController, sel_registerName("setTitle:"), @"Alert Title!");
    
    NSAttributedString *attributedMessage = [[NSAttributedString alloc] initWithString:@"Message!" attributes:@{
        NSForegroundColorAttributeName: reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(UIColor.class, sel_registerName("systemTealColor"))
    }];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(alertController, sel_registerName("setAttributedMessage:"), attributedMessage);
    [attributedMessage release];
    
    
    NSAttributedString *footer = [[NSAttributedString alloc] initWithString:@"Footer!" attributes:@{
        NSForegroundColorAttributeName: reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(UIColor.class, sel_registerName("systemOrangeColor"))
    }];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(alertController, sel_registerName("setFooter:"), footer);
    [footer release];
    
    
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(alertController, sel_registerName("setShowCancelButton:"), YES);
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(alertController, sel_registerName("setShouldTintCancelButton:"), YES);
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(alertController, sel_registerName("setShouldDismissOnCancel:"), YES);
    
    //
    
    UIImageSymbolConfiguration *configuration = [UIImageSymbolConfiguration configurationWithPaletteColors:@[
        reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(UIColor.class, sel_registerName("systemPinkColor")),
        reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(UIColor.class, sel_registerName("systemGreenColor"))
    ]];
    
    UIImage *image = [UIImage systemImageNamed:@"fan.desk" withConfiguration:configuration];
    id imageView = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("UIImageView") alloc], sel_registerName("initWithImage:"), image);
    
    NSSymbolRotateEffect *effect = [[NSSymbolRotateEffect rotateClockwiseEffect] effectWithByLayer];
    NSSymbolEffectOptions *options = [NSSymbolEffectOptions optionsWithRepeatBehavior:[NSSymbolEffectOptionsRepeatBehavior behaviorContinuous]];
    reinterpret_cast<void (*)(id, SEL, id, id)>(objc_msgSend)(imageView, sel_registerName("addSymbolEffect:options:"), effect, options);
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(alertController, sel_registerName("setImageView:"), imageView);
    [imageView release];
    
    //
    
    id doneAction_1 = reinterpret_cast<id (*)(Class, SEL, id, NSInteger, id)>(objc_msgSend)(objc_lookUpClass("PUICActionSheetItem"), sel_registerName("actionWithTitle:style:actionHandler:"), @"Done 1", 0, ^(id item) {
        
    });
    
    id doneAction_2 = reinterpret_cast<id (*)(Class, SEL, id, NSInteger, id)>(objc_msgSend)(objc_lookUpClass("PUICActionSheetItem"), sel_registerName("actionWithTitle:style:actionHandler:"), @"Done 2", 1, ^(id item) {
        
    });
    
    id group_1 = reinterpret_cast<id (*)(Class, SEL, id, id)>(objc_msgSend)(objc_lookUpClass("PUICActionSheetGroup"), sel_registerName("groupWithActions:title:"), @[doneAction_1, doneAction_2], @"Group");
    
    //
    
    id doneAction_3 = reinterpret_cast<id (*)(Class, SEL, id, NSInteger, id)>(objc_msgSend)(objc_lookUpClass("PUICActionSheetItem"), sel_registerName("actionWithTitle:style:actionHandler:"), @"Done 3", 0, ^(id item) {
        
    });
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(doneAction_3, sel_registerName("setLoading:"), YES);
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(doneAction_3, sel_registerName("setShouldDismiss:"), NO);
    UIColor *systemBrownColor = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(UIColor.class, sel_registerName("systemBrownColor"));
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(doneAction_3, sel_registerName("setBackgroundColor:"), systemBrownColor);
    UIColor *systemTealColor = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(UIColor.class, sel_registerName("systemTealColor"));
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(doneAction_3, sel_registerName("setTitleColor:"), systemTealColor);
    
    id doneAction_4 = reinterpret_cast<id (*)(Class, SEL, id, NSInteger, id)>(objc_msgSend)(objc_lookUpClass("PUICActionSheetItem"), sel_registerName("actionWithTitle:style:actionHandler:"), @"Disabled", 1, ^(id item) {
        
    });
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(doneAction_4, sel_registerName("setEnabled:"), NO);
    id doneAction_4_imageView = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("UIImageView") alloc], sel_registerName("initWithImage:"), image);
    reinterpret_cast<void (*)(id, SEL, id, id)>(objc_msgSend)(doneAction_4_imageView, sel_registerName("addSymbolEffect:options:"), effect, options);
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(doneAction_4, sel_registerName("setAccessoryView:"), doneAction_4_imageView);
    [doneAction_4_imageView release];
    
    id group_2 = reinterpret_cast<id (*)(Class, SEL, id, id)>(objc_msgSend)(objc_lookUpClass("PUICActionSheetGroup"), sel_registerName("groupWithActions:title:"), @[doneAction_3, doneAction_4], @"Group");
    
    //
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(alertController, sel_registerName("setGroups:"), @[group_1, group_2]);
    
    //
    
    id contentViewController = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(alertController, sel_registerName("contentViewController"));
    id contentViewController_navigationItem = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(contentViewController, sel_registerName("navigationItem"));
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(contentViewController_navigationItem, sel_registerName("setTitle:"), @"Title");
    
    id mapView = reinterpret_cast<id (*)(id, SEL, CGRect)>(objc_msgSend)([objc_lookUpClass("MKMapView") alloc], sel_registerName("initWithFrame:"), CGRectNull);
    id contentView = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(contentViewController, sel_registerName("view"));
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(alertController, sel_registerName("setSupplementView:"), mapView);
    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(contentView, sel_registerName("layoutIfNeeded"));
    
    id superview = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(mapView, sel_registerName("superview"));
    CGRect superviewBounds = reinterpret_cast<CGRect (*)(id, SEL)>(objc_msgSend)(superview, sel_registerName("bounds"));
    
    CGRect mapViewFrame = reinterpret_cast<CGRect (*)(id, SEL)>(objc_msgSend)(mapView, sel_registerName("frame"));
    mapViewFrame.size = CGSizeMake(CGRectGetWidth(superviewBounds), 100.);
    reinterpret_cast<void (*)(id, SEL, CGRect)>(objc_msgSend)(mapView, sel_registerName("setFrame:"), mapViewFrame);
    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(mapView, sel_registerName("setAutoresizingMask:"), 1 << 1);
    
    [mapView release];
    
    //
    
    reinterpret_cast<void (*)(id, SEL, id, BOOL, id)>(objc_msgSend)(self, sel_registerName("presentViewController:animated:completion:"), alertController, YES, nil);
    
    [alertController release];
}

- (void)actionSheetController:(id)arg1 didDismissWithActionAtIndexPath:(id)arg2 {
    
}

- (void)actionSheetController:(id)arg1 didTapActionAtIndexPath:(id)arg2 {
    
}

- (void)actionSheetController:(id)arg1 willDismissWithActionAtIndexPath:(id)arg2 {
    
}

- (void)actionSheetController:(id)arg1 willTapActionAtIndexPath:(id)arg2 {
    
}

- (void)actionContentControllerCancel:(id)arg1 {
    
}

@end
