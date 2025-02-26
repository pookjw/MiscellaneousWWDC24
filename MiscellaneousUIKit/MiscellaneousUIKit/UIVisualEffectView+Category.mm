//
//  UIVisualEffectView+Category.m
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 2/26/25.
//

#import "UIVisualEffectView+Category.h"
#include <objc/message.h>
#include <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void); /* objc_super superInfo = { self, [self class] }; */

namespace mui_UIVisualEffectView {
    namespace _addSubview_positioned_relativeTo_ {
        void (*original)(UIVisualEffectView *self, SEL _cmd, UIView *subview, long position, id relative);
        void custom(UIVisualEffectView *self, SEL _cmd, UIView *subview, long position, id relative) {
            if ([subview isKindOfClass:objc_lookUpClass("_UIDebugAlignmentRectView")]) {
//                 objc_super superInfo = { self, [self class] };
//                 reinterpret_cast<void (*)(objc_super *, SEL, id, long, id)>(objc_msgSendSuper2)(&superInfo, _cmd, subview, position, relative);
                IMP imp = class_getMethodImplementation([UIView class], sel_registerName("_addSubview:positioned:relativeTo:"));
                reinterpret_cast<void (*)(id, SEL, id, long, id)>(imp)(self, _cmd, subview, position, relative);
                return;
            }

            original(self, _cmd, subview, position, relative);
        }
        void hook(void) {
            Method method = class_getInstanceMethod([UIVisualEffectView class], sel_registerName("_addSubview:positioned:relativeTo:"));
            original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
            method_setImplementation(method, reinterpret_cast<IMP>(custom));
        }
    }
}

@implementation UIVisualEffectView (Category)

+ (void)load {
    mui_UIVisualEffectView::_addSubview_positioned_relativeTo_::hook();
}

@end
