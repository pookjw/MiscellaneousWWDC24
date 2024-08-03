//
//  MessagePresenterViewController.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 8/4/24.
//

#import "MessagePresenterViewController.h"
#import <UIKit/UIKit.h>
#import <objc/message.h>
#import <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

@implementation MessagePresenterViewController

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
        Class _dynamicIsa = objc_allocateClassPair(objc_lookUpClass("SPViewController"), "_MessagePresenterViewController", 0);
        
        IMP description = class_getMethodImplementation(self, @selector(description));
        assert(class_addMethod(_dynamicIsa, @selector(description), description, NULL));
        
        IMP respondsToSelector = class_getMethodImplementation(self, @selector(respondsToSelector:));
        assert(class_addMethod(_dynamicIsa, @selector(respondsToSelector:), respondsToSelector, NULL));
        
        IMP loadView = class_getMethodImplementation(self, @selector(loadView));
        assert(class_addMethod(_dynamicIsa, @selector(loadView), loadView, NULL));
        
        IMP quickboard_textEntered = class_getMethodImplementation(self, @selector(quickboard:textEntered:));
        assert(class_addMethod(_dynamicIsa, @selector(quickboard:textEntered:), quickboard_textEntered, NULL));
        
        IMP quickboardInputCancelled = class_getMethodImplementation(self, @selector(quickboardInputCancelled:));
        assert(class_addMethod(_dynamicIsa, @selector(quickboardInputCancelled:), quickboardInputCancelled, NULL));
        
        dynamicIsa = _dynamicIsa;
    });
    
    return dynamicIsa;
}

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

- (void)loadView {
    __weak auto weakSelf = self;
    
    id primaryAction = reinterpret_cast<id (*)(Class, SEL, id, id, id, id)>(objc_msgSend)(objc_lookUpClass("UIAction"), sel_registerName("actionWithTitle:image:identifier:handler:"), @"Present", nil, nil, ^(id) {
        [weakSelf presetViewController];
    });
    
    id button = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("UIButton"), sel_registerName("systemButtonWithPrimaryAction:"), primaryAction);
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setView:"), button);
}

- (void)presetViewController __attribute__((objc_direct)) {
    id quickboardArouetViewController = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("PUICQuickboardMessageViewController") alloc], sel_registerName("initWithDelegate:"), self);;
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(quickboardArouetViewController, sel_registerName("setEmojiDelegate:"), self);
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(quickboardArouetViewController, sel_registerName("setAllowsEmojiInput:"), YES);
    
    reinterpret_cast<void (*)(id, SEL, id, BOOL, id)>(objc_msgSend)(self, sel_registerName("presentViewController:animated:completion:"), quickboardArouetViewController, YES, nil);
    
    [quickboardArouetViewController release];
}

- (void)quickboard:(id)quickboard textEntered:(NSAttributedString *)attributedText {
    id navigationItem = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("navigationItem"));
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(navigationItem, sel_registerName("setTitle:"), attributedText.string);
    
    reinterpret_cast<void (*)(id, SEL, BOOL, id)>(objc_msgSend)(quickboard, sel_registerName("dismissViewControllerAnimated:completion:"), YES, nil);
}

- (void)quickboardInputCancelled:(id)quickboard {
    reinterpret_cast<void (*)(id, SEL, BOOL, id)>(objc_msgSend)(quickboard, sel_registerName("dismissViewControllerAnimated:completion:"), YES, nil);
}

@end
