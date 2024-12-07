//
//  ApplicationCategoryViewController.m
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 12/4/24.
//

#import <TargetConditionals.h>

#if !TARGET_OS_VISION

#import "ApplicationCategoryViewController.h"

@interface ApplicationCategoryViewController ()
@property (retain, nonatomic, readonly) UIStackView *stackView;
@property (retain, nonatomic, readonly) UILabel *statusLabel;
@property (retain, nonatomic, readonly) UIButton *openDefaultApplicationsSettingsButton;
@end

@implementation ApplicationCategoryViewController
@synthesize stackView = _stackView;
@synthesize statusLabel = _statusLabel;
@synthesize openDefaultApplicationsSettingsButton = _openDefaultApplicationsSettingsButton;

- (void)dealloc {
    [_stackView release];
    [_statusLabel release];
    [_openDefaultApplicationsSettingsButton release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.stackView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    
    NSError * _Nullable error = nil;
    UIApplicationCategoryDefaultStatus status = [UIApplication.sharedApplication defaultStatusForCategory:UIApplicationCategoryWebBrowser error:&error];
    assert(error == nil);
    switch (status) {
        case UIApplicationCategoryDefaultStatusUnavailable:
            self.statusLabel.text = @"Unavailable";
            break;
        case UIApplicationCategoryDefaultStatusIsDefault:
            self.statusLabel.text = @"IsDefault";
            break;
        case UIApplicationCategoryDefaultStatusNotDefault:
            self.statusLabel.text = @"NotDefault";
            break;
        default:
            break;
    }
}

- (UIStackView *)stackView {
    if (auto stackView = _stackView) return stackView;
    
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[
        self.statusLabel,
        self.openDefaultApplicationsSettingsButton
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

- (UIButton *)openDefaultApplicationsSettingsButton {
    if (auto openDefaultApplicationsSettingsButton = _openDefaultApplicationsSettingsButton) return openDefaultApplicationsSettingsButton;
    
    UIButton *openDefaultApplicationsSettingsButton = [UIButton new];
    
    UIButtonConfiguration *configuration = [UIButtonConfiguration filledButtonConfiguration];
    configuration.title = UIApplicationOpenDefaultApplicationsSettingsURLString;
    
    openDefaultApplicationsSettingsButton.configuration = configuration;
    [openDefaultApplicationsSettingsButton addTarget:self action:@selector(didTriggerOpenDefaultApplicationsSettingsButton:) forControlEvents:UIControlEventPrimaryActionTriggered];
    
    _openDefaultApplicationsSettingsButton = [openDefaultApplicationsSettingsButton retain];
    return [openDefaultApplicationsSettingsButton autorelease];
}

- (void)didTriggerOpenDefaultApplicationsSettingsButton:(UIButton *)sender {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenDefaultApplicationsSettingsURLString];
    assert(url != nil);
    [self.view.window.windowScene openURL:url options:nil completionHandler:^(BOOL success) {
        assert(success);
    }];
}

@end

#endif
