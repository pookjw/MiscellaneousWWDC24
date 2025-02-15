//
//  UnsafeDebouncer.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/15/25.
//

#import "UnsafeDebouncer.h"
#import <Cocoa/Cocoa.h>

@interface UnsafeDebouncer ()
@property (assign, nonatomic, readonly, getter=_timeInterval) NSTimeInterval timeInterval;
@property (retain, nonatomic, nullable, getter=_timer, setter=_setTimer:) NSTimer *timer;
@property (copy, nonatomic, getter=_block, setter=_setBlock:) void (^block)(BOOL cancelled);
@property (copy, nonatomic, readonly, getter=_modes) NSArray<NSRunLoopMode> *modes;
@end

@implementation UnsafeDebouncer

- (instancetype)initWithTimeInterval:(NSTimeInterval)timeInterval modes:(NSArray<NSRunLoopMode> *)modes {
    if (self = [super init]) {
        _timeInterval = timeInterval;
        _modes = [modes copy];
    }
    
    return self;
}

- (void)dealloc {
    [_timer invalidate];
    [_timer release];
    [_block release];
    [_modes release];
    [super dealloc];
}

- (void)scheduleBlock:(void (^)(BOOL))block {
    if (self.timer == nil) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:self.timeInterval
                                                 target:self
                                               selector:@selector(_didTriggerTimer:)
                                               userInfo:nil
                                                repeats:NO];
        
        for (NSRunLoopMode mode in self.modes) {
            [NSRunLoop.currentRunLoop addTimer:timer forMode:mode];
        }
        
        self.timer = timer;
    }
    
    if (auto oldBlock = self.block) oldBlock(YES);
    self.block = block;
}

- (void)cancelPendingBlock {
    self.block = nil;
    [self.timer invalidate];
    self.timer = nil;
}

- (void)_didTriggerTimer:(NSTimer *)sender {
    assert(self.block != nil);
    self.block(NO);
    self.block = nil;
    [sender invalidate];
    self.timer = nil;
}

@end
