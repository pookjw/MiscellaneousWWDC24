//
//  OrangeViewController.m
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/20/24.
//

#import "OrangeViewController.h"

@implementation OrangeViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.tabBarItem.image = [UIImage systemImageNamed:@"3.circle"];
        self.tabBarItem.title = @"Orange";
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.systemOrangeColor;
}

@end
