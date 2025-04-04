//
//  ViewDemoViewController.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 1/31/25.
//

#import "ViewDemoViewController.h"
#import "ConfigurationView.h"
#import "ViewDemoOpaqueAncestorView.h"
#import "ViewDemoDescendantOfView.h"
#import "ViewDemoAncestorSharedView.h"
#import "ViewDemoEnclosingMenuItemView.h"
#import "ViewDemoEnclosingScrollView.h"
#import "ViewDemoPositionedSubviewView.h"
#import "ViewDemoRemoveFromSuperviewWithoutNeedingDisplayView.h"
#import "ViewDemoReplaceSubviewView.h"
#import "ViewDemoSortSubviewsView.h"
#import "ViewDemoFrameRotationView.h"
#import "VideoDemoFrameDidChangeNotificationView.h"
#import "ViewDemoBoundsRotationView.h"

@interface ViewDemoViewController () <ConfigurationViewDelegate>
@property (retain, nonatomic, readonly, getter=_configurationView) ConfigurationView *configurationView;
@end

@implementation ViewDemoViewController
@synthesize configurationView = _configurationView;

- (void)dealloc {
    [_configurationView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ConfigurationView *configurationView = self.configurationView;
    configurationView.frame = self.view.bounds;
    configurationView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self.view addSubview:configurationView];
    
    [self _reload];
}

- (void)_reload {
    NSDiffableDataSourceSnapshot<NSNull *, ConfigurationItemModel *> *snapshot = [NSDiffableDataSourceSnapshot new];
    
    [snapshot appendSectionsWithIdentifiers:@[[NSNull null]]];
    [snapshot appendItemsWithIdentifiers:@[
        [self _makeBoundsRotationViewItemModel],
        [self _makeFrameDidChangeNotificationViewItemModel],
        [self _makeFrameRotationViewItemModel],
        [self _makeSortSubviewsItemModel],
        [self _makeReplaceSubviewItemModel],
        [self _makeRemoveFromSuperviewWithoutNeedingDisplayViewItemModel],
        [self _makeAddSubviewPositionedRelativeToItemModel],
        [self _makeEnclosingScrollViewItemModel],
        [self _makeEnclosingMenuItemItemModel],
        [self _makeAncestorSharedWithViewItemModel],
        [self _makeIsDescendantOfItemModel],
        [self _makeOpaqueAncestorItemModel]
    ]
               intoSectionWithIdentifier:[NSNull null]];
    
    [self.configurationView applySnapshot:snapshot animatingDifferences:YES];
    [snapshot release];
}

- (ConfigurationItemModel *)_makeOpaqueAncestorItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeViewPresentation
                                          identifier:@"Opaque Ancestor"
                                               label:@"Opaque Ancestor"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationViewPresentationDescription descriptorWithStyle:ConfigurationViewPresentationStyleAlert
                                                                 viewBuilder:^__kindof NSView * _Nonnull(void (^ _Nonnull layout)(), __kindof NSView * _Nullable reloadingView) {
            return [[[ViewDemoOpaqueAncestorView alloc] initWithFrame:NSMakeRect(0., 0., 300., 300.)] autorelease];
        }
                                                             didCloseHandler:nil];
    }];
}

- (ConfigurationItemModel *)_makeIsDescendantOfItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeViewPresentation
                                          identifier:@"Is Descendant Of"
                                               label:@"Is Descendant Of"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationViewPresentationDescription descriptorWithStyle:ConfigurationViewPresentationStyleAlert
                                                                 viewBuilder:^__kindof NSView * _Nonnull(void (^ _Nonnull layout)(), __kindof NSView * _Nullable reloadingView) {
            return [[[ViewDemoDescendantOfView alloc] initWithFrame:NSMakeRect(0., 0., 300., 300.)] autorelease];
        }
                                                             didCloseHandler:nil];
    }];
}

- (ConfigurationItemModel *)_makeAncestorSharedWithViewItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeViewPresentation
                                          identifier:@"Ancestor Shared With View"
                                               label:@"Ancestor Shared With View"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationViewPresentationDescription descriptorWithStyle:ConfigurationViewPresentationStyleAlert
                                                                 viewBuilder:^__kindof NSView * _Nonnull(void (^ _Nonnull layout)(), __kindof NSView * _Nullable reloadingView) {
            return [[[ViewDemoAncestorSharedView alloc] initWithFrame:NSMakeRect(0., 0., 300., 300.)] autorelease];
        }
                                                             didCloseHandler:nil];
    }];
}

- (ConfigurationItemModel *)_makeEnclosingMenuItemItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                          identifier:@"Enclosing Menu Item"
                                               label:@"Enclosing Menu Item"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSMenu *menu = [NSMenu new];
        
        NSMenuItem *menuItem = [NSMenuItem new];
        ViewDemoEnclosingMenuItemView *view = [[ViewDemoEnclosingMenuItemView alloc] initWithFrame:NSMakeRect(0., 0., 300., 100.)];
        menuItem.view = view;
        [view release];
        [menu addItem:menuItem];
        [menuItem release];
        
        ConfigurationButtonDescription *description = [ConfigurationButtonDescription descriptionWithTitle:@"Menu" menu:menu showsMenuAsPrimaryAction:YES];
        [menu release];
        
        return description;
    }];
}

- (ConfigurationItemModel *)_makeEnclosingScrollViewItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeViewPresentation
                                          identifier:@"Enclosing Scroll View"
                                               label:@"Enclosing Scroll View"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationViewPresentationDescription descriptorWithStyle:ConfigurationViewPresentationStyleAlert
                                                                 viewBuilder:^__kindof NSView * _Nonnull(void (^ _Nonnull layout)(), __kindof NSView * _Nullable reloadingView) {
            return [[[ViewDemoEnclosingScrollView alloc] initWithFrame:NSMakeRect(0., 0., 300., 300.)] autorelease];
        }
                                                             didCloseHandler:nil];
    }];
}

- (ConfigurationItemModel *)_makeAddSubviewPositionedRelativeToItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeViewPresentation
                                          identifier:@"Add Subview Positioned Relative To"
                                               label:@"Add Subview Positioned Relative To"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationViewPresentationDescription descriptorWithStyle:ConfigurationViewPresentationStyleAlert
                                                                 viewBuilder:^__kindof NSView * _Nonnull(void (^ _Nonnull layout)(), __kindof NSView * _Nullable reloadingView) {
            return [[[ViewDemoPositionedSubviewView alloc] initWithFrame:NSMakeRect(0., 0., 300., 300.)] autorelease];
        }
                                                             didCloseHandler:nil];
    }];
}

- (ConfigurationItemModel *)_makeRemoveFromSuperviewWithoutNeedingDisplayViewItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeViewPresentation
                                          identifier:@"Remove From Superview Without Needing Display View"
                                               label:@"Remove From Superview Without Needing Display View"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationViewPresentationDescription descriptorWithStyle:ConfigurationViewPresentationStyleAlert
                                                                 viewBuilder:^__kindof NSView * _Nonnull(void (^ _Nonnull layout)(), __kindof NSView * _Nullable reloadingView) {
            return [[[ViewDemoRemoveFromSuperviewWithoutNeedingDisplayView alloc] initWithFrame:NSMakeRect(0., 0., 300., 300.)] autorelease];
        }
                                                             didCloseHandler:nil];
    }];
}

- (ConfigurationItemModel *)_makeReplaceSubviewItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeViewPresentation
                                          identifier:@"Replace Subview"
                                               label:@"Replace Subview"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationViewPresentationDescription descriptorWithStyle:ConfigurationViewPresentationStyleAlert
                                                                 viewBuilder:^__kindof NSView * _Nonnull(void (^ _Nonnull layout)(), __kindof NSView * _Nullable reloadingView) {
            return [[[ViewDemoReplaceSubviewView alloc] initWithFrame:NSMakeRect(0., 0., 300., 300.)] autorelease];
        }
                                                             didCloseHandler:nil];
    }];
}

- (ConfigurationItemModel *)_makeSortSubviewsItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeViewPresentation
                                          identifier:@"Sort Subviews"
                                               label:@"Sort Subviews"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationViewPresentationDescription descriptorWithStyle:ConfigurationViewPresentationStyleAlert
                                                                 viewBuilder:^__kindof NSView * _Nonnull(void (^ _Nonnull layout)(), __kindof NSView * _Nullable reloadingView) {
            return [[[ViewDemoSortSubviewsView alloc] initWithFrame:NSMakeRect(0., 0., 300., 300.)] autorelease];
        }
                                                             didCloseHandler:nil];
    }];
}

- (ConfigurationItemModel *)_makeFrameRotationViewItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeViewPresentation
                                          identifier:@"Frame Rotation"
                                            label:@"Frame Rotation"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationViewPresentationDescription descriptorWithStyle:ConfigurationViewPresentationStyleAlert
                                                                 viewBuilder:^__kindof NSView * _Nonnull(void (^ _Nonnull layout)(), __kindof NSView * _Nullable reloadingView) {
            return [[[ViewDemoFrameRotationView alloc] initWithFrame:NSMakeRect(0., 0., 300., 300.)] autorelease];
        }
                                                             didCloseHandler:nil];
    }];
}

- (ConfigurationItemModel *)_makeFrameDidChangeNotificationViewItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeViewPresentation
                                          identifier:@"Frame Did Change Notification"
                                               label:@"Frame Did Change Notification"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationViewPresentationDescription descriptorWithStyle:ConfigurationViewPresentationStyleAlert
                                                                 viewBuilder:^__kindof NSView * _Nonnull(void (^ _Nonnull layout)(), __kindof NSView * _Nullable reloadingView) {
            return [[[VideoDemoFrameDidChangeNotificationView alloc] initWithFrame:NSMakeRect(0., 0., 300., 300.)] autorelease];
        }
                                                             didCloseHandler:nil];
    }];
}

- (ConfigurationItemModel *)_makeBoundsRotationViewItemModel {
    return [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeViewPresentation
                                          identifier:@"Bounds Rotation"
                                               label:@"Bounds Rotation"
                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationViewPresentationDescription descriptorWithStyle:ConfigurationViewPresentationStyleAlert
                                                                 viewBuilder:^__kindof NSView * _Nonnull(void (^ _Nonnull layout)(), __kindof NSView * _Nullable reloadingView) {
            return [[[ViewDemoBoundsRotationView alloc] initWithFrame:NSMakeRect(0., 0., 300., 300.)] autorelease];
        }
                                                             didCloseHandler:nil];
    }];
}

- (ConfigurationView *)_configurationView {
    if (auto configurationView = _configurationView) return configurationView;
    
    ConfigurationView *configurationView = [ConfigurationView new];
    configurationView.showBlendedBackground = YES;
    configurationView.delegate = self;
    
    _configurationView = configurationView;
    return configurationView;
}

- (BOOL)configurationView:(ConfigurationView *)configurationView didTriggerActionWithItemModel:(ConfigurationItemModel *)itemModel newValue:(id<NSCopying>)newValue {
    NSString *identifier = itemModel.identifier;
    
    
    
    abort();
}

- (void)didTriggerReloadButtonWithConfigurationView:(ConfigurationView *)configurationView {
    [self _reload];
}

@end
