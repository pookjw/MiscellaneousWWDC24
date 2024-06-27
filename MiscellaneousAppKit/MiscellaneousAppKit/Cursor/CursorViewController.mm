//
//  CursorViewController.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/27/24.
//

#import "CursorViewController.h"

@interface CursorViewController ()
@property (retain, readonly, nonatomic) NSStackView *stackView;
@property (retain, readonly, nonatomic) NSButton *hideCursorButton;
@property (retain, readonly, nonatomic) NSButton *unhideCursorButton;
@end

@implementation CursorViewController
@synthesize stackView = _stackView;
@synthesize hideCursorButton = _hideCursorButton;
@synthesize unhideCursorButton = _unhideCursorButton;

- (void)dealloc {
    [_stackView release];
    [_hideCursorButton release];
    [_unhideCursorButton release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

@end
