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
#import "ConfigurationSliderItem.h"
#import "ConfigurationStepperItem.h"
#import "ConfigurationButtonItem.h"
#import "ConfigurationPopUpButtonItem.h"
#import "ConfigurationColorWellItem.h"
#import "ConfigurationLabelItem.h"
#include <ranges>

@interface ConfigurationView () <ConfigurationSwitchItemDelegate, ConfigurationSliderItemDelegate, ConfigurationStepperItemDelegate, ConfigurationButtonItemDelegate, ConfigurationPopUpButtonItemDelegate, ConfigurationColorWellItemDelegate, NSSearchFieldDelegate>
@property (class, nonatomic, readonly, getter=_switchItemIdentifier) NSUserInterfaceItemIdentifier switchItemIdentifier;
@property (class, nonatomic, readonly, getter=_sliderItemIdentifier) NSUserInterfaceItemIdentifier sliderItemIdentifier;
@property (class, nonatomic, readonly, getter=_stepperItemIdentifier) NSUserInterfaceItemIdentifier stepperItemIdentifier;
@property (class, nonatomic, readonly, getter=_buttonItemIdentifier) NSUserInterfaceItemIdentifier buttonItemIdentifier;
@property (class, nonatomic, readonly, getter=_colorWellItemIdentifier) NSUserInterfaceItemIdentifier colorWellItemIdentifier;
@property (class, nonatomic, readonly, getter=_popUpButtonItemIdentifier) NSUserInterfaceItemIdentifier popUpButtonItemIdentifier;
@property (class, nonatomic, readonly, getter=_separatorItemIdentifier) NSUserInterfaceItemIdentifier separatorItemIdentifier;
@property (class, nonatomic, readonly, getter=_labelItemIdentifier) NSUserInterfaceItemIdentifier labelItemIdentifier;
@property (class, nonatomic, readonly, getter=_separatorElementKind) NSCollectionViewSupplementaryElementKind separatorElementKind;
@property (retain, nonatomic, readonly, getter=_visualEffectView) NSVisualEffectView *visualEffectView;
@property (retain, nonatomic, readonly, getter=_collectionView) NSCollectionView *collectionView;
@property (retain, nonatomic, readonly, getter=_scrollView) NSScrollView *scrollView;
@property (retain, nonatomic, readonly, getter=_reloadButton) NSButton *reloadButton;
@property (retain, nonatomic, readonly, getter=_searchField) NSSearchField *searchField;
@property (retain, nonatomic, readonly, getter=_stackView) NSStackView *stackView;
@property (copy, nonatomic, nullable, getter=_originalSnapshot, setter=_setOriginalSnapshot:) NSDiffableDataSourceSnapshot<NSNull *, ConfigurationItemModel *> *originalSnapshot;
@property (retain, nonatomic, readonly, getter=_dataSource) NSCollectionViewDiffableDataSource<NSNull *, ConfigurationItemModel *> *dataSource;
@end

@implementation ConfigurationView
@synthesize dataSource = _dataSource;
@synthesize visualEffectView = _visualEffectView;
@synthesize collectionView = _collectionView;
@synthesize scrollView = _scrollView;
@synthesize reloadButton = _reloadButton;
@synthesize searchField = _searchField;
@synthesize stackView = _stackView;

+ (NSUserInterfaceItemIdentifier)_switchItemIdentifier {
    return NSStringFromClass([ConfigurationSwitchItem class]);
}

+ (NSUserInterfaceItemIdentifier)_sliderItemIdentifier {
    return NSStringFromClass([ConfigurationSliderItem class]);
}

+ (NSUserInterfaceItemIdentifier)_stepperItemIdentifier {
    return NSStringFromClass([ConfigurationStepperItem class]);
}

+ (NSUserInterfaceItemIdentifier)_buttonItemIdentifier {
    return NSStringFromClass([ConfigurationButtonItem class]);
}

+ (NSUserInterfaceItemIdentifier)_popUpButtonItemIdentifier {
    return NSStringFromClass([ConfigurationPopUpButtonItem class]);
}

+ (NSUserInterfaceItemIdentifier)_colorWellItemIdentifier {
    return NSStringFromClass([ConfigurationColorWellItem class]);
}

+ (NSUserInterfaceItemIdentifier)_labelItemIdentifier {
    return NSStringFromClass([ConfigurationLabelItem class]);
}

+ (NSUserInterfaceItemIdentifier)_separatorItemIdentifier {
    return NSStringFromClass([ConfigurationSeparatorView class]);
}

+ (NSCollectionViewSupplementaryElementKind)_separatorElementKind {
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
    [_searchField release];
    [_stackView release];
    [_originalSnapshot release];
    [super dealloc];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    BOOL responds = [super respondsToSelector:aSelector];
    
    if (!responds) {
        NSLog(@"%@ does not respond to %s.", NSStringFromClass([self class]), sel_getName(aSelector));
    }
    
    return responds;
}

- (void)layout {
    [super layout];
    self.visualEffectView.frame = self.scrollView.bounds;
}

- (void)reconfigureItemModelsWithIdentifiers:(NSArray<NSString *> *)identifiers {
    if (identifiers.count == 0) return;
    
    {
        NSDiffableDataSourceSnapshot<NSNull *, ConfigurationItemModel *> *originalSnapshot = self.originalSnapshot;
        
        NSMutableArray<NSString *> *verification = [identifiers mutableCopy];
        for (ConfigurationItemModel *itemModel in originalSnapshot.itemIdentifiers) {
            NSInteger index = [verification indexOfObject:itemModel.identifier];
            if (index != NSNotFound) {
                [verification removeObjectAtIndex:index];
            }
        }
        assert(verification.count == 0);
        [verification release];
    }
    
    NSRect bounds = self.collectionView.bounds;
    if (NSWidth(bounds) == 0. or NSHeight(bounds) == 0.) return;
    
    NSCollectionViewDiffableDataSource<NSNull *, ConfigurationItemModel *> *dataSource = self.dataSource;
    NSDiffableDataSourceSnapshot<NSNull *, ConfigurationItemModel *> *snapshot = [dataSource.snapshot copy];
    
    for (ConfigurationItemModel *itemModel in snapshot.itemIdentifiers) {
        if ([identifiers containsObject:itemModel.identifier]) {
            [snapshot reloadItemsWithIdentifiers:@[itemModel]];
        }
    }
    
    [dataSource applySnapshot:snapshot animatingDifferences:NO];
    [snapshot release];
}

- (void)_commonInit_ConfigurationView {
    NSRect bounds = self.bounds;
    
    NSStackView *stackView = self.stackView;
    stackView.frame = bounds;
    stackView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self addSubview:stackView];
    
    NSButton *reloadButton = self.reloadButton;
    reloadButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:reloadButton];
    [NSLayoutConstraint activateConstraints:@[
        [reloadButton.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-20.],
        [reloadButton.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-20.]
    ]];
}

- (NSDiffableDataSourceSnapshot<NSNull *,ConfigurationItemModel *> *)snapshot {
    if (auto originalSnapshot = self.originalSnapshot) {
        return [[originalSnapshot copy] autorelease];
    }
    
    return [[self.dataSource.snapshot copy] autorelease];
}

- (void)applySnapshot:(NSDiffableDataSourceSnapshot<NSNull *,ConfigurationItemModel *> *)snapshot animatingDifferences:(BOOL)animatingDifferences {
    self.originalSnapshot = snapshot;
    [self _filterItemModelsWithQuery:self.searchField.stringValue animatingDifferences:animatingDifferences];
}

- (NSCollectionViewDiffableDataSource<NSNull *,ConfigurationItemModel *> *)_dataSource {
    if (auto dataSource = _dataSource) return dataSource;
    
    __block auto unretainedSelf = self;
    
    NSCollectionViewDiffableDataSource<NSNull *,ConfigurationItemModel *> *dataSource = [[NSCollectionViewDiffableDataSource alloc] initWithCollectionView:self.collectionView itemProvider:^NSCollectionViewItem * _Nullable(NSCollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, ConfigurationItemModel * _Nonnull itemModel) {
        ConfigurationItemModelType type = itemModel.type;
        auto value = static_cast<NSObject<NSCopying> *>(itemModel.valueResolver(itemModel));
        NSString *label = itemModel.labelResolver(itemModel, value);
        
        switch (type) {
            case ConfigurationItemModelTypeSwitch: {
                assert([value isKindOfClass:[NSNumber class]]);
                BOOL isOn = static_cast<NSNumber *>(value).boolValue;
                
                ConfigurationSwitchItem *item = [collectionView makeItemWithIdentifier:ConfigurationView.switchItemIdentifier forIndexPath:indexPath];
                item.resolvedValue = value;
                item.delegate = unretainedSelf;
                item.textField.stringValue = label;
                
//                reinterpret_cast<void (*)(Class, SEL, id)>(objc_msgSend)([NSView class], sel_registerName("_performWithoutAnimation:"), ^{
                    item.toggleSwitch.state = isOn ? NSControlStateValueOn : NSControlStateValueOff;
//                });
                
                return item;
            }
            case ConfigurationItemModelTypeSlider: {
                assert([value isKindOfClass:[ConfigurationSliderDescription class]]);
                auto sliderDescription = static_cast<ConfigurationSliderDescription *>(value);
                
                ConfigurationSliderItem *item = [collectionView makeItemWithIdentifier:ConfigurationView.sliderItemIdentifier forIndexPath:indexPath];
                item.resolvedValue = value;
                item.delegate = unretainedSelf;
                item.textField.stringValue = label;
                item.slider.minValue = sliderDescription.minimumValue;
                item.slider.maxValue = sliderDescription.maximumValue;
                item.slider.doubleValue = sliderDescription.sliderValue;
                item.slider.continuous = sliderDescription.continuous;
                
                return item;
            }
            case ConfigurationItemModelTypeStepper: {
                assert([value isKindOfClass:[ConfigurationStepperDescription class]]);
                auto stepperDescription = static_cast<ConfigurationStepperDescription *>(value);
                
                ConfigurationStepperItem *item = [collectionView makeItemWithIdentifier:ConfigurationView.stepperItemIdentifier forIndexPath:indexPath];
                item.resolvedValue = value;
                item.delegate = unretainedSelf;
                item.textField.stringValue = label;
                item.stepper.minValue = stepperDescription.minimumValue;
                item.stepper.maxValue = stepperDescription.maximumValue;
                item.stepper.doubleValue = stepperDescription.stepperValue;
                item.stepper.increment = stepperDescription.stepValue;
                item.stepper.continuous = stepperDescription.continuous;
                item.stepper.autorepeat = stepperDescription.autorepeat;
                item.stepper.valueWraps = stepperDescription.valueWraps;
                
                return item;
            }
            case ConfigurationItemModelTypeButton: {
                ConfigurationButtonItem *item = [collectionView makeItemWithIdentifier:ConfigurationView.buttonItemIdentifier forIndexPath:indexPath];
                item.resolvedValue = value;
                item.delegate = unretainedSelf;
                item.textField.stringValue = label;
                
                if ([value isKindOfClass:[ConfigurationButtonDescription class]]) {
                    auto description = static_cast<ConfigurationButtonDescription *>(value);
                    item.showsMenuAsPrimaryAction = description.showsMenuAsPrimaryAction;
                    item.button.menu = description.menu;
                    item.button.title = description.title;
                } else if ([value isKindOfClass:[NSNull class]]) {
                    NSLog(@"Setting the class of Value to NSNull is deprecated. Instead, use ConfigurationButtonDescription. (identifier : %@)", itemModel.identifier);
                    item.showsMenuAsPrimaryAction = NO;
                    item.button.menu = nil;
                    item.button.title = @"Button";
                } else {
                    abort();
                }
                
                return item;
            }
            case ConfigurationItemModelTypePopUpButton: {
                ConfigurationPopUpButtonItem *item = [collectionView makeItemWithIdentifier:ConfigurationView.popUpButtonItemIdentifier forIndexPath:indexPath];
                item.resolvedValue = value;
                
                item.delegate = unretainedSelf;
                item.textField.stringValue = label;
                
                assert([value isKindOfClass:[ConfigurationPopUpButtonDescription class]]);
                auto description = static_cast<ConfigurationPopUpButtonDescription *>(value);
                NSPopUpButton *popUpButton = item.popUpButton;
                
                /*
                 NSMenu를 새로 생성해야 한다.
                 
                 만약 NSMenu를 그대로 활용한다면
                 NSPopupMenuWindow이 뜨는 도중에 WindowDemoViewController에 Window 관련 Notification이 수신되면서 Reconfigure가 일어나고,
                 현재 뜨려는 NSMenu가 다른 Item이 되어, 엉뚱한 Item이 뜨는 문제가 있다.
                 
                 따라서 Reconfigure가 일어나도, 여기에서 설정되는 NSMenu와 뜨려는 NSMenu는 별개이어야 한다.
                 */
                NSMenu *menu = [NSMenu new];
                
                {
                    NSMenuItem *noneItem = [NSMenuItem new];
                    noneItem.title = @"(None)";
                    noneItem.enabled = NO;
                    noneItem.state = (description.selectedTitles.count > 0) ? NSControlStateValueOff : NSControlStateValueOn;
                    [menu addItem:noneItem];
                    [noneItem release];
                }
                
                [menu addItem:[NSMenuItem separatorItem]];
                
                for (NSString *title in description.titles) {
                    NSMenuItem *item = [NSMenuItem new];
                    item.title = title;
                    item.representedObject = itemModel.identifier;
                    [menu addItem:item];
                    [item release];
                }
                
                popUpButton.menu = menu;
                [menu release];
                
                //
                
                return item;
            }
            case ConfigurationItemModelTypeColorWell: {
                ConfigurationColorWellItem *item = [collectionView makeItemWithIdentifier:ConfigurationView.colorWellItemIdentifier forIndexPath:indexPath];
                item.resolvedValue = value;
                item.delegate = unretainedSelf;
                item.textField.stringValue = label;
                
                assert([value isKindOfClass:[NSColor class]]);
                item.colorWell.color = static_cast<NSColor *>(value);
                
                return item;
            }
            case ConfigurationItemModelTypeLabel: {
                assert([value isKindOfClass:[NSNull class]]);
                
                ConfigurationLabelItem *item = [collectionView makeItemWithIdentifier:ConfigurationView.labelItemIdentifier forIndexPath:indexPath];
                item.resolvedValue = value;
                item.textField.stringValue = label;
                
                return item;
            }
            case ConfigurationItemModelTypeViewPresentation: {
                assert([value isKindOfClass:[ConfigurationViewPresentationDescription class]]);
                auto description = static_cast<ConfigurationViewPresentationDescription *>(value);
                
                ConfigurationButtonItem *item = [collectionView makeItemWithIdentifier:ConfigurationView.buttonItemIdentifier forIndexPath:indexPath];
                item.resolvedValue = value;
                item.delegate = unretainedSelf;
                item.textField.stringValue = label;
                
                item.showsMenuAsPrimaryAction = NO;
                item.button.menu = nil;
                
                switch (description.style) {
                    case ConfigurationViewPresentationStyleAlert:
                        item.button.title = @"Alert";
                        break;
                    case ConfigurationViewPresentationStylePopover:
                        item.button.title = @"Popover";
                        break;
                    default:
                        abort();
                }
                
                return item;
            }
            default:
                abort();
        }
    }];
    
    dataSource.supplementaryViewProvider = ^NSView * _Nullable(NSCollectionView * _Nonnull collectionView, NSString * _Nonnull elementKind, NSIndexPath * _Nonnull indexPath) {
        if ([elementKind isEqualToString:ConfigurationView.separatorElementKind]) {
            return [collectionView makeSupplementaryViewOfKind:elementKind withIdentifier:ConfigurationView.separatorItemIdentifier forIndexPath:indexPath];
        } else {
            abort();
        }
    };
    
    _dataSource = dataSource;
    return dataSource;
}

- (NSCollectionView *)_collectionView {
    if (auto collectionView = _collectionView) return collectionView;
    
    NSCollectionView *collectionView = [NSCollectionView new];
    
    NSCollectionViewCompositionalLayoutConfiguration *configuration = [NSCollectionViewCompositionalLayoutConfiguration new];
    configuration.scrollDirection = NSCollectionViewScrollDirectionVertical;
    
    
    NSCollectionViewCompositionalLayout *collectionViewLayout = [[NSCollectionViewCompositionalLayout alloc] initWithSectionProvider:^NSCollectionLayoutSection * _Nullable(NSInteger sectionIndex, id<NSCollectionLayoutEnvironment> _Nonnull environment) {
//        id _dataSourceSnapshot = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(environment, sel_registerName("_dataSourceSnapshot"));
//        NSInteger numberOfItems = reinterpret_cast<NSInteger (*)(id, SEL, NSInteger)>(objc_msgSend)(_dataSourceSnapshot, sel_registerName("numberOfItemsInSection:"), sectionIndex);
        
        NSCollectionLayoutSize *itemSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.]
                                                                          heightDimension:[NSCollectionLayoutDimension estimatedDimension:40.]];
        
        NSCollectionLayoutSize *separatorSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.]
                                                                               heightDimension:[NSCollectionLayoutDimension absoluteDimension:1.]];
        
        NSCollectionLayoutSupplementaryItem *separatorItem = [NSCollectionLayoutSupplementaryItem supplementaryItemWithLayoutSize:separatorSize
                                                                                                                      elementKind:ConfigurationView.separatorElementKind
                                                                                                                  containerAnchor:[NSCollectionLayoutAnchor layoutAnchorWithEdges:NSDirectionalRectEdgeBottom]
                                                                                                                       itemAnchor:[NSCollectionLayoutAnchor layoutAnchorWithEdges:NSDirectionalRectEdgeTop]];
        
        NSCollectionLayoutItem *item = [NSCollectionLayoutItem itemWithLayoutSize:itemSize supplementaryItems:@[separatorItem]];
        
        NSCollectionLayoutSize *groupSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.]
                                                                           heightDimension:[NSCollectionLayoutDimension estimatedDimension:41.]];
        
        NSCollectionLayoutGroup *group = [NSCollectionLayoutGroup horizontalGroupWithLayoutSize:groupSize subitem:item count:1];
        
        group.edgeSpacing = [NSCollectionLayoutEdgeSpacing spacingForLeading:nil top:nil trailing:nil bottom:[NSCollectionLayoutSpacing fixedSpacing:1.]];
        
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
    
    NSNib *sliderItemNib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([ConfigurationSliderItem class]) bundle:NSBundle.mainBundle];
    [collectionView registerNib:sliderItemNib forItemWithIdentifier:ConfigurationView.sliderItemIdentifier];
    [sliderItemNib release];
    
    NSNib *stepperItemNib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([ConfigurationStepperItem class]) bundle:NSBundle.mainBundle];
    [collectionView registerNib:stepperItemNib forItemWithIdentifier:ConfigurationView.stepperItemIdentifier];
    [stepperItemNib release];
    
    NSNib *buttonItemNib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([ConfigurationButtonItem class]) bundle:NSBundle.mainBundle];
    [collectionView registerNib:buttonItemNib forItemWithIdentifier:ConfigurationView.buttonItemIdentifier];
    [buttonItemNib release];
    
    NSNib *popUpButtonItemNib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([ConfigurationPopUpButtonItem class]) bundle:NSBundle.mainBundle];
    [collectionView registerNib:popUpButtonItemNib forItemWithIdentifier:ConfigurationView.popUpButtonItemIdentifier];
    [popUpButtonItemNib release];
    
    NSNib *colorWellItemNib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([ConfigurationColorWellItem class]) bundle:NSBundle.mainBundle];
    [collectionView registerNib:colorWellItemNib forItemWithIdentifier:ConfigurationView.colorWellItemIdentifier];
    [colorWellItemNib release];
    
    NSNib *labelItemNib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([ConfigurationLabelItem class]) bundle:NSBundle.mainBundle];
    [collectionView registerNib:labelItemNib forItemWithIdentifier:ConfigurationView.labelItemIdentifier];
    [labelItemNib release];
    
    [collectionView registerClass:[ConfigurationSeparatorView class] forSupplementaryViewOfKind:ConfigurationView.separatorElementKind withIdentifier:ConfigurationView.separatorItemIdentifier];
    
    collectionView.backgroundColors = @[NSColor.clearColor];
    
    _collectionView = collectionView;
    return collectionView;
}

- (NSScrollView *)_scrollView {
    if (auto scrollView = _scrollView) return scrollView;
    
    NSScrollView *scrollView = [NSScrollView new];
    scrollView.documentView = self.collectionView;
    scrollView.contentView.drawsBackground = NO;
    scrollView.drawsBackground = NO;
    scrollView.scrollerStyle = NSScrollerStyleOverlay;
    scrollView.autohidesScrollers = YES;
    scrollView.automaticallyAdjustsContentInsets = NO;
    scrollView.contentInsets = NSEdgeInsetsMake(0., 0., self.reloadButton.fittingSize.height + 20., 0.);
    
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
    
    NSButton *reloadButton = [NSButton buttonWithImage:[NSImage imageWithSystemSymbolName:@"arrow.clockwise" accessibilityDescription:nil]
                                                target:self
                                                action:@selector(_didTriggerReloadButton:)];
    
    reloadButton.toolTip = @"Reload";
    
    _reloadButton = [reloadButton retain];
    return reloadButton;
}

- (NSSearchField *)_searchField {
    if (auto searchField = _searchField) return searchField;
    
    NSSearchField *searchField = [NSSearchField new];
    searchField.delegate = self;
    
    _searchField = searchField;
    return searchField;
}

- (NSStackView *)_stackView {
    if (auto stackView = _stackView) return stackView;
    
    NSStackView *stackView = [NSStackView new];
    stackView.orientation = NSUserInterfaceLayoutOrientationVertical;
    stackView.distribution = NSStackViewDistributionFillProportionally;
    stackView.alignment = NSLayoutAttributeWidth;
    
    NSSearchField *searchField = self.searchField;
    NSScrollView *scrollView = self.scrollView;
    
//    [searchField setContentHuggingPriority:NSLayoutPriorityRequired forOrientation:NSLayoutConstraintOrientationVertical];
//    [scrollView setContentHuggingPriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationVertical];
    
    [stackView addArrangedSubview:searchField];
    [stackView addArrangedSubview:scrollView];
    
    _stackView = stackView;
    return stackView;
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

- (BOOL)showBlendedBackground {
    return self.visualEffectView.superview != nil;
}

- (void)setShowBlendedBackground:(BOOL)showBlendedBackground {
    if (self.visualEffectView.superview == nil) {
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self.scrollView, sel_registerName("_addBackgroundView:"), self.visualEffectView);
    } else {
        [self.visualEffectView removeFromSuperview];
    }
}

- (void)performTextFinderAction:(id)sender {
    [self.searchField becomeFirstResponder];
}

- (void)configurationSwitchItem:(ConfigurationSwitchItem *)configurationSwitchItem didToggleValue:(BOOL)value {
    [self _didChangeItemValueWithItem:configurationSwitchItem newValue:@(value)];
}

- (void)configurationSliderItem:(ConfigurationSliderItem *)configurationSliderItem didChangeValue:(double)value {
    [self _didChangeItemValueWithItem:configurationSliderItem newValue:@(value)];
}

- (void)configurationStepperItem:(ConfigurationStepperItem *)configurationStepperItem didChangeValue:(double)value {
    [self _didChangeItemValueWithItem:configurationStepperItem newValue:@(value)];
}

- (void)configurationButtonItem:(ConfigurationButtonItem *)configurationButtonItem didTriggerButton:(NSButton *)sender {
    NSIndexPath *indexPath = [self.collectionView indexPathForItem:configurationButtonItem];
    if (indexPath == nil) return;
    
    ConfigurationItemModel *itemModel = [self.dataSource itemIdentifierForIndexPath:indexPath];
    assert(itemModel != nil);
    
    switch (itemModel.type) {
        case ConfigurationItemModelTypeButton: {
            [self _didChangeItemValueWithItemModel:itemModel newValue:[NSNull null]];
            break;
        }
        case ConfigurationItemModelTypeViewPresentation: {
            auto description = static_cast<ConfigurationViewPresentationDescription *>(configurationButtonItem.resolvedValue);
            assert([description isKindOfClass:[ConfigurationViewPresentationDescription class]]);
            
            switch (description.style) {
                case ConfigurationViewPresentationStyleAlert: {
                    NSAlert *alert = [NSAlert new];
                    
                    alert.messageText = configurationButtonItem.textField.stringValue;
                    
                    __kindof NSView *resolvedView = description.viewBuilder(^{
                        [alert layout];
                    });
                    alert.accessoryView = resolvedView;
                    
                    [alert beginSheetModalForWindow:self.window completionHandler:^(NSModalResponse returnCode) {
                        // resolvedView가 Layout Block을 retain하면 Retain Cycle이 일어나기에 이렇게 해줘야함
                        alert.accessoryView = nil;
                        [resolvedView removeFromSuperview];
                        
                        description.didCloseHandler(resolvedView, @{ConfigurationViewPresentationModalResponseKey: @(returnCode)});
                    }];
                    [alert release];
                    break;
                }
                case ConfigurationViewPresentationStylePopover: {
                    NSPopover *popover = [NSPopover new];
                    
                    __kindof NSView *resolvedView = description.viewBuilder(^{
                        NSView *view = popover.contentViewController.view;
                        popover.contentSize = view.frame.size;
                    });
                    
                    NSViewController *viewController = [NSViewController new];
                    viewController.view = resolvedView;
                    popover.contentViewController = viewController;
                    [viewController release];
                    
                    popover.behavior = NSPopoverBehaviorSemitransient;
                    
                    static void *key = &key;
                    
                    id<NSObject> observer = [NSNotificationCenter.defaultCenter addObserverForName:NSPopoverDidCloseNotification
                                                                                            object:popover
                                                                                             queue:nil
                                                                                        usingBlock:^(NSNotification * _Nonnull notification) {
                        auto popover = static_cast<NSPopover *>(notification.object);
                        
                        // resolvedView가 Layout Block을 retain하면 Retain Cycle이 일어나기에 이렇게 해줘야함
                        popover.contentViewController = nil;
                        description.didCloseHandler(resolvedView, @{});
                        
                        // Popover -> Observer -> Resolved View -> Layout Block -> Popover으로 인해 Retain Cycle이 일어나므로, 'Observer -> Resolved View'를 제거한다.
                        id<NSObject> observer = objc_getAssociatedObject(popover, key);
                        [NSNotificationCenter.defaultCenter removeObserver:observer];
                        objc_setAssociatedObject(popover, key, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                    }];
                    
                    objc_setAssociatedObject(popover, key, observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                    
                    [popover showRelativeToRect:NSZeroRect
                                         ofView:sender
                                  preferredEdge:NSRectEdgeMaxX];
                    [popover release];
                    break;
                }
                default:
                    abort();
            }
            
            break;
        }
        default:
            abort();
    }
}

- (void)configurationPopUpButtonItem:(ConfigurationPopUpButtonItem *)configurationPopUpButtonItem didSelectItem:(NSMenuItem *)selectedItem {
    [self _didChangeItemValueWithItem:configurationPopUpButtonItem newValue:selectedItem.title];
}

- (void)configurationColorWellItem:(ConfigurationColorWellItem *)configurationColorWellItem didSelectColor:(NSColor *)color {
    [self _didChangeItemValueWithItem:configurationColorWellItem newValue:color];
}

- (void)_didChangeItemValueWithItem:(NSCollectionViewItem *)item newValue:(id<NSCopying>)newValue {
    NSIndexPath *indexPath = [self.collectionView indexPathForItem:item];
//    assert(indexPath != nil);
    if (indexPath == nil) return;
    
    ConfigurationItemModel *itemModel = [self.dataSource itemIdentifierForIndexPath:indexPath];
    assert(itemModel != nil);
    
    [self _didChangeItemValueWithItemModel:itemModel newValue:newValue];
}

- (void)_didChangeItemValueWithIdentifier:(NSString *)identifier newValue:(id<NSCopying>)newValue {
    for (ConfigurationItemModel *itemModel in self.snapshot.itemIdentifiers) {
        if ([itemModel.identifier isEqualToString:identifier]) {
            [self _didChangeItemValueWithItemModel:itemModel newValue:newValue];
            return;
        }
    }
    
    abort();
}

- (void)_didChangeItemValueWithItemModel:(ConfigurationItemModel *)itemModel newValue:(id<NSCopying>)newValue {
    BOOL shouldReconfigure;
    if (id<ConfigurationViewDelegate> delegate = self.delegate) {
        shouldReconfigure = [delegate configurationView:self didTriggerActionWithItemModel:itemModel newValue:newValue];
    } else {
        shouldReconfigure = YES;
    }
    
//    if (!shouldReconfigure) {
//        assert(itemModel.type != ConfigurationItemModelTypePopUpButton);
//    }
    
    if (shouldReconfigure) {
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
//        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(snapshot, sel_registerName("reconfigureItemsWithIdentifiers:"), @[itemModel]);
        [snapshot reloadItemsWithIdentifiers:@[itemModel]];
        [self.dataSource applySnapshot:snapshot animatingDifferences:NO];
        [snapshot release];
    }
}

- (void)_didTriggerReloadButton:(NSButton *)sender {
    id<ConfigurationViewDelegate> delegate = self.delegate;
    if (delegate == nil) return;
    
    [delegate didTriggerReloadButtonWithConfigurationView:self];
}

- (void)_filterItemModelsWithQuery:(NSString * _Nullable)query animatingDifferences:(BOOL)animatingDifferences {
    NSDiffableDataSourceSnapshot<NSNull *, ConfigurationItemModel *> * __autoreleasing snapshot;
    if ((query == nil) or (query.length == 0)) {
        snapshot = self.originalSnapshot;
    } else {
        snapshot = [[NSDiffableDataSourceSnapshot new] autorelease];
        NSDiffableDataSourceSnapshot<NSNull *, ConfigurationItemModel *> *originalSnapshot = self.originalSnapshot;
        
        for (NSNull *sectionModel in originalSnapshot.sectionIdentifiers) {
            [snapshot appendSectionsWithIdentifiers:@[sectionModel]];
            
            for (ConfigurationItemModel *itemModel in [originalSnapshot itemIdentifiersInSectionWithIdentifier:sectionModel]) {
                BOOL contains;
                
                NSString *identifier = itemModel.identifier;
                if ([identifier localizedCaseInsensitiveContainsString:query]) {
                    contains = YES;
                } else {
                    id value = itemModel.valueResolver(itemModel);
                    NSString *label = itemModel.labelResolver(itemModel, value);
                    
                    if ([label localizedCaseInsensitiveContainsString:query]) {
                        contains = YES;
                    } else {
                        contains = NO;
                    }
                }
                
                if (contains) {
                    [snapshot appendItemsWithIdentifiers:@[itemModel] intoSectionWithIdentifier:sectionModel];
                }
            }
        }
    }
    
    [self.dataSource applySnapshot:snapshot animatingDifferences:animatingDifferences];
}

- (void)controlTextDidChange:(NSNotification *)obj {
    [self _filterItemModelsWithQuery:self.searchField.stringValue animatingDifferences:YES];
}

- (void)_popUpItemAction:(NSMenuItem *)sender {
    // https://x.com/_silgen_name/status/1895002552774861135
    [self _didChangeItemValueWithIdentifier:sender.representedObject newValue:sender.title];
}

@end
