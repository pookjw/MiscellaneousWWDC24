//
//  IntelligenceUILightViewController.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 12/8/24.
//

#import "IntelligenceUILightViewController.h"
#import <objc/runtime.h>

@interface IntelligenceUILightViewController ()

@end

@implementation IntelligenceUILightViewController

- (void)loadView {
    __kindof NSView *lightView = [objc_lookUpClass("NSIntelligenceUILightView") new];
    self.view = lightView;
    [lightView release];
}

@end
