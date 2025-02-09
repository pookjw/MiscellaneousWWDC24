//
//  HoverViewController.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 2/9/25.
//

#import "HoverViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import "HoverContentConfiguration.h"
#import "CustomHoverContentConfiguration.h"
#include <numeric>

#warning TODO UIHoverEffectLayer

UIKIT_EXTERN NSString * const _UIRemoteHoverEffectDefaultDescriptorScrollIndicatorHorizontal;
UIKIT_EXTERN NSString * const _UIRemoteHoverEffectDefaultDescriptorScrollIndicatorVertical;
UIKIT_EXTERN NSString * const _UIRemoteHoverEffectDefaultDescriptorWolfScrollIndicatorHorizontal;
UIKIT_EXTERN NSString * const _UIRemoteHoverEffectDefaultDescriptorWolfScrollIndicatorVertical;
UIKIT_EXTERN NSString * const _UIRemoteHoverEffectDefaultDescriptorHighlight;
UIKIT_EXTERN NSString * const _UIRemoteHoverEffectDefaultDescriptorSpotlight;
UIKIT_EXTERN NSString * const _UIRemoteHoverEffectDefaultDescriptorAutomatic;
CG_EXTERN NSString * const kCARemoteEffectStateIdle;

@interface HoverViewController ()
@property (class, nonatomic, readonly, getter=_hoverStyles) NSDictionary<NSString *, UIHoverStyle *> *hoverStyles;
@property (class, nonatomic, readonly, getter=_sortedHoverStyleKeys) NSArray<NSString *> *sortedHoverStyleKeys;
@property (retain, readonly, nonatomic, getter=_hoverEffectCellRegistration) UICollectionViewCellRegistration *hoverEffectCellRegistration;
@property (retain, readonly, nonatomic, getter=_customEffectCellRegistration) UICollectionViewCellRegistration *customEffectCellRegistration;
@end

@implementation HoverViewController
@synthesize hoverEffectCellRegistration = _hoverEffectCellRegistration;
@synthesize customEffectCellRegistration = _customEffectCellRegistration;

+ (NSDictionary<NSString *, UIHoverStyle *> *)_hoverStyles {
    static NSDictionary<NSString *, UIHoverStyle *> *results;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableDictionary<NSString *, UIHoverStyle *> *_results = [NSMutableDictionary new];
        
        _results[@"Automatic"] = [UIHoverStyle styleWithEffect:[UIHoverAutomaticEffect effect] shape:nil];
        _results[@"Highlight"] = [UIHoverStyle styleWithEffect:[UIHoverHighlightEffect effect] shape:nil];
        _results[@"Lift"] = [UIHoverStyle styleWithEffect:[UIHoverLiftEffect effect] shape:nil];
        
        NSArray<NSString *> *defaultDescriptors = @[
            _UIRemoteHoverEffectDefaultDescriptorScrollIndicatorHorizontal,
            _UIRemoteHoverEffectDefaultDescriptorScrollIndicatorVertical,
            _UIRemoteHoverEffectDefaultDescriptorWolfScrollIndicatorHorizontal,
            _UIRemoteHoverEffectDefaultDescriptorWolfScrollIndicatorVertical,
            _UIRemoteHoverEffectDefaultDescriptorHighlight,
            _UIRemoteHoverEffectDefaultDescriptorSpotlight,
            _UIRemoteHoverEffectDefaultDescriptorAutomatic
        ];
        
        for (NSString *descriptorName in defaultDescriptors) {
            id descriptor = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("_UIRemoteHoverEffectDescriptor"), sel_registerName("descriptorWithName:"), descriptorName);
            
//            NSArray *overlays = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(descriptor, sel_registerName("overlays"));
//            NSArray *underlays = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(descriptor, sel_registerName("underlays"));
            
            id<UIHoverEffect> hoverEffect = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("_UIRemoteHoverEffect") alloc], sel_registerName("initWithDescriptor:"), descriptor);
            UIHoverStyle *hoverStyle = [UIHoverStyle styleWithEffect:hoverEffect shape:nil];
            [hoverEffect release];
            _results[descriptorName] = hoverStyle;
        }
        
        {
            id descriptor = [objc_lookUpClass("_UIRemoteHoverEffectDescriptor") new];
            
            //
            
            id rotationEffect = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("CARemotePropertyEffect"), sel_registerName("effectWithKeyPath:"), @"transform.rotation");
            reinterpret_cast<void (*)(id, SEL, id, id)>(objc_msgSend)(rotationEffect, sel_registerName("setValue:forState:"), @(0), kCARemoteEffectStateIdle);
            reinterpret_cast<void (*)(id, SEL, id, id)>(objc_msgSend)(rotationEffect, sel_registerName("setValue:forState:"), @(M_PI * 2), @"hover");
            
            id scaleEffect = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("CARemotePropertyEffect"), sel_registerName("effectWithKeyPath:"), @"transform.scale");
            reinterpret_cast<void (*)(id, SEL, id, id)>(objc_msgSend)(scaleEffect, sel_registerName("setValue:forState:"), @(1.0), kCARemoteEffectStateIdle);
            reinterpret_cast<void (*)(id, SEL, id, id)>(objc_msgSend)(scaleEffect, sel_registerName("setValue:forState:"), @(1.5), @"hover");
            
            {
                CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                scaleAnimation.duration = 2.0;
                reinterpret_cast<void (*)(id, SEL, id, id, id)>(objc_msgSend)(scaleEffect, sel_registerName("setAnimation:fromState:toState:"), scaleAnimation, nil, kCARemoteEffectStateIdle);
            }
            {
                CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                scaleAnimation.duration = 1.0;
                reinterpret_cast<void (*)(id, SEL, id, id, id)>(objc_msgSend)(scaleEffect, sel_registerName("setAnimation:fromState:toState:"), scaleAnimation, nil, @"hover");
            }
            
            id group = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("CARemoteEffectGroup"), sel_registerName("groupWithEffects:"), @[rotationEffect, scaleEffect]);
            reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(group, sel_registerName("setGroupName:"), @"Test Group");
            reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(group, sel_registerName("setMatched:"), YES);
            
            reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(descriptor, sel_registerName("setContentEffects:"), @[group]);
            
            //
            
            {
                id opacityEffect = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("CARemotePropertyEffect"), sel_registerName("effectWithKeyPath:"), @"opacity");
                reinterpret_cast<void (*)(id, SEL, id, id)>(objc_msgSend)(opacityEffect, sel_registerName("setValue:forState:"), @(0.0), kCARemoteEffectStateIdle);
                reinterpret_cast<void (*)(id, SEL, id, id)>(objc_msgSend)(opacityEffect, sel_registerName("setValue:forState:"), @(1.0), @"hover");
                
                id group = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("CARemoteEffectGroup"), sel_registerName("groupWithEffects:"), @[opacityEffect]);
                reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(group, sel_registerName("setGroupName:"), @"Test Group");
                reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(group, sel_registerName("setMatched:"), YES);
                
                id entry = reinterpret_cast<id (*)(id, SEL, id, id)>(objc_msgSend)([objc_lookUpClass("_UIRemoteHoverEffectEntry") alloc], sel_registerName("initWithEffects:configuringLayerWith:"), @[group], ^(CALayer *layer) {
                    layer.opacity = 0.;
                    layer.backgroundColor = UIColor.cyanColor.CGColor;
                });
                
                reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(descriptor, sel_registerName("setUnderlays:"), @[entry]);
                [entry release];
            }
            
            //
            
            id<UIHoverEffect> hoverEffect = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("_UIRemoteHoverEffect") alloc], sel_registerName("initWithDescriptor:"), descriptor);
            [descriptor release];
            UIHoverStyle *hoverStyle = [UIHoverStyle styleWithEffect:hoverEffect shape:nil];
            [hoverEffect release];
            _results[@"Test (Underlay)"] = hoverStyle;
        }
        
        {
            id descriptor = [objc_lookUpClass("_UIRemoteHoverEffectDescriptor") new];
            
            //
            
            id rotationEffect = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("CARemotePropertyEffect"), sel_registerName("effectWithKeyPath:"), @"transform.rotation");
            reinterpret_cast<void (*)(id, SEL, id, id)>(objc_msgSend)(rotationEffect, sel_registerName("setValue:forState:"), @(0), kCARemoteEffectStateIdle);
            reinterpret_cast<void (*)(id, SEL, id, id)>(objc_msgSend)(rotationEffect, sel_registerName("setValue:forState:"), @(M_PI * 2), @"hover");
            
            id scaleEffect = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("CARemotePropertyEffect"), sel_registerName("effectWithKeyPath:"), @"transform.scale");
            reinterpret_cast<void (*)(id, SEL, id, id)>(objc_msgSend)(scaleEffect, sel_registerName("setValue:forState:"), @(1.0), kCARemoteEffectStateIdle);
            reinterpret_cast<void (*)(id, SEL, id, id)>(objc_msgSend)(scaleEffect, sel_registerName("setValue:forState:"), @(1.5), @"hover");
            
            {
                CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                scaleAnimation.duration = 2.0;
                reinterpret_cast<void (*)(id, SEL, id, id, id)>(objc_msgSend)(scaleEffect, sel_registerName("setAnimation:fromState:toState:"), scaleAnimation, nil, kCARemoteEffectStateIdle);
            }
            {
                CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                scaleAnimation.duration = 1.0;
                reinterpret_cast<void (*)(id, SEL, id, id, id)>(objc_msgSend)(scaleEffect, sel_registerName("setAnimation:fromState:toState:"), scaleAnimation, nil, @"hover");
            }
            
            id group = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("CARemoteEffectGroup"), sel_registerName("groupWithEffects:"), @[rotationEffect, scaleEffect]);
            reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(group, sel_registerName("setGroupName:"), @"Test Group");
            reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(group, sel_registerName("setMatched:"), YES);
            
            reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(descriptor, sel_registerName("setContentEffects:"), @[group]);
            
            //
            
            {
                id opacityEffect = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("CARemotePropertyEffect"), sel_registerName("effectWithKeyPath:"), @"opacity");
                reinterpret_cast<void (*)(id, SEL, id, id)>(objc_msgSend)(opacityEffect, sel_registerName("setValue:forState:"), @(0.0), kCARemoteEffectStateIdle);
                reinterpret_cast<void (*)(id, SEL, id, id)>(objc_msgSend)(opacityEffect, sel_registerName("setValue:forState:"), @(0.5), @"hover");
                
                id group = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("CARemoteEffectGroup"), sel_registerName("groupWithEffects:"), @[opacityEffect]);
                reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(group, sel_registerName("setGroupName:"), @"Test Group");
                reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(group, sel_registerName("setMatched:"), YES);
                
                id entry = reinterpret_cast<id (*)(id, SEL, id, id)>(objc_msgSend)([objc_lookUpClass("_UIRemoteHoverEffectEntry") alloc], sel_registerName("initWithEffects:configuringLayerWith:"), @[group], ^(CALayer *layer) {
                    layer.opacity = 0.;
                    layer.backgroundColor = UIColor.redColor.CGColor;
                });
                
                reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(descriptor, sel_registerName("setOverlays:"), @[entry]);
                [entry release];
            }
            
            //
            
            id<UIHoverEffect> hoverEffect = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("_UIRemoteHoverEffect") alloc], sel_registerName("initWithDescriptor:"), descriptor);
            [descriptor release];
            UIHoverStyle *hoverStyle = [UIHoverStyle styleWithEffect:hoverEffect shape:nil];
            [hoverEffect release];
            _results[@"Test (Overlay)"] = hoverStyle;
        }
        
        results = [_results copy];
        [_results release];
    });
    
    return results;
}

+ (NSArray<NSString *> *)_sortedHoverStyleKeys {
    static NSArray<NSString *> *results;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary<NSString *, UIHoverStyle *> *hoverStyles = HoverViewController.hoverStyles;
        NSArray<NSString *> *sortedKeys = [hoverStyles.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString * _Nonnull obj1, NSString * _Nonnull obj2) {
            return [obj1 compare:obj2];
        }];
        results = [sortedKeys copy];
    });
    
    return results;
}

- (instancetype)init {
    UICollectionViewCompositionalLayoutConfiguration *configuration = [UICollectionViewCompositionalLayoutConfiguration new];
    configuration.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionViewCompositionalLayout *collectionViewLayout = [[UICollectionViewCompositionalLayout alloc] initWithSectionProvider:^NSCollectionLayoutSection * _Nullable(NSInteger sectionIndex, id<NSCollectionLayoutEnvironment>  _Nonnull layoutEnvironment) {
        NSUInteger quotient = std::floorf(layoutEnvironment.container.contentSize.width / 200.f);
        NSUInteger count = MAX(quotient, 2);
        
        NSCollectionLayoutSize *itemSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.f / count]
                                                                          heightDimension:[NSCollectionLayoutDimension fractionalHeightDimension:1.f]];
        
        NSCollectionLayoutItem *item = [NSCollectionLayoutItem itemWithLayoutSize:itemSize];
        item.contentInsets = NSDirectionalEdgeInsetsMake(10.f, 10.f, 10.f, 10.f);
        
        NSCollectionLayoutSize *groupSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.f]
                                                                           heightDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.f / count]];
        
        NSCollectionLayoutGroup *group = [NSCollectionLayoutGroup horizontalGroupWithLayoutSize:groupSize repeatingSubitem:item count:count];
        
        NSCollectionLayoutSection *section = [NSCollectionLayoutSection sectionWithGroup:group];
        section.contentInsets = NSDirectionalEdgeInsetsMake(10.f, 10.f, 10.f, 10.f);
        
        return section;
    }
                                                                                                                       configuration:configuration];
    [configuration release];
    
    self = [super initWithCollectionViewLayout:collectionViewLayout];
    [collectionViewLayout release];
    
    return self;
}

- (void)dealloc {
    [_hoverEffectCellRegistration release];
    [_customEffectCellRegistration release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _hoverEffectCellRegistration];
    [self _customEffectCellRegistration];
    self.view.backgroundColor = UIColor.systemBackgroundColor;
}

- (UICollectionViewCellRegistration *)_hoverEffectCellRegistration {
    if (auto hoverEffectCellRegistration = _hoverEffectCellRegistration) return hoverEffectCellRegistration;
    
    NSDictionary<NSString *, UIHoverStyle *> *hoverStyles = HoverViewController.hoverStyles;
    NSArray<NSString *> *sortedHoverStyleKeys = HoverViewController.sortedHoverStyleKeys;
    
    UICollectionViewCellRegistration *hoverEffectCellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:[UICollectionViewCell class] configurationHandler:^(__kindof UICollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id  _Nonnull item) {
        NSString *key = sortedHoverStyleKeys[indexPath.item];
        UIHoverStyle *hoverStyle = hoverStyles[key];
        HoverContentConfiguration *contentConfiguration = [[HoverContentConfiguration alloc] initWithTitle:key hoverStyle:hoverStyle];
        cell.contentConfiguration = contentConfiguration;
        [contentConfiguration release];
        
        cell.hoverStyle = nil;
    }];
    
    _hoverEffectCellRegistration = [hoverEffectCellRegistration retain];
    return hoverEffectCellRegistration;
}

- (UICollectionViewCellRegistration *)_customEffectCellRegistration {
    if (auto customEffectCellRegistration = _customEffectCellRegistration) return customEffectCellRegistration;
    
    UICollectionViewCellRegistration *customEffectCellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:[UICollectionViewCell class] configurationHandler:^(__kindof UICollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id  _Nonnull item) {
        CustomHoverContentConfiguration *contentConfiguration = [CustomHoverContentConfiguration new];
        cell.contentConfiguration = contentConfiguration;
        [contentConfiguration release];
    }];
    
    _customEffectCellRegistration = [customEffectCellRegistration retain];
    return customEffectCellRegistration;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return HoverViewController.hoverStyles.count + 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < HoverViewController.hoverStyles.count) {
        return [collectionView dequeueConfiguredReusableCellWithRegistration:self.hoverEffectCellRegistration forIndexPath:indexPath item:[NSNull null]];
    } else {
        return [collectionView dequeueConfiguredReusableCellWithRegistration:self.customEffectCellRegistration forIndexPath:indexPath item:[NSNull null]];
    }
}

@end
