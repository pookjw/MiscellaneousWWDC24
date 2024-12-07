//
//  PointerInteractionViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 7/30/24.
//

#import "PointerInteractionViewController.h"
#include <cmath>

@interface PointerInteractionViewController () <UIPointerInteractionDelegate>
@property (retain, readonly, nonatomic) UIView *blueView;
@end

@implementation PointerInteractionViewController
@synthesize blueView = _blueView;

- (void)dealloc {
    [_blueView release];
    [super dealloc];
}

- (UIView *)blueView {
    if (auto blueView = _blueView) return blueView;
    
    UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(0., 0., 100., 100.)];
    blueView.backgroundColor = UIColor.systemBlueColor;
    blueView.translatesAutoresizingMaskIntoConstraints = NO;
    
    _blueView = [blueView retain];
    return [blueView autorelease];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    [self.view addSubview:self.blueView];
    
    UIPointerInteraction *pointerInteraction = [[UIPointerInteraction alloc] initWithDelegate:self];
    NSLog(@"%@", pointerInteraction);
    
    [self.view addInteraction:pointerInteraction];
    [pointerInteraction release];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didTriggerPanGestureRecognizer:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
    [panGestureRecognizer release];
}

- (void)didTriggerPanGestureRecognizer:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self.view];
    NSLog(@"%@", NSStringFromCGPoint(translation));
    
    self.blueView.frame = CGRectMake(translation.x,
                                     translation.y,
                                     100.,
                                     100.);
}

- (UIPointerRegion *)pointerInteraction:(UIPointerInteraction *)interaction regionForRequest:(UIPointerRegionRequest *)request defaultRegion:(UIPointerRegion *)defaultRegion {
    
    UIPointerRegion *region = [defaultRegion copy];
    
    // -didTriggerPanGestureRecognizer:를 보면 Snap이 걸리는 것을 볼 수 있으며
    // 실제 Pointer의 Snap 및 Cursor (UIPointerStyle)의 Snap은 별개 
    region.latchingAxes = UIAxisVertical;
    
    return [region autorelease];
}

- (UIPointerStyle *)pointerInteraction:(UIPointerInteraction *)interaction styleForRegion:(UIPointerRegion *)region {
    UIPointerStyle *style = [UIPointerStyle styleWithShape:[UIPointerShape shapeWithRoundedRect:CGRectMake(0., 0., 100., 100.)]
                                           constrainedAxes:UIAxisVertical];
    
//    
//    UITargetedPreview *targetedPreview = [[UITargetedPreview alloc] initWithView:self.blueView];
//    
//    UIPointerEffect *effect = [UIPointerEffect effectWithPreview:targetedPreview];
//    [targetedPreview release];
//    
//    UIPointerStyle *style = [UIPointerStyle styleWithEffect:effect
//                                                      shape:nil];
    
    style.accessories = @[
        [UIPointerAccessory arrowAccessoryWithPosition:UIPointerAccessoryPositionMake(60., 0.)],
        [UIPointerAccessory arrowAccessoryWithPosition:UIPointerAccessoryPositionMake(60. / std::sin(M_PI_4), M_PI_2 + M_PI_4)],
        [UIPointerAccessory arrowAccessoryWithPosition:UIPointerAccessoryPositionMake(60. / std::sin(M_PI_4), M_PI + M_PI_4)]
    ];
    
    return style;
}

- (void)pointerInteraction:(UIPointerInteraction *)interaction willEnterRegion:(UIPointerRegion *)region animator:(id<UIPointerInteractionAnimating>)animator {
    NSLog(@"%s", sel_getName(_cmd));
    
    [animator addAnimations:^{
        self.view.backgroundColor = UIColor.systemPinkColor;
    }];
}

- (void)pointerInteraction:(UIPointerInteraction *)interaction willExitRegion:(UIPointerRegion *)region animator:(id<UIPointerInteractionAnimating>)animator {
    NSLog(@"%s", sel_getName(_cmd));
    
    [animator addAnimations:^{
        self.view.backgroundColor = UIColor.systemBackgroundColor;
    }];
}

/*
 PointerUIServices
 -[PSPointerClientController clientInteractionStateDidChange:]
 _UIPointerArbiterCore_iOS
 */

@end
