//
//  WorldTrackingLimitationViewController.m
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 7/29/24.
//

#import "WorldTrackingLimitationViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import <dlfcn.h>

@interface WorldTrackingLimitationViewController ()
@property (retain, readonly, nonatomic) UILabel *label;
@end

@implementation WorldTrackingLimitationViewController
@synthesize label = _label;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *label = self.label;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:label];
    [NSLayoutConstraint activateConstraints:@[
        [label.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [label.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor]
    ]];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(worldTrackingCapabilitiesDidChangeNotification:)
                                               name:@"_MRUIWindowSceneWorldTrackingCapabilitiesDidChange"
                                             object:nil];
}

- (void)viewIsAppearing:(BOOL)animated {
    [super viewIsAppearing:animated];
    [self updateLabel];
}

- (UILabel *)label {
    if (auto label = _label) return label;
    
    UILabel *label = [UILabel new];
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleExtraLargeTitle];
    
    _label = [label retain];
    return [label autorelease];
}

- (void)worldTrackingCapabilitiesDidChangeNotification:(NSNotification *)notification {
    if (![self.view.window.windowScene isEqual:notification.object]) return;
    
    [self updateLabel];
}

- (void)updateLabel {
    void *handle = dlopen("/System/Library/PrivateFrameworks/MRUIKit.framework/MRUIKit", RTLD_NOW);
    void *symbol = dlsym(handle, "_NSStringFromMRUIWorldTrackingCapabilities");
    
    NSUInteger _worldTrackingCapabilities = reinterpret_cast<NSUInteger (*)(id, SEL)>(objc_msgSend)(self.view.window.windowScene, sel_registerName("_worldTrackingCapabilities"));
    NSString *string = reinterpret_cast<id (*)(NSUInteger)>(symbol)(_worldTrackingCapabilities);
    self.label.text = string;
}

@end
