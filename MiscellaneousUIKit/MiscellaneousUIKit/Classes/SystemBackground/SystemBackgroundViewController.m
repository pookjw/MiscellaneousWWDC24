//
//  SystemBackgroundViewController.m
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/12/24.
//

#import "SystemBackgroundViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

@implementation SystemBackgroundViewController

- (void)loadView {
    UIBackgroundConfiguration *backgroundConfiguration = [UIBackgroundConfiguration clearConfiguration];
    backgroundConfiguration.backgroundColor = UIColor.systemPinkColor;
    
    __kindof UIView *systemBackgroundView = ((id (*)(id, SEL, id))objc_msgSend)([objc_lookUpClass("_UISystemBackgroundView") alloc], sel_registerName("initWithConfiguration:"), backgroundConfiguration);
    self.view = systemBackgroundView;
    [systemBackgroundView release];
}

@end
