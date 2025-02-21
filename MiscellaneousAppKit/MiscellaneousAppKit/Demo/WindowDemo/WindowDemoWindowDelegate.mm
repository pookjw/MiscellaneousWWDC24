//
//  WindowDemoWindowDelegate.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/19/25.
//

#import "WindowDemoWindowDelegate.h"

@implementation WindowDemoWindowDelegate

//- (BOOL)respondsToSelector:(SEL)aSelector {
//    BOOL responds = [super respondsToSelector:aSelector];
//    
//    if (!responds) {
//        NSLog(@"%@ does not respond to %s.", NSStringFromClass([self class]), sel_getName(aSelector));
//    }
//    
//    return responds;
//}

//- (id)windowWillReturnFieldEditor:(NSWindow *)sender toObject:(id)client {
//    abort();
//}

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
    NSLog(@"draggingEntered %@", sender);
    return NSDragOperationCopy;
}

@end
