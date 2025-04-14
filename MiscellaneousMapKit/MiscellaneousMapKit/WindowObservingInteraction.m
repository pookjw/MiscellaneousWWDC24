//
//  WindowObservingInteraction.m
//  MiscellaneousMapKit
//
//  Created by Jinwoo Kim on 4/14/25.
//

#import "WindowObservingInteraction.h"

@implementation WindowObservingInteraction

- (void)dealloc {
    [_willMoveToWindow release];
    [_didMoveToWindow release];
    [super dealloc];
}

- (void)willMoveToView:(nullable UIView *)view {
    
}

- (void)didMoveToView:(nullable UIView *)view {
    
}

- (void)_willMoveFromWindow:(nullable UIWindow *)oldWindow toWindow:(nullable UIWindow *)newWindow {
    if (_willMoveToWindow) _willMoveToWindow(self, oldWindow, newWindow);
}

- (void)_didMoveFromWindow:(nullable UIWindow *)oldWindow toWindow:(nullable UIWindow *)newWindow {
    if (_didMoveToWindow) _didMoveToWindow(self, oldWindow, newWindow);
}

@end
