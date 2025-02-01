//
//  ConfigurationView.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 1/31/25.
//

#import "ConfigurationView.h"
#import "ConfigurationSwitchItem.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import "ConfigurationSeparatorView.h"

@interface ConfigurationView () <ConfigurationSwitchItemDelegate>
@property (class, nonatomic, readonly, getter=_switchItemIdentifier) NSUserInterfaceItemIdentifier switchItemIdentifier;
@property (class, nonatomic, readonly, getter=_separatorItemIdentifier) NSUserInterfaceItemIdentifier separatorItemIdentifier;
@property (retain, nonatomic, readonly, getter=_visualEffectView) NSVisualEffectView *visualEffectView;
@property (retain, nonatomic, readonly, getter=_collectionView) NSCollectionView *collectionView;
@property (retain, nonatomic, readonly, getter=_scrollView) NSScrollView *scrollView;
@property (retain, nonatomic, readonly, getter=_reloadButton) NSButton *reloadButton;
@end

@implementation ConfigurationView
@synthesize dataSource = _dataSource;
@synthesize visualEffectView = _visualEffectView;
@synthesize collectionView = _collectionView;
@synthesize scrollView = _scrollView;
@synthesize reloadButton = _reloadButton;

+ (NSUserInterfaceItemIdentifier)_switchItemIdentifier {
    return NSStringFromClass([ConfigurationSwitchItem class]);
}

+ (NSUserInterfaceItemIdentifier)_separatorItemIdentifier {
    return NSStringFromClass([ConfigurationSeparatorView class]);
}

- (instancetype)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _commonInit_ConfigurationView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self _commonInit_ConfigurationView];
    }
    return self;
}

- (void)dealloc {
    [_dataSource release];
    [_visualEffectView release];
    [_collectionView release];
    [_scrollView release];
    [_reloadButton release];
    [super dealloc];
}

- (void)layout {
    [super layout];
    self.visualEffectView.frame = self.scrollView.bounds;
}

- (void)_commonInit_ConfigurationView {
    NSScrollView *scrollView = self.scrollView;
    scrollView.frame = self.bounds;
    scrollView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self addSubview:scrollView];
}

- (NSCollectionViewDiffableDataSource<NSNull *,ConfigurationItemModel *> *)dataSource {
    if (auto dataSource = _dataSource) return dataSource;
    
    __block auto unretainedSelf = self;
    
    NSCollectionViewDiffableDataSource<NSNull *,ConfigurationItemModel *> *dataSource = [[NSCollectionViewDiffableDataSource alloc] initWithCollectionView:self.collectionView itemProvider:^NSCollectionViewItem * _Nullable(NSCollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, ConfigurationItemModel * _Nonnull itemModel) {
        ConfigurationItemModelType type = itemModel.type;
        NSObject<NSCopying> *value = itemModel.valueResolver(itemModel);
        
        switch (type) {
            case ConfigurationItemModelTypeSwitch: {
                BOOL isOn = static_cast<NSNumber *>(value).boolValue;
                
                ConfigurationSwitchItem *item = [collectionView makeItemWithIdentifier:ConfigurationView.switchItemIdentifier forIndexPath:indexPath];
                item.delegate = unretainedSelf;
                item.textField.stringValue = itemModel.label;
                item.toggleSwitch.state = isOn ? NSControlStateValueOn : NSControlStateValueOff;
                return item;
            }
            default:
                abort();
        }
    }];
    
    dataSource.supplementaryViewProvider = ^NSView * _Nullable(NSCollectionView * _Nonnull, NSString * _Nonnull, NSIndexPath * _Nonnull) {
        
    };
    
    _dataSource = dataSource;
    return dataSource;
}

- (NSCollectionView *)_collectionView {
    if (auto collectionView = _collectionView) return collectionView;
    
    NSCollectionView *collectionView = [NSCollectionView new];
    
    NSCollectionViewCompositionalLayoutConfiguration *configuration = [NSCollectionViewCompositionalLayoutConfiguration new];
    configuration.scrollDirection = NSCollectionViewScrollDirectionVertical;
    
    
    NSCollectionViewCompositionalLayout *collectionViewLayout = [[NSCollectionViewCompositionalLayout alloc] initWithSectionProvider:^NSCollectionLayoutSection * _Nullable(NSInteger sectionIndex, id<NSCollectionLayoutEnvironment> _Nonnull) {
        NSCollectionLayoutSize *itemSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.]
                                                                          heightDimension:[NSCollectionLayoutDimension fractionalHeightDimension:1.]];
        
        NSCollectionLayoutSupplementaryItem *separatorItem = [NSCollectionLayoutSupplementaryItem supplementaryItemWithLayoutSize:<#(nonnull NSCollectionLayoutSize *)#> elementKind:<#(nonnull NSString *)#> containerAnchor:<#(nonnull NSCollectionLayoutAnchor *)#> itemAnchor:<#(nonnull NSCollectionLayoutAnchor *)#>]
        
        NSCollectionLayoutItem *item = [NSCollectionLayoutItem itemWithLayoutSize:itemSize supplementaryItems:@[separatorItem]];
        
        NSCollectionLayoutSize *groupSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.]
                                                                           heightDimension:[NSCollectionLayoutDimension estimatedDimension:60.]];
        
        NSCollectionLayoutGroup *group = [NSCollectionLayoutGroup horizontalGroupWithLayoutSize:groupSize subitem:item count:1];
        
        NSCollectionLayoutSection *section = [NSCollectionLayoutSection sectionWithGroup:group];
        return section;
    }
                                                                                                                       configuration:configuration];
    [configuration release];
    
    collectionView.collectionViewLayout = collectionViewLayout;
    [collectionViewLayout release];
    
    NSNib *switchItemNib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([ConfigurationSwitchItem class]) bundle:NSBundle.mainBundle];
    [collectionView registerNib:switchItemNib forItemWithIdentifier:ConfigurationView.switchItemIdentifier];
    [switchItemNib release];
    
    [collectionView registerClass:[ConfigurationSeparatorView class] forSupplementaryViewOfKind:<#(nonnull NSCollectionViewSupplementaryElementKind)#> withIdentifier:<#(nonnull NSUserInterfaceItemIdentifier)#>]
    
    collectionView.backgroundColors = @[NSColor.clearColor];
    
    _collectionView = collectionView;
    return collectionView;
}

- (NSScrollView *)_scrollView {
    if (auto scrollView = _scrollView) return scrollView;
    
    NSScrollView *scrollView = [NSScrollView new];
    scrollView.documentView = self.collectionView;
//    scrollView.contentView.drawsBackground = NO;
//    scrollView.drawsBackground = NO;
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(scrollView, sel_registerName("_addBackgroundView:"), self.visualEffectView);
    
    _scrollView = scrollView;
    return scrollView;
}

- (NSVisualEffectView *)_visualEffectView {
    if (auto visualEffectView = _visualEffectView) return visualEffectView;
    
    NSVisualEffectView *visualEffectView = [NSVisualEffectView new];
    visualEffectView.autoresizingMask = 0;
    visualEffectView.material = NSVisualEffectMaterialSidebar;
    visualEffectView.blendingMode = NSVisualEffectBlendingModeBehindWindow;
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(visualEffectView, sel_registerName("setShouldBeArchived:"), NO);
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(visualEffectView, sel_registerName("setIgnoreHitTest:"), YES);
    
    _visualEffectView = visualEffectView;
    return visualEffectView;
}

- (NSButton *)_reloadButton {
    if (auto reloadButton = _reloadButton) return reloadButton;
    
    return nil;
}

- (void)setDelegate:(id<ConfigurationViewDelegate>)delegate {
    _delegate = delegate;
    
    BOOL showReloadButton;
    if (delegate == nil) {
        showReloadButton = NO;
    } else {
        showReloadButton = [delegate respondsToSelector:@selector(didTriggerReloadButtonWithConfigurationView:)];
    }
    
    self.reloadButton.hidden = !showReloadButton;
}

- (void)configurationSwitchItem:(ConfigurationSwitchItem *)configurationSwitchItem didToggleWithValue:(BOOL)value {
    NSIndexPath *indexPath = [self.collectionView indexPathForItem:configurationSwitchItem];
    assert(indexPath != nil);
    
    ConfigurationItemModel *itemModel = [self.dataSource itemIdentifierForIndexPath:indexPath];
    assert(itemModel != nil);
    assert(itemModel.type == ConfigurationItemModelTypeSwitch);
    
    BOOL shouldReconfigure;
    if (id<ConfigurationViewDelegate> delegate = self.delegate) {
        shouldReconfigure = [delegate configurationView:self didTriggerActionWithItemModel:itemModel];
    } else {
        shouldReconfigure = YES;
    }
    
    if (shouldReconfigure) {
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
//        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(snapshot, sel_registerName("reconfigureItemsWithIdentifiers:"), @[itemModel]);
        [snapshot reloadItemsWithIdentifiers:@[itemModel]];
        [self.dataSource applySnapshot:snapshot animatingDifferences:YES];
        [snapshot release];
    }
}

@end
