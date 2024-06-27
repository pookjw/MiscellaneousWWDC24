//
//  RulerContentView.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/26/24.
//

#import "RulerContentView.h"
#import "CustomRulerMarker.h"
#import <objc/message.h>
#import <objc/runtime.h>

@implementation RulerContentView

- (void)rulerView:(NSRulerView *)ruler handleMouseDown:(NSEvent *)event {
    CustomRulerMarker *marker = [[CustomRulerMarker alloc] initWithRulerView:ruler markerLocation:0. image:[NSImage imageWithSystemSymbolName:@"curtains.closed" accessibilityDescription:nil] imageOrigin:NSZeroPoint];
    
    marker.movable = YES;
    marker.removable = YES;
    
    [ruler trackMarker:marker withMouseEvent:event];
    [marker release];
}

- (void)rulerView:(NSRulerView *)ruler handleMouseDown:(NSEvent *)event forMarker:(NSRulerMarker *)marker {
    
}

@end
