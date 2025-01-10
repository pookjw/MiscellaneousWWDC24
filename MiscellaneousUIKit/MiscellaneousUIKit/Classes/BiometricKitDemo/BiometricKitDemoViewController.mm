//
//  BiometricKitDemoViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 1/5/25.
//

#import "BiometricKitDemoViewController.h"
#import <TargetConditionals.h>
#import <dlfcn.h>
#import <objc/message.h>
#import <objc/runtime.h>

/*
 BKUIPearlEnrollController
 */

@interface BiometricKitDemoViewController ()
@property (retain, readonly, nonatomic) UICollectionViewCellRegistration *_cellRegistration;
@end

@implementation BiometricKitDemoViewController
@synthesize _cellRegistration = __cellRegistration;

+ (void)load {
    assert(dlopen("/System/Library/PrivateFrameworks/LocalAuthenticationPrivateUI.framework/LocalAuthenticationPrivateUI", RTLD_NOW) != NULL);
    assert(dlopen("/System/Library/PrivateFrameworks/OnBoardingKit.framework/OnBoardingKit", RTLD_NOW) != NULL);
#if !TARGET_OS_SIMULATOR
    assert(dlopen("/System/Library/PrivateFrameworks/BiometricKitUI.framework/BiometricKitUI", RTLD_NOW) != NULL);
#endif
    assert(dlopen("/System/Library/PrivateFrameworks/BiometricKit.framework/BiometricKit", RTLD_NOW) != NULL);
    assert(dlopen("/System/Library/PrivateFrameworks/SoftLinking.framework/SoftLinking", RTLD_NOW) != NULL);
    
    if (Protocol *BKUIPearlEnrollControllerDelegate = NSProtocolFromString(@"BKUIPearlEnrollControllerDelegate")) {
        assert(class_addProtocol(self, BKUIPearlEnrollControllerDelegate));
    }
    
    if (Protocol *BiometricKitUIEnrollResultDelegate = NSProtocolFromString(@"BiometricKitUIEnrollResultDelegate")) {
        assert(class_addProtocol(self, BiometricKitUIEnrollResultDelegate));
    }
    
    if (Protocol *BiometricKitDelegate = NSProtocolFromString(@"BiometricKitDelegate")) {
        assert(class_addProtocol(self, BiometricKitDelegate));
    }
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _cellRegistration];
    
    reinterpret_cast<void (*)(id, SEL, id, BOOL, UICollectionViewScrollPosition, BOOL, BOOL, BOOL, BOOL)>(objc_msgSend)(self.collectionView, sel_registerName("_selectItemAtIndexPath:animated:scrollPosition:notifyDelegate:deselectPrevious:performPrimaryAction:performCustomSelectionAction:"), [NSIndexPath indexPathForItem:2 inSection:0], NO, 0, YES, YES, NO, NO);
}

- (UICollectionViewCellRegistration *)_cellRegistration {
    if (auto cellRegistration = __cellRegistration) return cellRegistration;
    
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:UICollectionViewListCell.class configurationHandler:^(__kindof UICollectionViewListCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id  _Nonnull item) {
        UIListContentConfiguration *contentConfiguration = [cell defaultContentConfiguration];
//        NSLog(@"%@", contentConfiguration);
        
        if (indexPath.item == 0) {
            contentConfiguration.text = @"-preloadWithCompletion:";
        } else if (indexPath.item == 1) {
            contentConfiguration.text = @"Buddy (with -preloadWithCompletion:)";
        } else if (indexPath.item == 2) {
            contentConfiguration.text = @"MESA Automation";
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
    return 3;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueConfiguredReusableCellWithRegistration:self._cellRegistration forIndexPath:indexPath item:[NSNull null]];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0) {
        reinterpret_cast<void (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("BKUIPearlEnrollController"), sel_registerName("preloadWithCompletion:"), ^(id state){
            NSLog(@"%@", state);
        });
    } else if (indexPath.item == 1) {
        reinterpret_cast<void (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("BKUIPearlEnrollController"), sel_registerName("preloadWithCompletion:"), ^(id state){
            dispatch_async(dispatch_get_main_queue(), ^{
                __kindof UIViewController *viewController = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("BKUIPearlEnrollController") alloc], sel_registerName("initWithPreloadedState:"), state);
                reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(viewController, sel_registerName("setDelegate:"), self);
                [self.navigationController pushViewController:viewController animated:YES];
                [viewController release];
            });
        });
    } else if (indexPath.item == 2) {
        id biometricKitUI = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("BiometricKitUI"), sel_registerName("sharedInstance"));
        __kindof UIViewController *enrollUIViewController = reinterpret_cast<id (*)(id, SEL, int, id)>(objc_msgSend)(biometricKitUI, sel_registerName("getEnrollUIViewController:bundleName:"), 1, nil);
        
        /*
         IN_BUDDY (NSNumber BOOL)
         BMKUI_ALERT_HUD (NSNumber BOOL)
         BMKUI_HIDE_UNLOCK_MSG (NSNumber BOOL)
         BMKUI_DISCLAIMER (NSNumber BOOL)
         LACE_FINGER_STRING (NSString)
         PLACE_FINGER_STRING (NSString)
         LONG_COMPLETION (NSNumber BOOL)
         FOLLOW_UP_ENROLLMENT (NSNumber BOOL)
         */
        reinterpret_cast<void (*)(id, SEL, id, id)>(objc_msgSend)(enrollUIViewController, sel_registerName("setProperty:forKey:"), @(YES), @"IN_BUDDY");
        reinterpret_cast<void (*)(id, SEL, id, id)>(objc_msgSend)(enrollUIViewController, sel_registerName("setProperty:forKey:"), @(YES), @"BMKUI_ALERT_HUD");
        reinterpret_cast<void (*)(id, SEL, id, id)>(objc_msgSend)(enrollUIViewController, sel_registerName("setProperty:forKey:"), @(YES), @"BMKUI_HIDE_UNLOCK_MSG");
        reinterpret_cast<void (*)(id, SEL, id, id)>(objc_msgSend)(enrollUIViewController, sel_registerName("setProperty:forKey:"), @(YES), @"BMKUI_DISCLAIMER");
        reinterpret_cast<void (*)(id, SEL, id, id)>(objc_msgSend)(enrollUIViewController, sel_registerName("setProperty:forKey:"), @(YES), @"LONG_COMPLETION");
        reinterpret_cast<void (*)(id, SEL, id, id)>(objc_msgSend)(enrollUIViewController, sel_registerName("setProperty:forKey:"), @(YES), @"FOLLOW_UP_ENROLLMENT");
        
        id biometricKit = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("BiometricKit"), sel_registerName("manager"));
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(biometricKit, sel_registerName("setDelegate:"), self);
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(enrollUIViewController, sel_registerName("setBiometricKit:"), biometricKit);
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(enrollUIViewController, sel_registerName("setDelegate:"), self);
        
        __block auto unretained = enrollUIViewController;
        UIAction *cancelAction = [UIAction actionWithTitle:@"Cancel" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            [unretained.navigationController popViewControllerAnimated:YES];
        }];
        UIAction *releaseAction = [UIAction actionWithTitle:@"Release" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(unretained, sel_registerName("statusMessage:"), 0x40);
        }];
        UIAction *holdAction = [UIAction actionWithTitle:@"Hold" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(unretained, sel_registerName("statusMessage:"), 0x49);
        }];
        UIBarButtonItem *menuBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" menu:[UIMenu menuWithChildren:@[cancelAction, releaseAction, holdAction]]];
        enrollUIViewController.navigationItem.leftBarButtonItem = menuBarButtonItem;
        [menuBarButtonItem release];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_didTriggerTapGestureRecognizerForEnrollController:)];
        [enrollUIViewController.view addGestureRecognizer:tapGestureRecognizer];
        [tapGestureRecognizer release];
        
        [self.navigationController pushViewController:enrollUIViewController animated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(enrollUIViewController, sel_registerName("_showDirtOnSensorAlertView"));
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            reinterpret_cast<void (*)(id, SEL, int, id)>(objc_msgSend)(enrollUIViewController, sel_registerName("_failEnrollment:withMessage:"), 0x2, @"FAILED");
        });
    }
}

- (void)pearlEnrollController:(__kindof UIViewController *)pearlEnrollController finishedEnrollWithError:(NSError * _Nullable)error {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)enrollResult:(int)result bkIdentity:(id)arg2 {
    
}

- (void)generateAuthToken {
    
}

- (void)enrollResult:(int)result identity:(id)arg2 {
    
}

- (void)_didTriggerTapGestureRecognizerForEnrollController:(UITapGestureRecognizer *)sender {
    // BKUIFingerprintEnrollViewController
    __kindof UIViewController *enrollUIViewController = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(sender.view, sel_registerName("_viewControllerForAncestor"));
    
//    reinterpret_cast<void (*)(id, SEL, id, id)>(objc_msgSend)(enrollUIViewController, sel_registerName("enrollOperation:finishedWithIdentity:"), nil, nil);
    reinterpret_cast<void (*)(id, SEL, id, BOOL)>(objc_msgSend)(enrollUIViewController, sel_registerName("extendEnroll:hasUpdated:"), nil, NO);
//    reinterpret_cast<void (*)(id, SEL, id, NSInteger)>(objc_msgSend)(enrollUIViewController, sel_registerName("enrollOperation:percentCompleted:"), nil, 1);
}

- (void)enrollResult:(id)arg1 {
    
}

- (void)touchIDButtonPressed:(_Bool)arg1 {
    
}

- (void)enrollUpdate:(id)arg1 {
    
}

- (void)taskResumeStatus:(int)arg1 {
    
}

- (void)enrollFeedback:(id)arg1 {
    
}

- (void)homeButtonPressed {
    
}

- (void)statusMessage:(unsigned int)arg1 {
    
}

- (void)enrollProgress:(id)arg1 {
    
}

- (void)matchResult:(id)arg1 {
    
}

- (void)matchResult:(id)arg1 withDetails:(id)arg2 {
    
}

- (void)templateUpdate:(id)arg1 withDetails:(id)arg2 {
    
}

@end
