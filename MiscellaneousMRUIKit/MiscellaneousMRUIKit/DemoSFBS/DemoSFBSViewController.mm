//
//  DemoSFBSViewController.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 8/31/24.
//

#import "DemoSFBSViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import <dlfcn.h>

// SecTaskCopyValueForEntitlement

@interface DemoSFBSViewController ()
@property (retain, readonly, nonatomic) UICollectionViewCellRegistration *cellRegistration;
@property (retain, readonly, nonatomic) UICollectionViewSupplementaryRegistration *headerRegistration;
@property (retain, readonly, nonatomic) id immsersionService;
@property (retain, readonly, nonatomic) id sessionService;
@end

@implementation DemoSFBSViewController
@synthesize cellRegistration = _cellRegistration;
@synthesize headerRegistration = _headerRegistration;
@synthesize sessionService = _sessionService;

+ (void)load {
    assert(dlopen("/System/Library/PrivateFrameworks/SurfBoardUIServices.framework/SurfBoardUIServices", RTLD_NOW) != NULL);
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    UICollectionLayoutListConfiguration *listConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearanceInsetGrouped];
    listConfiguration.headerMode = UICollectionLayoutListHeaderModeSupplementary;
    
    UICollectionViewCompositionalLayout *collectionViewLayout = [UICollectionViewCompositionalLayout layoutWithListConfiguration:listConfiguration];
    [listConfiguration release];
    
    if (self = [super initWithCollectionViewLayout:collectionViewLayout]) {
        [self cellRegistration];
        [self headerRegistration];
        
        id immersionService = [objc_lookUpClass("SFBSImmersionService") new];
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(immersionService, sel_registerName("addImmersionUpdateObserver:"), self);
        _immsersionService = [immersionService retain];
        [immersionService release];
        
        // not working
        id sessionService = [objc_lookUpClass("SFBSSceneSessionService") new];
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(sessionService, sel_registerName("addSceneSessionObserver:"), self);
        _sessionService = [sessionService retain];
        [sessionService release];
    }
    
    return self;
}

- (void)dealloc {
    [_cellRegistration release];
    [_headerRegistration release];
    [_immsersionService release];
    [_sessionService release];
    [super dealloc];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    BOOL responds = [super respondsToSelector:aSelector];
    
    if (!responds) {
        NSLog(@"%s", sel_getName(aSelector));
    }
    
    return responds;
}

- (UICollectionViewCellRegistration *)cellRegistration {
    if (auto cellRegistration = _cellRegistration) return cellRegistration;
    
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:UICollectionViewListCell.class configurationHandler:^(__kindof UICollectionViewListCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, NSString * _Nonnull item) {
        UIListContentConfiguration *contentConfiguration = [cell defaultContentConfiguration];
        contentConfiguration.text = item;
        
        cell.contentConfiguration = contentConfiguration;
    }];
    
    _cellRegistration = [cellRegistration retain];
    return cellRegistration;
}

- (UICollectionViewSupplementaryRegistration *)headerRegistration {
    if (auto headerRegistration = _headerRegistration) return headerRegistration;
    
    NSArray<Class> *serviceClasses = [self serviceClasses];
    
    UICollectionViewSupplementaryRegistration *headerRegistration = [UICollectionViewSupplementaryRegistration registrationWithSupplementaryClass:UICollectionViewListCell.class elementKind:UICollectionElementKindSectionHeader configurationHandler:^(__kindof UICollectionViewListCell * _Nonnull supplementaryView, NSString * _Nonnull elementKind, NSIndexPath * _Nonnull indexPath) {
        UIListContentConfiguration *contentConfiguration = [supplementaryView defaultContentConfiguration];
        contentConfiguration.text = NSStringFromClass(serviceClasses[indexPath.section]);
        supplementaryView.contentConfiguration = contentConfiguration;
    }];
    
    _headerRegistration = [headerRegistration retain];
    return headerRegistration;
}

- (NSArray<Class> *)serviceClasses {
    return @[
        objc_lookUpClass("SFBSApplicationService"),
        objc_lookUpClass("SFBSLockScreenService"),
        objc_lookUpClass("SFBSShutdownService"),
        objc_lookUpClass("SFBSHUDControlService"),
        objc_lookUpClass("SFBSEntityInteractionService"),
        objc_lookUpClass("SFBSSceneUnderstandingService"),
        objc_lookUpClass("SFBSImmersionService"),
        objc_lookUpClass("SFBSDeviceResetService"),
        objc_lookUpClass("SFBSDebugService"),
        objc_lookUpClass("SFBSLauncherService"),
        objc_lookUpClass("SFBSPlacementService")
    ];
}

- (NSArray<NSString *> *)selectorNamesForServiceClass:(Class)serviceClass {
    if (serviceClass == objc_lookUpClass("SFBSPlacementService")) {
        return @[
            @"repositionSceneWithIdentifier:placementPosition:animationSettings:completion:"
        ];
    } else if (serviceClass == objc_lookUpClass("SFBSLauncherService")) {
        return @[
            @"showLauncherWithCompletion:"
        ];
    } else if (serviceClass == objc_lookUpClass("SFBSDebugService")) {
        return @[
            @"setOcclusionMeshVisible:withCompletion:",
            @"setImmersiveViewboxVisible:withCompletion:",
            @"setImmersiveRoomExtentsVisible:withCompletion:",
            @"setFrameProfilerVisible:withCompletion:",
            @"setBoundsVisible:withCompletion:",
            @"setCursorVisible:withCompletion:",
            @"setEventSynthesisVisible:withCompletion:",
            @"setCollisionShapesVisible:withCompletion:",
            @"setSurfaceSnappingVisible:withCompletion:",
            @"setSurfacesVisible:withCompletion:",
            @"setAcousticMeshVisualizationEnabled:withCompletion:",
            @"setAnchorVisualizationEnabled:withCompletion:",
            @"setEnvProbeVisualizationEnabled:withCompletion:",
            @"setProfilerServiceProcessorEnabled:forProcessorType:withCompletion:"
        ];
    } else if (serviceClass == objc_lookUpClass("SFBSDeviceResetService")) {
        return @[
            @"resetDataPartitionWithReason:completion:"
        ];
    } else if (serviceClass == objc_lookUpClass("SFBSImmersionService")) {
        return @[
            @"setImmersionLevel:bundleIdentifier:animationDuration:completion:"
        ];
    } else if (serviceClass == objc_lookUpClass("SFBSSceneUnderstandingService")) {
        return @[
            @"saveSceneToFile:withCompletion:"
        ];
    } else if (serviceClass == objc_lookUpClass("SFBSEntityInteractionService")) {
        return @[
            @"requestEntityInteractionObserverWithFlags:error:"
        ];
    } else if (serviceClass == objc_lookUpClass("SFBSHUDControlService")) {
        return @[
            @"setUpwardsIndicatorVisible:"
        ];
    } else if (serviceClass == objc_lookUpClass("SFBSShutdownService")) {
        return @[
            @"presentShutdownUIWithCompletion:",
            @"requestShutdownWithReason:completion:"
        ];
    } else if (serviceClass == objc_lookUpClass("SFBSLockScreenService")) {
        return @[
            @"lockWithRequest:completion:"
        ];
    } else if (serviceClass == objc_lookUpClass("SFBSApplicationService")) {
        return @[
            @"startGuidedAccessForApplicationBundleIdentifiers:availableSystemApplications:completion:",
            @"endGuidedAccess",
            @"setUserInterfaceDistance:forSceneWithID:completion:",
            @"setVisualDepthEnabled:",
            @"setForceQuitMenuVisible:completion:",
            @"setRingerMuted:completion:",
            @"setWindowZoomEnabled:completion:"
        ];
    } else {
        abort();
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self serviceClasses].count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self selectorNamesForServiceClass:[self serviceClasses][section]].count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *selectorString = [self selectorNamesForServiceClass:[self serviceClasses][indexPath.section]][indexPath.item];
    return [collectionView dequeueConfiguredReusableCellWithRegistration:_cellRegistration forIndexPath:indexPath item:selectorString];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        return [collectionView dequeueConfiguredReusableSupplementaryViewWithRegistration:_headerRegistration forIndexPath:indexPath];
    } else {
        abort();
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    Class serviceClass = [self serviceClasses][indexPath.section];
    NSString *selectorString = [self selectorNamesForServiceClass:[self serviceClasses][indexPath.section]][indexPath.item];
    
    if (serviceClass == objc_lookUpClass("SFBSPlacementService")) {
        if ([selectorString isEqualToString:@"repositionSceneWithIdentifier:placementPosition:animationSettings:completion:"]) {
            id service = [objc_lookUpClass("SFBSPlacementService") new];
            
            id fbsScene = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self.view.window.windowScene, sel_registerName("_scene"));
            NSString *identifier = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(fbsScene, sel_registerName("identifier"));
            
            id animationSettings = reinterpret_cast<id (*)(Class, SEL, CGFloat)>(objc_msgSend)(objc_lookUpClass("BSAnimationSettings"), sel_registerName("settingsWithDuration:"), 1.f);
            
            reinterpret_cast<void (*)(id, SEL, id, id, id, id)>(objc_msgSend)(service, sel_registerName("repositionSceneWithIdentifier:placementPosition:animationSettings:completion:"), identifier, nil, animationSettings, ^(NSError * _Nullable error) {
                [service release];
                NSLog(@"%@", error);
            });
            
            return;
        }
    } else if (serviceClass == objc_lookUpClass("SFBSLauncherService")) {
        if ([selectorString isEqualToString:@"showLauncherWithCompletion:"]) {
            id service = [objc_lookUpClass("SFBSLauncherService") new];
            
            reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(service, sel_registerName("showLauncherWithCompletion:"),  ^(NSError * _Nullable error) {
                [service release];
                NSLog(@"%@", error);
            });
            
            return;
        }
    } else if (serviceClass == objc_lookUpClass("SFBSDebugService")) {
        if ([selectorString isEqualToString:@"setBoundsVisible:withCompletion:"]) {
            id service = [objc_lookUpClass("SFBSDebugService") new];
            
            reinterpret_cast<void (*)(id, SEL, BOOL, id)>(objc_msgSend)(service, sel_registerName("setBoundsVisible:withCompletion:"), YES,  ^(NSError * _Nullable error) {
                [service release];
                NSLog(@"%@", error);
            });
            
            return;
        } else if ([selectorString isEqualToString:@"setSurfacesVisible:withCompletion:"]) {
            id service = [objc_lookUpClass("SFBSDebugService") new];
            
            reinterpret_cast<void (*)(id, SEL, BOOL, id)>(objc_msgSend)(service, sel_registerName("setSurfacesVisible:withCompletion:"), YES,  ^(NSError * _Nullable error) {
                [service release];
                NSLog(@"%@", error);
            });
            
            return;
        } else if ([selectorString isEqualToString:@"setSurfaceSnappingVisible:withCompletion:"]) {
            id service = [objc_lookUpClass("SFBSDebugService") new];
            
            reinterpret_cast<void (*)(id, SEL, BOOL, id)>(objc_msgSend)(service, sel_registerName("setSurfaceSnappingVisible:withCompletion:"), YES,  ^(NSError * _Nullable error) {
                [service release];
                NSLog(@"%@", error);
            });
            
            return;
        } else if ([selectorString isEqualToString:@"setCollisionShapesVisible:withCompletion:"]) {
            id service = [objc_lookUpClass("SFBSDebugService") new];
            
            reinterpret_cast<void (*)(id, SEL, BOOL, id)>(objc_msgSend)(service, sel_registerName("setCollisionShapesVisible:withCompletion:"), YES,  ^(NSError * _Nullable error) {
                [service release];
                NSLog(@"%@", error);
            });
            
            return;
        } else if ([selectorString isEqualToString:@"setCursorVisible:withCompletion:"]) {
            id service = [objc_lookUpClass("SFBSDebugService") new];
            
            reinterpret_cast<void (*)(id, SEL, BOOL, id)>(objc_msgSend)(service, sel_registerName("setCursorVisible:withCompletion:"), YES,  ^(NSError * _Nullable error) {
                [service release];
                NSLog(@"%@", error);
            });
            
            return;
        } else if ([selectorString isEqualToString:@"setEventSynthesisVisible:withCompletion:"]) {
            id service = [objc_lookUpClass("SFBSDebugService") new];
            
            reinterpret_cast<void (*)(id, SEL, BOOL, id)>(objc_msgSend)(service, sel_registerName("setEventSynthesisVisible:withCompletion:"), YES,  ^(NSError * _Nullable error) {
                [service release];
                NSLog(@"%@", error);
            });
            
            return;
        } else if ([selectorString isEqualToString:@"setFrameProfilerVisible:withCompletion:"]) {
            id service = [objc_lookUpClass("SFBSDebugService") new];
            
            reinterpret_cast<void (*)(id, SEL, BOOL, id)>(objc_msgSend)(service, sel_registerName("setFrameProfilerVisible:withCompletion:"), YES,  ^(NSError * _Nullable error) {
                [service release];
                NSLog(@"%@", error);
            });
            
            return;
        } else if ([selectorString isEqualToString:@"setImmersiveRoomExtentsVisible:withCompletion:"]) {
            id service = [objc_lookUpClass("SFBSDebugService") new];
            
            reinterpret_cast<void (*)(id, SEL, BOOL, id)>(objc_msgSend)(service, sel_registerName("setImmersiveRoomExtentsVisible:withCompletion:"), YES,  ^(NSError * _Nullable error) {
                [service release];
                NSLog(@"%@", error);
            });
        } else if ([selectorString isEqualToString:@"setImmersiveViewboxVisible:withCompletion:"]) {
            id service = [objc_lookUpClass("SFBSDebugService") new];
            
            reinterpret_cast<void (*)(id, SEL, BOOL, id)>(objc_msgSend)(service, sel_registerName("setImmersiveViewboxVisible:withCompletion:"), YES,  ^(NSError * _Nullable error) {
                [service release];
                NSLog(@"%@", error);
            });
            
            return;
        } else if ([selectorString isEqualToString:@"setOcclusionMeshVisible:withCompletion:"]) {
            id service = [objc_lookUpClass("SFBSDebugService") new];
            
            reinterpret_cast<void (*)(id, SEL, BOOL, id)>(objc_msgSend)(service, sel_registerName("setOcclusionMeshVisible:withCompletion:"), YES,  ^(NSError * _Nullable error) {
                [service release];
                NSLog(@"%@", error);
            });
            
            return;
        } else if ([selectorString isEqualToString:@"setAcousticMeshVisualizationEnabled:withCompletion:"]) {
            id service = [objc_lookUpClass("SFBSDebugService") new];
            
            reinterpret_cast<void (*)(id, SEL, BOOL, id)>(objc_msgSend)(service, sel_registerName("setAcousticMeshVisualizationEnabled:withCompletion:"), YES,  ^(NSError * _Nullable error) {
                [service release];
                NSLog(@"%@", error);
            });
            
            return;
        } else if ([selectorString isEqualToString:@"setAcousticMeshVisualizationSolidStyle:withCompletion:"]) {
            id service = [objc_lookUpClass("SFBSDebugService") new];
            
            reinterpret_cast<void (*)(id, SEL, NSInteger, id)>(objc_msgSend)(service, sel_registerName("setAcousticMeshVisualizationSolidStyle:withCompletion:"), 0,  ^(NSError * _Nullable error) {
                [service release];
                NSLog(@"%@", error);
            });
            
            return;
        } else if ([selectorString isEqualToString:@"setAnchorVisualizationEnabled:withCompletion:"]) {
            id service = [objc_lookUpClass("SFBSDebugService") new];
            
            reinterpret_cast<void (*)(id, SEL, BOOL, id)>(objc_msgSend)(service, sel_registerName("setAnchorVisualizationEnabled:withCompletion:"), YES, ^(NSError * _Nullable error) {
                [service release];
                NSLog(@"%@", error);
            });
            
            return;
        } else if ([selectorString isEqualToString:@"setEnvProbeVisualizationEnabled:withCompletion:"]) {
            id service = [objc_lookUpClass("SFBSDebugService") new];
            
            reinterpret_cast<void (*)(id, SEL, BOOL, id)>(objc_msgSend)(service, sel_registerName("setEnvProbeVisualizationEnabled:withCompletion:"), YES, ^(NSError * _Nullable error) {
                [service release];
                NSLog(@"%@", error);
            });
            
            return;
        } else if ([selectorString isEqualToString:@"setProfilerServiceProcessorEnabled:forProcessorType:withCompletion:"]) {
            id service = [objc_lookUpClass("SFBSDebugService") new];
            
            reinterpret_cast<void (*)(id, SEL, BOOL, NSUInteger, id)>(objc_msgSend)(service, sel_registerName("setProfilerServiceProcessorEnabled:forProcessorType:withCompletion:"), YES, 0, ^(NSError * _Nullable error) {
                [service release];
                NSLog(@"%@", error);
            });
            
            return;
        }
    } else if (serviceClass == objc_lookUpClass("SFBSDeviceResetService")) {
        if ([selectorString isEqualToString:@"resetDataPartitionWithReason:completion:"]) {
            id service = [objc_lookUpClass("SFBSDeviceResetService") new];
            
            reinterpret_cast<void (*)(id, SEL, id, id)>(objc_msgSend)(service, sel_registerName("resetDataPartitionWithReason:completion:"), nil, ^(NSError * _Nullable error) {
                [service release];
                NSLog(@"%@", error);
            });
            
            return;
        }
    } else if (serviceClass == objc_lookUpClass("SFBSImmersionService")) {
        if ([selectorString isEqualToString:@"setImmersionLevel:bundleIdentifier:animationDuration:completion:"]) {
            id service = [objc_lookUpClass("SFBSImmersionService") new];
            
            reinterpret_cast<void (*)(id, SEL, float, id, double, id)>(objc_msgSend)(service, sel_registerName("setImmersionLevel:bundleIdentifier:animationDuration:completion:"), 0.25f, NSBundle.mainBundle.bundleIdentifier, 1.f, ^(NSError * _Nullable error) {
                [service release];
                NSLog(@"%@", error);
            });
            
            return;
        }
    } else if (serviceClass == objc_lookUpClass("SFBSSceneUnderstandingService")) {
        if ([selectorString isEqualToString:@"saveSceneToFile:withCompletion:"]) {
            id service = [objc_lookUpClass("SFBSSceneUnderstandingService") new];
            
            reinterpret_cast<void (*)(id, SEL, id, id)>(objc_msgSend)(service, sel_registerName("saveSceneToFile:withCompletion:"), [NSURL fileURLWithPath:@"/Users/pookjw/Desktop/scene.usda"], ^(NSError * _Nullable error) {
                [service release];
                NSLog(@"%@", error);
            });
            
            return;
        }
    } else if (serviceClass == objc_lookUpClass("SFBSEntityInteractionService")) {
        if ([selectorString isEqualToString:@"requestEntityInteractionObserverWithFlags:error:"]) {
            id service = [objc_lookUpClass("SFBSEntityInteractionService") new];
            
            NSError * _Nullable error = nil;
            id entityInteractionObserver = reinterpret_cast<id (*)(id, SEL, NSInteger, id *)>(objc_msgSend)(service, sel_registerName("requestEntityInteractionObserverWithFlags:error:"), 0, &error);
            assert(error == nil);
            
            NSLog(@"%@", entityInteractionObserver);
            [service release];
            
            return;
        }
    } else if (serviceClass == objc_lookUpClass("SFBSHUDControlService")) {
        if ([selectorString isEqualToString:@"setUpwardsIndicatorVisible:"]) {
            // not working
            id service = [objc_lookUpClass("SFBSHUDControlService") new];
            reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(service, sel_registerName("setUpwardsIndicatorVisible:"), YES);
            [service release];
            
            return;
        }
    } else if (serviceClass == objc_lookUpClass("SFBSShutdownService")) {
        if ([selectorString isEqualToString:@"presentShutdownUIWithCompletion:"]) {
            id service = [objc_lookUpClass("SFBSShutdownService") new];
            
            reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(service,sel_registerName("presentShutdownUIWithCompletion:"), ^(NSError * _Nullable error) {
                [service release];
                NSLog(@"%@", error);
            });
            
            return;
        } else if ([selectorString isEqualToString:@"requestShutdownWithReason:completion:"]) {
            id service = [objc_lookUpClass("SFBSShutdownService") new];
            
            reinterpret_cast<void (*)(id, SEL, id, id)>(objc_msgSend)(service,sel_registerName("requestShutdownWithReason:completion:"), nil, ^(NSError * _Nullable error) {
                [service release];
                NSLog(@"%@", error);
            });
            
            return;
        }
    } else if (serviceClass == objc_lookUpClass("SFBSLockScreenService")) {
        if ([selectorString isEqualToString:@"lockWithRequest:completion:"]) {
            id service = [objc_lookUpClass("SFBSLockScreenService") new];
            id request = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("SFBSUnlockRequest") alloc], sel_registerName("initWithReason:"), @"");
            
            reinterpret_cast<void (*)(id, SEL, id, id)>(objc_msgSend)(service,sel_registerName("lockWithRequest:completion:"), request, ^(NSError * _Nullable error) {
                [service release];
                NSLog(@"%@", error);
            });
            
            [request release];
            
            return;
        }
    } else if (serviceClass == objc_lookUpClass("SFBSApplicationService")) {
        if ([selectorString isEqualToString:@"startGuidedAccessForApplicationBundleIdentifiers:availableSystemApplications:completion:"]) {
            id service = [objc_lookUpClass("SFBSApplicationService") new];
            
            reinterpret_cast<void (*)(id, SEL, id, id, id)>(objc_msgSend)(service, sel_registerName("startGuidedAccessForApplicationBundleIdentifiers:availableSystemApplications:completion:"), @[NSBundle.mainBundle.bundleIdentifier], nil, ^(NSError * _Nullable error) {
                [service release];
                NSLog(@"%@", error);
            });
            
            return;
        } else if ([selectorString isEqualToString:@"endGuidedAccess"]) {
            id service = [objc_lookUpClass("SFBSApplicationService") new];
            
            reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(service, sel_registerName("endGuidedAccess"));
            
            [service release];
            
            return;
        } else if ([selectorString isEqualToString:@"setUserInterfaceDistance:forSceneWithID:completion:"]) {
            id service = [objc_lookUpClass("SFBSApplicationService") new];
            
            id fbsScene = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self.view.window.windowScene, sel_registerName("_scene"));
            NSString *identifier = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(fbsScene, sel_registerName("identifier"));
            
            reinterpret_cast<void (*)(id, SEL, float, id, id)>(objc_msgSend)(service, sel_registerName("setUserInterfaceDistance:forSceneWithID:completion:"), 10.f, identifier, ^(NSError * _Nullable error) {
                [service release];
                NSLog(@"%@", error);
            });
            
            return;
        } else if ([selectorString isEqualToString:@"setVisualDepthEnabled:"]) {
            id service = [objc_lookUpClass("SFBSApplicationService") new];
            
            reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(service, sel_registerName("setVisualDepthEnabled:"), YES);
            
            [service release];
            
            return;
        } else if ([selectorString isEqualToString:@"setForceQuitMenuVisible:completion:"]) {
            id service = [objc_lookUpClass("SFBSApplicationService") new];
            
            reinterpret_cast<void (*)(id, SEL, BOOL, id)>(objc_msgSend)(service, sel_registerName("setForceQuitMenuVisible:completion:"), YES, ^(NSError * _Nullable error) {
                [service release];
                NSLog(@"%@", error);
            });
            
            return;
        } else if ([selectorString isEqualToString:@"setRingerMuted:completion:"]) {
            id service = [objc_lookUpClass("SFBSApplicationService") new];
            
            reinterpret_cast<void (*)(id, SEL, BOOL, id)>(objc_msgSend)(service, sel_registerName("setRingerMuted:completion:"), YES, ^(NSError * _Nullable error) {
                [service release];
                NSLog(@"%@", error);
            });
            
            return;
        } else if ([selectorString isEqualToString:@"setWindowZoomEnabled:completion:"]) {
            id service = [objc_lookUpClass("SFBSApplicationService") new];
            
            reinterpret_cast<void (*)(id, SEL, BOOL, id)>(objc_msgSend)(service, sel_registerName("setWindowZoomEnabled:completion:"), YES, ^(NSError * _Nullable error) {
                [service release];
                NSLog(@"%@", error);
            });
            
            return;
        }
    }
    
    abort();
}

- (void)updatedFocusedImmersionProcessWithBundleID:(NSString *)bundleID immersionLevel:(float)immersionLevel targetImmersionLevel:(float)targetImmersionLevel {
    NSLog(@"%lf", immersionLevel);
}

@end
