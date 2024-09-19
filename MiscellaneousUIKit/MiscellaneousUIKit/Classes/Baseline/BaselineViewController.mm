//
//  BaselineViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 9/19/24.
//

#import "BaselineViewController.h"

@interface BaselineViewController ()
@property (retain, nonatomic, readonly) UIStackView *stackView;
@property (retain, nonatomic, readonly) UILabel *label_1;
@property (retain, nonatomic, readonly) UILabel *label_2;
@property (retain, nonatomic, readonly) UILabel *label_3;
@end

@implementation BaselineViewController
@synthesize stackView = _stackView;
@synthesize label_1 = _label_1;
@synthesize label_2 = _label_2;
@synthesize label_3 = _label_3;

- (void)dealloc {
    [_stackView release];
    [_label_1 release];
    [_label_2 release];
    [_label_3 release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.stackView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    
    UINavigationItem *navigationItem = self.navigationItem;
    UIBarButtonItem *toggleBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Toggle" style:UIBarButtonItemStylePlain target:self action:@selector(toggle:)];
    navigationItem.rightBarButtonItem = toggleBarButtonItem;
    [toggleBarButtonItem release];
}

- (void)toggle:(UIBarButtonItem *)sender {
    UIStackView *stackView = self.stackView;
    
    stackView.alignment = (stackView.alignment == UIStackViewAlignmentFirstBaseline) ? UIStackViewAlignmentLastBaseline : UIStackViewAlignmentFirstBaseline;
}

- (UIStackView *)stackView {
    if (auto stackView = _stackView) return stackView;
    
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[
        self.label_1,
        self.label_2,
        self.label_3
    ]];
    
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.distribution = UIStackViewDistributionFillEqually;
    stackView.alignment = UIStackViewAlignmentFirstBaseline;
    stackView.spacing = 8.;
    
    _stackView = [stackView retain];
    return [stackView autorelease];
}

- (UILabel *)label_1 {
    if (auto label_1 = _label_1) return label_1;
    
    UILabel *label_1 = [UILabel new];
    label_1.numberOfLines = 0;
    label_1.backgroundColor = UIColor.systemCyanColor;
    label_1.textColor = UIColor.systemOrangeColor;
    label_1.font = [UIFont preferredFontForTextStyle:UIFontTextStyleLargeTitle];
    label_1.text = @"HelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHello";
    
    _label_1 = [label_1 retain];
    return [label_1 autorelease];
}

- (UILabel *)label_2 {
    if (auto label_2 = _label_2) return label_2;
    
    UILabel *label_2 = [UILabel new];
    label_2.numberOfLines = 0;
    label_2.backgroundColor = UIColor.systemCyanColor;
    label_2.textColor = UIColor.systemOrangeColor;
    label_2.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle1];
    label_2.text = @"Hello";
    
    _label_2 = [label_2 retain];
    return [label_2 autorelease];
}

- (UILabel *)label_3 {
    if (auto label_3 = _label_3) return label_3;
    
    UILabel *label_3 = [UILabel new];
    label_3.numberOfLines = 0;
    label_3.backgroundColor = UIColor.systemCyanColor;
    label_3.textColor = UIColor.systemOrangeColor;
    label_3.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    label_3.text = @"HelloHelloHelloHelloHelloHell";
    
    _label_3 = [label_3 retain];
    return [label_3 autorelease];
}

@end
