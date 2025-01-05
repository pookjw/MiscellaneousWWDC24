//
//  TestFlightCoreDemoViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 1/5/25.
//

#import "TestFlightCoreDemoViewController.h"
#import <dlfcn.h>
#import <objc/message.h>
#import <objc/runtime.h>

/*
 ASDBetaAppLaunchInfo
 */

@interface TestFlightCoreDemoViewController ()
@property (retain, readonly, nonatomic) UICollectionViewCellRegistration *_cellRegistration;
@end

@implementation TestFlightCoreDemoViewController
@synthesize _cellRegistration = __cellRegistration;

+ (void)load {
    assert(dlopen("/System/Library/PrivateFrameworks/TestFlightCore.framework/TestFlightCore", RTLD_NOW));
}

- (instancetype)init {
    UICollectionLayoutListConfiguration *listConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearanceInsetGrouped];
    UICollectionViewCompositionalLayout *collectionViewLayout = [UICollectionViewCompositionalLayout layoutWithListConfiguration:listConfiguration];
    [listConfiguration release];
    
    if (self = [super initWithCollectionViewLayout:collectionViewLayout]) {
        
    }
    
    return self;
}

- (void)dealloc {
    [__cellRegistration release];
    [super dealloc];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    BOOL responds = [super respondsToSelector:aSelector];
    
    if (!responds) {
        NSLog(@"%s", sel_getName(aSelector));
    }
    
    return responds;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"WIP";
    [self _cellRegistration];
}

- (UICollectionViewCellRegistration *)_cellRegistration {
    if (auto cellRegistration = __cellRegistration) return cellRegistration;
    
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:UICollectionViewListCell.class configurationHandler:^(__kindof UICollectionViewListCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id  _Nonnull item) {
        UIListContentConfiguration *contentConfiguration = [cell defaultContentConfiguration];
//        NSLog(@"%@", contentConfiguration);
        
        if (indexPath.item == 0) {
            contentConfiguration.text = @"ABC";
        }
        
        cell.contentConfiguration = contentConfiguration;
        
        UICellAccessoryDisclosureIndicator *disclosureIndicator = [UICellAccessoryDisclosureIndicator new];
        cell.accessories = @[disclosureIndicator];
        [disclosureIndicator release];
    }];
    
    __cellRegistration = [cellRegistration retain];
    return cellRegistration;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueConfiguredReusableCellWithRegistration:self._cellRegistration forIndexPath:indexPath item:[NSNull null]];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0) {
        id processHandle = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("BSProcessHandle"), sel_registerName("processHandle"));
        id launchHandle = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)([objc_lookUpClass("TFBetaLaunchHandle") alloc], sel_registerName("initWithProcessHandle:"), processHandle);
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(launchHandle, sel_registerName("setActivationDelegate:"), self);
        
        NSString *bundleIdentifier = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(processHandle, sel_registerName("bundleIdentifier"));
        
        id launchInfo = [objc_lookUpClass("ASDBetaAppLaunchInfo") new];
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(launchInfo, sel_registerName("setArtistName:"), @"Leo Shimonaka");
        
//        id displayNames = reinterpret_cast<id (*)(Class, SEL, id, id)>(objc_msgSend)(objc_lookUpClass("ASDBetaAppDisplayNames"), sel_registerName("displayNameWithLocalizedNames:andPrimaryLocale:"), @[@"Display Name"], @"en_US");
//        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(launchInfo, sel_registerName("setDisplayNames:"), displayNames);
        
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(launchInfo, sel_registerName("setExpirationDate:"), [NSDate dateWithTimeIntervalSinceNow:120.]);
        reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(launchInfo, sel_registerName("setFeedbackEnabled:"), YES);
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(launchInfo, sel_registerName("setIconURLTemplate:"), @"https://is3-ssl.mzstatic.com/image/thumb/Purple128/v4/9a/bd/45/9abd45c6-445e-bf95-26b1-1a6b0addb13b/AppIcon-0-1x_U007emarketing-0-0-85-220-7.png/{w}x{h}bb.{f}");
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(launchInfo, sel_registerName("setLastWelcomeScreenViewDate:"), nil);
        reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(launchInfo, sel_registerName("setLaunchScreenEnabled:"), YES);
//        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(launchInfo, sel_registerName("setLocalizedTestNotes:"), @"Hello World!");
        reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(launchInfo, sel_registerName("setSharedFeedback:"), NO);
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(launchInfo, sel_registerName("setTesterEmail:"), @"lshimonaka@apple.com");
        
        id appVersion = reinterpret_cast<id (*)(Class, SEL, id, id, id)>(objc_msgSend)(objc_lookUpClass("ASDBetaAppVersion"), sel_registerName("versionWithBundleID:bundleVersion:andShortVersion:"), bundleIdentifier, @"1", @"1.0");
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(launchInfo, sel_registerName("setVersion:"), appVersion);
        
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(launchHandle, sel_registerName("activateForTestingWithLaunchInfo:"), launchInfo);
        [launchHandle release];
    } else if (indexPath.item == 1) {
        id launchInfo = [objc_lookUpClass("ASDBetaAppLaunchInfo") new];
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(launchInfo, sel_registerName("setArtistName:"), @"Leo Shimonaka");
        
//        id displayNames = reinterpret_cast<id (*)(Class, SEL, id, id)>(objc_msgSend)(objc_lookUpClass("ASDBetaAppDisplayNames"), sel_registerName("displayNameWithLocalizedNames:andPrimaryLocale:"), @[@"Display Name"], @"en_US");
//        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(launchInfo, sel_registerName("setDisplayNames:"), displayNames);
        
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(launchInfo, sel_registerName("setExpirationDate:"), [NSDate dateWithTimeIntervalSinceNow:120.]);
        reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(launchInfo, sel_registerName("setFeedbackEnabled:"), YES);
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(launchInfo, sel_registerName("setIconURLTemplate:"), @"https://is3-ssl.mzstatic.com/image/thumb/Purple128/v4/9a/bd/45/9abd45c6-445e-bf95-26b1-1a6b0addb13b/AppIcon-0-1x_U007emarketing-0-0-85-220-7.png/{w}x{h}bb.{f}");
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(launchInfo, sel_registerName("setLastWelcomeScreenViewDate:"), nil);
        reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(launchInfo, sel_registerName("setLaunchScreenEnabled:"), YES);
//        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(launchInfo, sel_registerName("setLocalizedTestNotes:"), @"Hello World!");
        reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(launchInfo, sel_registerName("setSharedFeedback:"), NO);
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(launchInfo, sel_registerName("setTesterEmail:"), @"lshimonaka@apple.com");
        
        id appVersion = reinterpret_cast<id (*)(Class, SEL, id, id, id)>(objc_msgSend)(objc_lookUpClass("ASDBetaAppVersion"), sel_registerName("versionWithBundleID:bundleVersion:andShortVersion:"), @"com.apple.TestFlightCoreTestApp", @"1", @"1.0");
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(launchInfo, sel_registerName("setVersion:"), appVersion);
        
        __kindof UIViewController *launchScreen = reinterpret_cast<id (*)(Class, SEL, id, id, id)>(objc_msgSend)(objc_lookUpClass("TFBetaAppLaunchScreenProvider"), sel_registerName("createBetaAppLaunchViewControllerForIdentifier:hostedIn:withSidepackLaunchInfo:"), @"com.apple.TestFlightCoreTestApp", self, launchInfo);
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:launchScreen];
        [self presentViewController:navigationController animated:YES completion:nil];
        [navigationController release];
    } else {
        abort();
    }
}

@end
