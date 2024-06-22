//
//  CyanViewController.m
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/20/24.
//

#import "CyanViewController.h"

@implementation CyanViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.tabBarItem.image = [UIImage systemImageNamed:@"2.circle"];
        self.tabBarItem.title = @"Cyan";
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.systemCyanColor;
}

@end
