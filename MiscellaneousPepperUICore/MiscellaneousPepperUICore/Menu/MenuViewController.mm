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
    [self dynamicIsa];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [[self dynamicIsa] allocWithZone:zone];
}

+ (Class)dynamicIsa {
    static Class dynamicIsa;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class _dynamicIsa = objc_allocateClassPair(objc_lookUpClass("SPViewController"), "_MenuViewController", 0);
        
        IMP description = class_getMethodImplementation(self, @selector(description));
        assert(class_addMethod(_dynamicIsa, @selector(description), description, NULL));
        
        IMP loadView = class_getMethodImplementation(self, @selector(loadView));
        assert(class_addMethod(_dynamicIsa, @selector(loadView), loadView, NULL));
        
//        assert(class_addProtocol(_dynamicIsa, NSProtocolFromString(@"PUICMenuViewControllerDelegate")));
        
        //
        
        dynamicIsa = _dynamicIsa;
    });
    
    return dynamicIsa;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%s: %p>", class_getName(self.class), self];
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
