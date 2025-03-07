//
//  ToolItemsConfigurationViewController.m
//  MyCanvas
//
//  Created by Jinwoo Kim on 3/7/25.
//

#import "ToolItemsConfigurationViewController.h"

@interface ToolItemsConfigurationViewController ()
@property (retain, nonatomic, readonly, getter=_menuButton) UIButton *menuButton;
@property (retain, nonatomic, readonly, getter=_doneBarButtonItem) UIBarButtonItem *doneBarButtonItem;
@property (retain, nonatomic, readonly, getter=_toolItems) NSMutableArray<PKToolPickerItem *> *toolItems;
@end

@implementation ToolItemsConfigurationViewController
@synthesize menuButton = _menuButton;
@synthesize doneBarButtonItem = _doneBarButtonItem;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        PKToolPicker *toolPicker = [PKToolPicker new];
        _toolItems = [toolPicker.toolItems mutableCopy];
        [toolPicker release];
    }
    
    return self;
}

- (instancetype)initWithToolItems:(NSArray<__kindof PKToolPickerItem *> *)toolItems {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _toolItems = [toolItems copy];
    }
    
    return self;
}

- (void)dealloc {
    [_menuButton release];
    [_doneBarButtonItem release];
    [_toolItems release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.menuButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.menuButton.menu = [self _makeMenu];
    self.navigationItem.ri
}

- (UIButton *)_menuButton {
    if (auto menuButton = _menuButton) return menuButton;
    
    UIButton *menuButton = [UIButton new];
    
    UIButtonConfiguration *configuration = [UIButtonConfiguration filledButtonConfiguration];
    configuration.title = @"Menu";
    
    menuButton.configuration = configuration;
    
    _menuButton = menuButton;
    return menuButton;
}

- (UIBarButtonItem *)_doneBarButtonItem {
    if (auto doneBarButtonItem = _doneBarButtonItem) return doneBarButtonItem;
    
    UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(_didTriggerDoneBarButtonItem:)];
    
    _doneBarButtonItem = doneBarButtonItem;
    return doneBarButtonItem;
}

- (void)_didTriggerDoneBarButtonItem:(UIBarButtonItem *)sender {
    [self.delegate toolItemsConfigurationViewController:self didFinishWithToolItems:self.toolItems];
}

- (UIMenu *)_makeMenu {
    NSMutableArray<PKToolPickerItem *> *toolItems = self.toolItems;
    
    UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
        NSMutableArray<__kindof UIMenuElement *> *rootChildren = [NSMutableArray new];
        
        {
            NSMutableArray<UIAction *> *actions = [[NSMutableArray alloc] initWithCapacity:toolItems.count];
            
            for (PKToolPickerItem *toolItem in toolItems) {
                UIAction *action = [UIAction actionWithTitle:toolItem.identifier image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    [toolItems removeObject:toolItem];
                }];
                
                action.attributes = UIMenuElementAttributesDestructive;
                action.subtitle = NSStringFromClass([toolItem class]);
                [actions addObject:action];
            }
            
            UIMenu *menu = [UIMenu menuWithTitle:@"" image:nil identifier:nil options:UIMenuOptionsDisplayInline children:actions];
            [actions release];
            [rootChildren addObject:menu];
        }
        
        completion(rootChildren);
        [rootChildren release];
    }];
    
    UIMenu *menu = [UIMenu menuWithChildren:@[element]];
    return menu;
}

@end
