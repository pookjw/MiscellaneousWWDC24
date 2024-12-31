//
//  CollectionViewController.m
//  MiscellaneousStark
//
//  Created by Jinwoo Kim on 1/1/25.
//

#import "CollectionViewController.h"

@interface CollectionViewController ()
@end

@implementation CollectionViewController

- (instancetype)init {
    UICollectionLayoutListConfiguration *listConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearanceInsetGrouped];
    UICollectionViewCompositionalLayout *collectionViewLayout = [UICollectionViewCompositionalLayout layoutWithListConfiguration:listConfiguration];
    [listConfiguration release];
    
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

@end
