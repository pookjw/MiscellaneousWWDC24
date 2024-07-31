//
//  DigitalCrownView.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 8/1/24.
//

#import "DigitalCrownView.h"
#import <objc/message.h>
#import <objc/runtime.h>

@implementation DigitalCrownView

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
        Class _dynamicIsa = objc_allocateClassPair(objc_lookUpClass("UIView"), "_DigitalCrownView", 0);
        
        IMP canBecomeFirstResponder = class_getMethodImplementation(self, @selector(canBecomeFirstResponder));
        assert(class_addMethod(_dynamicIsa, @selector(canBecomeFirstResponder), canBecomeFirstResponder, NULL));
        
        dynamicIsa = _dynamicIsa;
    });
    
    return dynamicIsa;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

@end
