//
//  ConfigurationSeparatorView.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/1/25.
//

#import "ConfigurationSeparatorView.h"
#import <objc/message.h>
#import <objc/runtime.h>

@implementation ConfigurationSeparatorView

- (instancetype)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setBackgroundColor:"), NSColor.separatorColor);
    }
    
    return self;
}

@end
