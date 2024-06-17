//
//  FromTransitionViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/14/24.
//

#import "FromTransitionViewController.h"
#import "ToTransitionViewController.h"
#import "CustomViewControllerTransition.h"
#import <objc/message.h>
#import <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

@interface FromTransitionViewController ()
@property (retain, readonly, nonatomic) UIImageView *imageView;
@end

@implementation FromTransitionViewController
@synthesize imageView = _imageView;

- (void)dealloc {
    [_imageView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.systemGreenColor;
    
    UIImageView *imageView = self.imageView;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:imageView];
    [NSLayoutConstraint activateConstraints:@[
        [imageView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [imageView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [imageView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:0.5],
        [imageView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:0.5]
    ]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    NSLog(@"%@", self.view.traitCollection);
}

- (UIImageView *)imageView {
    if (auto imageView = _imageView) return imageView;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"robot"]];
    imageView.backgroundColor = UIColor.systemCyanColor;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerDidTrigger:)];
    [imageView addGestureRecognizer:tapGestureRecognizer];
    [tapGestureRecognizer release];
    
    _imageView = [imageView retain];
    return [imageView autorelease];
}

- (void)tapGestureRecognizerDidTrigger:(UITapGestureRecognizer *)sender {
    ToTransitionViewController *viewController = [ToTransitionViewController new];
//    
    UIZoomTransitionOptions *options = [UIZoomTransitionOptions new];
    options.interactiveDismissShouldBegin = ^BOOL(UIZoomTransitionInteractionContext * _Nonnull context) {
        return YES;
    };
    
    options.alignmentRectProvider = ^CGRect(UIZoomTransitionAlignmentRectContext * _Nonnull context) {
        return CGRectNull;
    };
    
    options.dimmingColor = UIColor.systemPinkColor;
    options.dimmingVisualEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
    
    __weak auto weakSelf = self;
    UIViewControllerTransition *transition = [UIViewControllerTransition zoomWithOptions:options sourceViewProvider:^UIView * _Nullable(UIZoomTransitionSourceViewProviderContext * _Nonnull context) {
        return weakSelf.imageView;
    }];
    
    [options release];
    
//    UIViewControllerTransition *transition = [UIViewControllerTransition coverVerticalTransition];
    
//    __weak auto weakSelf = self;
//    CustomViewControllerTransition *transition = [[[CustomViewControllerTransition alloc] initWithSourceViewProvider:^__kindof UIView * _Nonnull{
//        return weakSelf.imageView;
//    }] autorelease];
    
    viewController.preferredTransition = transition;

    NSLog(@"%@", viewController.presentationController);
    
    [self presentViewController:viewController animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            pause();
        });
    }];
    [viewController release];
}

@end
