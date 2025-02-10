//
//  FeedbackGeneratorViewController.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 2/9/25.
//

// https://x.com/_silgen_name/status/1888628565874511901

#import "FeedbackGeneratorViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>
#include <dlfcn.h>

NSString * mui_MRUICadenzaNameForFeedback(NSUInteger type) {
    static void *symbol;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        void *handle = dlopen("/System/Library/PrivateFrameworks/MRUIKit.framework/MRUIKit", RTLD_NOW);
        assert(handle != NULL);
        void *_symbol = dlsym(handle, "_MRUICadenzaNameForFeedback");
        assert(_symbol != NULL);
        symbol = _symbol;
    });
    
    return reinterpret_cast<id (*)(NSUInteger)>(symbol)(type);
}

@interface FeedbackGeneratorViewController ()
@property (class, nonatomic, readonly, getter=_feedbackTypesByCandenzaName) NSDictionary<NSString *, NSNumber *> *feedbackTypesByCandenzaName;
@property (class, nonatomic, readonly, getter=_sortedFeedbackTypes) NSArray<NSNumber *> *sortedFeedbackTypes;
@property (retain, readonly, nonatomic, getter=_cellRegistration) UICollectionViewCellRegistration *cellRegistration;
@property (retain, readonly, nonatomic, getter=_feedbackGenerator) id feedbackGenerator;
@end

@implementation FeedbackGeneratorViewController
@synthesize cellRegistration = _cellRegistration;
@synthesize feedbackGenerator = _feedbackGenerator;

+ (NSDictionary<NSString *,NSNumber *> *)_feedbackTypesByCandenzaName {
    return @{
        @"RUIFeedbackTypeButtonNavigationBarTouchDown": @2,
        @"MRUIFeedbackTypeButtonNavigationBarTouchUp": @3,
        @"MRUIFeedbackTypeButtonStandardTouchDown": @5,
        @"MRUIFeedbackTypeButtonStandardTouchUp": @6,
        @"MRUIFeedbackTypeButtonStepperMinusTouchDown": @8,
        @"MRUIFeedbackTypeButtonStepperMinusTouchUp": @9,
        @"MRUIFeedbackTypeButtonStepperPlusTouchDown": @11,
        @"MRUIFeedbackTypeButtonStepperPlusTouchUp": @12,
        @"MRUIFeedbackTypeGridItemLargeTouchDown": @16,
        @"MRUIFeedbackTypeGridItemLargeTouchUp": @17,
        @"MRUIFeedbackTypeGridItemMediumTouchDown": @19,
        @"MRUIFeedbackTypeGridItemMediumTouchUp": @20,
        @"MRUIFeedbackTypeGridItemSmallTouchDown": @22,
        @"MRUIFeedbackTypeGridItemSmallTouchUp": @23,
        @"MRUIFeedbackTypeListItemLargeTouchDown": @25,
        @"MRUIFeedbackTypeListItemLargeTouchUp": @26,
        @"MRUIFeedbackTypeListItemMediumTouchDown": @28,
        @"MRUIFeedbackTypeListItemMediumTouchUp": @29,
        @"MRUIFeedbackTypeListItemSmallTouchDown": @31,
        @"MRUIFeedbackTypeListItemSmallTouchUp": @32,
        @"MRUIFeedbackTypePickerScroll": @33,
        @"MRUIFeedbackTypePresentationAlert": @34,
        @"MRUIFeedbackTypePresentationModal": @35,
        @"MRUIFeedbackTypePresentationPopover": @36,
        @"MRUIFeedbackTypeScrollViewGrabberTouchDown": @38,
        @"MRUIFeedbackTypeScrollViewGrabberTouchUp": @39,
        @"MRUIFeedbackTypeSegmentedControlItemTouchDown": @43,
        @"MRUIFeedbackTypeSegmentedControlItemTouchUp": @44,
        @"MRUIFeedbackTypeSliderTouchDown": @46,
        @"MRUIFeedbackTypeSliderTouchUp": @47,
        @"MRUIFeedbackTypeSliderSlidToMaximumValue": @48,
        @"MRUIFeedbackTypeSliderSlidToMinimumValue": @49,
        @"MRUIFeedbackTypeTabViewItemTouchDown": @51,
        @"MRUIFeedbackTypeTabViewItemTouchUp": @52,
        @"MRUIFeedbackTypeTabViewItemsContainerExpanded": @53,
        @"MRUIFeedbackTypeTabViewItemsContainerClosed": @54,
        @"MRUIFeedbackTypeTextFieldTouchDown": @56,
        @"MRUIFeedbackTypeToggleTouchDown": @59,
        @"MRUIFeedbackTypeToggleSetToOn": @60,
        @"MRUIFeedbackTypeToggleSetToOff": @61,
        @"MRUIFeedbackTypeCircularButtonTouchDown": @62,
        @"MRUIFeedbackTypeCircularButtonTouchUp": @63,
        @"MRUIFeedbackTypeButtonWithBackgroundTouchDown": @64,
        @"MRUIFeedbackTypeButtonWithBackgroundTouchUp": @65,
        @"MRUIFeedbackTypeButtonToggleOn": @66,
        @"MRUIFeedbackTypeButtonToggleOff": @67,
        @"MRUIFeedbackTypeButtonWithoutBackgroundTouchDown": @68,
        @"MRUIFeedbackTypeButtonWithoutBackgroundTouchUp": @69,
        @"MRUIFeedbackTypeContextMenuOpen": @450,
        @"MRUIFeedbackTypeContextMenuDismiss": @451,
        @"MRUIFeedbackTypeDragStart": @500,
        @"MRUIFeedbackTypeDragCancel": @501,
        @"MRUIFeedbackTypeDropInApp": @502,
        @"MRUIFeedbackTypeDropInVoid": @503,
        @"MRUIFeedbackTypeHandReveal": @550,
        @"MRUIFeedbackTypeHandConceal": @551,
        @"MRUIFeedbackTypeHandFlipPalmUp": @552,
        @"MRUIFeedbackTypeHandFlipPalmDown": @553
    };
}

+ (NSArray<NSNumber *> *)_sortedFeedbackTypes {
    static NSArray<NSNumber *> *results;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary<NSString *, NSNumber *> *feedbackTypesByCandenzaName = FeedbackGeneratorViewController.feedbackTypesByCandenzaName;
        NSArray<NSNumber *> *sorted = [feedbackTypesByCandenzaName.allValues sortedArrayUsingComparator:^NSComparisonResult(NSNumber * _Nonnull obj1, NSNumber * _Nonnull obj2) {
            return [obj1 compare:obj2];
        }];
        results = [sorted copy];
    });
    
    return results;
}

- (instancetype)init {
    UICollectionLayoutListConfiguration *listConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearanceInsetGrouped];
    UICollectionViewCompositionalLayout *collectionViewLayout = [UICollectionViewCompositionalLayout layoutWithListConfiguration:listConfiguration];
    [listConfiguration release];
    
    self = [super initWithCollectionViewLayout:collectionViewLayout];
    return self;
}

- (void)dealloc {
    [_cellRegistration release];
    [_feedbackGenerator release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _cellRegistration];
}

- (UICollectionViewCellRegistration *)_cellRegistration {
    if (auto cellRegistration = _cellRegistration) return cellRegistration;
    
    NSArray<NSNumber *> *sortedFeedbackTypes = FeedbackGeneratorViewController.sortedFeedbackTypes;
    
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:UICollectionViewListCell.class configurationHandler:^(__kindof UICollectionViewListCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id  _Nonnull item) {
        UIListContentConfiguration *contentConfiguration = [cell defaultContentConfiguration];
        contentConfiguration.text = mui_MRUICadenzaNameForFeedback(sortedFeedbackTypes[indexPath.item].unsignedIntegerValue);
        cell.contentConfiguration = contentConfiguration;
    }];
    
    _cellRegistration = [cellRegistration retain];
    return cellRegistration;
}

- (id)_feedbackGenerator {
    if (id feedbackGenerator = _feedbackGenerator) return feedbackGenerator;
    
    id feedbackGenerator = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("MRUIFeedbackGenerator") alloc], sel_registerName("initWithView:"), self.view);
    
    _feedbackGenerator = feedbackGenerator;
    return feedbackGenerator;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return FeedbackGeneratorViewController.sortedFeedbackTypes.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueConfiguredReusableCellWithRegistration:self.cellRegistration forIndexPath:indexPath item:[NSNull null]];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger type = FeedbackGeneratorViewController.sortedFeedbackTypes[indexPath.item].unsignedIntegerValue;
    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(self.feedbackGenerator, sel_registerName("playFeedbackForFeedbackType:"), type);
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

@end

// MRUIFeedbackGenerator
