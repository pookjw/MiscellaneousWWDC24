//
//  enableVolumetricPresntationForWindow.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 2/10/25.
//

#import "enableVolumetricPresntationForWindow.h"
#import <objc/message.h>
#import <objc/runtime.h>
#include <dlfcn.h>
#include <execinfo.h>

namespace mui_UIWindow {
    namespace _isInVolumetricContext {
        static void *key = &key;
        BOOL (*original)(UIWindow *self, SEL _cmd);
        BOOL custom(UIWindow *self, SEL _cmd) {
            BOOL shouldReturnNO;
            
            NSNumber * _Nullable number = objc_getAssociatedObject(self, key);
            if ((number == nil) or !number.boolValue) {
                shouldReturnNO = NO;
            } else {
                void *buffer[2];
                int count = backtrace(buffer, 2);
                
                if (count < 2) {
                    shouldReturnNO = NO;
                } else {
                    void *addr = buffer[1];
                    struct dl_info info;
                    assert(dladdr(addr, &info) != 0);
                    
                    IMP baseAddr = class_getMethodImplementation([UIViewController class], sel_registerName("_presentViewController:withAnimationController:completion:"));
                    shouldReturnNO = (info.dli_saddr == baseAddr);
                }
            }
            
            if (shouldReturnNO) {
                return NO;
            } else {
                return original(self, _cmd);
            }
        }
        void swizzle() {
            Method method = class_getInstanceMethod([UIWindow class], sel_registerName("_isInVolumetricContext"));
            original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
            method_setImplementation(method, reinterpret_cast<IMP>(custom));
        }
    }
}

void enableVolumetricPresntationForWindow(UIWindow *window, BOOL enabled) {
    objc_setAssociatedObject(window, mui_UIWindow::_isInVolumetricContext::key, @(enabled), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@interface UIWindow (MUI_Category)
@end

@implementation UIWindow (MUI_Category)
+ (void)load {
    mui_UIWindow::_isInVolumetricContext::swizzle();
}
@end
