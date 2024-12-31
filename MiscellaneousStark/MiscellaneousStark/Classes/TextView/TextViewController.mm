//
//  TextViewController.mm
//  MiscellaneousStark
//
//  Created by Jinwoo Kim on 1/1/25.
//

#import "TextViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface TextView : UITextView
@end

@implementation TextView


@end

@implementation TextViewController

- (void)loadView {
    TextView *textView = [TextView new];
    self.view = textView;
    [textView release];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.view becomeFirstResponder];
}

@end
