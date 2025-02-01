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

@interface ConfigurationView () <ConfigurationSwitchItemDelegate, ConfigurationSliderItemDelegate, ConfigurationStepperItemDelegate, ConfigurationButtonItemDelegate, ConfigurationPopUpButtonItemDelegate>
@property (class, nonatomic, readonly, getter=_switchItemIdentifier) NSUserInterfaceItemIdentifier switchItemIdentifier;
@property (class, nonatomic, readonly, getter=_sliderItemIdentifier) NSUserInterfaceItemIdentifier sliderItemIdentifier;
@property (class, nonatomic, readonly, getter=_stepperItemIdentifier) NSUserInterfaceItemIdentifier stepperItemIdentifier;
@property (class, nonatomic, readonly, getter=_buttonItemIdentifier) NSUserInterfaceItemIdentifier buttonItemIdentifier;
@property (class, nonatomic, readonly, getter=_popUpButtonItemIdentifier) NSUserInterfaceItemIdentifier popUpButtonItemIdentifier;
@property (class, nonatomic, readonly, getter=_separatorItemIdentifier) NSUserInterfaceItemIdentifier separatorItemIdentifier;
@property (class, nonatomic, readonly, getter=_separatorElementKind) NSCollectionViewSupplementaryElementKind separatorElementKind;
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
    [super dealloc];
}

- (void)layout {
    [super layout];
    self.visualEffectView.frame = self.scrollView.bounds;
}

- (void)_commonInit_ConfigurationView {
    NSRect bounds = self.bounds;
    
    NSScrollView *scrollView = self.scrollView;
    scrollView.frame = bounds;
    scrollView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self addSubview:scrollView];
    
    NSButton *reloadButton = self.reloadButton;
    reloadButton.translatesAutoresizingMaskIntoConstraints = NO;
//    reloadButton.frame = NSMakeRect(-30., -30., 30., 30.);
//    reloadButton.autoresizingMask = NSViewMinXMargin | NSViewMinYMargin;
    [self addSubview:reloadButton];
    [NSLayoutConstraint activateConstraints:@[
        [reloadButton.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-20.],
        [reloadButton.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-20.]
    ]];
}

- (NSCollectionViewDiffableDataSource<NSNull *,ConfigurationItemModel *> *)dataSource {
    if (auto dataSource = _dataSource) return dataSource;
    
    __block auto unretainedSelf = self;
    
    NSCollectionViewDiffableDataSource<NSNull *,ConfigurationItemModel *> *dataSource = [[NSCollectionViewDiffableDataSource alloc] initWithCollectionView:self.collectionView itemProvider:^NSCollectionViewItem * _Nullable(NSCollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, ConfigurationItemModel * _Nonnull itemModel) {
        ConfigurationItemModelType type = itemModel.type;
        id<NSCopying> value = itemModel.valueResolver(itemModel);
        NSString *label = itemModel.labelResolver(itemModel, value);
        
        switch (type) {
            case ConfigurationItemModelTypeSwitch: {
                BOOL isOn = static_cast<NSNumber *>(value).boolValue;
                
                ConfigurationSwitchItem *item = [collectionView makeItemWithIdentifier:ConfigurationView.switchItemIdentifier forIndexPath:indexPath];
                item.delegate = unretainedSelf;
                item.textField.stringValue = label;
                
//                reinterpret_cast<void (*)(Class, SEL, id)>(objc_msgSend)([NSView class], sel_registerName("_performWithoutAnimation:"), ^{
                    item.toggleSwitch.state = isOn ? NSControlStateValueOn : NSControlStateValueOff;
//                });
                
                return item;
            }
            case ConfigurationItemModelTypeSlider: {
                auto sliderDescription = static_cast<ConfigurationSliderDescription *>(value);
                
                ConfigurationSliderItem *item = [collectionView makeItemWithIdentifier:ConfigurationView.sliderItemIdentifier forIndexPath:indexPath];
                item.delegate = unretainedSelf;
                item.textField.stringValue = label;
                item.slider.minValue = sliderDescription.minimumValue;
                item.slider.maxValue = sliderDescription.maximumValue;
                item.slider.doubleValue = sliderDescription.sliderValue;
                item.slider.continuous = sliderDescription.continuous;
                
                return item;
            }
            case ConfigurationItemModelTypeStepper: {
                auto stepperDescription = static_cast<ConfigurationStepperDescription *>(value);
                
                ConfigurationStepperItem *item = [collectionView makeItemWithIdentifier:ConfigurationView.stepperItemIdentifier forIndexPath:indexPath];
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
                item.delegate = unretainedSelf;
                item.textField.stringValue = label;
                
                return item;
            }
            case ConfigurationItemModelTypePopUpButton: {
                ConfigurationPopUpButtonItem *item = [collectionView makeItemWithIdentifier:ConfigurationView.popUpButtonItemIdentifier forIndexPath:indexPath];
                item.delegate = unretainedSelf;
                item.textField.stringValue = label;
                
                auto description = static_cast<ConfigurationPopUpButtonDescription *>(value);
                NSPopUpButton *popUpButton = item.popUpButton;
                
                [popUpButton.menu removeAllItems];
                [popUpButton addItemWithTitle:@"None"];
                [popUpButton addItemsWithTitles:description.titles];
                
                if (NSString *selectedDisplayTitle = description.selectedDisplayTitle) {
                    [popUpButton selectItemWithTitle:selectedDisplayTitle];
                    
                    for (NSMenuItem *item in popUpButton.menu.itemArray) {
                        if ([description.selectedTitles containsObject:item.title]) {
                            item.state = NSControlStateValueOn;
                        } else {
                            item.state = NSControlStateValueOff;
                        }
                    }
                }
                
                //
                
                NSMenuItem *noneItem = [popUpButton itemAtIndex:0];
                assert([noneItem.title isEqualToString:@"None"]);
                noneItem.enabled = NO;
                noneItem.state = (description.selectedTitles.count > 0) ? NSControlStateValueOff : NSControlStateValueOn;
                
                [popUpButton.menu insertItem:[NSMenuItem separatorItem] atIndex:1];
                
                //
                
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
                                                                          heightDimension:[NSCollectionLayoutDimension estimatedDimension:60.]];
        
        NSCollectionLayoutSize *separatorSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.]
                                                                               heightDimension:[NSCollectionLayoutDimension absoluteDimension:1.]];
        
        NSCollectionLayoutSupplementaryItem *separatorItem = [NSCollectionLayoutSupplementaryItem supplementaryItemWithLayoutSize:separatorSize
                                                                                                                      elementKind:ConfigurationView.separatorElementKind
                                                                                                                  containerAnchor:[NSCollectionLayoutAnchor layoutAnchorWithEdges:NSDirectionalRectEdgeBottom]
                                                                                                                       itemAnchor:[NSCollectionLayoutAnchor layoutAnchorWithEdges:NSDirectionalRectEdgeTop]];
        
        NSCollectionLayoutItem *item = [NSCollectionLayoutItem itemWithLayoutSize:itemSize supplementaryItems:@[separatorItem]];
        
        NSCollectionLayoutSize *groupSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.]
                                                                           heightDimension:[NSCollectionLayoutDimension estimatedDimension:61.]];
        
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
    
    [collectionView registerClass:[ConfigurationSeparatorView class] forSupplementaryViewOfKind:ConfigurationView.separatorElementKind withIdentifier:ConfigurationView.separatorItemIdentifier];
    
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
    scrollView.scrollerStyle = NSScrollerStyleOverlay;
    scrollView.autohidesScrollers = YES;
    
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

- (void)configurationSwitchItem:(ConfigurationSwitchItem *)configurationSwitchItem didToggleValue:(BOOL)value {
    [self _didChangeItemValueWithItem:configurationSwitchItem newValue:@(value)];
}

- (void)configurationSliderItem:(ConfigurationSliderItem *)configurationSliderItem didChangeValue:(double)value {
    [self _didChangeItemValueWithItem:configurationSliderItem newValue:@(value)];
}

- (void)configurationStepperItem:(ConfigurationStepperItem *)configurationStepperItem didChangeValue:(double)value {
    [self _didChangeItemValueWithItem:configurationStepperItem newValue:@(value)];
}

- (void)didTriggerButton:(ConfigurationButtonItem *)configurationButtonItem {
    [self _didChangeItemValueWithItem:configurationButtonItem newValue:[NSNull null]];
}

- (void)configurationPopUpButtonItem:(ConfigurationPopUpButtonItem *)configurationPopUpButtonItem didSelectItem:(NSMenuItem *)selectedItem {
    [self _didChangeItemValueWithItem:configurationPopUpButtonItem newValue:selectedItem.title];
}

- (void)_didChangeItemValueWithItem:(NSCollectionViewItem *)item newValue:(id<NSCopying>)newValue {
    NSIndexPath *indexPath = [self.collectionView indexPathForItem:item];
//    assert(indexPath != nil);
    if (indexPath == nil) return;
    
    ConfigurationItemModel *itemModel = [self.dataSource itemIdentifierForIndexPath:indexPath];
    assert(itemModel != nil);
    
    BOOL shouldReconfigure;
    if (id<ConfigurationViewDelegate> delegate = self.delegate) {
        shouldReconfigure = [delegate configurationView:self didTriggerActionWithItemModel:itemModel newValue:newValue];
    } else {
        shouldReconfigure = YES;
    }
    
    if (!shouldReconfigure) {
        assert(itemModel.type != ConfigurationItemModelTypePopUpButton);
    }
    
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

@end
