//
//  DeviceActivityMonitorExtension.mm
//  DeviceActivityMonitorExtensionObjC
//
//  Created by Jinwoo Kim on 4/25/25.
//

#import "DeviceActivityMonitorExtension.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface DeviceActivityMonitorExtension ()
@property (retain, nonatomic, readonly, getter=_managedSettingsConnection) NSXPCConnection *managedSettingsConnection;
@property (retain, nonatomic, readonly, getter=_usageTrackingConnection) NSXPCConnection *usageTrackingConnection;
- (void)intervalDidStartForActivity:(NSString *)activity replyHandler:(void (^)(NSError * _Nullable error))replyHandler;
- (void)intervalDidEndForActivity:(NSString *)activity replyHandler:(void (^ NS_NOESCAPE)(NSError * _Nullable error))replyHandler;
@end

namespace sco_MonitorContext {
    
    namespace intervalDidStartForActivity_replyHandler_ {
        void (*original)(id self, SEL _cmd, NSString *activity, void (^replyHandler)(NSError * _Nullable error));
        void custom(id self, SEL _cmd, NSString *activity, void (^replyHandler)(NSError * _Nullable error)) {
            DeviceActivityMonitorExtension *_principalObject = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("_principalObject"));
            assert([_principalObject isKindOfClass:[DeviceActivityMonitorExtension class]]);
            [_principalObject intervalDidStartForActivity:activity replyHandler:replyHandler];
        }
        void swizzle() {
            Method method = class_getInstanceMethod(objc_lookUpClass("_TtC14DeviceActivity28DeviceActivityMonitorContext"), sel_registerName("intervalDidStartForActivity:replyHandler:"));
            assert(method != NULL);
            original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
            method_setImplementation(method, reinterpret_cast<IMP>(custom));
        }
    }
    
    namespace intervalDidEndForActivity_replyHandler_ {
        void (*original)(id self, SEL _cmd, NSString *activity, void (^replyHandler)(NSError * _Nullable error));
        void custom(id self, SEL _cmd, NSString *activity, void (^replyHandler)(NSError * _Nullable error)) {
            DeviceActivityMonitorExtension *_principalObject = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("_principalObject"));
            assert([_principalObject isKindOfClass:[DeviceActivityMonitorExtension class]]);
            [_principalObject intervalDidEndForActivity:activity replyHandler:replyHandler];
        }
        void swizzle() {
            Method method = class_getInstanceMethod(objc_lookUpClass("_TtC14DeviceActivity28DeviceActivityMonitorContext"), sel_registerName("intervalDidEndForActivity:replyHandler:"));
            assert(method != NULL);
            original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
            method_setImplementation(method, reinterpret_cast<IMP>(custom));
        }
    }
    
    namespace intervalWillStartWarningForActivity_replyHandler_ {
        // TODO
    }
    
    namespace intervalWillEndWarningForActivity_replyHandler_ {
        // TODO
    }
    
    namespace eventDidReachThreshold_activity_replyHandler_ {
        // TODO
    }
    
    namespace eventDidUnreachThreshold_activity_replyHandler_ {
        // TODO
    }
    
    namespace eventWillReachThresholdWarning_activity_replyHandler_ {
        // TODO
    }
    
}

@implementation DeviceActivityMonitorExtension

+ (void)load {
    using namespace sco_MonitorContext;
    intervalDidStartForActivity_replyHandler_::swizzle();
    intervalDidEndForActivity_replyHandler_::swizzle();
}

- (instancetype)init {
    if (self = [super init]) {
        _managedSettingsConnection = reinterpret_cast<id (*)(id, SEL, id, NSXPCConnectionOptions)>(objc_msgSend)([NSXPCConnection alloc], sel_registerName("initWithMachServiceName:options:"), @"com.apple.ManagedSettingsAgent", NSXPCConnectionPrivileged);
        _managedSettingsConnection.remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:NSProtocolFromString(@"_TtP15ManagedSettings20ManagedSettingsAgent_")];
        _managedSettingsConnection.interruptionHandler = ^{
//            abort();
        };
        [_managedSettingsConnection resume];
        
        _usageTrackingConnection = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("USTrackingAgentConnection"), sel_registerName("newConnection"));
        _usageTrackingConnection.interruptionHandler = ^{
//            abort();
        };
        [_usageTrackingConnection resume];
    }
    
    return self;
}

- (void)dealloc {
    [_managedSettingsConnection invalidate];
    [_managedSettingsConnection release];
    [_usageTrackingConnection invalidate];
    [_usageTrackingConnection release];
    [super dealloc];
}

- (void)intervalDidStartForActivity:(NSString *)activity replyHandler:(void (^)(NSError * _Nullable error))replyHandler {
    reinterpret_cast<void (*)(id, SEL, id, id)>(objc_msgSend)(_usageTrackingConnection.remoteObjectProxy, sel_registerName("fetchActivitiesForClient:replyHandler:"), nil, ^(NSArray<NSString *> * _Nullable activities, NSError * _Nullable error) {
        if (error != nil) {
            replyHandler(error);
            return;
        }
        
        for (NSString *activity in activities) {
            reinterpret_cast<void (*)(id, SEL, id, id, id)>(objc_msgSend)(_usageTrackingConnection.remoteObjectProxy, sel_registerName("fetchEventsForActivity:withClient:replyHandler:"), activity, nil, ^(NSDictionary * _Nullable events, NSError * _Nullable error) {
                if (error != nil) {
                    replyHandler(error);
                    return;
                }
                
                NSMutableArray *array = [NSMutableArray new];
                for (id event in events.allValues) {
                    NSSet<NSData *> *_applicationTokens = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(event, sel_registerName("applicationTokens"));
                    for (NSData *token in _applicationTokens) {
                        [array addObject:@{@"token": @{@"data": token}}];
                    }
                }
                
                reinterpret_cast<void (*)(id, SEL, id, id, id, id, id)>(objc_msgSend)(_managedSettingsConnection.remoteObjectProxy, sel_registerName("setValues:recordIdentifier:storeContainer:storeName:replyHandler:"), @{
                    @"shield.applications": array
                }, nil, @"com.pookjw.MyScreenTimeObjC", @"Test", ^(NSUUID * _Nullable recordIdentifier, NSError * _Nullable error) {
                    replyHandler(error);
                });
                
                [array release];
            });
        }
    });
}

- (void)intervalDidEndForActivity:(NSString *)activity replyHandler:(void (^ NS_NOESCAPE)(NSError * _Nullable error))replyHandler {
    reinterpret_cast<void (*)(id, SEL, id, id, id, id, id)>(objc_msgSend)(_managedSettingsConnection.remoteObjectProxy, sel_registerName("removeValuesForSettingNames:recordIdentifier:storeContainer:storeName:replyHandler:"), @[@"shield.applications"], nil, @"com.pookjw.MyScreenTimeObjC", @"Test", ^(NSUUID * _Nullable recordIdentifier, NSError * _Nullable error) {
        replyHandler(error);
    });
}

@end
