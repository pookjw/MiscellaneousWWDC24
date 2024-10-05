//
//  ViewController.m
//  MiscellaneousPepperUICore
//
//  Created by Jinwoo Kim on 10/5/24.
//

#import "ViewController.h"
#import <WatchConnectivity/WatchConnectivity.h>
#import <objc/message.h>

@interface ViewController () <WCSessionDelegate>
@property (retain, nonatomic, readonly) WCSession *session;
@property (retain, nonatomic, readonly) UIStackView *stackView;
@property (retain, nonatomic, readonly) UILabel *statusLabel;
@end

@implementation ViewController
@synthesize session = _session;
@synthesize stackView = _stackView;
@synthesize statusLabel = _statusLabel;

- (void)dealloc {
    [_session release];
    [_stackView release];
    [_statusLabel release];
    [super dealloc];
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
    
    UIMenu *actionMenu = [UIMenu menuWithChildren:@[
        activateAction
    ]];
    
    UIBarButtonItem *actionMenuBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"list.bullet"]  menu:actionMenu];
    self.navigationItem.rightBarButtonItems = @[actionMenuBarButtonItem];
    [actionMenuBarButtonItem release];
}

- (WCSession *)session {
    if (auto session = _session) return session;
    
    WCSession *session = WCSession.defaultSession;
    session.delegate = self;
    
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
    
    NSString *text = [NSString stringWithFormat:@"%@\n%@", activationStateString, isReachableString];
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
        assert(WCSession.defaultSession.watchAppInstalled);
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
    
}

- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message replyHandler:(void (^)(NSDictionary<NSString *,id> * _Nonnull))replyHandler {
    
}

@end
