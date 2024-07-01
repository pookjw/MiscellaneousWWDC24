//
//  ViewpointAzimuthWindowScene.m
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 7/1/24.
//

#import "ViewpointAzimuthWindowScene.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface ViewpointAzimuthWindowScene ()
@property (retain, nonatomic, nullable) id<UITraitChangeRegistration> viewpointAzimuthTraitRegistration;
@property (retain, nonatomic, nullable) id<UITraitChangeRegistration> rawViewpointAzimuthTraitRegistration;
@end

@implementation ViewpointAzimuthWindowScene

- (void)dealloc {
    [_window release];
    [_viewpointAzimuthTraitRegistration release];
    [_rawViewpointAzimuthTraitRegistration release];
    [super dealloc];
}

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    UIWindow *window = [[UIWindow alloc] initWithWindowScene:(UIWindowScene *)scene];
    
    self.viewpointAzimuthTraitRegistration = [window registerForTraitChanges:@[objc_lookUpClass("UITraitViewpointAzimuth")] withTarget:self action:@selector(viewpointAzimuthTraitDidChange:)];
    self.rawViewpointAzimuthTraitRegistration = [window registerForTraitChanges:@[objc_lookUpClass("UITraitRawViewpointAzimuth")] withTarget:self action:@selector(rawViewpointAzimuthTraitDidChange:)];
    
    UIViewController *rootViewController = [UIViewController new];
    rootViewController.view.backgroundColor = UIColor.systemCyanColor;
    
    window.rootViewController = rootViewController;
    [rootViewController release];
    
    ((void (*)(id, SEL, id, id))objc_msgSend)(rootViewController.view, sel_registerName("setValue:forPreferenceKey:"), @(2), objc_lookUpClass("MRUISupportedVolumeViewpointsPreferenceKey"));
    
    self.window = window;
    [window makeKeyAndVisible];
    [window release];
    
}

- (void)viewpointAzimuthTraitDidChange:(UIWindow *)sender {
    NSLog(@"UITraitViewpointAzimuth: %lf", [sender.traitCollection valueForCGFloatTrait:objc_lookUpClass("UITraitViewpointAzimuth")]);
}

- (void)rawViewpointAzimuthTraitDidChange:(UIWindow *)sender {
    NSLog(@"UITraitRawViewpointAzimuth: %lf", [sender.traitCollection valueForCGFloatTrait:objc_lookUpClass("UITraitRawViewpointAzimuth")]);
    
//    ((void (*)(id, SEL, id, id))objc_msgSend)(sender.rootViewController.view, sel_registerName("setValue:forPreferenceKey:"), @2, @"MRUISupportedVolumeViewpointsPreferenceKey");
}

@end
