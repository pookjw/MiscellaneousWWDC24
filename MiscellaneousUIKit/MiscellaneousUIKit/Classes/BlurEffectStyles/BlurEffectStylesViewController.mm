//
//  BlurEffectStylesViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 2/7/25.
//

#import "BlurEffectStylesViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

UIKIT_EXTERN NSString * _UIStyledEffectConvertToString(UIBlurEffectStyle);
OBJC_EXPORT id objc_msgSendSuper2(void); /* objc_super superInfo = { self, [self class] }; */

@interface VisualEffectView : UIVisualEffectView
@end
@implementation VisualEffectView
- (void)_configureEffects {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("_setGroupName:"), nil);
}
@end

@interface BlurEffectStylesViewController () <UICollectionViewDataSource>
@property (class, nonatomic, readonly, getter=_effectStylesByString) NSDictionary<NSString *, NSNumber *> *effectStylesByString;
@property (class, nonatomic, readonly, getter=_sortedEffectStyles) NSArray<NSNumber *> *sortedEffectStyles;
//@property (class, nonatomic, readonly, getter=_sortedEffectStyleStrings) NSArray<NSString *> *sortedEffectStyleStrings;
@property (retain, nonatomic, readonly, getter=_imageView) UIImageView *imageView;
@property (retain, nonatomic, readonly, getter=_collectionView) UICollectionView *collectionView;
@property (retain, nonatomic, readonly, getter=_cellRegistration) UICollectionViewCellRegistration *cellRegistration;
@end

@implementation BlurEffectStylesViewController
@synthesize imageView = _imageView;
@synthesize collectionView = _collectionView;
@synthesize cellRegistration = _cellRegistration;

+ (NSDictionary<NSString *,NSNumber *> *)_effectStylesByString {
    return @{
        @"UIBlurEffectStyleExtraLight": @0,
        @"UIBlurEffectStyleLight": @1,
        @"UIBlurEffectStyleDark": @2,
        @"UIBlurEffectStyleExtraDark": @3,
        @"UIBlurEffectStyleRegular": @4,
        @"UIBlurEffectStyleProminent": @5,
        @"UIBlurEffectStyleSystemUltraThinMaterial": @6,
        @"UIBlurEffectStyleSystemThinMaterial": @7,
        @"UIBlurEffectStyleSystemMaterial": @8,
        @"UIBlurEffectStyleSystemThickMaterial": @9,
        @"UIBlurEffectStyleSystemChromeMaterial": @10,
        @"UIBlurEffectStyleSystemUltraThinMaterialLight": @11,
        @"UIBlurEffectStyleSystemThinMaterialLight": @12,
        @"UIBlurEffectStyleSystemMaterialLight": @13,
        @"UIBlurEffectStyleSystemThickMaterialLight": @14,
        @"UIBlurEffectStyleSystemChromeMaterialLight": @15,
        @"UIBlurEffectStyleSystemUltraThinMaterialDark": @16,
        @"UIBlurEffectStyleSystemThinMaterialDark": @17,
        @"UIBlurEffectStyleSystemMaterialDark": @18,
        @"UIBlurEffectStyleSystemThickMaterialDark": @19,
        @"UIBlurEffectStyleSystemChromeMaterialDark": @20,
        @"UIBlurEffectStyleUltraDark": @99,
        @"UIBlurEffectStyleUltraColored": @100,
        @"UIBlurEffectStyleLightKeyboard": @501,
        @"UIBlurEffectStyleLightEmojiKeyboard": @502,
        @"UIBlurEffectStyleAutomatic": @1000,
        @"UIBlurEffectStyleSystemChromeBackground": @1100,
        @"UIBlurEffectStyleSystemChromeBackgroundLight": @1101,
        @"UIBlurEffectStyleSystemChromeBackgroundDark": @1102,
        @"UIBlurEffectStyleSystemVibrantBackgroundRegular": @1200,
        @"UIBlurEffectStyleSystemVibrantBackgroundUltraThin": @1201,
        @"UIBlurEffectStyleSystemVibrantBackgroundThin": @1202,
        @"UIBlurEffectStyleSystemVibrantBackgroundThick": @1203,
        @"UIBlurEffectStyleSystemVibrantBackgroundRegularLight": @1204,
        @"UIBlurEffectStyleSystemVibrantBackgroundUltraThinLight": @1205,
        @"UIBlurEffectStyleSystemVibrantBackgroundThinLight": @1206,
        @"UIBlurEffectStyleSystemVibrantBackgroundThickLight": @1207,
        @"UIBlurEffectStyleSystemVibrantBackgroundRegularDark": @1208,
        @"UIBlurEffectStyleSystemVibrantBackgroundUltraThinDark": @1209,
        @"UIBlurEffectStyleSystemVibrantBackgroundThinDark": @1210,
        @"UIBlurEffectStyleSystemVibrantBackgroundThickDark": @1211,
        @"UIBlurEffectStyleATVSemiLight": @4000,
        @"UIBlurEffectStyleATVMediumLight": @4001,
        @"UIBlurEffectStyleATVLight": @4002,
        @"UIBlurEffectStyleATVUltraLight": @4003,
        @"UIBlurEffectStyleATVMenuLight": @4004,
        @"UIBlurEffectStyleATVSemiDark": @4005,
        @"UIBlurEffectStyleATVMediumDark": @4006,
        @"UIBlurEffectStyleATVDark": @4007,
        @"UIBlurEffectStyleATVUltraDark": @4008,
        @"UIBlurEffectStyleATVMenuDark": @4009,
        @"UIBlurEffectStyleATVAdaptive": @4010,
        @"UIBlurEffectStyleATVAdaptiveLighten": @4011,
        @"UIBlurEffectStyleATVLightTextField": @4012,
        @"UIBlurEffectStyleATVDarkTextField": @4013,
        @"UIBlurEffectStyleATVAccessoryLight": @4014,
        @"UIBlurEffectStyleATVAccessoryDark": @4015,
        @"UIBlurEffectStyleATVBlackTextField": @4016,
        @"UIBlurEffectStyleATVAutomatic": @5000,
        @"UIBlurEffectStyleATVSemiAutomatic": @5001,
        @"UIBlurEffectStyleATVMediumAutomatic": @5002,
        @"UIBlurEffectStyleATVUltraAutomatic": @5003,
        @"UIBlurEffectStyleATVMenuAutomatic": @5004,
        @"UIBlurEffectStyleATVAccessoryAutomatic": @5005,
        @"UIBlurEffectStyleATVTextFieldAutomatic": @5006,
        @"UIBlurEffectStylePinched": @6000,
        @"UIBlurEffectStyleSelected": @6001,
        @"UIBlurEffectStyleDisabled": @6002,
        @"UIBlurEffectStyleGlassLighter": @6003,
        @"UIBlurEffectStyleGlassDarker": @6004,
        @"UIBlurEffectStyleGlassUltraDarker": @6005,
        @"UIBlurEffectStyleGlass": @6006,
        @"UIBlurEffectStyleUndefined": @0x8000000000000000,
    };
}

+ (NSArray<NSNumber *> *)_sortedEffectStyles {
    static NSArray<NSNumber *> *result;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        result = [[BlurEffectStylesViewController.effectStylesByString.allValues sortedArrayUsingComparator:^NSComparisonResult(NSNumber * _Nonnull obj1, NSNumber * _Nonnull obj2) {
            return [obj1 compare:obj2];
        }] copy];
    });
    
    return result;
}

//+ (NSArray<NSString *> *)_sortedEffectStyleStrings {
//    static NSArray<NSString *> *result;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        NSDictionary<NSString *, NSNumber *> *effectStylesByString = BlurEffectStylesViewController.effectStylesByString;
//        NSArray<NSNumber *> *sortedEffectStyles = BlurEffectStylesViewController.sortedEffectStyles;
//        
//        result = [[BlurEffectStylesViewController.effectStylesByString.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString * _Nonnull obj1, NSString * _Nonnull obj2) {
//            NSNumber *n1 = effectStylesByString[obj1];
//            NSNumber *n2 = effectStylesByString[obj2];
//            
//            NSInteger i1 = [sortedEffectStyles indexOfObject:n1];
//            NSInteger i2 = [sortedEffectStyles indexOfObject:n2];
//            
//            return [@(i1) compare:@(i2)];
//        }] copy];
//    });
//    
//    return result;
//}

- (void)dealloc {
    [_imageView release];
    [_collectionView release];
    [_cellRegistration release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _cellRegistration];
    
    UIImageView *imageView = self.imageView;
    [self.view addSubview:imageView];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self.view, sel_registerName("_addBoundsMatchingConstraintsForView:"), imageView);
    
//    UICollectionView *collectionView = self.collectionView;
//    [self.view addSubview:collectionView];
//    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self.view, sel_registerName("_addBoundsMatchingConstraintsForView:"), collectionView);
    
    UIVisualEffectView *visualEffectView = [[VisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:static_cast<UIBlurEffectStyle>(1100)]];
    [visualEffectView contentView].backgroundColor = UIColor.clearColor;
    [self.view addSubview:visualEffectView];
    visualEffectView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [visualEffectView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [visualEffectView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [visualEffectView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:0.5],
        [visualEffectView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:0.5],
    ]];
    visualEffectView.effect = [UIBlurEffect effectWithStyle:static_cast<UIBlurEffectStyle>(1100)];
    [visualEffectView release];
}

- (UIImageView *)_imageView {
    if (auto imageView = _imageView) return imageView;
    
    NSURL *url = [NSBundle.mainBundle URLForResource:@"beer" withExtension:@"jpg"];
    assert(url != nil);
    UIImage *image = [UIImage imageWithContentsOfFile:url.path];
    assert(image != nil);
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    _imageView = imageView;
    return imageView;
}

- (UICollectionView *)_collectionView {
    if (auto collectionView = _collectionView) return collectionView;
    
    UICollectionLayoutListConfiguration *listConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearanceInsetGrouped];
    listConfiguration.backgroundColor = UIColor.clearColor;
    UICollectionViewCompositionalLayout *collectionViewLayout = [UICollectionViewCompositionalLayout layoutWithListConfiguration:listConfiguration];
    [listConfiguration release];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectNull collectionViewLayout:collectionViewLayout];
    
    collectionView.dataSource = self;
    collectionView.allowsSelection = NO;
    
    _collectionView = collectionView;
    return collectionView;
}

- (UICollectionViewCellRegistration *)_cellRegistration {
    if (auto cellRegistration = _cellRegistration) return cellRegistration;
    
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:[UICollectionViewListCell class] configurationHandler:^(UICollectionViewListCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id  _Nonnull item) {
        auto style = static_cast<UIBlurEffectStyle>(BlurEffectStylesViewController.sortedEffectStyles[indexPath.item].integerValue);
        
        UIListContentConfiguration *contentConfiguration = [cell defaultContentConfiguration];
        contentConfiguration.text = _UIStyledEffectConvertToString(style);
        cell.contentConfiguration = contentConfiguration;
        
        UIBackgroundConfiguration *backgroundConfiguration = [cell defaultBackgroundConfiguration];
        backgroundConfiguration.backgroundColor = UIColor.clearColor;
        backgroundConfiguration.visualEffect = [UIBlurEffect effectWithStyle:style];
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(backgroundConfiguration, sel_registerName("__setVisualEffectGroupName:"), [NSUUID UUID].UUIDString);
        cell.backgroundConfiguration = backgroundConfiguration;
    }];
    
    _cellRegistration = [cellRegistration retain];
    return cellRegistration;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return BlurEffectStylesViewController.effectStylesByString.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueConfiguredReusableCellWithRegistration:self.cellRegistration forIndexPath:indexPath item:[NSNull null]];
}

@end
