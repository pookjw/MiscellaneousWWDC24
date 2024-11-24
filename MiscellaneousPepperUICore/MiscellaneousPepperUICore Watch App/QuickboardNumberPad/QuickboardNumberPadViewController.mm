//
//  QuickboardNumberPadViewController.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 8/3/24.
//

#import "QuickboardNumberPadViewController.h"
#import <UIKit/UIKit.h>
#import <objc/message.h>
#import <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

@implementation QuickboardNumberPadViewController

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
        Class _isa = objc_allocateClassPair(objc_lookUpClass("SPViewController"), "_QuickboardNumberPadViewController", 0);
        
        IMP respondsToSelector = class_getMethodImplementation(self, @selector(respondsToSelector:));
        assert(class_addMethod(_isa, @selector(respondsToSelector:), respondsToSelector, NULL));
        
        IMP loadView = class_getMethodImplementation(self, @selector(loadView));
        assert(class_addMethod(_isa, @selector(loadView), loadView, NULL));
        
        IMP numberPadView_didHighlightNumberPadCharacter = class_getMethodImplementation(self, @selector(numberPadView:didHighlightNumberPadCharacter:));
        assert(class_addMethod(_isa, @selector(numberPadView:didHighlightNumberPadCharacter:), numberPadView_didHighlightNumberPadCharacter, NULL));
        
        IMP numberPadView_didSelectNumberPadCharacter = class_getMethodImplementation(self, @selector(numberPadView:didSelectNumberPadCharacter:));
        assert(class_addMethod(_isa, @selector(numberPadView:didSelectNumberPadCharacter:), numberPadView_didSelectNumberPadCharacter, NULL));
        
        IMP numberPadView_didUnhighlightNumberPadCharacter = class_getMethodImplementation(self, @selector(numberPadView:didUnhighlightNumberPadCharacter:));
        assert(class_addMethod(_isa, @selector(numberPadView:didUnhighlightNumberPadCharacter:), numberPadView_didUnhighlightNumberPadCharacter, NULL));
        
        IMP numberPadViewDidSelectDelete = class_getMethodImplementation(self, @selector(numberPadViewDidSelectDelete:));
        assert(class_addMethod(_isa, @selector(numberPadViewDidSelectDelete:), numberPadViewDidSelectDelete, NULL));
        
        IMP numberPadViewDidSelectOK = class_getMethodImplementation(self, @selector(numberPadViewDidSelectOK:));
        assert(class_addMethod(_isa, @selector(numberPadViewDidSelectOK:), numberPadViewDidSelectOK, NULL));
        
        //
        
        assert(class_addProtocol(_isa, NSProtocolFromString(@"PUICQuickboardNumberPadViewDelegate")));
        
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

- (void)loadView {
    // mode
    //  - 0 : . / Delete
    //  - 1 : + / OK (preferDeleteButtonInDialerMode이 YES일 경우 Delete)
    //  - 2 : * / # (preferDeleteButtonInDialerMode이 YES일 경우 Delete)
    id quickboardNumberPadView = reinterpret_cast<id (*)(id, SEL, CGRect, int, BOOL, NSInteger)>(objc_msgSend)([objc_lookUpClass("PUICQuickboardNumberPadView") alloc], sel_registerName("initWithFrame:mode:preferDeleteButtonInDialerMode:returnKeyType:"), CGRectNull, 2, NO, 0 /* 의미 없는듯 */);
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(quickboardNumberPadView, sel_registerName("setDelegate:"), self);
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setView:"), quickboardNumberPadView);
    [quickboardNumberPadView release];
}

- (void)numberPadView:(id)numberPadView didHighlightNumberPadCharacter:(NSInteger)character {
    
}

- (void)numberPadView:(id)numberPadView didSelectNumberPadCharacter:(long)character {
    
}

- (void)numberPadView:(id)numberPadView didUnhighlightNumberPadCharacter:(long)character {
    
}

- (void)numberPadViewDidSelectDelete:(id)numberPadView {
    
}

- (void)numberPadViewDidSelectOK:(id)numberPadView {
    
}

@end
