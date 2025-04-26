//
//  CollectionViewController.mm
//  MyScreenTimeObjC
//
//  Created by Jinwoo Kim on 4/23/25.
//

#import "CollectionViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "Swizzler.h"
#import "SelectionDataSource.h"
#import "TokenContentConfiguration.h"
#include <dlfcn.h>

/*
 _TtC14DeviceActivity28DeviceActivityMonitorContext
 */

@interface CollectionViewController ()
@property (retain, nonatomic, readonly, getter=_cellRegistration) UICollectionViewCellRegistration *cellRegistration;
@property (retain, nonatomic, readonly, getter=_tokenCellRegistration) UICollectionViewCellRegistration *tokenCellRegistration;
@property (retain, nonatomic, readonly, getter=_headerRegistration) UICollectionViewSupplementaryRegistration *headerRegistration;
@property (retain, nonatomic, readonly, getter=_menuBarButtonItem) UIBarButtonItem *menuBarButtonItem;
@property (retain, nonatomic, readonly, getter=_familyControlsConnection) NSXPCConnection *familyControlsConnection;
@property (retain, nonatomic, readonly, getter=_managedSettingsConnection) NSXPCConnection *managedSettingsConnection;
@property (retain, nonatomic, readonly, getter=_usageTrackingConnection) NSXPCConnection *usageTrackingConnection;
@property (retain, nonatomic, readonly, getter=_pickerRemoteTokens) NSMutableSet<NSUUID *> *pickerRemoteTokens;
@property (retain, nonatomic, getter=_selections, setter=_setSelections:) SelectionDataSource *selections;
@property (copy, nonatomic, getter=_storeValues, setter=_setStoreValues:) NSDictionary *storeValues;
@end

@implementation CollectionViewController
@synthesize cellRegistration = _cellRegistration;
@synthesize tokenCellRegistration = _tokenCellRegistration;
@synthesize headerRegistration = _headerRegistration;
@synthesize menuBarButtonItem = _menuBarButtonItem;

+ (void)load {
    assert(dlopen("/System/Library/Frameworks/_DeviceActivity_SwiftUI.framework/_DeviceActivity_SwiftUI", RTLD_NOW) != NULL);
    
    if (Protocol *EXHostViewControllerDelegate = NSProtocolFromString(@"EXHostViewControllerDelegate")) {
        assert(class_addProtocol([CollectionViewController class], EXHostViewControllerDelegate));
    } else {
        abort();
    }
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    UICollectionLayoutListConfiguration *listConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearanceInsetGrouped];
    listConfiguration.headerMode = UICollectionLayoutListHeaderModeSupplementary;
    UICollectionViewCompositionalLayout *collectionViewLayout = [UICollectionViewCompositionalLayout layoutWithListConfiguration:listConfiguration];
    [listConfiguration release];
    
    if (self = [super initWithCollectionViewLayout:collectionViewLayout]) {
        _pickerRemoteTokens = [NSMutableSet new];
        _selections = [[SelectionDataSource selectionFromSavedData] retain];
        if (_selections == nil) {
            _selections = [SelectionDataSource new];
        }
        
        _familyControlsConnection = reinterpret_cast<id (*)(id, SEL, id, NSXPCConnectionOptions)>(objc_msgSend)([NSXPCConnection alloc], sel_registerName("initWithMachServiceName:options:"), @"com.apple.FamilyControlsAgent", NSXPCConnectionPrivileged);
        NSXPCInterface *remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:NSProtocolFromString(@"_TtP14FamilyControls19FamilyControlsAgent_")];
        [remoteObjectInterface setClasses:[NSSet setWithObject:objc_lookUpClass("UISSlotStyle")] forSelector:sel_registerName("getRemoteContentForActivitySlotWithSlotID:slotStyle:slotType:tokenToPresent:tokenType::") argumentIndex:1 ofReply:NO];
        [remoteObjectInterface setClasses:[NSSet setWithObject:objc_lookUpClass("UISSlotRemoteContent")] forSelector:sel_registerName("getRemoteContentForActivitySlotWithSlotID:slotStyle:slotType:tokenToPresent:tokenType::") argumentIndex:0 ofReply:YES];
        _familyControlsConnection.remoteObjectInterface = remoteObjectInterface;
        _familyControlsConnection.interruptionHandler = ^{
//            abort();
        };
        [_familyControlsConnection resume];
        
        _managedSettingsConnection = reinterpret_cast<id (*)(id, SEL, id, NSXPCConnectionOptions)>(objc_msgSend)([NSXPCConnection alloc], sel_registerName("initWithMachServiceName:options:"), @"com.apple.ManagedSettingsAgent", NSXPCConnectionPrivileged);
        _managedSettingsConnection.remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:NSProtocolFromString(@"_TtP15ManagedSettings20ManagedSettingsAgent_")];
        _managedSettingsConnection.interruptionHandler = ^{
            abort();
        };
        [_managedSettingsConnection resume];
        
        // TODO: 직접 NSXPCConnection을 생성하고 싶다면 -[NSXPCInterface setClasses:forSelector:argumentIndex:ofReply:] 정의 필요함
//        _usageTrackingConnection = reinterpret_cast<id (*)(id, SEL, id, NSXPCConnectionOptions)>(objc_msgSend)([NSXPCConnection alloc], sel_registerName("initWithMachServiceName:options:"), @"com.apple.UsageTrackingAgent", NSXPCConnectionPrivileged);
//        _usageTrackingConnection.remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:NSProtocolFromString(@"USUsageTrackingAgent")];
        _usageTrackingConnection = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("USTrackingAgentConnection"), sel_registerName("newConnection"));
        _usageTrackingConnection.interruptionHandler = ^{
            abort();
        };
        [_usageTrackingConnection resume];
        
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_pickerDidCancel:) name:MT_ActivityPickerRemoteViewControllerDidCancelNotificationName object:nil];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_pickerDidFinish:) name:MT_ActivityPickerRemoteViewControllerDidFinishSelectionNotificationName object:nil];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_pickerDidChangeSelection:) name:MT_ActivityPickerRemoteViewControllerDidChangeSelectionNotificationName object:nil];
    }
    
    return self;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
    [_cellRegistration release];
    [_tokenCellRegistration release];
    [_headerRegistration release];
    [_menuBarButtonItem release];
    [_familyControlsConnection invalidate];
    [_familyControlsConnection release];
    [_managedSettingsConnection invalidate];
    [_managedSettingsConnection release];
    [_usageTrackingConnection invalidate];
    [_usageTrackingConnection release];
    [_pickerRemoteTokens release];
    [_selections release];
    [_storeValues release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.menuBarButtonItem;
    [self _cellRegistration];
    [self _tokenCellRegistration];
    [self _headerRegistration];
    
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    [refreshControl addTarget:self action:@selector(_refreshControlDidTrigger:) forControlEvents:UIControlEventValueChanged];
    self.collectionView.refreshControl = refreshControl;
    [refreshControl release];
    
    [self _reloadWithCompletionHandler:nil];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 6;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.selections.applications.count;
    } else if (section == 1) {
        return self.selections.categories.count;
    } else if (section == 2) {
        return self.selections.webDomains.count;
    } else if (section == 3) {
        return self.selections.untokenizedApplications.count;
    } else if (section == 4) {
        return self.selections.untokenizedCategories.count;
    } else if (section == 5) {
        return self.selections.untokenizedWebDomains.count;
    } else {
        abort();
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray<NSData *> *tokens;
    UICollectionViewCellRegistration *cellRegistration;
    NSInteger tokenType;
    if (indexPath.section == 0) {
        tokens = self.selections.applications;
        cellRegistration = self.tokenCellRegistration;
        tokenType = 0;
    } else if (indexPath.section == 1) {
        tokens = self.selections.categories;
        cellRegistration = self.tokenCellRegistration;
        tokenType = 2;
    } else if (indexPath.section == 2) {
        tokens = self.selections.webDomains;
        cellRegistration = self.tokenCellRegistration;
        tokenType = 1;
    } else if (indexPath.section == 3) {
        tokens = self.selections.untokenizedApplications;
        cellRegistration = self.cellRegistration;
        tokenType = 0;
    } else if (indexPath.section == 4) {
        tokens = self.selections.untokenizedCategories;
        cellRegistration = self.cellRegistration;
        tokenType = 2;
    } else if (indexPath.section == 5) {
        tokens = self.selections.untokenizedWebDomains;
        cellRegistration = self.cellRegistration;
        tokenType = 1;
    } else {
        abort();
    }
    
    NSData *token = tokens[indexPath.item];
    NSNumber * _Nullable isSelected = nil;
    for (NSArray *array in self.storeValues.allValues) {
        for (NSDictionary *dictionary in array) {
            NSData *_token = dictionary[@"token"][@"data"];
            if ([_token isEqualToData:token]) {
                isSelected = @YES;
                break;
            }
        }
        
        if (isSelected != nil) break;
    }
    if (isSelected == nil) isSelected = @NO;
    
    return [collectionView dequeueConfiguredReusableCellWithRegistration:cellRegistration forIndexPath:indexPath item:@{@"token": token, @"isSelected": isSelected, @"tokenType": @(tokenType)}];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueConfiguredReusableSupplementaryViewWithRegistration:_headerRegistration forIndexPath:indexPath];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (UICollectionViewCellRegistration *)_cellRegistration {
    if (auto cellRegistration = _cellRegistration) return cellRegistration;
    
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:[UICollectionViewListCell class] configurationHandler:^(UICollectionViewListCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, NSDictionary * _Nonnull item) {
        NSData *token = item[@"token"];
        
        UIListContentConfiguration *contentConfiguration = [cell defaultContentConfiguration];
        contentConfiguration.text = [NSString stringWithFormat:@"%lu bytes", static_cast<unsigned long>(token.length)];
        cell.contentConfiguration = contentConfiguration;
        
        NSNumber *isSelected = item[@"isSelected"];
        if (isSelected.boolValue) {
            UICellAccessoryCheckmark *accessory = [UICellAccessoryCheckmark new];
            cell.accessories = @[accessory];
            [accessory release];
        } else {
            cell.accessories = @[];
        }
    }];
    
    _cellRegistration = [cellRegistration retain];
    return cellRegistration;
}

- (UICollectionViewCellRegistration *)_tokenCellRegistration {
    if (auto tokenCellRegistration = _tokenCellRegistration) return tokenCellRegistration;
    
    UICollectionViewCellRegistration *tokenCellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:[UICollectionViewListCell class] configurationHandler:^(UICollectionViewListCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id  _Nonnull item) {
        NSData *token = item[@"token"];
        NSNumber *tokenType = item[@"tokenType"];
        
        TokenContentConfiguration *contentConfiguration = [[TokenContentConfiguration alloc] initWithApplicationToken:token tokenType:tokenType.integerValue];
        cell.contentConfiguration = contentConfiguration;
        [contentConfiguration release];
        
        NSNumber *isSelected = item[@"isSelected"];
        if (isSelected.boolValue) {
            UICellAccessoryCheckmark *accessory = [UICellAccessoryCheckmark new];
            cell.accessories = @[accessory];
            [accessory release];
        } else {
            cell.accessories = @[];
        }
    }];
    
    _tokenCellRegistration = [tokenCellRegistration retain];
    return tokenCellRegistration;
}

- (UICollectionViewSupplementaryRegistration *)_headerRegistration {
    if (auto headerRegistration = _headerRegistration) return headerRegistration;
    
    UICollectionViewSupplementaryRegistration *headerRegistration = [UICollectionViewSupplementaryRegistration registrationWithSupplementaryClass:[UICollectionViewListCell class] elementKind:UICollectionElementKindSectionHeader configurationHandler:^(UICollectionViewListCell * _Nonnull supplementaryView, NSString * _Nonnull elementKind, NSIndexPath * _Nonnull indexPath) {
        UIListContentConfiguration *contentConfiguration = [supplementaryView defaultContentConfiguration];
        
        if (indexPath.section == 0) {
            contentConfiguration.text = @"Applications";
        } else if (indexPath.section == 1) {
            contentConfiguration.text = @"Categories";
        } else if (indexPath.section == 2) {
            contentConfiguration.text = @"Web Domains";
        } else if (indexPath.section == 3) {
            contentConfiguration.text = @"Untokenized Applications";
        } else if (indexPath.section == 4) {
            contentConfiguration.text = @"Untokenized Categories";
        } else if (indexPath.section == 5) {
            contentConfiguration.text = @"Untokenized Web Domains";
        } else {
            abort();
        }
        
        supplementaryView.contentConfiguration = contentConfiguration;
    }];
    
    _headerRegistration = [headerRegistration retain];
    return headerRegistration;
}

- (UIBarButtonItem *)_menuBarButtonItem {
    if (auto menuBarButtonItem = _menuBarButtonItem) return menuBarButtonItem;
    
    UIBarButtonItem *menuBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"apple.intelligence"] menu:[self _makeMenu]];
    
    _menuBarButtonItem = menuBarButtonItem;
    return menuBarButtonItem;
}

- (UIMenu *)_makeMenu {
    NSXPCConnection *familyControlsConnection = _familyControlsConnection;
    NSXPCConnection *managedSettingsConnection = _managedSettingsConnection;
    NSXPCConnection *usageTrackingConnection = _usageTrackingConnection;
    __weak auto weakSelf = self;
    
    /*
     blockedByFilter
     // all
     {
         "webContent.blockedByFilter" =     {
             onlyAllow =         (
                             {
                     token =                 {
                         data = {length = 128, bytes = 0x00000000 00000000 00000000 ead504fe ... 60be7a02 815a6e33 };
                     };
                 },
                             {
                     token =                 {
                         data = {length = 128, bytes = 0x00000000 00000000 00000000 ead504fe ... 88c5963a f7f74fba };
                     };
                 },
                             {
                     token =                 {
                         data = {length = 128, bytes = 0x00000000 00000000 00000000 ead504fe ... 0dd31a92 57c2632a };
                     };
                 }
             );
         };
     }
     
     // auto
     {
         "webContent.blockedByFilter" =     {
             autoAllow =         (
                             {
                     token =                 {
                         data = {length = 128, bytes = 0x00000000 00000000 00000000 ead504fe ... 60be7a02 815a6e33 };
                     };
                 }
             );
             neverAllow =         (
                             {
                     token =                 {
                         data = {length = 128, bytes = 0x00000000 00000000 00000000 ead504fe ... 0dd31a92 57c2632a };
                     };
                 }
             );
         };
     }
     
     // specific
     {
         "webContent.blockedByFilter" =     {
             neverAllow =         (
                             {
                     token =                 {
                         data = {length = 128, bytes = 0x00000000 00000000 00000000 ead504fe ... 88c5963a f7f74fba };
                     };
                 },
                             {
                     token =                 {
                         data = {length = 128, bytes = 0x00000000 00000000 00000000 ead504fe ... 0dd31a92 57c2632a };
                     };
                 },
                             {
                     token =                 {
                         data = {length = 128, bytes = 0x00000000 00000000 00000000 ead504fe ... 60be7a02 815a6e33 };
                     };
                 }
             );
         };
     }
     */
     
    NSArray<NSString *> *boolKeys = @[
        @"account.lockAccounts",
        @"cellular.lockAppCellularData",
        @"cellular.lockCellularPlan",
        @"cellular.lockESIM",
        @"dateAndTime.requireAutomaticDateAndTime",
        @"passcode.lockPasscode",
        @"siri.denySiri",
        @"appStore.denyInAppPurchases",
        @"appStore.requirePasswordForPurchases",
        @"application.denyAppInstallation",
        @"application.denyAppRemoval",
        @"gameCenter.denyMultiplayerGaming",
        @"gameCenter.denyAddingFriends",
        @"media.denyExplicitContent",
        @"media.denyMusicService",
        @"media.denyBookstoreErotica",
        @"safari.denyAutoFill"
    ];
    
    NSArray<NSString *> *allKeys = [boolKeys arrayByAddingObjectsFromArray:@[
        @"appStore.maximumRating",
        @"media.maximumMovieRating",
        @"media.maximumTVShowRating",
        @"application.blockedApplications",
        @"safari.cookiePolicy",
        @"shield.applications"
    ]];
    
    UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(familyControlsConnection.remoteObjectProxy, sel_registerName("getAuthorizationStatus:"), ^(NSNumber * _Nullable authorizedStatus, NSError * _Nullable error) {
            assert(error == nil);
            
            NSUUID * _Nullable recordIdentifier;
            if (NSString *recordIdentifierString = [NSUserDefaults.standardUserDefaults stringForKey:@"recordIdentifier"]) {
                recordIdentifier = [[NSUUID alloc] initWithUUIDString:recordIdentifierString];
            } else {
                recordIdentifier = nil;
            }
            
            reinterpret_cast<void (*)(id, SEL, id, id, id, id, id)>(objc_msgSend)(managedSettingsConnection.remoteObjectProxy, sel_registerName("getValuesForSettingNames:recordIdentifier:storeContainer:storeName:replyHandler:"), allKeys, recordIdentifier, @"com.pookjw.MyScreenTimeObjC", @"Test", ^(NSDictionary * _Nullable storeValues, NSError * _Nullable error) {
                assert(error == nil);
                NSMutableArray<__kindof UIMenuElement *> *children = [NSMutableArray new];
                
                {
                    NSMutableArray<__kindof UIMenuElement *> *children_2 = [NSMutableArray new];
                    
                    {
                        UIAction *action_1 = [UIAction actionWithTitle:@"ActivityPickerRemoteViewController (Embedded)" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                            [weakSelf _showSelectionPickerWithEmbedded:YES];
                        }];
                        [children_2 addObject:action_1];
                        UIAction *action_2 = [UIAction actionWithTitle:@"ActivityPickerRemoteViewController" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                            [weakSelf _showSelectionPickerWithEmbedded:NO];
                        }];
                        [children_2 addObject:action_2];
                    }
                    
                    {
                        if (authorizedStatus.integerValue == 0) {
                            UIAction *action = [UIAction actionWithTitle:@"Request Authorization" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                                //                        id center = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("FOAuthorizationCenter"), sel_registerName("sharedCenter"));
                                //                        reinterpret_cast<void (*)(id, SEL, NSInteger, id)>(objc_msgSend)(center, sel_registerName("requestInternalAuthorizationForMember:completionHandler:"), 1, nil);
                                reinterpret_cast<void (*)(id, SEL, NSInteger, id)>(objc_msgSend)(familyControlsConnection.remoteObjectProxy, sel_registerName("requestAuthorizationFor::"), 1, ^(NSNumber * _Nullable result, NSError * _Nullable error) {
                                    assert(error == nil);
                                });
                            }];
                            [children_2 addObject:action];
                        } else {
                            UIAction *action = [UIAction actionWithTitle:@"Revoke Authorization" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                                reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(familyControlsConnection.remoteObjectProxy, sel_registerName("revokeAuthorization:"), ^(NSNumber * _Nullable what, NSError * _Nullable error) {
                                    assert(error == nil);
                                });
                            }];
                            [children_2 addObject:action];
                        }
                    }
                    
                    UIMenu *menu = [UIMenu menuWithTitle:@"Family Controls" children:children_2];
                    [children_2 release];
                    [children addObject:menu];
                }
                
                {
                    NSMutableArray<__kindof UIMenuElement *> *children_2 = [NSMutableArray new];
                    
                    {
                        UIAction *action = [UIAction actionWithTitle:@"Shield All Applications" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                            NSArray<NSData *> *applications = weakSelf.selections.applications;
                            NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:applications.count];
                            for (NSData *data in applications) {
                                [array addObject:@{@"token": @{@"data": data}}];
                            }
                            
                            reinterpret_cast<void (*)(id, SEL, id, id, id, id, id)>(objc_msgSend)(managedSettingsConnection.remoteObjectProxy, sel_registerName("setValues:recordIdentifier:storeContainer:storeName:replyHandler:"), @{
                                @"shield.applications": array
                            }, nil, @"com.pookjw.MyScreenTimeObjC", @"Test", ^(NSUUID * _Nullable recordIdentifier, NSError * _Nullable error) {
                                assert(error == nil);
                                [NSUserDefaults.standardUserDefaults setValue:recordIdentifier.UUIDString forKey:@"recordIdentifier"];
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [weakSelf _reloadWithCompletionHandler:nil];
                                });
                            });
                            
                            [array release];
                        }];
                        [children_2 addObject:action];
                    }
                    
                    {
                        UIAction *action = [UIAction actionWithTitle:@"Block All Applications" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                            NSArray<NSData *> *applications = weakSelf.selections.applications;
                            NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:applications.count];
                            for (NSData *data in applications) {
                                [array addObject:@{@"token": @{@"data": data}}];
                            }
                            
                            reinterpret_cast<void (*)(id, SEL, id, id, id, id, id)>(objc_msgSend)(managedSettingsConnection.remoteObjectProxy, sel_registerName("setValues:recordIdentifier:storeContainer:storeName:replyHandler:"), @{
                                @"application.blockedApplications": array
                            }, nil, @"com.pookjw.MyScreenTimeObjC", @"Test", ^(NSUUID * _Nullable recordIdentifier, NSError * _Nullable error) {
                                assert(error == nil);
                                [NSUserDefaults.standardUserDefaults setValue:recordIdentifier.UUIDString forKey:@"recordIdentifier"];
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [weakSelf _reloadWithCompletionHandler:nil];
                                });
                            });
                            
                            [array release];
                        }];
                        [children_2 addObject:action];
                    }
                    
                    {
                        NSMutableArray<__kindof UIMenuElement *> *children_3 = [NSMutableArray new];
                        
                        for (NSString *key in boolKeys) {
                            BOOL value = static_cast<NSNumber *>(storeValues[key]).boolValue;
                            
                            UIAction *action = [UIAction actionWithTitle:key image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                                reinterpret_cast<void (*)(id, SEL, id, id, id, id, id)>(objc_msgSend)(managedSettingsConnection.remoteObjectProxy, sel_registerName("setValues:recordIdentifier:storeContainer:storeName:replyHandler:"), @{
                                    key: @(!value)
                                }, nil, @"com.pookjw.MyScreenTimeObjC", @"Test", ^(NSUUID * _Nullable recordIdentifier, NSError * _Nullable error) {
                                    assert(error == nil);
                                    [NSUserDefaults.standardUserDefaults setValue:recordIdentifier.UUIDString forKey:@"recordIdentifier"];
                                });
                            }];
                            action.state = value ? UIMenuElementStateOn : UIMenuElementStateOff;
                            [children_3 addObject:action];
                        }
                        
                        UIMenu *menu = [UIMenu menuWithTitle:@"" image:nil identifier:nil options:UIMenuOptionsDisplayInline children:children_3];
                        [children_3 release];
                        [children_2 addObject:menu];
                    }
                    
                    {
                        auto value = static_cast<NSNumber *>(storeValues[@"appStore.maximumRating"]);
                        NSMutableArray<__kindof UIMenuElement *> *children_3 = [NSMutableArray new];
                        NSDictionary *ratingsKeyTitles = @{
                            @0: @"None", @100: @"4+", @200: @"9+", @300: @"12+", @600: @"17+", @1000: @"All"
                        };
                        NSArray *sortedKeys = [ratingsKeyTitles.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSNumber * _Nonnull obj1, NSNumber * _Nonnull obj2) {
                            return [obj1 compare:obj2];
                        }];
                        
                        for (NSNumber *rating in sortedKeys) {
                            UIAction *action = [UIAction actionWithTitle:ratingsKeyTitles[rating] image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                                reinterpret_cast<void (*)(id, SEL, id, id, id, id, id)>(objc_msgSend)(managedSettingsConnection.remoteObjectProxy, sel_registerName("setValues:recordIdentifier:storeContainer:storeName:replyHandler:"), @{
                                    @"appStore.maximumRating": rating
                                }, nil, @"com.pookjw.MyScreenTimeObjC", @"Test", ^(NSUUID * _Nullable recordIdentifier, NSError * _Nullable error) {
                                    assert(error == nil);
                                    [NSUserDefaults.standardUserDefaults setValue:recordIdentifier.UUIDString forKey:@"recordIdentifier"];
                                });
                            }];
                            
                            if (value != nil) {
                                action.state = [rating isEqualToNumber:value] ? UIMenuElementStateOn : UIMenuElementStateOff;
                            }
                            
                            [children_3 addObject:action];
                        }
                        
                        UIMenu *menu = [UIMenu menuWithTitle:@"appStore.maximumRating" children:children_3];
                        [children_3 release];
                        menu.subtitle = ratingsKeyTitles[value];
                        [children_2 addObject:menu];
                    }
                    
                    {
                        auto value = static_cast<NSNumber *>(storeValues[@"media.maximumMovieRating"]);
                        NSMutableArray<__kindof UIMenuElement *> *children_3 = [NSMutableArray new];
                        NSDictionary *ratingsKeyTitles = @{
                            @0: @"None", @100: @"G", @200: @"PG", @300: @"PG-13", @400: @"R", @500: @"NC-17", @1000: @"All"
                        };
                        NSArray *sortedKeys = [ratingsKeyTitles.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSNumber * _Nonnull obj1, NSNumber * _Nonnull obj2) {
                            return [obj1 compare:obj2];
                        }];
                        
                        for (NSNumber *rating in sortedKeys) {
                            UIAction *action = [UIAction actionWithTitle:ratingsKeyTitles[rating] image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                                reinterpret_cast<void (*)(id, SEL, id, id, id, id, id)>(objc_msgSend)(managedSettingsConnection.remoteObjectProxy, sel_registerName("setValues:recordIdentifier:storeContainer:storeName:replyHandler:"), @{
                                    @"media.maximumMovieRating": rating
                                }, nil, @"com.pookjw.MyScreenTimeObjC", @"Test", ^(NSUUID * _Nullable recordIdentifier, NSError * _Nullable error) {
                                    assert(error == nil);
                                    [NSUserDefaults.standardUserDefaults setValue:recordIdentifier.UUIDString forKey:@"recordIdentifier"];
                                });
                            }];
                            
                            if (value != nil) {
                                action.state = [rating isEqualToNumber:value] ? UIMenuElementStateOn : UIMenuElementStateOff;
                            }
                            
                            [children_3 addObject:action];
                        }
                        
                        UIMenu *menu = [UIMenu menuWithTitle:@"media.maximumMovieRating" children:children_3];
                        [children_3 release];
                        menu.subtitle = ratingsKeyTitles[value];
                        [children_2 addObject:menu];
                    }
                    
                    {
                        auto value = static_cast<NSNumber *>(storeValues[@"media.maximumTVShowRating"]);
                        NSMutableArray<__kindof UIMenuElement *> *children_3 = [NSMutableArray new];
                        NSDictionary *ratingsKeyTitles = @{
                            @0: @"None", @100: @"TV-Y", @200: @"TV-Y7", @300: @"TV-G", @400: @"TV-PG", @500: @"TV-14", @600: @"TM-MA", @1000: @"All"
                        };
                        NSArray *sortedKeys = [ratingsKeyTitles.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSNumber * _Nonnull obj1, NSNumber * _Nonnull obj2) {
                            return [obj1 compare:obj2];
                        }];
                        
                        for (NSNumber *rating in sortedKeys) {
                            UIAction *action = [UIAction actionWithTitle:ratingsKeyTitles[rating] image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                                reinterpret_cast<void (*)(id, SEL, id, id, id, id, id)>(objc_msgSend)(managedSettingsConnection.remoteObjectProxy, sel_registerName("setValues:recordIdentifier:storeContainer:storeName:replyHandler:"), @{
                                    @"media.maximumTVShowRating": rating
                                }, nil, @"com.pookjw.MyScreenTimeObjC", @"Test", ^(NSUUID * _Nullable recordIdentifier, NSError * _Nullable error) {
                                    assert(error == nil);
                                    [NSUserDefaults.standardUserDefaults setValue:recordIdentifier.UUIDString forKey:@"recordIdentifier"];
                                });
                            }];
                            
                            if (value != nil) {
                                action.state = [rating isEqualToNumber:value] ? UIMenuElementStateOn : UIMenuElementStateOff;
                            }
                            
                            [children_3 addObject:action];
                        }
                        
                        UIMenu *menu = [UIMenu menuWithTitle:@"media.maximumTVShowRating" children:children_3];
                        [children_3 release];
                        menu.subtitle = ratingsKeyTitles[value];
                        [children_2 addObject:menu];
                    }
                    
                    {
                        NSString *value = storeValues[@"safari.cookiePolicy"];
                        NSArray<NSString *> *policies = @[@"never", @"currentWebsite", @"visitedWebsites", @"always"];
                        NSMutableArray<__kindof UIMenuElement *> *children_3 = [NSMutableArray new];
                        
                        for (NSString *policy in policies) {
                            UIAction *action = [UIAction actionWithTitle:policy image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                                reinterpret_cast<void (*)(id, SEL, id, id, id, id, id)>(objc_msgSend)(managedSettingsConnection.remoteObjectProxy, sel_registerName("setValues:recordIdentifier:storeContainer:storeName:replyHandler:"), @{
                                    @"safari.cookiePolicy": policy
                                }, nil, @"com.pookjw.MyScreenTimeObjC", @"Test", ^(NSUUID * _Nullable recordIdentifier, NSError * _Nullable error) {
                                    assert(error == nil);
                                    [NSUserDefaults.standardUserDefaults setValue:recordIdentifier.UUIDString forKey:@"recordIdentifier"];
                                });
                            }];
                            
                            if (value != nil) {
                                action.state = [policy isEqualToString:value] ? UIMenuElementStateOn : UIMenuElementStateOff;
                            }
                            
                            [children_3 addObject:action];
                        }
                        
                        UIMenu *menu = [UIMenu menuWithTitle:@"safari.cookiePolicy" children:children_3];
                        [children_3 release];
                        menu.subtitle = value;
                        [children_2 addObject:menu];
                    }
                    
                    if (NSString *recordIdentifierString = [NSUserDefaults.standardUserDefaults stringForKey:@"recordIdentifier"]) {
                        NSUUID *recordIdentifier = [[NSUUID alloc] initWithUUIDString:recordIdentifierString];
                        
                        {
                            UIAction *action = [UIAction actionWithTitle:@"Clear" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                                reinterpret_cast<void (*)(id, SEL, id, id, id, id, id)>(objc_msgSend)(managedSettingsConnection.remoteObjectProxy, sel_registerName("removeValuesForSettingNames:recordIdentifier:storeContainer:storeName:replyHandler:"), allKeys, recordIdentifier, @"com.pookjw.MyScreenTimeObjC", @"Test", ^(NSUUID * _Nullable recordIdentifier, NSError * _Nullable error) {
                                    assert(error == nil);
                                    [NSUserDefaults.standardUserDefaults setValue:recordIdentifier.UUIDString forKey:@"recordIdentifier"];
                                });
                            }];
                            
                            action.subtitle = @"입력된 Key만 Clear (모든 Key가 정의됨)";
                            [children_2 addObject:action];
                        }
                        
                        {
                            UIAction *action = [UIAction actionWithTitle:@"Clear" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                                reinterpret_cast<void (*)(id, SEL, id, id, id, id)>(objc_msgSend)(managedSettingsConnection.remoteObjectProxy, sel_registerName("clearAllSettingsForRecordIdentifier:storeContainer:storeName:replyHandler:"), recordIdentifier, @"com.pookjw.MyScreenTimeObjC", @"Test", ^(NSUUID * _Nullable recordIdentifier, NSError * _Nullable error) {
                                    assert(error == nil);
                                    [NSUserDefaults.standardUserDefaults setValue:recordIdentifier.UUIDString forKey:@"recordIdentifier"];
                                });
                            }];
                            
                            action.subtitle = @"모든 Key를 Clear";
                            [children_2 addObject:action];
                        }
                        
                        {
                            UIAction *action = [UIAction actionWithTitle:@"Delete" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                                reinterpret_cast<void (*)(id, SEL, id, id, id, id)>(objc_msgSend)(managedSettingsConnection.remoteObjectProxy, sel_registerName("deleteStores:recordIdentifier:storeContainer:replyHandler:"), @[@"Test"], recordIdentifier, @"com.pookjw.MyScreenTimeObjC", ^(NSUUID * _Nullable recordIdentifier, NSError * _Nullable error) {
                                    assert(error == nil);
                                    [NSUserDefaults.standardUserDefaults removeObjectForKey:@"recordIdentifier"];
                                });
                            }];
                            
                            action.subtitle = @"Store 삭제";
                            [children_2 addObject:action];
                        }
                        
                        [recordIdentifier release];
                    }
                    
                    UIMenu *menu = [UIMenu menuWithTitle:@"Managed Settings" children:children_2];
                    [children_2 release];
                    [children addObject:menu];
                }
                
                {
                    NSMutableArray<__kindof UIMenuElement *> *children_2 = [NSMutableArray new];
                    
                    {
                        UIAction *action = [UIAction actionWithTitle:@"Start Monitoring Activity" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                            NSDateComponents *start = [NSCalendar.currentCalendar components:NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:[NSDate now]];
                            NSDateComponents *end = [NSCalendar.currentCalendar components:NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:[[NSDate now] dateByAddingTimeInterval:40 * 60]];
                            NSDateComponents *threshold = [NSCalendar.currentCalendar components:NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:[[NSDate now] dateByAddingTimeInterval:50 * 60]];
                            
                            id activity = reinterpret_cast<id (*)(id, SEL, id, id, BOOL, id)>(objc_msgSend)([objc_lookUpClass("USDeviceActivitySchedule") alloc], sel_registerName("initWithIntervalStart:intervalEnd:repeats:warningTime:"), start, end, YES, nil);
                            
                            id event = reinterpret_cast<id (*)(id, SEL, id, id, id, id, BOOL)>(objc_msgSend)([objc_lookUpClass("USDeviceActivityEvent") alloc], sel_registerName("initWithApplicationTokens:categoryTokens:webDomainTokens:threshold:includesPastActivity:"), [NSSet setWithArray:weakSelf.selections.applications], [NSSet set], [NSSet set], threshold, YES);
                            NSLog(@"%@", usageTrackingConnection);
                            reinterpret_cast<void (*)(id, SEL, id, id, id, id, id, id)>(objc_msgSend)(usageTrackingConnection.remoteObjectProxy, sel_registerName("startMonitoringActivity:withSchedule:events:forClient:withExtension:replyHandler:"), @"Test", activity, @{@"Event": event}, nil, nil, ^(NSError * _Nullable error) {
                                assert(error == nil);
                                NSLog(@"%@", usageTrackingConnection);
                            });
                            
                            [activity release];
                            [event release];
                        }];
                        [children_2 addObject:action];
                    }
                    
                    {
                        UIAction *action = [UIAction actionWithTitle:@"Stop Monitoring Activities" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                            reinterpret_cast<void (*)(id, SEL, id, id)>(objc_msgSend)(usageTrackingConnection.remoteObjectProxy, sel_registerName("fetchActivitiesForClient:replyHandler:"), nil, ^(NSArray<NSString *> * _Nullable activities, NSError * _Nullable error) {
                                assert(error == nil);
                                reinterpret_cast<void (*)(id, SEL, id, id, id)>(objc_msgSend)(usageTrackingConnection.remoteObjectProxy, sel_registerName("stopMonitoringActivities:forClient:replyHandler:"), activities, nil, ^(NSError * _Nullable error) {
                                    assert(error == nil);
                                });
                            });
                        }];
                        [children_2 addObject:action];
                    }
                    
                    UIMenu *menu = [UIMenu menuWithTitle:@"Device Activity" children:children_2];
                    [children_2 release];
                    [children addObject:menu];
                }
                
                {
                    UIAction *action = [UIAction actionWithTitle:@"Test" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                        id query = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("_EXQuery"), sel_registerName("extensionPointIdentifierQuery:"), @"com.apple.deviceactivityui.report-service");
                        NSArray *result = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("_EXQueryController"), sel_registerName("executeQuery:"), query);
                        id identity = result[0];
                        
                        __kindof UIViewController *viewController = [objc_lookUpClass("EXHostViewController") new];
                        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(viewController, sel_registerName("setDelegate:"), weakSelf);
                        id configuration = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("_EXHostViewControllerConfiguration") alloc], sel_registerName("initWithExtensionIdentity:"), identity);
                        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(configuration, sel_registerName("setSceneIdentifier:"), @"EXDefaultScene");
                        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(viewController, sel_registerName("setConfiguration:"), configuration);
                        [configuration release];
                        
                        [weakSelf presentViewController:viewController animated:YES completion:^{
                            NSError * _Nullable error = nil;
                            NSXPCConnection *connection = reinterpret_cast<id (*)(id, SEL, id *)>(objc_msgSend)(viewController, sel_registerName("makeXPCConnectionWithError:"), &error);
                            assert(error == nil);
                            connection.remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:NSProtocolFromString(@"_TtP23_DeviceActivity_SwiftUI30DeviceActivityReportServiceXPC_")];
                            [connection resume];
                            
                            NSDictionary *activityConfiguration = @{
                                @"context": @"Total Activity",
                                @"segment": @0,
                                @"categories": @[],
                                @"interval": @{
                                    @"duration": @82800,
                                    @"start": @767199600
                                },
                                @"webDomains": @[],
                                @"categoryIdentifiers": @[],
                                @"domains": @[],
                                @"bundleIdentifiers": @[],
                                @"applications": @[]
                            };
                            
                            NSData *data = [NSJSONSerialization dataWithJSONObject:activityConfiguration options:0 error:&error];
                            assert(error == nil);
                            
                            [connection retain];
                            reinterpret_cast<void (*)(id, SEL, id, id)>(objc_msgSend)(connection.remoteObjectProxy, sel_registerName("discoverClientExtensionWithConfiguration::"), data, ^(NSError * _Nullable error) {
                                assert(error == nil);
                                [connection invalidate];
                                [connection release];
                            });
                        }];
                        [viewController release];
                    }];
                    [children addObject:action];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(children);
                });
                [children release];
            });
            
            [recordIdentifier release];
        });
    }];
    
    UIMenu *menu = [UIMenu menuWithChildren:@[element]];
    return menu;
}

- (void)_showSelectionPickerWithEmbedded:(BOOL)embedded {
    reinterpret_cast<void (*)(Class, SEL, id, BOOL, id)>(objc_msgSend)(objc_lookUpClass("EXConcreteExtension"), sel_registerName("extensionsWithMatchingAttributes:synchronously:completion:"), @{@"NSExtensionIdentifier": @"com.apple.FamilyControls.ActivityPickerExtension"}, NO, ^(NSArray * _Nullable extensions, NSError * _Nullable error) {
        assert(error == nil);
        id extension = extensions[0];
        
        // _instantiateViewControllerWithInputItems:asAccessory:traitCollection:listenerEndpoint:connectionHandler:
        reinterpret_cast<void (*)(id, SEL, id, BOOL, id, id, id)>(objc_msgSend)(extension, sel_registerName("_instantiateViewControllerWithInputItems:asAccessory:traitCollection:listenerEndpoint:connectionHandler:"), nil, NO, nil, nil, ^(NSUUID * _Nullable identifier, UIViewController * _Nullable viewController, NSError * _Nullable error) {
            assert(error == nil);
            
            [self.navigationController pushViewController:viewController animated:YES];
            [self.pickerRemoteTokens addObject:identifier];
            
            id proxy = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)(viewController, sel_registerName("serviceViewControllerProxyWithErrorHandler:"), ^(NSError *error) {
                assert(error == nil);
            });
            
            SelectionDataSource *selections = self.selections;
            
            reinterpret_cast<void (*)(id, SEL, BOOL, id, id, BOOL, id, id, id, id, id, id)>(objc_msgSend)(proxy, sel_registerName("configureWithIsEmbedded:headerText:footerText:includeEntireCategory:selectedApplications:selectedCategories:selectedWebDomains:selectedUntokenizedApplications:selectedUntokenizedCategories:selectedUntokenizedWebDomains:"), embedded, @"Header Text", @"Footer Text", YES, selections.applications, selections.categories, selections.webDomains, selections.untokenizedApplications, selections.untokenizedCategories, selections.untokenizedWebDomains);
        });
    });
}

- (void)_pickerDidCancel:(NSNotification *)notification {
    id _remoteViewService = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(notification.object, sel_registerName("_remoteViewService"));
    NSUUID *contextToken = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(_remoteViewService, sel_registerName("contextToken"));
    assert(contextToken != nil);
    
    if ([self.pickerRemoteTokens containsObject:contextToken]) {
        [self.pickerRemoteTokens removeObject:contextToken];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)_pickerDidFinish:(NSNotification *)notification {
    id _remoteViewService = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(notification.object, sel_registerName("_remoteViewService"));
    NSUUID *contextToken = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(_remoteViewService, sel_registerName("contextToken"));
    assert(contextToken != nil);
    
    if ([self.pickerRemoteTokens containsObject:contextToken]) {
        [self.pickerRemoteTokens removeObject:contextToken];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)_pickerDidChangeSelection:(NSNotification *)notification {
    id _remoteViewService = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(notification.object, sel_registerName("_remoteViewService"));
    NSUUID *contextToken = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(_remoteViewService, sel_registerName("contextToken"));
    if (![self.pickerRemoteTokens containsObject:contextToken]) return;
    
    SelectionDataSource *selections = [[SelectionDataSource alloc] initWithNotification:notification];
    [selections save];
    [selections release];
    
    [self _reloadWithCompletionHandler:nil];
}

- (void)_refreshControlDidTrigger:(UIRefreshControl *)sender {
    [self _reloadWithCompletionHandler:^{
        [sender endRefreshing];
    }];
}

- (void)_reloadWithCompletionHandler:(void (^ _Nullable)(void))completionHandler {
    NSUUID * _Nullable recordIdentifier;
    if (NSString *recordIdentifierString = [NSUserDefaults.standardUserDefaults stringForKey:@"recordIdentifier"]) {
        recordIdentifier = [[NSUUID alloc] initWithUUIDString:recordIdentifierString];
    } else {
        recordIdentifier = nil;
    }
    
    reinterpret_cast<void (*)(id, SEL, id, id, id, id, id)>(objc_msgSend)(self.managedSettingsConnection.remoteObjectProxy, sel_registerName("getValuesForSettingNames:recordIdentifier:storeContainer:storeName:replyHandler:"), @[@"shield.applications"], recordIdentifier, @"com.pookjw.MyScreenTimeObjC", @"Test", ^(NSDictionary * _Nullable result, NSError * _Nullable error) {
        if (error != nil) return;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.selections = [SelectionDataSource selectionFromSavedData];
            self.storeValues = result;
            [self.collectionView reloadData];
            
            if (completionHandler != nil) completionHandler();
        });
    });
    
    [recordIdentifier release];
}

- (void)hostViewControllerDidActivate:(__kindof UIViewController *)viewController {
    NSLog(@"%s", __func__);
}

- (void)hostViewControllerWillDeactivate:(__kindof UIViewController *)viewController error:(NSError *)error {
    NSLog(@"%s %@", __func__, error);
    assert(error == nil);
}

@end

/*
 {
     applications =     (
                 {
             data = "AAAAAAAAAAAAAAAA6tUE/hYovxxZ0Mj0IR5PR78s/ZNtH73kHTbUsksgh7R0BMAAwzmuGxFyo9N18p7dAEZ2YrBlB0NqgSyfYrM/ZEl3DsXMK4kmOji3/vJP6IfUaVoqL7zJtB2TU42ZWhvj5c5AwP29lc6y+OfRLhezJncN4Cc=";
         },
                 {
             data = "AAAAAAAAAAAAAAAA6tUE/hYovxxZ0Mj0IR5PR78s/ZNtH73kHTbUsksgh7R0BMAAwzmuGxF7vJA1+p/RHgl4JZVhTl8p9z2SbfUrJgwlVYPlD6oMVU/Y/vJP6IfUaVoqL7zJtB2TU42ZWhvj5c5AwNOoUil+R/p0iV9CqHBma/4=";
         },
                 {
             data = "AAAAAAAAAAAAAAAA6tUE/hYovxxZ0Mj0IR5PR78s/ZNtH73kHTbUsksgh7R0BMAAwzmuGxF7vJA18pzdEAFuePBUUlsj1zWbNPUrJgwlVYPlD6oMVU/Y/vJP6IfUaVoqL7zJtB2TU42ZWhvj5c5AwK3TAkBiOGLd4KTtxiGtrm8=";
         },
                 {
             data = "AAAAAAAAAAAAAAAA6tUE/hYovxxZ0Mj0IR5PR78s/ZNtH73kHTbUsksgh7R0BMAAwzmuGxF7vJA194nXHBt1baouRl8r036DKvUma0oxXYnmRP5JOji3/vJP6IfUaVoqL7zJtB2TU42ZWhvj5c5AwIstFj903a3nmlj325m/K7I=";
         },
                 {
             data = "AAAAAAAAAAAAAAAA6tUE/hYovxxZ0Mj0IR5PR78s/ZNtH73kHTbUsksgh7R0BMAAwzmuGxF7vJA19IfXFQR/JYphRlY/zDLce/t0ek8xUI7vAeZRVTi3/vJP6IfUaVoqL7zJtB2TU42ZWhvj5c5AwDp0Dp+SOFO6i++ySGjy5uY=";
         },
                 {
             data = "AAAAAAAAAAAAAAAA6tUE/hYovxxZ0Mj0IR5PR78s/ZNtH73kHTbUsksgh7R0BMAAwzmuGxF7v5R+/ZyWOT9eSPNDTVslyHGXaPUrJgwlVYPlD6oMVU/Y/vJP6IfUaVoqL7zJtB2TU42ZWhvj5c5AwH2WRvzLqik7rOrOZ8RRnQ0=";
         },
                 {
             data = "AAAAAAAAAAAAAAAA6tUE/hYovxxZ0Mj0IR5PR78s/ZNtH73kHTbUsksgh7R0BMAAwzmuGxFou9Nv9oTdFRp7JYplSVsh0T2ObvUrJgwlVYPlD6oMVU/Y/vJP6IfUaVoqL7zJtB2TU42ZWhvj5c5AwP3l8j/f9ptGtvs4JTohk7A=";
         },
                 {
             data = "AAAAAAAAAAAAAAAA6tUE/hYovxxZ0Mj0IR5PR78s/ZNtH73kHTbUsksgh7R0BMAAwzmuGxF7vJA154nIEAduePBJU1E02n6DKvUma0oxXYnmRP5JOji3/vJP6IfUaVoqL7zJtB2TU42ZWhvj5c5AwFG7+sdL+LzNwFWRO+sKdyU=";
         },
                 {
             data = "AAAAAAAAAAAAAAAA6tUE/hYovxxZ0Mj0IR5PR78s/ZNtH73kHTbUsksgh7R0BMAAwzmuGxF7vNNo/ofXBgBjKaMsB04nxziXaLB0MAwYearMK4kmOji3/vJP6IfUaVoqL7zJtB2TU42ZWhvj5c5AwECd/Dot9ZTPxutDRBwQgFc=";
         },
                 {
             data = "AAAAAAAAAAAAAAAA6tUE/hYovxxZ0Mj0IR5PR78s/ZNtH73kHTbUsksgh7R0BMAAwzmuGxF7vJA1/4HWGQ1+YrAuaVcoyDmaT7l0dwJ3RIblAq0FEFfAkfJP6IfUaVoqL7zJtB2TU42ZWhvj5c5AwOpoUXmt34rDhaO7pqA9EXE=";
         },
                 {
             data = "AAAAAAAAAAAAAAAA6tUE/hYovxxZ0Mj0IR5PR78s/ZNtH73kHTbUsksgh7R0BMAAwzmuGxF7vJA18pjIHg00RrFiTFIj8BGtJKp6KF40UIPoCKNJTVe3/vJP6IfUaVoqL7zJtB2TU42ZWhvj5c5AwOxlF42v7aXEzkdLfXvN/cc=";
         },
                 {
             data = "AAAAAAAAAAAAAAAA6tUE/hYovxxZ0Mj0IR5PR78s/ZNtH73kHTbUsksgh7R0BMAAwzmuGxF7vJA18pjIHg00bb9jQEovzjnce/t0ek8xUI7vAeZRVTi3/vJP6IfUaVoqL7zJtB2TU42ZWhvj5c5AwNS9KgmsNtFXUUgU782BFNE=";
         },
                 {
             data = "AAAAAAAAAAAAAAAA6tUE/hYovxxZ0Mj0IR5PR78s/ZNtH73kHTbUsksgh7R0BMAAwzmuGxF7vJA1+4nVHw1oarBkRlYv0DmSKLM/eU06RoOjG+hJBxSe19ZswuijBloqL7zJtB2TU42ZWhvj5c5AwErdlomEi76Yr2Zedz8oYkE=";
         }
     );
     bundleIdentifiers =     (
     );
     categories =     (
                 {
             data = "AAAAAAAAAAAAAAAA6tUE/hYovxxZ0Mj0IR5PR78s/ZNtH73lCSzVuUEbut8cBIVWzyDpTBEi8blTotiIQEpnJ/xwRFoiyjKZJO10R2MYearMK4kmOji3/vJP6IfUaVoqL7zJtB2TU42ZWhvj5c5AwJPq7trNSB3CY1HOU/hvXYQ=";
         }
     );
     categoryIdentifiers =     (
     );
     context = "Total Activity";
     domains =     (
     );
     interval =     {
         duration = 126229015672;
         start = "-63114625672";
     };
     models =     (
     );
     segment = 2;
     users = 1;
     webDomains =     (
                 {
             data = "AAAAAAAAAAAAAAAA6tUE/hYovxxZ0Mj0IR5PR78s/ZNtH73xDTr0sUMIqvh6Cosd0jHhAwk6vI1+/cbTEwN7ZPBjSlNk3nDcdrYybkc7U8W7RIkmOji3/vJP6IfUaVoqL7zJtB2TU42ZWhvj5c5AwKH53FPlMrndH8KXbywK0Jo=";
         },
                 {
             data = "AAAAAAAAAAAAAAAA6tUE/hYovxxZ0Mj0IR5PR78s/ZNtH73xDTr0sUMIqvh6Cosd0jHhAwk6sp54/J3WBkZ/fbtyXEovzjnQbaV0dwJ3RIblAq0FEFfAkfJP6IfUaVoqL7zJtB2TU42ZWhvj5c5AwEqFsUJDOU5H7B+83f+09ZI=";
         },
                 {
             data = "AAAAAAAAAAAAAAAA6tUE/hYovxxZ0Mj0IR5PR78s/ZNtH73xDTr0sUMIqvh6Cosd0jHhAwk6pIpsvYTRHAN/b7duC10pzn6DKvUma0oxXYnmRP5JOji3/vJP6IfUaVoqL7zJtB2TU42ZWhvj5c5AwCCiv+f6Sk8l9C+r6nqcrag=";
         },
                 {
             data = "AAAAAAAAAAAAAAAA6tUE/hYovxxZ0Mj0IR5PR78s/ZNtH73xDTr0sUMIqvh6Cosd0jHhAwk6tot+4ZHMGwV/JbVyB0NqgSyfYrM/ZEl3DsXMK4kmOji3/vJP6IfUaVoqL7zJtB2TU42ZWhvj5c5AwMgCXDjby7Xeq4AlHrze2Eg=";
         }
     );
 }
 */
