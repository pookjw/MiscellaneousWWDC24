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
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

#warning -[WCSession delegateSupportsActiveDeviceSwitch]

OBJC_EXPORT id objc_msgSendSuper2(void);

@interface WatchConnectivityViewController () <WCSessionDelegate>

@end

@implementation WatchConnectivityViewController

+ (void)load {
    [self class];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [[self class] allocWithZone:zone];
}

+ (Class)class {
    static Class isa;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class _isa = objc_allocateClassPair(objc_lookUpClass("SPViewController"), "_WatchConnectivityViewController", 0);
        
        assert(class_addProtocol(_isa, @protocol(WCSessionDelegate)));
        
        IMP dealloc = class_getMethodImplementation(self, @selector(dealloc));
        assert(class_addMethod(_isa, @selector(dealloc), dealloc, NULL));
        
        IMP respondsToSelector = class_getMethodImplementation(self, @selector(respondsToSelector:));
        assert(class_addMethod(_isa, @selector(respondsToSelector:), respondsToSelector, NULL));
        
        IMP observeValueForKeyPath_ofObject_change_context = class_getMethodImplementation(self, @selector(observeValueForKeyPath:ofObject:change:context:));
        assert(class_addMethod(_isa, @selector(observeValueForKeyPath:ofObject:change:context:), observeValueForKeyPath_ofObject_change_context, NULL));
        
        IMP loadView = class_getMethodImplementation(self, @selector(loadView));
        assert(class_addMethod(_isa, @selector(loadView), loadView, NULL));
        
        IMP viewDidLoad = class_getMethodImplementation(self, @selector(viewDidLoad));
        assert(class_addMethod(_isa, @selector(viewDidLoad), viewDidLoad, NULL));
        
        IMP didTriggerActionMenuBarButtonItem = class_getMethodImplementation(self, @selector(didTriggerActionMenuBarButtonItem:));
        assert(class_addMethod(_isa, @selector(didTriggerActionMenuBarButtonItem:), didTriggerActionMenuBarButtonItem, NULL));
        
        IMP session_activationDidCompleteWithState_error = class_getMethodImplementation(self, @selector(session:activationDidCompleteWithState:error:));
        assert(class_addMethod(_isa, @selector(session:activationDidCompleteWithState:error:), session_activationDidCompleteWithState_error, NULL));
        
        IMP session_didReceiveMessage = class_getMethodImplementation(self, @selector(session:didReceiveMessage:));
        assert(class_addMethod(_isa, @selector(session:didReceiveMessage:), session_didReceiveMessage, NULL));
        
        IMP sessionReachabilityDidChange = class_getMethodImplementation(self, @selector(sessionReachabilityDidChange:));
        assert(class_addMethod(_isa, @selector(sessionReachabilityDidChange:), sessionReachabilityDidChange, NULL));
        
        IMP session_didReceiveMessage_replyHandler = class_getMethodImplementation(self, @selector(session:didReceiveMessage:replyHandler:));
        assert(class_addMethod(_isa, @selector(session:didReceiveMessage:replyHandler:), session_didReceiveMessage_replyHandler, NULL));
        
        IMP session_didReceiveUserInfo = class_getMethodImplementation(self, @selector(session:didReceiveUserInfo:));
        assert(class_addMethod(_isa, @selector(session:didReceiveUserInfo:), session_didReceiveUserInfo, NULL));
        
        IMP session_didFinishUserInfoTransfer_error = class_getMethodImplementation(self, @selector(session:didFinishUserInfoTransfer:error:));
        assert(class_addMethod(_isa, @selector(session:didFinishUserInfoTransfer:error:), session_didFinishUserInfoTransfer_error, NULL));
        
        IMP session_didReceiveApplicationContext = class_getMethodImplementation(self, @selector(session:didReceiveApplicationContext:));
        assert(class_addMethod(_isa, @selector(session:didReceiveApplicationContext:), session_didReceiveApplicationContext, NULL));
        
        IMP session_didReceiveFile = class_getMethodImplementation(self, @selector(session:didReceiveFile:));
        assert(class_addMethod(_isa, @selector(session:didReceiveFile:), session_didReceiveFile, NULL));
        
        assert(class_addIvar(_isa, "_session", sizeof(id), sizeof(id), @encode(id)));
        assert(class_addIvar(_isa, "_statusLabel", sizeof(id), sizeof(id), @encode(id)));
        
        //
        
        objc_registerClassPair(_isa);
        
        isa = _isa;
    });
    
    return isa;
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"outstandingUserInfoTransfers"]) {
        NSLog(@"Hello!");
        return;
    }
    
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
}

- (void)loadView {
    id statusLabel = [self statusLabel];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setView:"), statusLabel);
}

- (void)viewDidLoad {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
    
    assert([WCSession isSupported]);
    
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
    
    [session addObserver:self forKeyPath:@"outstandingUserInfoTransfers" options:NSKeyValueObservingOptionNew context:NULL];
    
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
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(statusLabel, sel_registerName("setAdjustsFontSizeToFitWidth:"), YES);
    reinterpret_cast<void (*)(id, SEL, CGFloat)>(objc_msgSend)(statusLabel, sel_registerName("setMinimumScaleFactor:"), 0.001);
    
    assert(object_setInstanceVariable(self, "_statusLabel", reinterpret_cast<void *>([statusLabel retain])) != nullptr);
    return [statusLabel autorelease];
}

- (void)didTriggerActionMenuBarButtonItem:(id)sender {
    __weak auto weakSelf = self;
    
    id activateAction = reinterpret_cast<id (*)(id, SEL, id, id, id, id, NSInteger, NSInteger, NSUInteger, id)>(objc_msgSend)([objc_lookUpClass("PUICMenuAction") alloc], sel_registerName("initWithTitle:detail:image:identifier:style:state:attributes:handler:"), @"Activate", nil, nil, @"activateAction", 0, 0, 0, ^(id action) {
        [weakSelf dismissPresentedViewController];
        [[weakSelf session] activateSession];
    });
    
    id sendDateAction = reinterpret_cast<id (*)(id, SEL, id, id, id, id, NSInteger, NSInteger, NSUInteger, id)>(objc_msgSend)([objc_lookUpClass("PUICMenuAction") alloc], sel_registerName("initWithTitle:detail:image:identifier:style:state:attributes:handler:"), @"Send Date", nil, nil, @"sendDateAction", 0, 0, 0, ^(id action) {
        [weakSelf dismissPresentedViewController];
        
        [[weakSelf session] sendMessage:@{@"action": @"showDate", @"date": NSDate.now} replyHandler:nil errorHandler:^(NSError * _Nonnull error) {
            abort();
        }];
    });
    
    id getOXAction = reinterpret_cast<id (*)(id, SEL, id, id, id, id, NSInteger, NSInteger, NSUInteger, id)>(objc_msgSend)([objc_lookUpClass("PUICMenuAction") alloc], sel_registerName("initWithTitle:detail:image:identifier:style:state:attributes:handler:"), @"Get O/X", nil, nil, @"getOXAction", 0, 0, 0, ^(id action) {
        [weakSelf dismissPresentedViewController];
        
        [[weakSelf session] sendMessage:@{@"action": @"getOX"}
                           replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
            NSString *result = replyMessage[@"result"];
            assert(result != nil);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                id alertController = reinterpret_cast<id (*)(Class, SEL, id, id, NSInteger)>(objc_msgSend)(objc_lookUpClass("UIAlertController"), sel_registerName("alertControllerWithTitle:message:preferredStyle:"), @"Result", result, 1);
                
                id alertAction = reinterpret_cast<id (*)(Class, SEL, id, NSInteger, id)>(objc_msgSend)(objc_lookUpClass("UIAlertAction"), sel_registerName("actionWithTitle:style:handler:"), @"Done", 0, ^(id alertAction) {});
                
                reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(alertController, sel_registerName("addAction:"), alertAction);
                
                reinterpret_cast<void (*)(id, SEL, id, BOOL, id)>(objc_msgSend)(weakSelf, sel_registerName("presentViewController:animated:completion:"), alertController, YES, nil);
            });
        }
                           errorHandler:^(NSError * _Nonnull error) {
            abort();
        }];
    });
    
    id sendFileAction = reinterpret_cast<id (*)(id, SEL, id, id, id, id, NSInteger, NSInteger, NSUInteger, id)>(objc_msgSend)([objc_lookUpClass("PUICMenuAction") alloc], sel_registerName("initWithTitle:detail:image:identifier:style:state:attributes:handler:"), @"Send File", nil, nil, @"sendFileAction", 0, 0, 0, ^(id action) {
        [weakSelf dismissPresentedViewController];
        
        NSURL *url = [NSBundle.mainBundle URLForResource:@"demo" withExtension:UTTypeHEIC.preferredFilenameExtension];
        assert(url != nil);
        [[weakSelf session] transferFile:url metadata:nil];
//        [[weakSelf session] ];
    });
    
    id transferUserInfoAction = reinterpret_cast<id (*)(id, SEL, id, id, id, id, NSInteger, NSInteger, NSUInteger, id)>(objc_msgSend)([objc_lookUpClass("PUICMenuAction") alloc], sel_registerName("initWithTitle:detail:image:identifier:style:state:attributes:handler:"), @"Transfer UserInfo", nil, nil, @"transferUserInfoAction", 0, 0, 0, ^(id action) {
        [weakSelf dismissPresentedViewController];
        
        [[weakSelf session] transferUserInfo:@{@"timestamp": NSDate.now}];
    });
    
    id updateApplicationContextAction = reinterpret_cast<id (*)(id, SEL, id, id, id, id, NSInteger, NSInteger, NSUInteger, id)>(objc_msgSend)([objc_lookUpClass("PUICMenuAction") alloc], sel_registerName("initWithTitle:detail:image:identifier:style:state:attributes:handler:"), @"Update Application Context", nil, nil, @"updateApplicationContextAction", 0, 0, 0, ^(id action) {
        [weakSelf dismissPresentedViewController];
        
        NSError * _Nullable error = nil;
        [[weakSelf session] updateApplicationContext:@{@"timestamp": NSDate.now} error:&error];
        assert(error == nil);
        
        [weakSelf updateStatusLabel];
    });
    
    id menuViewController = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("PUICMenuViewController") alloc], sel_registerName("initWithMenuElements:"), @[
        activateAction,
        sendDateAction,
        getOXAction,
        sendFileAction,
        transferUserInfoAction,
        updateApplicationContextAction
    ]);
    
    [activateAction release];
    [sendDateAction release];
    [getOXAction release];
    [sendFileAction release];
    [transferUserInfoAction release];
    [updateApplicationContextAction release];
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(menuViewController, sel_registerName("setDelegate:"), self);
    
    reinterpret_cast<void (*)(id, SEL, id, BOOL, id)>(objc_msgSend)(self, sel_registerName("presentViewController:animated:completion:"), menuViewController, YES, nil);
    [menuViewController release];
}

- (void)dismissPresentedViewController __attribute__((objc_direct)) {
    id presentedViewController = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("presentedViewController"));
    reinterpret_cast<void (*)(id, SEL, BOOL, id)>(objc_msgSend)(presentedViewController, sel_registerName("dismissViewControllerAnimated:completion:"), YES, nil);
}

- (void)updateStatusLabel __attribute__((objc_direct)) {
    WCSession *session = [self session];
    WCSessionActivationState activationState = session.activationState;
    
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
    
    NSString *isReachableString = session.isReachable ? @"Reachable" : @"Not Reachable";
    
    NSDictionary<NSString *, id> *applicationContext = session.applicationContext;
    NSDictionary<NSString *, id> *receivedApplicationContext = session.receivedApplicationContext;
    
    id statusLabel = [self statusLabel];
    NSString *text = [NSString stringWithFormat:@"%@\n%@\napplicationContext : %@\nreceivedApplicationContext : %@", activationStateString, isReachableString, applicationContext, receivedApplicationContext];
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
    NSString *action = message[@"action"];
    assert(action != nil);
    
    if ([action isEqualToString:@"showDate"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDate *date = message[@"date"];
            assert(date != nil);
            
            id alertController = reinterpret_cast<id (*)(Class, SEL, id, id, NSInteger)>(objc_msgSend)(objc_lookUpClass("UIAlertController"), sel_registerName("alertControllerWithTitle:message:preferredStyle:"), @"Date", date.description, 1);
            
            id alertAction = reinterpret_cast<id (*)(Class, SEL, id, NSInteger, id)>(objc_msgSend)(objc_lookUpClass("UIAlertAction"), sel_registerName("actionWithTitle:style:handler:"), @"Done", 0, ^(id alertAction) {});
            
            reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(alertController, sel_registerName("addAction:"), alertAction);
            
            reinterpret_cast<void (*)(id, SEL, id, BOOL, id)>(objc_msgSend)(self, sel_registerName("presentViewController:animated:completion:"), alertController, YES, nil);
        });
    } else {
        abort();
    }
}

- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message replyHandler:(void (^)(NSDictionary<NSString *,id> * _Nonnull))replyHandler {
    NSString *action = message[@"action"];
    assert(action != nil);
    
    if ([action isEqualToString:@"getOX"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            id alertController = reinterpret_cast<id (*)(Class, SEL, id, id, NSInteger)>(objc_msgSend)(objc_lookUpClass("UIAlertController"), sel_registerName("alertControllerWithTitle:message:preferredStyle:"), @"O/X", nil, 1);
            
            id oAlertAction = reinterpret_cast<id (*)(Class, SEL, id, NSInteger, id)>(objc_msgSend)(objc_lookUpClass("UIAlertAction"), sel_registerName("actionWithTitle:style:handler:"), @"O", 0, ^(id alertAction) {
                replyHandler(@{@"result": @"O"});
            });
            
            reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(alertController, sel_registerName("addAction:"), oAlertAction);
            
            id xAlertAction = reinterpret_cast<id (*)(Class, SEL, id, NSInteger, id)>(objc_msgSend)(objc_lookUpClass("UIAlertAction"), sel_registerName("actionWithTitle:style:handler:"), @"X", 0, ^(id alertAction) {
                replyHandler(@{@"result": @"X"});
            });
            
            reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(alertController, sel_registerName("addAction:"), xAlertAction);
            
            reinterpret_cast<void (*)(id, SEL, id, BOOL, id)>(objc_msgSend)(self, sel_registerName("presentViewController:animated:completion:"), alertController, YES, nil);
        });
    } else {
        abort();
    }
}

- (void)session:(WCSession *)session didReceiveUserInfo:(NSDictionary<NSString *,id> *)userInfo {
    dispatch_async(dispatch_get_main_queue(), ^{
        id alertController = reinterpret_cast<id (*)(Class, SEL, id, id, NSInteger)>(objc_msgSend)(objc_lookUpClass("UIAlertController"), sel_registerName("alertControllerWithTitle:message:preferredStyle:"), @"UserInfo", userInfo.description, 1);
        
        id alertAction = reinterpret_cast<id (*)(Class, SEL, id, NSInteger, id)>(objc_msgSend)(objc_lookUpClass("UIAlertAction"), sel_registerName("actionWithTitle:style:handler:"), @"Done", 0, ^(id alertAction) {});
        
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(alertController, sel_registerName("addAction:"), alertAction);
        
        reinterpret_cast<void (*)(id, SEL, id, BOOL, id)>(objc_msgSend)(self, sel_registerName("presentViewController:animated:completion:"), alertController, YES, nil);
    });
}

- (void)session:(WCSession *)session didFinishUserInfoTransfer:(WCSessionUserInfoTransfer *)userInfoTransfer error:(NSError *)error {
    assert(error == nil);
    dispatch_async(dispatch_get_main_queue(), ^{
        id alertController = reinterpret_cast<id (*)(Class, SEL, id, id, NSInteger)>(objc_msgSend)(objc_lookUpClass("UIAlertController"), sel_registerName("alertControllerWithTitle:message:preferredStyle:"), @"Sent", userInfoTransfer.userInfo.description, 1);
        
        id alertAction = reinterpret_cast<id (*)(Class, SEL, id, NSInteger, id)>(objc_msgSend)(objc_lookUpClass("UIAlertAction"), sel_registerName("actionWithTitle:style:handler:"), @"Done", 0, ^(id alertAction) {});
        
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(alertController, sel_registerName("addAction:"), alertAction);
        
        reinterpret_cast<void (*)(id, SEL, id, BOOL, id)>(objc_msgSend)(self, sel_registerName("presentViewController:animated:completion:"), alertController, YES, nil);
    });
}

- (void)session:(WCSession *)session didReceiveApplicationContext:(NSDictionary<NSString *,id> *)applicationContext {
    dispatch_async(dispatch_get_main_queue(), ^{
        id alertController = reinterpret_cast<id (*)(Class, SEL, id, id, NSInteger)>(objc_msgSend)(objc_lookUpClass("UIAlertController"), sel_registerName("alertControllerWithTitle:message:preferredStyle:"), @"Application Context", session.receivedApplicationContext.description, 1);
        
        id alertAction = reinterpret_cast<id (*)(Class, SEL, id, NSInteger, id)>(objc_msgSend)(objc_lookUpClass("UIAlertAction"), sel_registerName("actionWithTitle:style:handler:"), @"Done", 0, ^(id alertAction) {});
        
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(alertController, sel_registerName("addAction:"), alertAction);
        
        reinterpret_cast<void (*)(id, SEL, id, BOOL, id)>(objc_msgSend)(self, sel_registerName("presentViewController:animated:completion:"), alertController, YES, nil);
        
        [self updateStatusLabel];
    });
}

- (void)session:(WCSession *)session didReceiveFile:(WCSessionFile *)file {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSURL *fileURL = file.fileURL;
        UIImage *image = [UIImage imageWithContentsOfFile:fileURL.path];
        assert(image != nil);
        
        id sheetController = [objc_lookUpClass("PUICAlertSheetController") new];
        
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(sheetController, sel_registerName("setTitle:"), @"Title");
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(sheetController, sel_registerName("setMessage:"), @"Message");
        
        //
        
        id doneAction = reinterpret_cast<id (*)(Class, SEL, id, NSInteger, id)>(objc_msgSend)(objc_lookUpClass("PUICActionSheetItem"), sel_registerName("actionWithTitle:style:actionHandler:"), @"Done", 0, ^(id item) {
            
        });
        
        id group_1 = reinterpret_cast<id (*)(Class, SEL, id, id)>(objc_msgSend)(objc_lookUpClass("PUICActionSheetGroup"), sel_registerName("groupWithActions:title:"), @[doneAction], @"Group");
        
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(sheetController, sel_registerName("setGroups:"), @[group_1]);
        
        //
        
        id contentView = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(sheetController, sel_registerName("view"));
        CGRect contentViewBounds = reinterpret_cast<CGRect (*)(id, SEL)>(objc_msgSend)(contentView, sel_registerName("bounds"));
        
        CGRect supplementViewFrame = CGRectMake(0., 0., CGRectGetWidth(contentViewBounds), 100.);
        id supplementView = reinterpret_cast<id (*)(id, SEL, CGRect)>(objc_msgSend)([objc_lookUpClass("UIView") alloc], sel_registerName("initWithFrame:"), supplementViewFrame);
        reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(supplementView, sel_registerName("setAutoresizingMask:"), (1 << 1));
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(sheetController, sel_registerName("setSupplementView:"), supplementView);
        
        CGRect supplementViewBounds = reinterpret_cast<CGRect (*)(id, SEL)>(objc_msgSend)(supplementView, sel_registerName("bounds"));
        
        id imageView = reinterpret_cast<id (*)(id, SEL, CGRect)>(objc_msgSend)([objc_lookUpClass("UIImageView") alloc], sel_registerName("initWithFrame:"), supplementViewBounds);
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(imageView, sel_registerName("setImage:"), image);
        reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(imageView, sel_registerName("setAutoresizingMask:"), (1 << 1) | (1 << 4));
        reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(imageView, sel_registerName("setContentMode:"), 1);
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(supplementView, sel_registerName("addSubview:"), imageView);
        
        [supplementView release];
        [imageView release];
        
        //
        
        reinterpret_cast<void (*)(id, SEL, id, BOOL, id)>(objc_msgSend)(self, sel_registerName("presentViewController:animated:completion:"), sheetController, YES, nil);
        [sheetController release];
    });
}

@end
