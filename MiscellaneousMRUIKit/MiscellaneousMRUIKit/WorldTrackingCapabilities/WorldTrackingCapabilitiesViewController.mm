//
//  WorldTrackingCapabilitiesViewController.m
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 7/2/24.
//

#import "WorldTrackingCapabilitiesViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>
#include <dlfcn.h>

/*
 _MRUIWindowSceneWorldTrackingCapabilitiesDidChange
 _NSStringFromMRUIWorldTrackingCapabilities
 
 -[UIWindowScene _worldTrackingCapabilities]
 
 MRUIWorldTrackingCapabilitiesAll
 MRUIWorldTrackingCapabilitiesNone
 MRUIWorldTrackingCapabilitiesTranslation
 MRUIWorldTrackingCapabilitiesOrientation
 */

@interface WorldTrackingCapabilitiesViewController ()
@property (retain, readonly, nonatomic) UILabel *label;
@end

@implementation WorldTrackingCapabilitiesViewController
@synthesize label = _label;

- (void)dealloc {
    [_label release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *label = self.label;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:label];
    [NSLayoutConstraint activateConstraints:@[
        [label.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [label.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor]
    ]];
}

- (void)viewIsAppearing:(BOOL)animated {
    [super viewIsAppearing:animated];
    
    NSUInteger value = reinterpret_cast<NSUInteger (*)(id, SEL)>(objc_msgSend)(self.view.window.windowScene, sel_registerName("_worldTrackingCapabilities"));
    self.label.text = [self stringFromMRUIWorldTrackingCapabilities:value];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didChange:) name:@"_MRUIWindowSceneWorldTrackingCapabilitiesDidChange" object:self.view.window.windowScene];
}

- (UILabel *)label {
    if (auto label = _label) return label;
    
    UILabel *label = [UILabel new];
    
    label.backgroundColor = UIColor.blackColor;
    label.textColor = UIColor.whiteColor;
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle1];
    
    _label = [label retain];
    return [label autorelease];
}

- (NSString *)stringFromMRUIWorldTrackingCapabilities:(NSUInteger)value {
    void *handle = dlopen("/System/Library/PrivateFrameworks/MRUIKit.framework/MRUIKit", RTLD_NOW);
    void *symbol = dlsym(handle, "_NSStringFromMRUIWorldTrackingCapabilities");
    
    auto func = reinterpret_cast<id (*)(NSInteger)>(symbol);
    
    return func(value);
}

- (void)didChange:(NSNotification *)notification {
    NSUInteger value = reinterpret_cast<NSUInteger (*)(id, SEL)>(objc_msgSend)(self.view.window.windowScene, sel_registerName("_worldTrackingCapabilities"));
    self.label.text = [self stringFromMRUIWorldTrackingCapabilities:value];
}

@end
