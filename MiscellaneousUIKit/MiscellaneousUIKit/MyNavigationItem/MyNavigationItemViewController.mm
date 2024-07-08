//
//  MyNavigationItemViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 7/9/24.
//

#import "MyNavigationItemViewController.h"

// TODO: 새로 생긴 Symbol Effects

@interface MyNavigationItemViewController () <UINavigationItemRenameDelegate>

@end

@implementation MyNavigationItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    
    UINavigationItem *navigationItem = self.navigationItem;
    
    navigationItem.renameDelegate = self;
    navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    navigationItem.style = UINavigationItemStyleEditor;
    navigationItem.customizationIdentifier = @"identifier";
    navigationItem.title = @"Hello";
    
    UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneBarButtonItemDidTrigger:)];
    
    UIBarButtonItem *diamondBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"diamond.fill"] style:UIBarButtonItemStylePlain target:self action:@selector(diamondBarButtonItemDidTrigger:)];
    
    UIBarButtonItem *triangleshapeBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"triangleshape.fill"] style:UIBarButtonItemStylePlain target:self action:@selector(diamondBarButtonItemDidTrigger:)];
    
    navigationItem.leadingItemGroups = @[
        [UIBarButtonItemGroup fixedGroupWithRepresentativeItem:nil items:@[doneBarButtonItem]],
        [UIBarButtonItemGroup optionalGroupWithCustomizationIdentifier:@"optiona;" inDefaultCustomization:YES representativeItem:diamondBarButtonItem items:@[triangleshapeBarButtonItem]]
    ];
    
    [doneBarButtonItem release];
    [diamondBarButtonItem release];
    [triangleshapeBarButtonItem release];
    
    navigationItem.centerItemGroups = @[
    
    ];
    
    navigationItem.trailingItemGroups = @[
    
    ];
    
    navigationItem.pinnedTrailingGroup = nil;
    
    navigationItem.titleMenuProvider = ^UIMenu * _Nullable (NSArray<UIMenuElement *> *suggestedActions) {
        UIMenu *menu = [UIMenu menuWithChildren:suggestedActions];
        return menu;
    };
    
    __weak auto weakSelf = self;
    navigationItem.backAction = [UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)doneBarButtonItemDidTrigger:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)diamondBarButtonItemDidTrigger:(UIBarButtonItem *)sender {}


#pragma mark - UINavigationItemRenameDelegate

- (BOOL)navigationItemShouldBeginRenaming:(UINavigationItem *)navigationItem {
    return YES;
}

- (BOOL)navigationItem:(UINavigationItem *)navigationItem shouldEndRenamingWithTitle:(NSString *)title {
    return YES;
}

- (NSString *)navigationItem:(UINavigationItem *)navigationItem willBeginRenamingWithSuggestedTitle:(NSString *)title selectedRange:(inout NSRange *)selectedRange {
    *selectedRange = NSMakeRange(title.length, 6);
    return [title stringByAppendingString:@" 12345"];
}

- (void)navigationItem:(UINavigationItem *)navigationItem didEndRenamingWithTitle:(NSString *)title {
    NSLog(@"%@", title);
}

@end
