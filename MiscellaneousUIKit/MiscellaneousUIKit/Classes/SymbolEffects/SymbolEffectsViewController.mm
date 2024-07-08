//
//  SymbolEffectsViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 7/9/24.
//

#import "SymbolEffectsViewController.h"

// square.stack.3d.up
@interface SymbolEffectsViewController ()
@property (retain, readonly, nonatomic) UIStackView *stackView;
@property (retain, readonly, nonatomic) UIImageView *appearEffectImageView;
@property (retain, readonly, nonatomic) UIImageView *bounceEffectImageView;
@property (retain, readonly, nonatomic) UIImageView *disappearEffectImageView;
@property (retain, readonly, nonatomic) UIImageView *pulseEffectImageView;
@property (retain, readonly, nonatomic) UIImageView *scaleEffectImageView;
@property (retain, readonly, nonatomic) UIImageView *variableColorEffectImageView;
@property (retain, readonly, nonatomic) UIImageView *breatheEffectImageView;
@property (retain, readonly, nonatomic) UIImageView *rotateEffectImageView;
@property (retain, readonly, nonatomic) UIImageView *wiggleEffectImageView;
@end

@implementation SymbolEffectsViewController
@synthesize stackView = _stackView;
@synthesize appearEffectImageView = _appearEffectImageView;
@synthesize bounceEffectImageView = _bounceEffectImageView;
@synthesize disappearEffectImageView = _disappearEffectImageView;
@synthesize pulseEffectImageView = _pulseEffectImageView;
@synthesize scaleEffectImageView = _scaleEffectImageView;
@synthesize variableColorEffectImageView = _variableColorEffectImageView;
@synthesize breatheEffectImageView = _breatheEffectImageView;
@synthesize rotateEffectImageView = _rotateEffectImageView;
@synthesize wiggleEffectImageView = _wiggleEffectImageView;

- (void)dealloc {
    [_stackView release];
    [_appearEffectImageView release];
    [_bounceEffectImageView release];
    [_disappearEffectImageView release];
    [_pulseEffectImageView release];
    [_scaleEffectImageView release];
    [_variableColorEffectImageView release];
    [_breatheEffectImageView release];
    [_rotateEffectImageView release];
    [_wiggleEffectImageView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

@end
