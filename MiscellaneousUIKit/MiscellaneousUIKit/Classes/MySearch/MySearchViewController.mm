//
//  MySearchViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 7/13/24.
//

#import "MySearchViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import <cstring>
#import <algorithm>
#import <ranges>

// TODO: UISearchDisplayController도 알아보기

@interface MySearchResultsController : UIViewController <UISearchResultsUpdating>
@end

@implementation MySearchResultsController
- (BOOL)respondsToSelector:(SEL)aSelector {
    BOOL responds = [super respondsToSelector:aSelector];
    if (!responds) {
        NSLog(@"%@: %s", NSStringFromClass(self.class), sel_getName(aSelector));
    }
    return responds;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor.systemPinkColor colorWithAlphaComponent:0.3];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTriggerTapGestureRecognizer:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    [tapGestureRecognizer release];
}
- (void)didMoveToParentViewController:(UIViewController *)parent {
    [super didMoveToParentViewController:parent];
}
- (void)didTriggerTapGestureRecognizer:(UITapGestureRecognizer *)sender {
    [static_cast<UISearchController *>(self.parentViewController) setActive:NO];
}
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
}
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController selectingSearchSuggestion:(id<UISearchSuggestion>)searchSuggestion {
    
}
@end


@interface MySearchViewController () <UISearchControllerDelegate>
@property (retain, readonly, nonatomic) UIBarButtonItem *dismissBarButtonItem;
@property (retain, readonly, nonatomic) UIStackView *stackView;
@property (retain, readonly, nonatomic) UIButton *activateSearchBarButton;
@property (retain, readonly, nonatomic) UIButton *toggleShowsCancelButtonOnSearchBarButton;
@property (retain, readonly, nonatomic) UISearchController *searchController;
@property (retain, readonly, nonatomic) MySearchResultsController *searchResultsController;
@end

@implementation MySearchViewController
@synthesize dismissBarButtonItem = _dismissBarButtonItem;
@synthesize stackView = _stackView;
@synthesize activateSearchBarButton = _activateSearchBarButton;
@synthesize toggleShowsCancelButtonOnSearchBarButton = _toggleShowsCancelButtonOnSearchBarButton;
@synthesize searchController = _searchController;
@synthesize searchResultsController = _searchResultsController;

- (void)dealloc {
    [_dismissBarButtonItem release];
    [_stackView release];
    [_activateSearchBarButton release];
    [_toggleShowsCancelButtonOnSearchBarButton release];
    [_searchController release];
    [_searchResultsController release];
    [super dealloc];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    BOOL responds = [super respondsToSelector:aSelector];
    if (!responds) {
        NSLog(@"%@: %s", NSStringFromClass(self.class), sel_getName(aSelector));
    }
    return responds;
}

- (void)loadView {
    self.view = self.stackView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    
    UINavigationItem *navigationItem = self.navigationItem;
    navigationItem.title = @"Title";
    navigationItem.searchController = self.searchController;
    navigationItem.leftBarButtonItem = self.dismissBarButtonItem;
    
    
}

- (UIBarButtonItem *)dismissBarButtonItem {
    if (auto dismissBarButtonItem = _dismissBarButtonItem) return dismissBarButtonItem;
    
    UIBarButtonItem *dismissBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(didTriggerDismissBarButtonItem:)];
    
    _dismissBarButtonItem = [dismissBarButtonItem retain];
    return [dismissBarButtonItem autorelease];
}

- (UIStackView *)stackView {
    if (auto stackView = _stackView) return stackView;
    
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[
//        self.activateSearchBarButton,
        self.toggleShowsCancelButtonOnSearchBarButton
    ]];
    
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.distribution = UIStackViewDistributionFillEqually;
    stackView.alignment = UIStackViewAlignmentFill;
    
    _stackView = [stackView retain];
    return [stackView autorelease];
}

- (UIButton *)activateSearchBarButton {
    if (auto activateSearchBarButton = _activateSearchBarButton) return activateSearchBarButton;
    
    UIButton *activateSearchBarButton = [UIButton new];
    
    UIButtonConfiguration *configuration = [UIButtonConfiguration tintedButtonConfiguration];
    configuration.title = @"Become First Responder";
    activateSearchBarButton.configuration = configuration;
    
    [activateSearchBarButton addTarget:self action:@selector(didTriggerActivateSearchBarButton:) forControlEvents:UIControlEventPrimaryActionTriggered];
    
    _activateSearchBarButton = [activateSearchBarButton retain];
    return [activateSearchBarButton autorelease];
}

- (UIButton *)toggleShowsCancelButtonOnSearchBarButton {
    if (auto toggleShowsCancelButtonOnSearchBarButton = _toggleShowsCancelButtonOnSearchBarButton) return toggleShowsCancelButtonOnSearchBarButton;
    
    UIButton *toggleShowsCancelButtonOnSearchBarButton = [UIButton new];
    
    UIButtonConfiguration *configuration = [UIButtonConfiguration tintedButtonConfiguration];
    configuration.title = @"Toggle Cancel Button Visibility";
    toggleShowsCancelButtonOnSearchBarButton.configuration = configuration;
    
    [toggleShowsCancelButtonOnSearchBarButton addTarget:self action:@selector(didTriggerToggleShowsCancelButtonOnSearchBarButton:) forControlEvents:UIControlEventPrimaryActionTriggered];
    
    _toggleShowsCancelButtonOnSearchBarButton = [toggleShowsCancelButtonOnSearchBarButton retain];
    return [toggleShowsCancelButtonOnSearchBarButton autorelease];
}

- (void)didTriggerDismissBarButtonItem:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didTriggerActivateSearchBarButton:(UIButton *)sender {
//    [self.searchController.searchBar becomeFirstResponder];
    self.searchController.active = YES;
}

- (void)didTriggerToggleShowsCancelButtonOnSearchBarButton:(UIButton *)sender {
    id _visualProvider = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self.searchController.searchBar, sel_registerName("_visualProvider"));
    
    unsigned int ivarsCount;
    Ivar *ivars = class_copyIvarList([_visualProvider class], &ivarsCount);
    auto ivar = std::ranges::find_if(ivars, ivars + ivarsCount, [](Ivar ivar) {
        auto name = ivar_getName(ivar);
        return !std::strcmp(name, "_searchBarVisualProviderFlags");
    });
    
    /*
     _searchBarVisualProviderFlags에서 showsCancelButton 까지의 offset은 18이다.
     
     만약 _searchBarVisualProviderFlags에서 offset 18 만큼의 Memory가 아래와 같다고 하자
     
      00000000 00000000 00 100000
     ^        ^        ^  ^
     0        8        16 18
     ^        ^        ^
     0x0      0x1      0x2
     
     우리는 offset 18의 Memory 값을 변조하고 싶으므로,
     _searchBarVisualProviderFlags의 Pointer에 0x2를 더한 후 unsigned long의 값을 읽어오면 00 10 00 00이 될 것이다.
     
     이를 unsigned long으로 변환하면 00000100이 된다.
     ^= 1 << 2 (XOR) 연산자를 통해 00000100 또는 00000000으로 설정해준 후,
     
     Pointer에 값을 할당해주면 showsCancelButton를 toggle 할 수 있게 된다.
     */
    unsigned long *basePtr = reinterpret_cast<unsigned long *>(reinterpret_cast<uintptr_t>(_visualProvider) + ivar_getOffset(*ivar) + 0x2);
    delete ivars;
    
    *basePtr ^= 1 << 2;
    
    __kindof UIView *searchFieldContainerView = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(_visualProvider, sel_registerName("searchFieldContainerView"));
    
    [self.searchController.searchBar setNeedsLayout];
    [searchFieldContainerView setNeedsLayout];
    
    [UIView animateWithDuration:1.0 animations:^{
        reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(self.searchController.searchBar, sel_registerName("layoutBelowIfNeeded"));
    }];
}

- (UISearchController *)searchController {
    if (auto searchController = _searchController) return searchController;
    
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchResultsController];
    searchController.delegate = self;
    searchController.searchResultsUpdater = self.searchResultsController;
//    searchController.obscuresBackgroundDuringPresentation = YES;
    searchController.hidesNavigationBarDuringPresentation = NO;
    searchController.automaticallyShowsCancelButton = NO;
    
    _searchController = [searchController retain];
    return [searchController autorelease];
}

- (MySearchResultsController *)searchResultsController {
    if (auto searchResultsController = _searchResultsController) return searchResultsController;
    
    MySearchResultsController *searchResultsController = [MySearchResultsController new];
    
    _searchResultsController = [searchResultsController retain];
    return [searchResultsController autorelease];
}

- (void)didDismissSearchController:(UISearchController *)searchController {
    
}

- (void)didPresentSearchController:(UISearchController *)searchController {
    
}

- (void)presentSearchController:(UISearchController *)searchController {
    
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    
}

- (void)willPresentSearchController:(UISearchController *)searchController {
    
}

- (void)searchController:(UISearchController *)searchController didChangeFromSearchBarPlacement:(UINavigationItemSearchBarPlacement)previousPlacement {
    
}

- (void)searchController:(UISearchController *)searchController willChangeToSearchBarPlacement:(UINavigationItemSearchBarPlacement)newPlacement {
    
}

- (void)_searchController:(UISearchController *)searchController insertSearchFieldTextSuggestion:(id)arg3 {
    
}

@end
