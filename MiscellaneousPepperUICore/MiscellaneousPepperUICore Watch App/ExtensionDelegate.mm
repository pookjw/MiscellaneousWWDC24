//
//  ExtensionDelegate.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 10/7/24.
//

#import "ExtensionDelegate.h"

@implementation ExtensionDelegate

- (BOOL)respondsToSelector:(SEL)aSelector {
    BOOL responds = [super respondsToSelector:aSelector];
    
    if (!responds) {
        NSLog(@"%@: %s", NSStringFromClass(self.class), sel_getName(aSelector));
    }
    
    return responds;
}

- (void)handleBackgroundTasks:(NSSet<WKRefreshBackgroundTask *> *)backgroundTasks {
#warning https://developer.apple.com/documentation/watchconnectivity/transferring-data-with-watch-connectivity?language=objc
}

@end
