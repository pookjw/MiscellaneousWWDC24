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

@interface CollectionViewController ()
@property (retain, nonatomic, readonly, getter=_cellRegistration) UICollectionViewCellRegistration *cellRegistration;
@property (retain, nonatomic, readonly, getter=_headerRegistration) UICollectionViewSupplementaryRegistration *headerRegistration;
@property (retain, nonatomic, readonly, getter=_menuBarButtonItem) UIBarButtonItem *menuBarButtonItem;
@property (retain, nonatomic, readonly, getter=_familyControlsConnection) NSXPCConnection *familyControlsConnection;
@property (retain, nonatomic, readonly, getter=_managedSettingsConnection) NSXPCConnection *managedSettingsConnection;
@property (retain, nonatomic, readonly, getter=_pickerRemoteTokens) NSMutableSet<NSUUID *> *pickerRemoteTokens;
@property (retain, nonatomic, getter=_selections, setter=_setSelections:) SelectionDataSource *selections;
@property (copy, nonatomic, getter=_storeValues, setter=_setStoreValues:) NSDictionary *storeValues;
@end

@implementation CollectionViewController
@synthesize cellRegistration = _cellRegistration;
@synthesize headerRegistration = _headerRegistration;
@synthesize menuBarButtonItem = _menuBarButtonItem;

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
        _familyControlsConnection.remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:NSProtocolFromString(@"_TtP14FamilyControls19FamilyControlsAgent_")];
        _familyControlsConnection.interruptionHandler = ^{
            abort();
        };
        [_familyControlsConnection resume];
        
        _managedSettingsConnection = reinterpret_cast<id (*)(id, SEL, id, NSXPCConnectionOptions)>(objc_msgSend)([NSXPCConnection alloc], sel_registerName("initWithMachServiceName:options:"), @"com.apple.ManagedSettingsAgent", NSXPCConnectionPrivileged);
        _managedSettingsConnection.remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:NSProtocolFromString(@"_TtP15ManagedSettings20ManagedSettingsAgent_")];
        _managedSettingsConnection.interruptionHandler = ^{
            abort();
        };
        [_managedSettingsConnection resume];
        
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_pickerDidCancel:) name:MT_ActivityPickerRemoteViewControllerDidCancelNotificationName object:nil];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_pickerDidFinish:) name:MT_ActivityPickerRemoteViewControllerDidFinishSelectionNotificationName object:nil];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_pickerDidChangeSelection:) name:MT_ActivityPickerRemoteViewControllerDidChangeSelectionNotificationName object:nil];
    }
    
    return self;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
    [_cellRegistration release];
    [_headerRegistration release];
    [_menuBarButtonItem release];
    [_familyControlsConnection invalidate];
    [_familyControlsConnection release];
    [_managedSettingsConnection invalidate];
    [_managedSettingsConnection release];
    [_pickerRemoteTokens release];
    [_selections release];
    [_storeValues release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.menuBarButtonItem;
    [self _cellRegistration];
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
    if (indexPath.section == 0) {
        tokens = self.selections.applications;
    } else if (indexPath.section == 1) {
        tokens = self.selections.categories;
    } else if (indexPath.section == 2) {
        tokens = self.selections.webDomains;
    } else if (indexPath.section == 3) {
        tokens = self.selections.untokenizedApplications;
    } else if (indexPath.section == 4) {
        tokens = self.selections.untokenizedCategories;
    } else if (indexPath.section == 5) {
        tokens = self.selections.untokenizedWebDomains;
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
    
    return [collectionView dequeueConfiguredReusableCellWithRegistration:_cellRegistration forIndexPath:indexPath item:@{@"token": token, @"isSelected": isSelected}];
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
    __weak auto weakSelf = self;
    
    UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(familyControlsConnection.remoteObjectProxy, sel_registerName("getAuthorizationStatus:"), ^(NSNumber * _Nullable result, NSError * _Nullable error) {
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
                    if (result.integerValue == 0) {
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
                    UIAction *action = [UIAction actionWithTitle:@"Sync" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
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
                
                if (NSString *recordIdentifierString = [NSUserDefaults.standardUserDefaults stringForKey:@"recordIdentifier"]) {
                    NSUUID *recordIdentifier = [[NSUUID alloc] initWithUUIDString:recordIdentifierString];
                    
                    {
                        UIAction *action = [UIAction actionWithTitle:@"Clear" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                            reinterpret_cast<void (*)(id, SEL, id, id, id, id)>(objc_msgSend)(managedSettingsConnection.remoteObjectProxy, sel_registerName("clearAllSettingsForRecordIdentifier:storeContainer:storeName:replyHandler:"), recordIdentifier, @"com.pookjw.MyScreenTimeObjC", @"Test", ^(NSUUID * _Nullable recordIdentifier, NSError * _Nullable error) {
                                assert(error == nil);
                                [NSUserDefaults.standardUserDefaults setValue:recordIdentifier.UUIDString forKey:@"recordIdentifier"];
                            });
                        }];
                        
                        [children_2 addObject:action];
                    }
                    
                    {
                        UIAction *action = [UIAction actionWithTitle:@"Delete" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                            reinterpret_cast<void (*)(id, SEL, id, id, id, id)>(objc_msgSend)(managedSettingsConnection.remoteObjectProxy, sel_registerName("deleteStores:recordIdentifier:storeContainer:replyHandler:"), @[@"Test"], recordIdentifier, @"com.pookjw.MyScreenTimeObjC", ^(NSUUID * _Nullable recordIdentifier, NSError * _Nullable error) {
                                assert(error == nil);
                                [NSUserDefaults.standardUserDefaults removeObjectForKey:@"recordIdentifier"];
                            });
                        }];
                        [children_2 addObject:action];
                    }
                    
                    {
                        UIAction *action = [UIAction actionWithTitle:@"Test" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                            reinterpret_cast<void (*)(id, SEL, id, id, id, id, id)>(objc_msgSend)(managedSettingsConnection.remoteObjectProxy, sel_registerName("getValuesForSettingNames:recordIdentifier:storeContainer:storeName:replyHandler:"), @[@"shield.applications"], recordIdentifier, @"com.pookjw.MyScreenTimeObjC", @"Test", ^(id result, NSError * _Nullable error) {
                                NSLog(@"%@ %@", result, error);
                            });
                        }];
                        [children_2 addObject:action];
                    }
                    
                    [recordIdentifier release];
                }
                
                UIMenu *menu = [UIMenu menuWithTitle:@"Managed Settings" children:children_2];
                [children_2 release];
                [children addObject:menu];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(children);
            });
            [children release];
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
        assert(error == nil);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.selections = [SelectionDataSource selectionFromSavedData];
            self.storeValues = result;
            [self.collectionView reloadData];
            
            if (completionHandler != nil) completionHandler();
        });
    });
    
    [recordIdentifier release];
}

@end
