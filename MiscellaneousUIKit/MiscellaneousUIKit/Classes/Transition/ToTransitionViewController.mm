//
//  ToTransitionViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/14/24.
//

#import "ToTransitionViewController.h"

@implementation ToTransitionViewController
@synthesize imageView = _imageView;

- (void)dealloc {
    [_imageView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.systemBlueColor;
    
    UIImageView *imageView = self.imageView;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:imageView];
    [NSLayoutConstraint activateConstraints:@[
        [imageView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [imageView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [imageView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:0.8],
        [imageView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:0.8]
    ]];
}

- (UIImageView *)imageView {
    if (auto imageView = _imageView) return imageView;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"robot"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    _imageView = [imageView retain];
    return [imageView autorelease];
}

@end
