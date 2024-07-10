//
//  MyNavigationItemViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 7/9/24.
//

#import "MyNavigationItemViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface MyNavigationItemViewController () <UINavigationItemRenameDelegate>

@end

@implementation MyNavigationItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    
    UINavigationItem *navigationItem = self.navigationItem;
    
    navigationItem.renameDelegate = self;
    navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
//    navigationItem.style = UINavigationItemStyleEditor;
    navigationItem.style = UINavigationItemStyleBrowser;
    navigationItem.customizationIdentifier = @"identifier";
    navigationItem.title = @"Hello";
    
    //
    
    UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneBarButtonItemDidTrigger:)];
    
    UIBarButtonItem *diamondBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"diamond.fill"] style:UIBarButtonItemStylePlain target:self action:@selector(diamondBarButtonItemDidTrigger:)];
    
    UIBarButtonItem *triangleshapeBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"triangleshape.fill"] style:UIBarButtonItemStylePlain target:self action:@selector(diamondBarButtonItemDidTrigger:)];
    
    navigationItem.leadingItemGroups = @[
        [UIBarButtonItemGroup fixedGroupWithRepresentativeItem:nil items:@[doneBarButtonItem]],
        [UIBarButtonItemGroup optionalGroupWithCustomizationIdentifier:@"optional_1" inDefaultCustomization:YES representativeItem:diamondBarButtonItem items:@[triangleshapeBarButtonItem]]
    ];
    
    [doneBarButtonItem release];
    [diamondBarButtonItem release];
    [triangleshapeBarButtonItem release];
    
    //
    
    UIBarButtonItem *noteBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"note"] style:UIBarButtonItemStylePlain target:self action:@selector(noteBarButtonItemDidTrigger:)];
    UIBarButtonItem *bookPagesBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"book.pages"] style:UIBarButtonItemStylePlain target:self action:@selector(bookPagesBarButtonItemDidTrigger:)];
    UIBarButtonItem *ladybugBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"ladybug"] style:UIBarButtonItemStylePlain target:self action:@selector(ladybugBarButtonItemDidTrigger:)];
    
    navigationItem.centerItemGroups = @[
        [UIBarButtonItemGroup movableGroupWithCustomizationIdentifier:@"movable_1" representativeItem:nil items:@[noteBarButtonItem, bookPagesBarButtonItem]],
        [UIBarButtonItemGroup fixedGroupWithRepresentativeItem:nil items:@[ladybugBarButtonItem]]
//        [UIBarButtonItemGroup optionalGroupWithCustomizationIdentifier:@"optional_3" inDefaultCustomization:NO representativeItem:nil items:@[ladybugBarButtonItem]]
    ];
    
    [noteBarButtonItem release];
    [bookPagesBarButtonItem release];
    [ladybugBarButtonItem release];
    
    //
    
    UIBarButtonItem *eraserBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"eraser"] style:UIBarButtonItemStylePlain target:self action:@selector(eraserBarButtonItemDidTrigger:)];
    UIBarButtonItem *trashBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"trash"] style:UIBarButtonItemStylePlain target:self action:@selector(trashBarButtonItemDidTrigger:)];
    UIBarButtonItem *folderBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"folder"] style:UIBarButtonItemStylePlain target:self action:@selector(folderBarButtonItemDidTrigger:)];
    UIBarButtonItem *paperplaneBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"paperplane"] style:UIBarButtonItemStylePlain target:self action:@selector(paperplaneBarButtonItemDidTrigger:)];
    UIBarButtonItem *archiveboxBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"archivebox"] style:UIBarButtonItemStylePlain target:self action:@selector(archiveboxBarButtonItemDidTrigger:)];
    
    navigationItem.trailingItemGroups = @[
        // 공간이 좁으면 representativeItem이 보임
        [UIBarButtonItemGroup optionalGroupWithCustomizationIdentifier:@"optional_2" inDefaultCustomization:YES representativeItem:eraserBarButtonItem items:@[trashBarButtonItem, folderBarButtonItem, paperplaneBarButtonItem, archiveboxBarButtonItem]]
    ];
    
    [eraserBarButtonItem release];
    [trashBarButtonItem release];
    [folderBarButtonItem release];
    [paperplaneBarButtonItem release];
    [archiveboxBarButtonItem release];
    
    //
    
    UIBarButtonItem *messageBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"message"] style:UIBarButtonItemStylePlain target:self action:@selector(messageBarButtonItemDidTrigger:)];
    
    navigationItem.pinnedTrailingGroup = [UIBarButtonItemGroup fixedGroupWithRepresentativeItem:nil items:@[messageBarButtonItem]];
    
    [messageBarButtonItem release];
    
    //
    
    navigationItem.titleMenuProvider = ^UIMenu * _Nullable (NSArray<UIMenuElement *> *suggestedActions) {
        NSMutableArray<UIMenuElement *> *children = [suggestedActions mutableCopy];
        
        UIMenu *secondaryMenu = [UIMenu menuWithTitle:@"" image:nil identifier:nil options:UIMenuOptionsDisplayInline children:@[
            [UIAction actionWithTitle:@"Hello" image:[UIImage systemImageNamed:@"hand.wave"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {}]
        ]];
        
        [children addObject:secondaryMenu];
        
        UIMenu *menu = [UIMenu menuWithChildren:children];
        [children release];
        
        return menu;
    };
    
    __weak auto weakSelf = self;
    navigationItem.backAction = [UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    
    //
    
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    
    searchController.obscuresBackgroundDuringPresentation = YES;
    searchController.hidesNavigationBarDuringPresentation = YES;
    
    navigationItem.searchController = searchController;
    [searchController release];
    navigationItem.preferredSearchBarPlacement = UINavigationItemSearchBarPlacementInline;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UINavigationItem *navigationItem = self.navigationItem;
    
    UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
    appearance.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemChromeMaterial];
    
    [navigationItem setCompactAppearance:appearance];
    [navigationItem setStandardAppearance:appearance];
    [navigationItem setScrollEdgeAppearance:appearance];
    [navigationItem setCompactScrollEdgeAppearance:appearance];
    
    [appearance release];
    
    [self.navigationController.navigationBar setOverrideUserInterfaceStyle:UIUserInterfaceStyleDark];
    self.navigationController.navigationBar.tintColor = UIColor.whiteColor;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setOverrideUserInterfaceStyle:UIUserInterfaceStyleUnspecified];
    self.navigationController.navigationBar.tintColor = nil;
}

- (void)doneBarButtonItemDidTrigger:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)diamondBarButtonItemDidTrigger:(UIBarButtonItem *)sender {}

- (void)noteBarButtonItemDidTrigger:(UIBarButtonItem *)sender {}

- (void)bookPagesBarButtonItemDidTrigger:(UIBarButtonItem *)sender {}

- (void)ladybugBarButtonItemDidTrigger:(UIBarButtonItem *)sender {
    // -[_UINavigationBarVisualProviderModernIOS _beginCustomization]
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    
    id _visualProvider;
    object_getInstanceVariable(navigationBar, "_visualProvider", (void **)&_visualProvider);
    
    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(_visualProvider, sel_registerName("_beginCustomization"));
}

- (void)eraserBarButtonItemDidTrigger:(UIBarButtonItem *)sender {}

- (void)trashBarButtonItemDidTrigger:(UIBarButtonItem *)sender {}

- (void)folderBarButtonItemDidTrigger:(UIBarButtonItem *)sender {}

- (void)paperplaneBarButtonItemDidTrigger:(UIBarButtonItem *)sender {}

- (void)archiveboxBarButtonItemDidTrigger:(UIBarButtonItem *)sender {}

- (void)messageBarButtonItemDidTrigger:(UIBarButtonItem *)sender {}


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
