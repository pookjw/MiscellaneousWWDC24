//
//  ShieldActionExtension.mm
//  ShieldActionExtensionObjC
//
//  Created by Jinwoo Kim on 4/25/25.
//

#import "ShieldActionExtension.h"
#import <objc/message.h>
#import <objc/runtime.h>

/*
 _TtC15ManagedSettings28ShieldActionExtensionContext
 */

@interface ShieldActionExtension ()
- (void)handleWithAction:(NSInteger)action applicationTokenData:(NSData *)applicationTokenData replyHandler:(void (^ NS_NOESCAPE)(NSNumber * _Nullable response, NSError * _Nullable error))replyHandler;
@end

namespace sco_ActionContext {
    
    namespace handleWithAction_applicationTokenData_replyHandler_ {
        void (*original)(id self, SEL _cmd, NSInteger action, NSData *applicationTokenData, void (^replyHandler)(NSNumber * _Nullable response, NSError * _Nullable error));
        void custom(id self, SEL _cmd, NSInteger action, NSData *applicationTokenData, void (^replyHandler)(NSNumber * _Nullable response, NSError * _Nullable error)) {
            ShieldActionExtension *_principalObject = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("_principalObject"));
            assert([_principalObject isKindOfClass:[ShieldActionExtension class]]);
            [_principalObject handleWithAction:action applicationTokenData:applicationTokenData replyHandler:replyHandler];
        }
        void swizzle() {
            Method method = class_getInstanceMethod(objc_lookUpClass("_TtC15ManagedSettings28ShieldActionExtensionContext"), sel_registerName("handleWithAction:applicationTokenData:replyHandler:"));
            assert(method != NULL);
            original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
            method_setImplementation(method, reinterpret_cast<IMP>(custom));
        }
    }
    
    
    namespace handleWithAction_categoryTokenData_replyHandler_ {
        // TODO
    }
    
    
    namespace handleWithAction_webDomainTokenData_replyHandler_ {
        // TODO
    }
}

@implementation ShieldActionExtension

+ (void)load {
    using namespace sco_ActionContext;
    handleWithAction_applicationTokenData_replyHandler_::swizzle();
}

- (void)handleWithAction:(NSInteger)action applicationTokenData:(NSData *)applicationTokenData replyHandler:(void (^ NS_NOESCAPE)(NSNumber * _Nullable, NSError * _Nullable))replyHandler {
    if (action == 1 /* primaryButtonPressed */) {
        replyHandler(@1 /* close */, nil);
    } else if (action == 2 /* secondaryButtonPressed */) {
        replyHandler(@2 /* defer */, nil);
    } else {
        replyHandler(@0 /* none */, nil);
    }
}

@end
