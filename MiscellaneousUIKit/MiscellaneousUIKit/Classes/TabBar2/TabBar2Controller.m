//
//  TabBar2Controller.m
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/23/24.
//

#import "TabBar2Controller.h"
#import "PinkViewController.h"
#import "CyanViewController.h"
#import "OrangeViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface TabBar2Controller ()

@end

@implementation TabBar2Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITab *pinkTab = [[UITab alloc] initWithTitle:@"Pink" image:nil identifier:@"Pink" viewControllerProvider:^UIViewController * _Nonnull(__kindof UITab * _Nonnull tab) {
        return [[PinkViewController new] autorelease];
    }];
    pinkTab.allowsHiding = NO;
    
    UITab *cyanTab = [[UITab alloc] initWithTitle:@"Cyan" image:nil identifier:@"Cyan" viewControllerProvider:^UIViewController * _Nonnull(__kindof UITab * _Nonnull tab) {
        return [[CyanViewController new] autorelease];
    }];
    cyanTab.allowsHiding = NO;
    
    UITab *orangeTab = [[UITab alloc] initWithTitle:@"Orange" image:nil identifier:@"Orange" viewControllerProvider:^UIViewController * _Nonnull(__kindof UITab * _Nonnull tab) {
        return [[OrangeViewController new] autorelease];
    }];
    orangeTab.allowsHiding = NO;
    
    self.tabs = @[pinkTab, cyanTab, orangeTab];
    
    [pinkTab release];
    [cyanTab release];
    [orangeTab release];
    
    id _tabModel;
    object_getInstanceVariable(self, "_tabModel", (void **)&_tabModel);
    
//    self.editing = YES;
//    ((void (*)(id, SEL, BOOL))objc_msgSend)(_tabModel, sel_registerName("setEditing:"), YES);
    ((void (*)(id, SEL, BOOL))objc_msgSend)(_tabModel, sel_registerName("setEditable:"), NO);
}

//- (void)setEditing:(BOOL)editing {
//    [super setEditing:NO];
//}

@end
