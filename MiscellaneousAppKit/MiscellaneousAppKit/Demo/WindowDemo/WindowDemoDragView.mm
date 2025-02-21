//
//  WindowDemoDragView.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/22/25.
//

#import "WindowDemoDragView.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

@interface WindowDemoDragView () <NSDraggingDestination>
@end

@implementation WindowDemoDragView

- (instancetype)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setBackgroundColor:"), [NSColor.whiteColor colorWithAlphaComponent:1.0]);
        [self registerForDraggedTypes:@[UTTypeText.identifier]];
        NSLog(@"%@", self.registeredDraggedTypes);
    }
    
    return self;
}

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
    return NSDragOperationCopy;
}


@end
