//
//  InputAssistantItemViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 7/14/24.
//

#import "InputAssistantItemViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import <TargetConditionals.h>

@interface InputAssistantItemViewController ()
@property (retain, readonly, nonatomic) UISearchController *searchController;
@property (retain, readonly, nonatomic) UIBarButtonItem *dismissBarButtonItem;
@end

@implementation InputAssistantItemViewController
@synthesize searchController = _searchController;
@synthesize dismissBarButtonItem = _dismissBarButtonItem;

- (void)dealloc {
    [_searchController release];
    [_dismissBarButtonItem release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    
    UINavigationItem *navigationItem = self.navigationItem;
    navigationItem.leftBarButtonItem = self.dismissBarButtonItem;
    navigationItem.searchController = self.searchController;
}



- (UISearchController *)searchController {
    if (auto searchController = _searchController) return searchController;
    
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    
    UITextInputAssistantItem *inputAssistantItem = searchController.searchBar.inputAssistantItem;
    
    //
    
#if TARGET_OS_VISION
    UIBarButtonItem *rainBarButtonItem = [[UIBarButtonItem alloc] initWithPrimaryAction:[UIAction actionWithTitle:@"123" image:[UIImage systemImageNamed:@"cloud.heavyrain.fill"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {}]];
    
    inputAssistantItem.keyboardActionButtonItem = rainBarButtonItem;
    [rainBarButtonItem release];
#else
    UIBarButtonItem *firstBarButtonItem = [[UIBarButtonItem alloc] initWithPrimaryAction:[UIAction actionWithTitle:@"1" image:[UIImage systemImageNamed:@"pencil.and.outline"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {}]];
    UIBarButtonItem *secondBarButtonItem = [[UIBarButtonItem alloc] initWithPrimaryAction:[UIAction actionWithTitle:@"2" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {}]];
    UIBarButtonItem *_keyboardDeleteItem = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("UITextInputAssistantItem"), sel_registerName("_keyboardDeleteItem"));
    
        inputAssistantItem.leadingBarButtonGroups = @[
            [UIBarButtonItemGroup fixedGroupWithRepresentativeItem:nil items:@[firstBarButtonItem, secondBarButtonItem, _keyboardDeleteItem]],
        ];
    
    [firstBarButtonItem release];
    [secondBarButtonItem release];
    
    // General - Keyboard에서 Shortcuts 설정에 따라 뜨고 말게 할지
    inputAssistantItem.allowsHidingShortcuts = YES;
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(inputAssistantItem, sel_registerName("_setDetachedBackgroundColor:"), [UIColor.systemCyanColor colorWithAlphaComponent:0.4]);
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(inputAssistantItem, sel_registerName("_setDetachedTintColor:"), UIColor.systemPinkColor);
#endif
    
    
    //
    
    // Not works on visionOS
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(inputAssistantItem, sel_registerName("_setDictationReplacementAction:"), [UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
        searchController.searchBar.text = [searchController.searchBar.text stringByAppendingString:@"Hello!"];
    }]);
    
    
    _searchController = [searchController retain];
    return [searchController autorelease];
}

- (UIBarButtonItem *)dismissBarButtonItem {
    if (auto dismissBarButtonItem = _dismissBarButtonItem) return dismissBarButtonItem;
    
    UIBarButtonItem *dismissBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(didTriggerDismissBarButtonItem:)];
    
    _dismissBarButtonItem = [dismissBarButtonItem retain];
    return [dismissBarButtonItem autorelease];
}

- (void)didTriggerDismissBarButtonItem:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
