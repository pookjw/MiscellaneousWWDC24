//
//  MarqueeLabelViewController.m
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 12/7/24.
//

#import "MarqueeLabelViewController.h"
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>
#import <objc/message.h>
#import <objc/runtime.h>
#include <ranges>

@interface MarqueeLabelViewController ()
@property (retain, nonatomic, readonly) UILabel *label;
@end

@implementation MarqueeLabelViewController
@synthesize label = _label;

- (void)dealloc {
    [_label release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.label;
}

- (UILabel *)label {
    if (auto label = _label) return label;
    
    UILabel *label = [UILabel new];
    
    NSURL *articleURL = [NSBundle.mainBundle URLForResource:@"article" withExtension:UTTypePlainText.preferredFilenameExtension];
    NSError * _Nullable error = nil;
    NSString *text = [[NSString alloc] initWithContentsOfURL:articleURL encoding:NSUTF8StringEncoding error:&error];
    assert(error == nil);
    label.text = text;
    [text release];
    
    label.backgroundColor = UIColor.systemBackgroundColor;
    label.textColor = UIColor.labelColor;
    label.numberOfLines = 1;
    
    // Marquee
    unsigned int ivarsCount;
    
    Ivar *ivars = class_copyIvarList([UILabel class], &ivarsCount);
    
    auto ivar = std::ranges::find_if(ivars, ivars + ivarsCount, [](Ivar ivar) {
        auto name = ivar_getName(ivar);
        return !std::strcmp(name, "_textLabelFlags");
    });
    
    uintptr_t base = reinterpret_cast<uintptr_t>(label);
    ptrdiff_t offset = ivar_getOffset(*ivar);
    delete ivars;
    
    auto location = reinterpret_cast<uint8_t *>(base + offset);
    location[1] |= (1 << 2); // marqueeRunable을 설정한다. offset이 10bit이므로 8 + 2에 0x1로 설정
    
    ((void (*)(id, SEL, BOOL))objc_msgSend)(label, sel_registerName("setMarqueeEnabled:"), YES);
    ((void (*)(id, SEL, NSUInteger))objc_msgSend)(label, sel_registerName("setMarqueeRepeatCount:"), 0);
    // END
    
    _label = [label retain];
    return [label autorelease];
}

@end
