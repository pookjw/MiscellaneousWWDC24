//
//  ToolbarAppearanceViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 7/10/24.
//

#import "ToolbarAppearanceViewController.h"

@interface ToolbarAppearanceViewController ()

@end

@implementation ToolbarAppearanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    
    UINavigationController *navigationController = self.navigationController;
    
    UINavigationItem *navigationItem = self.navigationItem;
    navigationItem.title = @"Title";
    
    //
    
    NSSymbolVariableColorEffect *effect = [[[[NSSymbolVariableColorEffect effect] effectWithIterative] effectWithDimInactiveLayers] effectWithReversing];
    NSSymbolEffectOptions *options = [NSSymbolEffectOptions optionsWithSpeed:0.1];
    
    UIBarButtonItem *rotateBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"cellularbars"] menu:nil];
    [rotateBarButtonItem addSymbolEffect:effect options:options];
    rotateBarButtonItem.symbolAnimationEnabled = YES;
    
    //
    
    UIBarButtonItem *helloBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Hello" menu:nil];
    UIBarButtonItem *hello2BarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Hello2" menu:nil];
    UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneBarButtonItemDidTrigger:)];
    
    //
    
//    navigationController.toolbarItems = @[rotateBarButtonItem, helloBarButtonItem];
//    toolbar.items = @[rotateBarButtonItem, helloBarButtonItem];
//    [toolbar setItems:@[rotateBarButtonItem, helloBarButtonItem] animated:YES];
    self.toolbarItems = @[
        rotateBarButtonItem, 
        [UIBarButtonItem flexibleSpaceItem],
        helloBarButtonItem,
        hello2BarButtonItem,
        doneBarButtonItem
    ]; // 이게 맞음 다른건 안 됨
    
    navigationController.toolbarHidden = NO;
    
    [rotateBarButtonItem release];
    [helloBarButtonItem release];
    [hello2BarButtonItem release];
    [doneBarButtonItem release];
    
    [self configureToolbarAppearance];
}

- (void)configureToolbarAppearance {
    UIToolbar *toolbar = self.navigationController.toolbar;
    
    [toolbar setOverrideUserInterfaceStyle:UIUserInterfaceStyleDark];
    toolbar.tintColor = UIColor.whiteColor;
    
    UIToolbarAppearance *appearance = [UIToolbarAppearance new];
    appearance.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemChromeMaterial];
    
    UIBarButtonItemAppearance *buttonAppearance = [[UIBarButtonItemAppearance alloc] initWithStyle:UIBarButtonItemStylePlain];
    buttonAppearance.normal.backgroundImage = [UIImage systemImageNamed:@"circle.grid.2x1.fill"];
    buttonAppearance.normal.titlePositionAdjustment = UIOffsetMake(0., -8.);
    buttonAppearance.normal.titleTextAttributes = @{NSForegroundColorAttributeName: UIColor.systemCyanColor};
    appearance.buttonAppearance = buttonAppearance;
    [buttonAppearance release];
    
    toolbar.compactAppearance = appearance;
    toolbar.standardAppearance = appearance;
    toolbar.scrollEdgeAppearance = appearance;
    toolbar.compactScrollEdgeAppearance = appearance;
    
    [appearance release];
}

- (void)doneBarButtonItemDidTrigger:(UIBarButtonItem *)sender {
    
}

@end
