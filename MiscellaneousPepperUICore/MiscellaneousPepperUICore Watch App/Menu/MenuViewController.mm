//
//  MenuViewController.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 8/6/24.
//

#import "MenuViewController.h"
#import <UIKit/UIKit.h>
#import <objc/message.h>
#import <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

@implementation MenuViewController

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
        Class _isa = objc_allocateClassPair(objc_lookUpClass("SPViewController"), "_MenuViewController", 0);
        
        IMP loadView = class_getMethodImplementation(self, @selector(loadView));
        assert(class_addMethod(_isa, @selector(loadView), loadView, NULL));
        
//        assert(class_addProtocol(_isa, NSProtocolFromString(@"PUICMenuViewControllerDelegate")));
        
        //
        
        objc_registerClassPair(_isa);
        
        isa = _isa;
    });
    
    return isa;
}

- (void)loadView {
    id button = [objc_lookUpClass("UIButton") new];
    
    id configuration = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("UIButtonConfiguration"), sel_registerName("tintedButtonConfiguration"));
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(configuration, sel_registerName("setTitle:"), @"Menu");
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(button, sel_registerName("setConfiguration:"), configuration);
    
    id menuAction = reinterpret_cast<id (*)(Class, SEL, id, id, id, id)>(objc_msgSend)(objc_lookUpClass("UIAction"), sel_registerName("actionWithTitle:image:identifier:handler:"), @"Action", nil, nil, ^(id) {
        
    });
    
    id menu = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("UIMenu"), sel_registerName("menuWithChildren:"), @[menuAction]);
    
    // -setMenu:가 iOS랑 동작이 다르며 _UIVariableGestureContextMenuInteraction, UIContextMenuInteraction, _UIContextMenuContainerView 같은 것이 아예 존재 안함.
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(button, sel_registerName("setMenu:"), menu);
    
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(button, sel_registerName("setShowsMenuAsPrimaryAction:"), YES);
    
    // UIMenuInteraction으로 해보기
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setView:"), button);
    [button release];
}

@end
