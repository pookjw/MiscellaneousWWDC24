//
//  ViewController.m
//  MiscellaneousPepperUICore
//
//  Created by Jinwoo Kim on 10/5/24.
//

#import "ViewController.h"
#import <WatchConnectivity/WatchConnectivity.h>
#import <objc/message.h>
#import <objc/runtime.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

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

@interface ViewController () <WCSessionDelegate>
@property (retain, nonatomic, readonly) WCSession *session;
@property (retain, nonatomic, readonly) UIStackView *stackView;
@property (retain, nonatomic, readonly) UILabel *statusLabel;
@end

@implementation ViewController
@synthesize session = _session;
@synthesize stackView = _stackView;
@synthesize statusLabel = _statusLabel;

+ (void)load {
//    mpuc_WCSession::outstandingUserInfoTransfers::swizzle();
//    mpuc_WCSession::outstandingFileTransfers::swizzle();
}

- (void)dealloc {
    [_session release];
    [_stackView release];
    [_statusLabel release];
    [super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"outstandingUserInfoTransfers"] or [keyPath isEqualToString:@"outstandingFileTransfers"]) {
        NSLog(@"Hello!");
        return;
    }
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    assert([WCSession isSupported]);
    
    UIStackView *stackView = self.stackView;
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:stackView];
    [NSLayoutConstraint activateConstraints:@[
        [stackView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [stackView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [stackView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
        [stackView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
    ]];
    //
    
    [self updateStatusLabel];
    
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    
    //
    
    __weak auto weakSelf = self;
    
    UIAction *activateAction = [UIAction actionWithTitle:@"Activate" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        [weakSelf.session activateSession];
    }];
    
    UIAction *sendDateAction = [UIAction actionWithTitle:@"Send Date" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        [weakSelf.session sendMessage:@{@"action": @"showDate", @"date": NSDate.now} replyHandler:nil errorHandler:^(NSError * _Nonnull error) {
            abort();
        }];
    }];
    
    UIAction *getOXAction = [UIAction actionWithTitle:@"Get O/X" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        [weakSelf.session sendMessage:@{@"action": @"getOX"}
                         replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
            NSString *result = replyMessage[@"result"];
            assert(result != nil);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Result" message:result preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *doneAlertAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alertController addAction:doneAlertAction];
                
                [weakSelf presentViewController:alertController animated:YES completion:nil];
            });
        }
                         errorHandler:^(NSError * _Nonnull error) {
            abort();
        }];
    }];
    
    UIAction *sendFileAction = [UIAction actionWithTitle:@"Send File" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        NSURL *url = [NSBundle.mainBundle URLForResource:@"demo" withExtension:UTTypeHEIC.preferredFilenameExtension];
        assert(url != nil);
        [weakSelf.session transferFile:url metadata:nil];
    }];
    
    UIAction *transferUserInfoAction = [UIAction actionWithTitle:@"Transfer UserInfo" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        [weakSelf.session transferUserInfo:@{@"timestamp": NSDate.now}];
    }];
    
    UIAction *updateApplicationContextAction = [UIAction actionWithTitle:@"Update Application Context" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        NSError * _Nullable error = nil;
        [weakSelf.session updateApplicationContext:@{@"timestamp": NSDate.now} error:&error];
        assert(error == nil);
        
        [weakSelf updateStatusLabel];
    }];
    
    UIMenu *actionMenu = [UIMenu menuWithChildren:@[
        activateAction,
        sendDateAction,
        getOXAction,
        sendFileAction,
        transferUserInfoAction,
        updateApplicationContextAction
    ]];
    
    UIBarButtonItem *actionMenuBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"list.bullet"]  menu:actionMenu];
    self.navigationItem.rightBarButtonItems = @[actionMenuBarButtonItem];
    [actionMenuBarButtonItem release];
}

- (void)viewIsAppearing:(BOOL)animated {
    [super viewIsAppearing:animated];
}

- (WCSession *)session {
    if (auto session = _session) return session;
    
    WCSession *session = WCSession.defaultSession;
    session.delegate = self;
    
    [session addObserver:self forKeyPath:@"outstandingUserInfoTransfers" options:NSKeyValueObservingOptionNew context:NULL];
    [session addObserver:self forKeyPath:@"outstandingFileTransfers" options:NSKeyValueObservingOptionNew context:NULL];
    
    _session = [session retain];
    return session;
}

- (UIStackView *)stackView {
    if (auto stackView = _stackView) return stackView;
    
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[
        self.statusLabel
    ]];
    
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.distribution = UIStackViewDistributionFillEqually;
    stackView.alignment = UIStackViewAlignmentFill;
    
    _stackView = [stackView retain];
    return [stackView autorelease];
}

- (UILabel *)statusLabel {
    if (auto statusLabel = _statusLabel) return statusLabel;
    
    UILabel *statusLabel = [UILabel new];
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.numberOfLines = 0;
    statusLabel.adjustsFontSizeToFitWidth = YES;
    statusLabel.minimumScaleFactor = 0.001;
    
    _statusLabel = [statusLabel retain];
    return [statusLabel autorelease];
}

- (void)updateStatusLabel {
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
    
    NSDictionary<NSString *, id> *applicationContext = self.session.applicationContext;
    NSDictionary<NSString *, id> *receivedApplicationContext = self.session.receivedApplicationContext;
    
    NSString *text = [NSString stringWithFormat:@"%@\n%@\napplicationContext : %@\nreceivedApplicationContext : %@", activationStateString, isReachableString, applicationContext, receivedApplicationContext];
    self.statusLabel.text = text;
}

- (void)sessionReachabilityDidChange:(WCSession *)session {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateStatusLabel];
    });
}

- (void)session:(WCSession *)session activationDidCompleteWithState:(WCSessionActivationState)activationState error:(NSError *)error {
    assert(error == nil);
    
    if (activationState == WCSessionActivationStateActivated) {
//        assert(WCSession.defaultSession.watchAppInstalled);
        assert(WCSession.defaultSession.isPaired);
        
        NSError *error = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(session, sel_registerName("errorIfNotReachable"));
        NSLog(@"%@", error);
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateStatusLabel];
    });
}

- (void)sessionDidBecomeInactive:(WCSession *)session {
    
}

- (void)sessionDidDeactivate:(WCSession *)session {
    
}

- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message {
    NSString *action = message[@"action"];
    assert(action != nil);
    
    if ([action isEqualToString:@"showDate"]) {
        NSDate *date = message[@"date"];
        assert(date != nil);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Date" message:date.description preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *doneAlertAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:doneAlertAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
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
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"O/X" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *oAlertAction = [UIAlertAction actionWithTitle:@"O" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                replyHandler(@{@"result": @"O"});
            }];
            [alertController addAction:oAlertAction];
            
            UIAlertAction *xAlertAction = [UIAlertAction actionWithTitle:@"X" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                replyHandler(@{@"result": @"X"});
            }];
            [alertController addAction:xAlertAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
        });
    } else {
        abort();
    }
}

- (void)session:(WCSession *)session didReceiveUserInfo:(NSDictionary<NSString *,id> *)userInfo {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"UserInfo" message:userInfo.description preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *doneAlertAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:doneAlertAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

- (void)session:(WCSession *)session didFinishUserInfoTransfer:(WCSessionUserInfoTransfer *)userInfoTransfer error:(NSError *)error {
    
}

- (void)session:(WCSession *)session didReceiveApplicationContext:(NSDictionary<NSString *,id> *)applicationContext {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Application Context" message:session.receivedApplicationContext.description preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *doneAlertAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:doneAlertAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        [self updateStatusLabel];
    });
}

- (void)session:(WCSession *)session didReceiveFile:(WCSessionFile *)file {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSURL *fileURL = file.fileURL;
        UIImage *image = [UIImage imageWithContentsOfFile:fileURL.path];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView.heightAnchor constraintEqualToAnchor:imageView
         .widthAnchor].active = YES;
        UIViewController *contentViewController = [UIViewController new];
        contentViewController.view = imageView;
        [imageView release];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Title" message:@"Message" preferredStyle:UIAlertControllerStyleAlert];
        
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(alertController, sel_registerName("setContentViewController:"), contentViewController);
        [contentViewController release];
        
        UIAlertAction *doneAlertAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:doneAlertAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

@end
