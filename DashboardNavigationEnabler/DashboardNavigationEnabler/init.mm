//
//  init.mm
//  DashboardNavigationEnabler
//
//  Created by Jinwoo Kim on 12/29/24.
//

#import <Foundation/Foundation.h>
#import <objc/message.h>
#import <objc/runtime.h>

namespace dne_DBApplicationInfo {
    namespace supportsDashboardNavigation {
        BOOL (*original)(id self, SEL _cmd);
        BOOL custom(id self, SEL _cmd) {
            NSString *bundleIdentifier = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("bundleIdentifier"));
            
            if ([bundleIdentifier isEqualToString:@"com.pookjw.MiscellaneousUIKit"]) {
                return YES;
            } else {
                return original(self, _cmd);
            }
        }
        void swizzle() {
            Method method = class_getInstanceMethod(objc_lookUpClass("DBApplicationInfo"), sel_registerName("supportsDashboardNavigation"));
            original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
            method_setImplementation(method, reinterpret_cast<IMP>(custom));
        }
    }
}

__attribute__((constructor)) void init(void) {
    dne_DBApplicationInfo::supportsDashboardNavigation::swizzle();
}
