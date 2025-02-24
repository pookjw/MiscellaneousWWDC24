//
//  NSProcessInfo+MUI_Category.m
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 2/24/25.
//

#import "NSProcessInfo+MUI_Category.h"
#import <objc/message.h>
#import <objc/runtime.h>
#include <dlfcn.h>
#include <execinfo.h>

namespace mui_NSProcessInfo {
    namespace processName {
        NSString * (*original)(NSProcessInfo *self, SEL _cmd);
        NSString *custom(NSProcessInfo *self, SEL _cmd) {
            if (![NSProcessInfo.processInfo isEqual:self]) {
                return original(self, _cmd);
            }
            
            void *buffer[2];
            int count = backtrace(buffer, 2);
            
            if (count < 2) {
                return original(self, _cmd);
            }
            
            void *addr = buffer[1];
            struct dl_info info;
            assert(dladdr(addr, &info) != 0);
            
            if (strcmp(info.dli_fname, "/System/Library/PrivateFrameworks/ARKitCore.framework/ARKitCore") != 0) {
                return original(self, _cmd);
            }
            
            return @"ARKitSamples";
        }
        void swizzle(void) {
            Method method = class_getInstanceMethod(objc_lookUpClass("_NSSwiftProcessInfo"), @selector(processName));
            original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
            method_setImplementation(method, reinterpret_cast<IMP>(custom));
        }
    }
}

@implementation NSProcessInfo (MUI_Category)

+ (void)load {
    mui_NSProcessInfo::processName::swizzle();
}

@end
