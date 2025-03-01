//
//  NSNotificationCenter+MA_Category.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 3/1/25.
//

#import "NSNotificationCenter+MA_Category.h"
#import <Cocoa/Cocoa.h>
#include <dlfcn.h>
#include <execinfo.h>
#import <objc/runtime.h>

static NSNotificationCenter * _ma_viewGeometryNotificationCenter;

namespace ma_NSNotificationCenter {
    namespace init {
        NSNotificationCenter * (*original)(NSNotificationCenter *self, SEL _cmd);
        NSNotificationCenter *custom(NSNotificationCenter *self, SEL _cmd) {
            if (original(self, _cmd)) {
                void *buffer[2];
                int count = backtrace(buffer, 2);
                
                if (count >= 2) {
                    void *addr = buffer[1];
                    struct dl_info info;
                    assert(dladdr(addr, &info) != 0);
                    
                    if (strcmp(info.dli_sname, "__viewGeometryNotificationCenter_block_invoke") == 0) {
                        _ma_viewGeometryNotificationCenter = self;
                    }
                }
            }
            
            return self;
        }
        void swizzle(void) {
            Method method = class_getInstanceMethod([NSNotificationCenter class], @selector(init));
            original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
            method_setImplementation(method, reinterpret_cast<IMP>(custom));
        }
    }
}

@implementation NSNotificationCenter (MA_Category)

+ (void)load {
    ma_NSNotificationCenter::init::swizzle();
}

+ (NSNotificationCenter *)ma_viewGeometryNotificationCenter {
    if (NSNotificationCenter *result = _ma_viewGeometryNotificationCenter) return result;
    [[[NSTrackingSeparatorToolbarItem alloc] initWithItemIdentifier:@""] release];
    return _ma_viewGeometryNotificationCenter;
}

@end
