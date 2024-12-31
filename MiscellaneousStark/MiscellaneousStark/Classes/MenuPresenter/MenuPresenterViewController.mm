//
//  MenuPresenterViewController.mm
//  MiscellaneousStark
//
//  Created by Jinwoo Kim on 1/1/25.
//

#import "MenuPresenterViewController.h"

@interface MenuPresenterViewController ()

@end

@implementation MenuPresenterViewController

- (void)loadView {
    UIAction *action = [UIAction actionWithTitle:@"Title" image:[UIImage systemImageNamed:@"bookmark.square"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        
    }];
    
    UIMenu *menu = [UIMenu menuWithChildren:@[action]];
    UIButtonConfiguration *configuration = [UIButtonConfiguration plainButtonConfiguration];
    configuration.title = @"Present";
    
    UIButton *button = [UIButton buttonWithConfiguration:configuration primaryAction:nil];
    button.menu = menu;
    button.showsMenuAsPrimaryAction = YES;
    
    self.view = button;
}

@end
