//
//  MainCollectionViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/11/24.
//

#import "MainCollectionViewController.h"
#import "ListEnvironmentCollectionViewController.h"
#import "SceneActivationViewController.h"
#import "CustomDocumentViewController.h"
#import "SystemBackgroundViewController.h"
#import "ContentHuggingElementsViewController.h"
#import "CalendarViewController.h"
#import <objc/message.h>

__attribute__((objc_direct_members))
@interface MainCollectionViewController ()
@property (retain, readonly, nonatomic) UICollectionViewCellRegistration *cellRegistration;
@property (assign, readonly, nonatomic) NSArray<Class> *classes;
@end

@implementation MainCollectionViewController

@synthesize cellRegistration = _cellRegistration;

- (instancetype)init {
    UICollectionLayoutListConfiguration *listConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearanceInsetGrouped];
    UICollectionViewCompositionalLayout *collectionViewLayout = [UICollectionViewCompositionalLayout layoutWithListConfiguration:listConfiguration];
    [listConfiguration release];
    
    if (self = [super initWithCollectionViewLayout:collectionViewLayout]) {
        [self commonInit_MainCollectionViewController];
    }
    
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self commonInit_MainCollectionViewController];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self commonInit_MainCollectionViewController];
    }
    
    return self;
}

- (void)dealloc {
    [_cellRegistration release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self cellRegistration];
}

- (void)commonInit_MainCollectionViewController __attribute__((objc_direct)) {
    UINavigationItem *navigationItem = self.navigationItem;
    
    navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    navigationItem.title = ((id (*)(id, SEL))objc_msgSend)(UIApplication.sharedApplication, sel_registerName("_localizedApplicationName"));
}

- (UICollectionViewCellRegistration *)cellRegistration {
    if (auto cellRegistration = _cellRegistration) return cellRegistration;
    
    NSArray<Class> *classes = self.classes;
    
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:UICollectionViewListCell.class configurationHandler:^(__kindof UICollectionViewListCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id  _Nonnull item) {
        Class _class = classes[indexPath.item];
        
        UIListContentConfiguration *contentConfiguration = [cell defaultContentConfiguration];
        NSLog(@"%@", contentConfiguration);
        contentConfiguration.text = NSStringFromClass(_class);
        
        cell.contentConfiguration = contentConfiguration;
        
        UICellAccessoryDisclosureIndicator *disclosureIndicator = [UICellAccessoryDisclosureIndicator new];
        cell.accessories = @[disclosureIndicator];
        [disclosureIndicator release];
    }];
    
    _cellRegistration = [cellRegistration retain];
    return cellRegistration;
}

- (NSArray<Class> *)classes {
    return @[
        ListEnvironmentCollectionViewController.class,
        SceneActivationViewController.class,
        CustomDocumentViewController.class,
        SystemBackgroundViewController.class,
        ContentHuggingElementsViewController.class,
        CalendarViewController.class
    ];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.classes.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueConfiguredReusableCellWithRegistration:self.cellRegistration forIndexPath:indexPath item:[NSNull null]];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Class _class = self.classes[indexPath.item];
    
    __kindof UIViewController *rootViewController = [_class new];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    [rootViewController release];
    
    [self presentViewController:navigationController animated:YES completion:nil];
    [navigationController release];
}

@end
