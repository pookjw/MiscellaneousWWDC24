//
//  WindowMovableViewController.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/30/24.
//

#import "WindowMovableViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import <os/lock.h>

@interface WindowMovableTestView : NSView
@end

@implementation WindowMovableTestView

- (BOOL)mouseDownCanMoveWindow {
    return YES;
}

@end

@interface WindowMovableViewController ()

@end

@implementation WindowMovableViewController

- (void)loadView {
    WindowMovableTestView *view = [WindowMovableTestView new];
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(view, sel_registerName("setBackgroundColor:"), NSColor.systemOrangeColor);
    
    self.view = view;
    [view release];
}

@end
