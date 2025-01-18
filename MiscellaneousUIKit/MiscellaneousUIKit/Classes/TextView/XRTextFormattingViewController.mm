//
//  XRTextFormattingViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 1/18/25.
//

#import "XRTextFormattingViewController.h"

#if TARGET_OS_VISION

#import <objc/message.h>
#import <objc/runtime.h>

@interface XRTextFormattingViewController () <UIColorPickerViewControllerDelegate>
@end

@implementation XRTextFormattingViewController

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [[self class] allocWithZone:zone];
}

+ (Class)class {
    static Class isa;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class _isa = objc_allocateClassPair(objc_lookUpClass("UITextFormattingViewController"), "_XRTextFormattingViewController", 0);
        
        //
        
        IMP _computeContentSize = class_getMethodImplementation(self, @selector(_computeContentSize));
        assert(class_addMethod(_isa, @selector(_computeContentSize), _computeContentSize, NULL));
        
        IMP _presentColorPicker_selectedColor_ = class_getMethodImplementation(self, @selector(_presentColorPicker:selectedColor:));
        assert(class_addMethod(_isa, @selector(_presentColorPicker:selectedColor:), _presentColorPicker_selectedColor_, NULL));
        
        //
        
        objc_registerClassPair(_isa);
        
        isa = _isa;
    });
    
    return isa;
}

- (CGSize)_computeContentSize {
    return CGSizeMake(self.preferredContentSize.width, 375.);
}

- (void)_presentColorPicker:(CGRect)rect selectedColor:(UIColor *)selectedColor {
    UIColorPickerViewController *viewController = [UIColorPickerViewController new];
    
    viewController.selectedColor = selectedColor;
    viewController.supportsAlpha = NO;
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(viewController, sel_registerName("_setSupportsEyedropper:"), NO);
    
    id delegate = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("delegate"));
    if ([delegate respondsToSelector:sel_registerName("textFormattingViewController:shouldPresentColorPicker:")]) {
        reinterpret_cast<void (*)(id, SEL, id, id)>(objc_msgSend)(delegate, sel_registerName("textFormattingViewController:shouldPresentColorPicker:"), self, viewController);
    }
    
    viewController.selectedColor = selectedColor;
    viewController.supportsAlpha = NO;
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(viewController, sel_registerName("_setSupportsEyedropper:"), NO);
    viewController.delegate = self;
    
    //
    
    if (reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("_isInPopoverPresentation"))) {
        reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("_stopSuppressingKeyboardForTextFormatting"));
        reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("_textFormattingRequestsFirstResponderResignation"));
        reinterpret_cast<void (*)(id, SEL, NSUInteger, BOOL)>(objc_msgSend)(self, sel_registerName("_modifyKeyboardTrackingIfNeededForType:start:"), 2, YES);
    }
    
    [self presentViewController:viewController animated:YES completion:^{
        reinterpret_cast<void (*)(id, SEL, NSUInteger, BOOL)>(objc_msgSend)(self, sel_registerName("_modifyKeyboardTrackingIfNeededForType:start:"), 2, NO);
    }];
    
    [viewController release];
}

@end

#endif
