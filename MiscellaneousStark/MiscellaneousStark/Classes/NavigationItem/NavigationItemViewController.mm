//
//  NavigationItemViewController.mm
//  MiscellaneousStark
//
//  Created by Jinwoo Kim on 1/1/25.
//

#import "NavigationItemViewController.h"

@interface NavigationItemViewController ()

@end

@implementation NavigationItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    
    UINavigationItem *navigationItem = self.navigationItem;
    navigationItem.title = @"Title";
    navigationItem.prompt = @"Prompt";
    navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    
    navigationItem.titleMenuProvider = ^ UIMenu * _Nullable(NSArray<UIMenuElement *> *suggestedActions) {
        UIAction *action = [UIAction actionWithTitle:@"Title" image:[UIImage systemImageNamed:@"bookmark.square"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            
        }];
        
        UIMenu *menu = [UIMenu menuWithTitle:@"Title" children:@[action]];
        
        return menu;
    };
    
    UIAction *action = [UIAction actionWithTitle:@"Title" image:[UIImage systemImageNamed:@"bookmark.square"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        
    }];
    
    UIMenu *menu = [UIMenu menuWithChildren:@[action]];
    UIBarButtonItem *menuBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" menu:menu];
    
    navigationItem.rightBarButtonItem = menuBarButtonItem;
    [menuBarButtonItem release];
}

@end
