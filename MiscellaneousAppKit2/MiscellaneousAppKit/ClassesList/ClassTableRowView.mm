//
//  ClassTableRowView.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/23/24.
//

#import "ClassTableRowView.h"
#import <QuartzCore/QuartzCore.h>

@interface ClassTableRowView () {
    double _lastTimestamp;
}
@property (retain, nonatomic, nullable) CADisplayLink *displayLink;
@end

@implementation ClassTableRowView

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        _lastTimestamp = 0.0;
    }
    
    return self;
}

- (void)dealloc {
    if (auto displayLink = _displayLink) {
        [displayLink invalidate];
        [displayLink release];
    }
    
    [super dealloc];
}

- (void)viewDidMoveToWindow {
    [super viewDidMoveToWindow];
    
    [self.displayLink invalidate];
    
    CADisplayLink *displayLink = [self displayLinkWithTarget:self selector:@selector(displayLinkDidTrigger:)];
    [displayLink addToRunLoop:NSRunLoop.currentRunLoop forMode:NSRunLoopCommonModes];
    self.displayLink = displayLink;
}

- (void)displayLinkDidTrigger:(CADisplayLink *)sender {
    if (_lastTimestamp == 0.0) {
        _lastTimestamp = sender.timestamp;
    }
    
    double a = fmod((sender.timestamp - _lastTimestamp), 4.0) / 4.0;
    
    if (a <= 0.5) {
        a *= 2.0;
    } else {
        a = 2.0 - (a * 2.0);
    }
    
    a = 0.3 + a * (1.0 / 0.7);
    
    self.alphaValue = a;
}

@end
