//
//  SymbolEffectsViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 7/9/24.
//

#import "SymbolEffectsViewController.h"

@interface SymbolEffectsViewController ()
@property (retain, readonly, nonatomic) UIStackView *stackView;
@property (retain, readonly, nonatomic) UIImageView *bounceEffectImageView;
@property (retain, readonly, nonatomic) UIImageView *pulseEffectImageView;
@property (retain, readonly, nonatomic) UIImageView *variableColorEffectImageView;
@property (retain, readonly, nonatomic) UIImageView *breatheEffectImageView;
@property (retain, readonly, nonatomic) UIImageView *rotateEffectImageView;
@property (retain, readonly, nonatomic) UIImageView *wiggleEffectImageView;
@property (retain, readonly, nonatomic) UIBarButtonItem *rotateBarButtonItem;
@end

@implementation SymbolEffectsViewController
@synthesize stackView = _stackView;
@synthesize bounceEffectImageView = _bounceEffectImageView;
@synthesize pulseEffectImageView = _pulseEffectImageView;
@synthesize variableColorEffectImageView = _variableColorEffectImageView;
@synthesize breatheEffectImageView = _breatheEffectImageView;
@synthesize rotateEffectImageView = _rotateEffectImageView;
@synthesize wiggleEffectImageView = _wiggleEffectImageView;
@synthesize rotateBarButtonItem = _rotateBarButtonItem;

- (void)dealloc {
    [_stackView release];
    [_bounceEffectImageView release];
    [_pulseEffectImageView release];
    [_variableColorEffectImageView release];
    [_breatheEffectImageView release];
    [_rotateEffectImageView release];
    [_wiggleEffectImageView release];
    [_rotateBarButtonItem release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.stackView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    self.navigationItem.rightBarButtonItem = self.rotateBarButtonItem;
}

- (UIStackView *)stackView {
    if (auto stackView = _stackView) return stackView;
    
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[
        self.bounceEffectImageView,
        self.pulseEffectImageView,
        self.variableColorEffectImageView,
        self.breatheEffectImageView,
        self.rotateEffectImageView,
        self.wiggleEffectImageView
    ]];
    
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.distribution = UIStackViewDistributionFillEqually;
    stackView.alignment = UIStackViewAlignmentFill;
    
    _stackView = [stackView retain];
    return [stackView autorelease];
}

- (UIImageView *)bounceEffectImageView {
    if (auto bounceEffectImageView = _bounceEffectImageView) return bounceEffectImageView;
    
    UIImageSymbolConfiguration *configuration = [UIImageSymbolConfiguration configurationWithPaletteColors:@[
        UIColor.systemRedColor,
        UIColor.systemGreenColor
    ]];
    
    UIImageView *bounceEffectImageView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"bubble.left.and.bubble.right.fill" withConfiguration:configuration]];
    bounceEffectImageView.contentMode = UIViewContentModeScaleAspectFit;
    [bounceEffectImageView addSymbolEffect:[[NSSymbolBounceEffect bounceUpEffect] effectWithByLayer] options:[NSSymbolEffectOptions optionsWithRepeatBehavior:[NSSymbolEffectOptionsRepeatBehavior behaviorPeriodic]]];
    
    _bounceEffectImageView = [bounceEffectImageView retain];
    return [bounceEffectImageView autorelease];
}

- (UIImageView *)pulseEffectImageView {
    if (auto pulseEffectImageView = _pulseEffectImageView) return pulseEffectImageView;
    
    UIImageSymbolConfiguration *configuration = [UIImageSymbolConfiguration configurationWithPaletteColors:@[
        UIColor.systemRedColor,
        UIColor.systemGreenColor
    ]];
    
    UIImageView *pulseEffectImageView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"sharedwithyou" withConfiguration:configuration]];
    pulseEffectImageView.contentMode = UIViewContentModeScaleAspectFit;
    [pulseEffectImageView addSymbolEffect:[[NSSymbolPulseEffect effect] effectWithByLayer] options:[NSSymbolEffectOptions optionsWithRepeatBehavior:[NSSymbolEffectOptionsRepeatBehavior behaviorPeriodic]]];
    
    _pulseEffectImageView = [pulseEffectImageView retain];
    return [pulseEffectImageView autorelease];
}

- (UIImageView *)variableColorEffectImageView {
    if (auto variableColorEffectImageView = _variableColorEffectImageView) return variableColorEffectImageView;
    
    UIImageSymbolConfiguration *configuration = [UIImageSymbolConfiguration configurationWithPaletteColors:@[
        UIColor.systemRedColor,
        UIColor.systemGreenColor
    ]];
    
    UIImageView *variableColorEffectImageView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"pencil.tip.crop.circle.badge.arrow.forward.fill" withConfiguration:configuration]];
    variableColorEffectImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [variableColorEffectImageView addSymbolEffect:[[NSSymbolVariableColorEffect effect] effectWithDimInactiveLayers] options:[NSSymbolEffectOptions optionsWithRepeatBehavior:[NSSymbolEffectOptionsRepeatBehavior behaviorContinuous]]];
    
    _variableColorEffectImageView = [variableColorEffectImageView retain];
    return [variableColorEffectImageView autorelease];
}

- (UIImageView *)breatheEffectImageView {
    if (auto breatheEffectImageView = _breatheEffectImageView) return breatheEffectImageView;
    
    UIImageSymbolConfiguration *configuration = [UIImageSymbolConfiguration configurationWithPaletteColors:@[
        UIColor.systemRedColor,
        UIColor.systemGreenColor
    ]];
    
    UIImageView *breatheEffectImageView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"square.stack.3d.up" withConfiguration:configuration]];
    
    breatheEffectImageView.contentMode = UIViewContentModeScaleAspectFit;
    [breatheEffectImageView addSymbolEffect:[[NSSymbolBreatheEffect breathePulseEffect] effectWithByLayer] options:[NSSymbolEffectOptions optionsWithRepeatBehavior:[NSSymbolEffectOptionsRepeatBehavior behaviorContinuous]]];
    
    _breatheEffectImageView = [breatheEffectImageView retain];
    return [breatheEffectImageView autorelease];
}

- (UIImageView *)rotateEffectImageView {
    if (auto rotateEffectImageView = _rotateEffectImageView) return rotateEffectImageView;
    
    UIImageSymbolConfiguration *configuration = [UIImageSymbolConfiguration configurationWithPaletteColors:@[
        UIColor.systemPinkColor,
        UIColor.systemGreenColor
    ]];
    
    UIImageView *rotateEffectImageView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"fan.desk" withConfiguration:configuration]];
    rotateEffectImageView.contentMode = UIViewContentModeScaleAspectFit;
    [rotateEffectImageView addSymbolEffect:[[NSSymbolRotateEffect rotateClockwiseEffect] effectWithByLayer] options:[NSSymbolEffectOptions optionsWithRepeatBehavior:[NSSymbolEffectOptionsRepeatBehavior behaviorContinuous]]];
    
    _rotateEffectImageView = [rotateEffectImageView retain];
    return [rotateEffectImageView autorelease];
}

- (UIImageView *)wiggleEffectImageView {
    if (auto wiggleEffectImageView = _wiggleEffectImageView) return wiggleEffectImageView;
    
    UIImageSymbolConfiguration *configuration = [UIImageSymbolConfiguration configurationWithPaletteColors:@[
        UIColor.systemPinkColor,
        UIColor.systemGreenColor
    ]];
    
    UIImageView *wiggleEffectImageView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"square.and.arrow.up" withConfiguration:configuration]];
    wiggleEffectImageView.contentMode = UIViewContentModeScaleAspectFit;
    [wiggleEffectImageView addSymbolEffect:[[NSSymbolWiggleEffect wiggleUpEffect] effectWithByLayer] options:[NSSymbolEffectOptions optionsWithRepeatBehavior:[NSSymbolEffectOptionsRepeatBehavior behaviorContinuous]]];
    
    _wiggleEffectImageView = [wiggleEffectImageView retain];
    return [wiggleEffectImageView autorelease];
}

- (UIBarButtonItem *)rotateBarButtonItem {
    if (auto rotateBarButtonItem = _rotateBarButtonItem) return rotateBarButtonItem;
    
    UIImageSymbolConfiguration *configuration = [UIImageSymbolConfiguration configurationWithPaletteColors:@[
        UIColor.systemPinkColor,
        UIColor.systemGreenColor
    ]];
    
    NSSymbolVariableColorEffect *effect = [[[[NSSymbolVariableColorEffect effect] effectWithIterative] effectWithDimInactiveLayers] effectWithReversing];
    NSSymbolEffectOptions *options = [NSSymbolEffectOptions optionsWithSpeed:0.1];
    
    UIBarButtonItem *rotateBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"cellularbars"] menu:nil];
    
    [rotateBarButtonItem addSymbolEffect:effect options:options];
    rotateBarButtonItem.symbolAnimationEnabled = YES;
    
    _rotateBarButtonItem = [rotateBarButtonItem retain];
    return [rotateBarButtonItem autorelease];
}

- (void)rotateBarButtonItemDidTrigger:(UIBarButtonItem *)sender {}

@end
