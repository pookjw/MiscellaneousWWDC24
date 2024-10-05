//
//  WatchConnectivityViewController.m
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 10/5/24.
//

#import "WatchConnectivityViewController.h"
#import <UIKit/UIKit.h>
#import <WatchConnectivity/WatchConnectivity.h>
#import <objc/message.h>
#import <objc/runtime.h>

#warning -[WCSession delegateSupportsActiveDeviceSwitch]

OBJC_EXPORT id objc_msgSendSuper2(void);

@interface WatchConnectivityViewController () <WCSessionDelegate>

@end

@implementation WatchConnectivityViewController

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
        Class _dynamicIsa = objc_allocateClassPair(objc_lookUpClass("SPViewController"), "_WatchConnectivityViewController", 0);
        
        assert(class_addProtocol(_dynamicIsa, @protocol(WCSessionDelegate)));
        
        IMP dealloc = class_getMethodImplementation(self, @selector(dealloc));
        assert(class_addMethod(_dynamicIsa, @selector(dealloc), dealloc, NULL));
        
        IMP respondsToSelector = class_getMethodImplementation(self, @selector(respondsToSelector:));
        assert(class_addMethod(_dynamicIsa, @selector(respondsToSelector:), respondsToSelector, NULL));
        
        IMP loadView = class_getMethodImplementation(self, @selector(loadView));
        assert(class_addMethod(_dynamicIsa, @selector(loadView), loadView, NULL));
        
        IMP viewDidLoad = class_getMethodImplementation(self, @selector(viewDidLoad));
        assert(class_addMethod(_dynamicIsa, @selector(viewDidLoad), viewDidLoad, NULL));
        
        IMP didTriggerActionMenuBarButtonItem = class_getMethodImplementation(self, @selector(didTriggerActionMenuBarButtonItem:));
        assert(class_addMethod(_dynamicIsa, @selector(didTriggerActionMenuBarButtonItem:), didTriggerActionMenuBarButtonItem, NULL));
        
        IMP session_activationDidCompleteWithState_error = class_getMethodImplementation(self, @selector(session:activationDidCompleteWithState:error:));
        assert(class_addMethod(_dynamicIsa, @selector(session:activationDidCompleteWithState:error:), session_activationDidCompleteWithState_error, NULL));
        
        IMP session_didReceiveMessage = class_getMethodImplementation(self, @selector(session:didReceiveMessage:));
        assert(class_addMethod(_dynamicIsa, @selector(session:didReceiveMessage:), session_didReceiveMessage, NULL));
        
        IMP session_didReceiveMessage_replyHandler = class_getMethodImplementation(self, @selector(session:didReceiveMessage:replyHandler:));
        assert(class_addMethod(_dynamicIsa, @selector(session:didReceiveMessage:replyHandler:), session_didReceiveMessage_replyHandler, NULL));
        
        assert(class_addIvar(_dynamicIsa, "_session", sizeof(id), sizeof(id), @encode(id)));
        assert(class_addIvar(_dynamicIsa, "_statusLabel", sizeof(id), sizeof(id), @encode(id)));
        
        //
        
        objc_registerClassPair(_dynamicIsa);
        
        dynamicIsa = _dynamicIsa;
    });
    
    return dynamicIsa;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"
- (void)dealloc {
    WCSession *_session;
    assert(object_getInstanceVariable(self, "_session", reinterpret_cast<void **>(&_session)) != nullptr);
    [_session release];
    
    id _statusLabel;
    assert(object_getInstanceVariable(self, "_statusLabel", reinterpret_cast<void **>(&_statusLabel)) != nullptr);
    [_statusLabel release];
    
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
}
#pragma clang diagnostic pop

- (BOOL)respondsToSelector:(SEL)aSelector {
    objc_super superInfo = { self, [self class] };
    BOOL responds = reinterpret_cast<BOOL (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
    
    if (!responds) {
        NSLog(@"%s", sel_getName(aSelector));
    }
    
    return responds;
}

- (void)loadView {
    id statusLabel = [self statusLabel];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setView:"), statusLabel);
}

- (void)viewDidLoad {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
    
    assert(WCSession.isSupported);
    
    //
    
    id actionMenuBarButtonItem = reinterpret_cast<id (*)(id, SEL, id, NSInteger, id, SEL)>(objc_msgSend)([objc_lookUpClass("UIBarButtonItem") alloc], sel_registerName("initWithImage:style:target:action:"), [UIImage systemImageNamed:@"scribble"], 0, self, @selector(didTriggerActionMenuBarButtonItem:));
    id navigationItem = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("navigationItem"));
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(navigationItem, sel_registerName("setRightBarButtonItems:"), @[actionMenuBarButtonItem]);
    [actionMenuBarButtonItem release];
    
    //
    
    [self updateStatusLabel];
}

- (WCSession *)session __attribute__((objc_direct)) {
    WCSession *session = nil;
    assert(object_getInstanceVariable(self, "_session", reinterpret_cast<void **>(&session)) != nullptr);
    if (session != nil) {
        return session;
    }
    
    session = WCSession.defaultSession;
    session.delegate = self;
    
    assert(object_setInstanceVariable(self, "_session", reinterpret_cast<void *>([session retain])) != nullptr);
    return session;
}

- (id)statusLabel __attribute__((objc_direct)) {
    id statusLabel = nil;
    assert(object_getInstanceVariable(self, "_statusLabel", reinterpret_cast<void **>(&statusLabel)) != nullptr);
    if (statusLabel != nil) {
        return statusLabel;
    }
    
    statusLabel = [objc_lookUpClass("UILabel") new];
    reinterpret_cast<void (*)(id, SEL, NSTextAlignment)>(objc_msgSend)(statusLabel, sel_registerName("setTextAlignment:"), NSTextAlignmentCenter);
    reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(statusLabel, sel_registerName("setNumberOfLines:"), 0);
    
    assert(object_setInstanceVariable(self, "_statusLabel", reinterpret_cast<void *>([statusLabel retain])) != nullptr);
    return [statusLabel autorelease];
}

- (void)didTriggerActionMenuBarButtonItem:(id)sender {
    __weak auto weakSelf = self;
    
    id activateAction = reinterpret_cast<id (*)(id, SEL, id, id, id, id, NSInteger, NSInteger, NSUInteger, id)>(objc_msgSend)([objc_lookUpClass("PUICMenuAction") alloc], sel_registerName("initWithTitle:detail:image:identifier:style:state:attributes:handler:"), @"Activate", nil, nil, @"activateAction", 0, 0, 0, ^(id action) {
        [weakSelf dismissPresentedViewController];
        [[weakSelf session] activateSession];
    });
    
    id sendMessageAction = reinterpret_cast<id (*)(id, SEL, id, id, id, id, NSInteger, NSInteger, NSUInteger, id)>(objc_msgSend)([objc_lookUpClass("PUICMenuAction") alloc], sel_registerName("initWithTitle:detail:image:identifier:style:state:attributes:handler:"), @"Send Message", nil, nil, @"sendMessageAction", 0, 0, 0, ^(id action) {
        [weakSelf dismissPresentedViewController];
        
        [[weakSelf session] sendMessage:@{@"timestamp": [NSDate now]} replyHandler:nil errorHandler:^(NSError * _Nonnull error) {
            abort();
        }];
    });
    
    id menuViewController = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("PUICMenuViewController") alloc], sel_registerName("initWithMenuElements:"), @[
        activateAction,
        sendMessageAction
    ]);
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(menuViewController, sel_registerName("setDelegate:"), self);
    
    reinterpret_cast<void (*)(id, SEL, id, BOOL, id)>(objc_msgSend)(self, sel_registerName("presentViewController:animated:completion:"), menuViewController, YES, nil);
    [menuViewController release];
}

- (void)dismissPresentedViewController __attribute__((objc_direct)) {
    id presentedViewController = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("presentedViewController"));
    reinterpret_cast<void (*)(id, SEL, BOOL, id)>(objc_msgSend)(presentedViewController, sel_registerName("dismissViewControllerAnimated:completion:"), YES, nil);
}

- (void)updateStatusLabel __attribute__((objc_direct)) {
    WCSession *sessoin = [self session];
    WCSessionActivationState activationState = sessoin.activationState;
    
    NSString *activationStateString;
    switch (activationState) {
        case WCSessionActivationStateNotActivated:
            activationStateString = @"Not Activated";
            break;
        case WCSessionActivationStateInactive:
            activationStateString = @"Inactive";
            break;
        case WCSessionActivationStateActivated:
            activationStateString = @"Activated";
            break;
        default:
            activationStateString = @"Unknown";
            break;
    }
    
    NSString *isReachableString = sessoin.isReachable ? @"Reachable" : @"Not Reachable";
    
    id statusLabel = [self statusLabel];
    NSString *text = [NSString stringWithFormat:@"%@\n%@", activationStateString, isReachableString];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(statusLabel, sel_registerName("setText:"), text);
}

- (void)session:(nonnull WCSession *)session activationDidCompleteWithState:(WCSessionActivationState)activationState error:(nullable NSError *)error {
    if (activationState == WCSessionActivationStateActivated) {
        assert(session.isCompanionAppInstalled);
        assert(!session.iOSDeviceNeedsUnlockAfterRebootForReachability);
        
        NSError *error = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(session, sel_registerName("errorIfNotReachable"));
        NSLog(@"%@", error);
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateStatusLabel];
    });
}

- (void)sessionReachabilityDidChange:(WCSession *)session {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateStatusLabel];
    });
}

- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message {
    
}

- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message replyHandler:(void (^)(NSDictionary<NSString *,id> * _Nonnull))replyHandler {
    
}

@end
