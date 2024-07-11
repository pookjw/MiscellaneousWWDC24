//
//  CircleProgressViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 7/11/24.
//

#import "CircleProgressViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface CircleProgressViewController ()
// _UICircleProgressView
@property (retain, readonly, nonatomic) __kindof UIView *circleProgressView;
@end

@implementation CircleProgressViewController
@synthesize circleProgressView = _circleProgressView;

- (void)dealloc {
    [_circleProgressView release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.circleProgressView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.systemBackgroundColor;
}

- (__kindof UIView *)circleProgressView {
    if (auto circleProgressView = _circleProgressView) return circleProgressView;
    
    // _UICircleProgressView
    __kindof UIView *circleProgressView = [objc_lookUpClass("_UICircleProgressView") new];
    
    reinterpret_cast<void (*)(id, SEL, CGFloat)>(objc_msgSend)(circleProgressView, sel_registerName("setProgress:"), 0.5);
    
    NSLog(@"%ld", reinterpret_cast<long (*)(id, SEL)>(objc_msgSend)(circleProgressView, sel_registerName("progressStartPoint")));
    
    _circleProgressView = [circleProgressView retain];
    return [circleProgressView autorelease];
}

@end
