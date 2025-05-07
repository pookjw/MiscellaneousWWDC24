//
//  TraitStorageViewController.m
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 5/7/25.
//

#import "TraitStorageViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

@implementation TraitStorageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    
    UIView *centerView = [UIView new];
    centerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:centerView];
    
    NSLayoutConstraint *widthLayoutConstraint = [centerView.widthAnchor constraintEqualToConstant:100];
    [NSLayoutConstraint activateConstraints:@[
        [centerView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [centerView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        widthLayoutConstraint,
        [centerView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:0.5]
    ]];
    
    id backgroundColorStorage = reinterpret_cast<id (*)(id, SEL, id, id)>(objc_msgSend)([objc_lookUpClass("_UIAttributeTraitStorage") alloc], sel_registerName("initWithObject:keyPath:"), centerView, @"backgroundColor");
    reinterpret_cast<void (*)(id, SEL, id, id)>(objc_msgSend)(backgroundColorStorage, sel_registerName("addRecordWithTraitCollection:value:"), [UITraitCollection traitCollectionWithHorizontalSizeClass:UIUserInterfaceSizeClassRegular], UIColor.systemCyanColor);
    reinterpret_cast<void (*)(id, SEL, id, id)>(objc_msgSend)(backgroundColorStorage, sel_registerName("addRecordWithTraitCollection:value:"), [UITraitCollection traitCollectionWithHorizontalSizeClass:UIUserInterfaceSizeClassCompact], UIColor.systemOrangeColor);
    
    id constantStorage = reinterpret_cast<id (*)(id, SEL, id, id)>(objc_msgSend)([objc_lookUpClass("_UIAttributeTraitStorage") alloc], sel_registerName("initWithObject:keyPath:"), widthLayoutConstraint, @"constant");
    reinterpret_cast<void (*)(id, SEL, id, id)>(objc_msgSend)(constantStorage, sel_registerName("addRecordWithTraitCollection:value:"), [UITraitCollection traitCollectionWithHorizontalSizeClass:UIUserInterfaceSizeClassRegular], @(300));
    reinterpret_cast<void (*)(id, SEL, id, id)>(objc_msgSend)(constantStorage, sel_registerName("addRecordWithTraitCollection:value:"), [UITraitCollection traitCollectionWithHorizontalSizeClass:UIUserInterfaceSizeClassCompact], @(100));
    
    id traitStorageList = reinterpret_cast<id (*)(id, SEL, id, id, id)>(objc_msgSend)([objc_lookUpClass("_UITraitStorageList") alloc], sel_registerName("initWithTopLevelObject:traitStorages:descendants:"), self.view, @[backgroundColorStorage, constantStorage], @[centerView, widthLayoutConstraint]);
    [backgroundColorStorage release];
    [constantStorage release];
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self.view, sel_registerName("_setTraitStorageList:"), traitStorageList);
    [traitStorageList release];
    
    [centerView release];
}

@end
