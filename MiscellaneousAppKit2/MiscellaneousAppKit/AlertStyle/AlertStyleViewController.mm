//
//  AlertStyleViewController.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 7/1/24.
//

#import "AlertStyleViewController.h"

@interface AlertStyleViewController ()
@property (retain, readonly, nonatomic) NSStackView *stackView;
@property (retain, readonly, nonatomic) NSButton *runCriticalAlertButton;
@property (retain, readonly, nonatomic) NSButton *runWarningAlertButton;
@property (retain, readonly, nonatomic) NSButton *runInformationalAlertButton;
@end

@implementation AlertStyleViewController
@synthesize stackView = _stackView;
@synthesize runCriticalAlertButton = _runCriticalAlertButton;
@synthesize runWarningAlertButton = _runWarningAlertButton;
@synthesize runInformationalAlertButton = _runInformationalAlertButton;

- (void)dealloc {
    [_stackView release];
    [_runCriticalAlertButton release];
    [_runWarningAlertButton release];
    [_runInformationalAlertButton release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSStackView *stackView = self.stackView;
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:stackView];
    [NSLayoutConstraint activateConstraints:@[
        [stackView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [stackView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor]
    ]];
}

- (NSStackView *)stackView {
    if (auto stackView = _stackView) return stackView;
    
    NSStackView *stackView = [NSStackView new];
    stackView.alignment = NSLayoutAttributeCenterX;
    stackView.orientation = NSUserInterfaceLayoutOrientationVertical;
    
    [stackView addArrangedSubview:self.runCriticalAlertButton];
    [stackView addArrangedSubview:self.runWarningAlertButton];
    [stackView addArrangedSubview:self.runInformationalAlertButton];
    
    _stackView = [stackView retain];
    return [stackView autorelease];
}

- (NSButton *)runCriticalAlertButton {
    if (auto runCriticalAlertButton = _runCriticalAlertButton) return runCriticalAlertButton;
    
    NSButton *runCriticalAlertButton = [NSButton buttonWithTitle:@"Critical Alert" target:self action:@selector(runCriticalAlertButtonDidTrigger:)];
    
    _runCriticalAlertButton = [runCriticalAlertButton retain];
    return runCriticalAlertButton;
}

- (NSButton *)runWarningAlertButton {
    if (auto runWarningAlertButton = _runWarningAlertButton) return runWarningAlertButton;
    
    NSButton *runWarningAlertButton = [NSButton buttonWithTitle:@"Warning Alert" target:self action:@selector(runWarningAlertButtonDidTrigger:)];
    
    _runWarningAlertButton = [runWarningAlertButton retain];
    return runWarningAlertButton;
}

- (NSButton *)runInformationalAlertButton {
    if (auto runInformationalAlertButton = _runInformationalAlertButton) return runInformationalAlertButton;
    
    NSButton *runInformationalAlertButton = [NSButton buttonWithTitle:@"Informational Alert" target:self action:@selector(runInformationalAlertButtonDidTrigger:)];
    
    _runInformationalAlertButton = [runInformationalAlertButton retain];
    return runInformationalAlertButton;
}

- (void)runCriticalAlertButtonDidTrigger:(NSButton *)sender {
    [self runModalWithAlertStyle:NSAlertStyleCritical];
}

- (void)runWarningAlertButtonDidTrigger:(NSButton *)sender {
    [self runModalWithAlertStyle:NSAlertStyleWarning];
}

- (void)runInformationalAlertButtonDidTrigger:(NSButton *)sender {
    [self runModalWithAlertStyle:NSAlertStyleInformational];
}

- (void)runModalWithAlertStyle:(NSAlertStyle)alertStyle {
    NSAlert *alert = [NSAlert new];
    
    alert.alertStyle = alertStyle;
    alert.icon = [NSImage imageWithSystemSymbolName:@"arrow.up.doc.on.clipboard" accessibilityDescription:nil];
    alert.showsHelp = YES;
    alert.showsSuppressionButton = YES;
    alert.informativeText = @"informativeText";
    alert.messageText = @"messageText";
//    alert.suppressionButton.title = @"Hello!";
    
    [alert runModal];
    
    NSLog(@"%@", alert.suppressionButton.objectValue);
    
    [alert release];
}

@end
