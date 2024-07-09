//
//  SymbolTransitionsViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 7/9/24.
//

#import "SymbolTransitionsViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface SymbolTransitionsViewController ()
@property (retain, readonly, nonatomic) UIBarButtonItem *transitBarButtonItem;
@property (retain, readonly, nonatomic) UIStackView *stackView;
@property (retain, readonly, nonatomic) UIImageView *replaceTransitionImageView;
@property (retain, readonly, nonatomic) UIImageView *magicReplaceTransitionImageView;
@property (assign, nonatomic) BOOL flag;
@end

@implementation SymbolTransitionsViewController
@synthesize transitBarButtonItem = _transitBarButtonItem;
@synthesize stackView = _stackView;
@synthesize replaceTransitionImageView = _replaceTransitionImageView;
@synthesize magicReplaceTransitionImageView = _magicReplaceTransitionImageView;

- (void)dealloc {
    [_transitBarButtonItem release];
    [_stackView release];
    [_replaceTransitionImageView release];
    [_magicReplaceTransitionImageView release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.stackView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    self.navigationItem.rightBarButtonItem = self.transitBarButtonItem;
}

- (UIBarButtonItem *)transitBarButtonItem {
    if (auto transitBarButtonItem = _transitBarButtonItem) return transitBarButtonItem;
    
    UIImageSymbolConfiguration *configuration = [UIImageSymbolConfiguration configurationWithPaletteColors:@[
        UIColor.systemRedColor,
        UIColor.systemGreenColor
    ]];
    
    UIBarButtonItem *transitBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"translate" withConfiguration:configuration] style:UIBarButtonItemStylePlain target:self action:@selector(transitBarButtonItemDidTrigger:)];
    
    _transitBarButtonItem = [transitBarButtonItem retain];
    return [transitBarButtonItem autorelease];
}

- (UIStackView *)stackView {
    if (auto stackView = _stackView) return stackView;
    
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[
        self.replaceTransitionImageView,
        self.magicReplaceTransitionImageView
    ]];
    
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.distribution = UIStackViewDistributionFillEqually;
    stackView.alignment = UIStackViewAlignmentFill;
    
    _stackView = [stackView retain];
    return [stackView autorelease];
}

- (UIImageView *)replaceTransitionImageView {
    if (auto replaceTransitionImageView = _replaceTransitionImageView) return replaceTransitionImageView;
    
    UIImageSymbolConfiguration *configuration = [UIImageSymbolConfiguration configurationWithPaletteColors:@[
        UIColor.systemGreenColor
    ]];
    
    UIImageView *replaceTransitionImageView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"bell" withConfiguration:configuration]];
    replaceTransitionImageView.contentMode = UIViewContentModeScaleAspectFit;
    
//    [replaceTransitionImageView addSymbolEffect:[[NSSymbolRotateEffect rotateClockwiseEffect] effectWithByLayer] options:[NSSymbolEffectOptions optionsWithRepeatBehavior:[NSSymbolEffectOptionsRepeatBehavior behaviorContinuous]]];
    
    _replaceTransitionImageView = [replaceTransitionImageView retain];
    return [replaceTransitionImageView autorelease];
}

- (UIImageView *)magicReplaceTransitionImageView {
    if (auto magicReplaceTransitionImageView = _magicReplaceTransitionImageView) return magicReplaceTransitionImageView;
    
    UIImageSymbolConfiguration *configuration = [UIImageSymbolConfiguration configurationWithPaletteColors:@[
        UIColor.systemGreenColor
    ]];
    
    UIImageView *magicReplaceTransitionImageView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"bell" withConfiguration:configuration]];
    magicReplaceTransitionImageView.contentMode = UIViewContentModeScaleAspectFit;
    
//    [magicReplaceTransitionImageView addSymbolEffect:[[NSSymbolRotateEffect rotateClockwiseEffect] effectWithByLayer] options:[NSSymbolEffectOptions optionsWithRepeatBehavior:[NSSymbolEffectOptionsRepeatBehavior behaviorContinuous]]];
    
    _magicReplaceTransitionImageView = [magicReplaceTransitionImageView retain];
    return [magicReplaceTransitionImageView autorelease];
}

- (void)transitBarButtonItemDidTrigger:(UIBarButtonItem *)sender {
    UIImageSymbolConfiguration *configuration = [UIImageSymbolConfiguration configurationWithPaletteColors:@[
        UIColor.systemGreenColor
    ]];
    
//    NSSymbolMagicReplaceContentTransition *magicReplaceContentTransition = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(NSSymbolMagicReplaceContentTransition.class, sel_registerName("transitionWithFallback:"), [[NSSymbolReplaceContentTransition replaceDownUpTransition] transitionWithByLayer]);
//    NSSymbolMagicReplaceContentTransition *magicReplaceContentTransition = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(NSSymbolMagicReplaceContentTransition.class, sel_registerName("transition"));
    NSSymbolMagicReplaceContentTransition *magicReplaceContentTransition = [NSSymbolReplaceContentTransition magicTransitionWithFallback:[[NSSymbolReplaceContentTransition replaceDownUpTransition] transitionWithByLayer]];
    
    if (self.flag) {
        [self.replaceTransitionImageView setSymbolImage:[UIImage systemImageNamed:@"bell" withConfiguration:configuration] withContentTransition:[[NSSymbolReplaceContentTransition replaceDownUpTransition] transitionWithByLayer]];
        [self.magicReplaceTransitionImageView setSymbolImage:[UIImage systemImageNamed:@"bell" withConfiguration:configuration] withContentTransition:magicReplaceContentTransition];
    } else {
        [self.replaceTransitionImageView setSymbolImage:[UIImage systemImageNamed:@"bell.slash" withConfiguration:configuration] withContentTransition:[[NSSymbolReplaceContentTransition replaceDownUpTransition] transitionWithByLayer]];
        [self.magicReplaceTransitionImageView setSymbolImage:[UIImage systemImageNamed:@"bell.slash" withConfiguration:configuration] withContentTransition:magicReplaceContentTransition];
    }
    
    self.flag = !self.flag;
}

@end
