//
//  WindowDemoViewController.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 1/31/25.
//

#import "WindowDemoViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface WindowDemoViewController ()

@end

@implementation WindowDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self.view, sel_registerName("setBackgroundColor:"), NSColor.systemOrangeColor);
}

@end
