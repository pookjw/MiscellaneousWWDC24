//
//  ProminenceViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/23/24.
//

#import "ProminenceViewController.h"

@interface ProminenceViewController ()
@property (retain, readonly, nonatomic) UIStackView *stackView;
@property (retain, readonly, nonatomic) UIBarButtonItem *toggleProminenceBarButtonItem;
@end

@implementation ProminenceViewController
@synthesize stackView = _stackView;
@synthesize toggleProminenceBarButtonItem = _toggleProminenceBarButtonItem;

- (void)dealloc {
    [_stackView release];
    [_toggleProminenceBarButtonItem release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIStackView *stackView = self.stackView;
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:stackView];
    [NSLayoutConstraint activateConstraints:@[
        [stackView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [stackView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [stackView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
        [stackView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
    ]];
    
    self.navigationItem.rightBarButtonItem = self.toggleProminenceBarButtonItem;
}

- (UIStackView *)stackView {
    if (auto stackView = _stackView) return stackView;
    
    UIView *redView = [UIView new];
    redView.backgroundColor = UIColor.systemRedColor;
    
    UIView *orangeView = [UIView new];
    orangeView.backgroundColor = UIColor.systemOrangeColor;
    
    UIView *yellowView = [UIView new];
    yellowView.backgroundColor = UIColor.systemYellowColor;
    
    UIView *greenView = [UIView new];
    greenView.backgroundColor = UIColor.systemGreenColor;
    
    UIView *blueView = [UIView new];
    blueView.backgroundColor = UIColor.systemBlueColor;
    
    UIView *purpleView = [UIView new];
    purpleView.backgroundColor = UIColor.systemPurpleColor;
    
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[
        redView,
        orangeView,
        yellowView,
        greenView,
        blueView,
        purpleView
    ]];
    
    [redView release];
    [orangeView release];
    [yellowView release];
    [greenView release];
    [blueView release];
    [purpleView release];
    
    stackView.alignment = UIStackViewAlignmentFill;
    stackView.distribution = UIStackViewDistributionFillEqually;
    stackView.axis = UILayoutConstraintAxisVertical;
    
    _stackView = [stackView retain];
    return [stackView autorelease];
}

- (UIBarButtonItem *)toggleProminenceBarButtonItem {
    if (auto toggleProminenceBarButtonItem = _toggleProminenceBarButtonItem) return toggleProminenceBarButtonItem;
    
    UIBarButtonItem *toggleProminenceBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Toggle" style:UIBarButtonItemStylePlain target:self action:@selector(toggleProminenceBarButtonItemDidTrigger:)];
    
    _toggleProminenceBarButtonItem = [toggleProminenceBarButtonItem retain];
    return [toggleProminenceBarButtonItem autorelease];
}

- (void)toggleProminenceBarButtonItemDidTrigger:(UIBarButtonItem *)sender {
    UIColorProminence currentProminence = self.stackView.arrangedSubviews.firstObject.backgroundColor.prominence;
    
    NSInteger *ptr = (NSInteger *)&currentProminence;
    *ptr = (*ptr) + 1;
    
    if (currentProminence == 4) {
        currentProminence = UIColorProminencePrimary;
    }
    
    for (UIView *view in self.stackView.arrangedSubviews) {
        view.backgroundColor = [view.backgroundColor colorWithProminence:currentProminence];
    }
}

@end
