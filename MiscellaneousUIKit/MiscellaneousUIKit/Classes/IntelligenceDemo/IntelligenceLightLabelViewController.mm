//
//  IntelligenceLightLabelViewController.m
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 12/8/24.
//

#import "IntelligenceLightLabelViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface IntelligenceLightLabelViewController ()

@end

@implementation IntelligenceLightLabelViewController

- (void)loadView {
    UILabel *label = [UILabel new];
    label.text = @"TEST";
    label.font = [UIFont boldSystemFontOfSize:50.];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = UIColor.clearColor;
    
    id descriptor = ((id (*)(Class, SEL))objc_msgSend)(objc_lookUpClass("_UIIntelligenceLightSourceDescriptor"), sel_registerName("sharedLight"));

    ((void (*)(id, SEL))objc_msgSend)(label, sel_registerName("_addLightSourceView"));

    ((void (*)(id, SEL, id))objc_msgSend)(label, sel_registerName("_setLightSourceDescriptor:"), descriptor);
    
    self.view = label;
    [label release];
}

@end
