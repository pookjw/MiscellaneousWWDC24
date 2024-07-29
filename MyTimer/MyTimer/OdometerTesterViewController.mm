//
//  OdometerTesterViewController.mm
//  MyTimer
//
//  Created by Jinwoo Kim on 7/29/24.
//

#import "OdometerTesterViewController.h"
#import "MyTimer-Swift.h"

@interface OdometerTesterViewController ()
@property (retain, readonly, nonatomic) UIStackView *stackView;
@property (retain, readonly, nonatomic) __kindof UIViewController *timerHostingController;
@property (retain, readonly, nonatomic) UIBarButtonItem *reloadBarButtonItem;
@end

@implementation OdometerTesterViewController
@synthesize timerHostingController = _timerHostingController;
@synthesize reloadBarButtonItem = _reloadBarButtonItem;

- (void)dealloc {
    [_timerHostingController release];
    [_reloadBarButtonItem release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __kindof UIViewController *timerHostingController = self.timerHostingController;
    timerHostingController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [timerHostingController willMoveToParentViewController:self];
    [self.view addSubview:timerHostingController.view];
    [NSLayoutConstraint activateConstraints:@[
        [timerHostingController.view.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [timerHostingController.view.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [timerHostingController.view.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [timerHostingController.view.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    //
    
    UINavigationItem *navigationItem = self.navigationItem;
    navigationItem.rightBarButtonItem = self.reloadBarButtonItem;
}

- (__kindof UIViewController *)timerHostingController {
    if (auto timerHostingController = _timerHostingController) return timerHostingController;
    
    __kindof UIViewController *timerHostingController = MyTimer::makeTimerHostingController([NSDate now], [[NSDate now] dateByAddingTimeInterval:7200.]);
    
    _timerHostingController = [timerHostingController retain];
    return [timerHostingController autorelease];
}

- (UIBarButtonItem *)reloadBarButtonItem {
    if (auto reloadBarButtonItem = _reloadBarButtonItem) return reloadBarButtonItem;
    
    UIBarButtonItem *reloadBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"arrow.trianglehead.clockwise"] style:UIBarButtonItemStylePlain target:self action:@selector(didTriggerReloadBarButtonItem:)];
    
    _reloadBarButtonItem = [reloadBarButtonItem retain];
    return [reloadBarButtonItem autorelease];
}

- (void)didTriggerReloadBarButtonItem:(UIBarButtonItem *)sender {
    NSDate *startDate = [NSDate now];
    NSDate *endDate = [startDate dateByAddingTimeInterval:125.];
    
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.pookjw.EmojiRangers"];
    [userDefaults setObject:startDate forKey:@"timerStartDate"];
    [userDefaults setObject:endDate forKey:@"timerEndDate"];
    [userDefaults release];
    
    MyTimer::updateTimerHostingController(startDate, endDate, self.timerHostingController);
    MyTimer::reloadAllTimelines();
}

@end
