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
    
    struct objc_super superInfo = { self, [self class] };
    CGPoint _compositePointInRuler = ((CGPoint (*)(struct objc_super *, SEL))objc_msgSendSuper2)(&superInfo, sel_registerName("_compositePointInRuler"));
    
    NSLog(@"%@", NSStringFromPoint(_compositePointInRuler));
    
    // 버그 : orientation이 무조건 NSHorizontalRuler이 나와서, vertical이면 representedObject로 판별한다.
    
    if (orientation == NSHorizontalRuler) {
        NSRect newRect = NSMakeRect(_compositePointInRuler.x, 0., 15., 15. * (self.image.size.height / self.image.size.width));
        [self.image drawInRect:newRect];
    } else {
        NSLog(@"%@", NSStringFromPoint(_compositePointInRuler));
        NSRect newRect = NSMakeRect(0., _compositePointInRuler.y, 15., 15. * (self.image.size.height / self.image.size.width));
            [self.image drawInRect:newRect];
    }
}

@end
