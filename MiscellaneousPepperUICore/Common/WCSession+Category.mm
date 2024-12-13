//
//  WCSession+Category.m
//  MiscellaneousPepperUICore
//
//  Created by Jinwoo Kim on 12/13/24.
//

#import "WCSession+Category.h"
#import <objc/message.h>
#import <objc/runtime.h>

namespace mpuc_WCSession {

namespace outstandingUserInfoTransfers {
NSArray<WCSessionUserInfoTransfer *> * (*original)(WCSession *self, SEL _cmd);
NSArray<WCSessionUserInfoTransfer *> * custom(WCSession *self, SEL _cmd) {
    NSOperationQueue *_workOperationQueue;
    assert(object_getInstanceVariable(self, "_workOperationQueue", reinterpret_cast<void **>(&_workOperationQueue)));
    
    if (![_workOperationQueue isEqual:NSOperationQueue.currentQueue]) {
        return original(self, _cmd);
    }
    
    NSDictionary *_internalOutstandingUserInfoTransfers;
    assert(object_getInstanceVariable(self, "_internalOutstandingUserInfoTransfers", reinterpret_cast<void **>(&_internalOutstandingUserInfoTransfers)));
    return _internalOutstandingUserInfoTransfers.allValues;
}
void swizzle() {
    Method method = class_getInstanceMethod(WCSession.class, sel_registerName("outstandingUserInfoTransfers"));
    original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}
}


namespace outstandingFileTransfers {
NSArray<WCSessionUserInfoTransfer *> * (*original)(WCSession *self, SEL _cmd);
NSArray<WCSessionUserInfoTransfer *> * custom(WCSession *self, SEL _cmd) {
    NSOperationQueue *_workOperationQueue;
    assert(object_getInstanceVariable(self, "_workOperationQueue", reinterpret_cast<void **>(&_workOperationQueue)));
    
    if (![_workOperationQueue isEqual:NSOperationQueue.currentQueue]) {
        return original(self, _cmd);
    }
    
    NSDictionary *_internalOutstandingFileTransfers;
    assert(object_getInstanceVariable(self, "_internalOutstandingFileTransfers", reinterpret_cast<void **>(&_internalOutstandingFileTransfers)));
    return _internalOutstandingFileTransfers.allValues;
}
void swizzle() {
    Method method = class_getInstanceMethod(WCSession.class, sel_registerName("outstandingFileTransfers"));
    original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}
}

}

@implementation WCSession (Category)

+ (void)load {
    mpuc_WCSession::outstandingUserInfoTransfers::swizzle();
    mpuc_WCSession::outstandingFileTransfers::swizzle();
}

@end
