//
//  CustomRulerMarker.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/26/24.
//

#import "CustomRulerMarker.h"
#import <objc/message.h>
#import <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

@implementation CustomRulerMarker

- (void)drawRect:(NSRect)rect {
    NSRulerOrientation orientation = self.ruler.orientation;
    CGPoint _compositePointInRuler = ((CGPoint (*)(id, SEL))objc_msgSend)(self, sel_registerName("_compositePointInRuler"));
    
    if (orientation == NSHorizontalRuler) {
        NSRect newRect = NSMakeRect(_compositePointInRuler.x, self.ruler.accessoryView.frame.size.height, 15., 15. * (self.image.size.height / self.image.size.width));
//        NSLog(@"%@", NSStringFromPoint(_compositePointInRuler));
        [self.image drawInRect:newRect];
    } else {
        NSRect newRect = NSMakeRect(self.ruler.accessoryView.frame.size.width, _compositePointInRuler.y, 15., 15. * (self.image.size.height / self.image.size.width));
            [self.image drawInRect:newRect];
    }
}

@end
