//
//  VariableBlurViewController.m
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 12/8/24.
//

#import <TargetConditionals.h>

#if TARGET_OS_VISION

#import "VariableBlurViewController.h"
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>
#import <objc/message.h>
#import <objc/runtime.h>

@implementation VariableBlurViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(didTriggerDoneBarButton:)];
    self.navigationItem.rightBarButtonItem = doneBarButtonItem;
    [doneBarButtonItem release];
    
    NSURL *url = [NSBundle.mainBundle URLForResource:@"image" withExtension:UTTypeHEIC.preferredFilenameExtension];
    assert(url != nil);
    UIImage *image = [UIImage imageWithContentsOfFile:url.path];
    assert(image != nil);
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imageView];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self.view, sel_registerName("_addBoundsMatchingConstraintsForView:"), imageView);
    [imageView release];
    
    //
    
    /*
     0 : Top to Bottom
     1 : Left to Right
     2 : Bottom to Top
     3 : Right to Left
     */
    __kindof UIView *bottomVariableBlurView = reinterpret_cast<id (*)(id, SEL, NSInteger, BOOL)>(objc_msgSend)([objc_lookUpClass("_UIVariableBlurView") alloc], sel_registerName("initWithOrientation:disableFadeEffect:"), 2, NO);
    bottomVariableBlurView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:bottomVariableBlurView];
    [NSLayoutConstraint activateConstraints:@[
        [bottomVariableBlurView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [bottomVariableBlurView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [bottomVariableBlurView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [bottomVariableBlurView.heightAnchor constraintEqualToConstant:200.]
    ]];
    [bottomVariableBlurView release];
}

- (void)didTriggerDoneBarButton:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

#endif
