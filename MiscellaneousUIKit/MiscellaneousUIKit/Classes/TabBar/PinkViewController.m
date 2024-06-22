//
//  PinkViewController.m
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/20/24.
//

#import "PinkViewController.h"

@implementation PinkViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.tabBarItem.image = [UIImage systemImageNamed:@"1.circle"];
        self.tabBarItem.title = @"Pink";
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.systemPinkColor;
}

@end
