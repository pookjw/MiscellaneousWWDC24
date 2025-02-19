//
//  WindowDemoView.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/17/25.
//

#import "WindowDemoView.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface WindowDemoView ()
@end

@implementation WindowDemoView

- (void)resetCursorRects {
    [super resetCursorRects];
    [self addCursorRect:self.bounds cursor:NSCursor.arrowCursor];
}

@end
