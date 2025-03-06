//
//  CanvasCollectionViewController.mm
//  MyCanvas
//
//  Created by Jinwoo Kim on 3/6/25.
//

#import "CanvasCollectionViewController.h"
#import "CanvasCollectionContentConfiguration.h"
#import <MyCanvasData/MyCanvasData.h>
#include <numeric>
#import "CanvasViewController.h"
#import "PreferencesViewController.h"

__attribute__((objc_direct_members))
@interface CanvasCollectionViewController () <NSFetchedResultsControllerDelegate>
@property (retain, nonatomic, readonly, getter=_fetchedResultsController) NSFetchedResultsController<MCCanvas *> *fetchedResultsController;
@property (retain, nonatomic, readonly, getter=_fetchedResultsControllerIfExists) NSFetchedResultsController<MCCanvas *> *fetchedResultsControllerIfExists;
@property (retain, nonatomic, readonly, getter=_cellRegistration) UICollectionViewCellRegistration *cellRegistration;
@property (retain, nonatomic, readonly, getter=_addBarButtonItem) UIBarButtonItem *addBarButtonItem;
@property (retain, nonatomic, readonly, getter=_preferencesBarButtonItem) UIBarButtonItem *preferencesBarButtonItem;
@end

@implementation CanvasCollectionViewController
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize cellRegistration = _cellRegistration;
@synthesize addBarButtonItem = _addBarButtonItem;
@synthesize preferencesBarButtonItem = _preferencesBarButtonItem;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    UICollectionViewCompositionalLayoutConfiguration *configuration = [UICollectionViewCompositionalLayoutConfiguration new];
    configuration.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionViewCompositionalLayout *collectionViewLayout = [[UICollectionViewCompositionalLayout alloc] initWithSectionProvider:^NSCollectionLayoutSection * _Nullable(NSInteger sectionIndex, id<NSCollectionLayoutEnvironment>  _Nonnull layoutEnvironment) {
        NSUInteger quotient = floorf(layoutEnvironment.container.contentSize.width / 200.);
        NSUInteger count = MAX(quotient, 2);
        
        NSCollectionLayoutSize *itemSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1. / count]
                                                                          heightDimension:[NSCollectionLayoutDimension fractionalHeightDimension:1.]];
        
        NSCollectionLayoutItem *item = [NSCollectionLayoutItem itemWithLayoutSize:itemSize];
        item.contentInsets = NSDirectionalEdgeInsetsMake(10., 10., 10., 10.);
        
        NSCollectionLayoutSize *groupSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.]
                                                                           heightDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1. / count]];
        
        NSCollectionLayoutGroup *group = [NSCollectionLayoutGroup horizontalGroupWithLayoutSize:groupSize repeatingSubitem:item count:count];
        
        NSCollectionLayoutSection *section = [NSCollectionLayoutSection sectionWithGroup:group];
        section.contentInsets = NSDirectionalEdgeInsetsMake(10., 10., 10., 10.);
        
        return section;
    }
                                                                                                                       configuration:configuration];
    [configuration release];
    
    self = [super initWithCollectionViewLayout:collectionViewLayout];
    [collectionViewLayout release];
    
    return self;
}

- (void)dealloc {
    [_fetchedResultsController release];
    [_cellRegistration release];
    [_addBarButtonItem release];
    [_preferencesBarButtonItem release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _cellRegistration];
    
    self.navigationItem.rightBarButtonItems = @[self.addBarButtonItem, self.preferencesBarButtonItem];
    
    [MCCoreDataStack.sharedInstance.backgroundContext performBlock:^{
        if (MCCoreDataStack.sharedInstance.initialized) {
            NSError * _Nullable error = nil;
            [self.fetchedResultsController performFetch:&error];
            assert(error == nil);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        } else {
            [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_didInitializeCoreDataStack:) name:MCCoreDataStackDidInitializeNotification object:MCCoreDataStack.sharedInstance];
        }
    }];
}

- (void)_didInitializeCoreDataStack:(NSNotification *)notification {
    NSError * _Nullable error = nil;
    [self.fetchedResultsController performFetch:&error];
    assert(error == nil);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

- (NSFetchedResultsController<MCCanvas *> *)_fetchedResultsController {
    if (auto fetchedResultsController = _fetchedResultsController) return fetchedResultsController;
    
    NSFetchRequest<MCCanvas *> *fetchRequest = MCCanvas.fetchRequest;
    fetchRequest.sortDescriptors = @[
        [NSSortDescriptor sortDescriptorWithKey:@"lastEditedDate" ascending:NO]
    ];
    
    NSFetchedResultsController<MCCanvas *> *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                           managedObjectContext:MCCoreDataStack.sharedInstance.backgroundContext
                                                                                                             sectionNameKeyPath:nil
                                                                                                                      cacheName:nil];
    
    fetchedResultsController.delegate = self;
    
    _fetchedResultsController = fetchedResultsController;
    return fetchedResultsController;
}

- (NSFetchedResultsController<MCCanvas *> *)_fetchedResultsControllerIfExists {
    return _fetchedResultsController;
}

- (UICollectionViewCellRegistration *)_cellRegistration {
    if (auto cellRegistration = _cellRegistration) return cellRegistration;
    
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:[UICollectionViewCell class] configurationHandler:^(__kindof UICollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, MCCanvas * _Nonnull item) {
        CanvasCollectionContentConfiguration *contentConfiguration = [[CanvasCollectionContentConfiguration alloc] initWithCanvas:item];
        cell.contentConfiguration = contentConfiguration;
        [contentConfiguration release];
    }];
    
    _cellRegistration = [cellRegistration retain];
    return cellRegistration;
}

- (UIBarButtonItem *)_addBarButtonItem {
    if (auto addBarButtonItem = _addBarButtonItem) return addBarButtonItem;
    
    UIBarButtonItem *addBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"plus"] style:UIBarButtonItemStylePlain target:self action:@selector(_didTriggerAddBarButtonItem:)];
    
    _addBarButtonItem = addBarButtonItem;
    return addBarButtonItem;
}

- (UIBarButtonItem *)_preferencesBarButtonItem {
    if (auto preferencesBarButtonItem = _preferencesBarButtonItem) return preferencesBarButtonItem;
    
    UIBarButtonItem *preferencesBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"gear"] style:UIBarButtonItemStylePlain target:self action:@selector(_didTriggerPreferencesBarButtonItem:)];
    
    _preferencesBarButtonItem = preferencesBarButtonItem;
    return preferencesBarButtonItem;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueConfiguredReusableCellWithRegistration:self.cellRegistration forIndexPath:indexPath item:[self.fetchedResultsController objectAtIndexPath:indexPath]];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.fetchedResultsControllerIfExists.fetchedObjects.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MCCanvas *canvas = [self.fetchedResultsController objectAtIndexPath:indexPath];
    assert(canvas != nil);
    CanvasViewController *canvasViewController = [[CanvasViewController alloc] initWithCanvas:canvas];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:canvasViewController];
    [canvasViewController release];
    navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [self presentViewController:navigationController animated:YES completion:nil];
    [navigationController release];
}

- (UIContextMenuConfiguration *)collectionView:(UICollectionView *)collectionView contextMenuConfigurationForItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths point:(CGPoint)point {
    NSFetchedResultsController<MCCanvas *> *fetchedResultsController = self.fetchedResultsController;
    
    UIContextMenuConfiguration *configuration = [UIContextMenuConfiguration configurationWithIdentifier:nil
                                                                                        previewProvider:^UIViewController * _Nullable{
        return nil;
    }
                                                                                         actionProvider:^UIMenu * _Nullable(NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
        NSMutableArray<UIMenuElement *> *children = [suggestedActions mutableCopy];
        
        UIAction *action = [UIAction actionWithTitle:@"Delete" image:[UIImage systemImageNamed:@"trash"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            NSManagedObjectContext *backgroundContext = MCCoreDataStack.sharedInstance.backgroundContext;
            [backgroundContext performBlock:^{
                for (NSIndexPath *indexPath in indexPaths) {
                    MCCanvas *canvas = [fetchedResultsController objectAtIndexPath:indexPath];
                    [backgroundContext deleteObject:canvas];
                }
                
                NSError * _Nullable error = nil;
                [backgroundContext save:&error];
                assert(error == nil);
            }];
        }];
        action.attributes = UIMenuElementAttributesDestructive;
        
        [children addObject:action];
        
        UIMenu *menu = [UIMenu menuWithChildren:children];
        [children release];
        return menu;
    }];
    
    return configuration;
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    dispatch_async(dispatch_get_main_queue(), ^{
        UICollectionView *collectionView = self.collectionView;
        
        [collectionView performBatchUpdates:^{
            switch (type) {
                case NSFetchedResultsChangeInsert: {
                    [collectionView insertItemsAtIndexPaths:@[newIndexPath]];
                    break;
                }
                case NSFetchedResultsChangeDelete: {
                    [collectionView deleteItemsAtIndexPaths:@[indexPath]];
                    break;
                }
                case NSFetchedResultsChangeMove:{
                    [collectionView moveItemAtIndexPath:indexPath toIndexPath:newIndexPath];
                    break;
                }
                case NSFetchedResultsChangeUpdate:
                    [collectionView reconfigureItemsAtIndexPaths:@[indexPath]];
                    break;
                default:
                    abort();
            }
        }
                                      completion:^(BOOL finished) {
            
        }];
    });
}

- (void)_didTriggerAddBarButtonItem:(UIBarButtonItem *)sender {
    NSManagedObjectContext *context = MCCoreDataStack.sharedInstance.backgroundContext;
    
    [context performBlock:^{
        MCCanvas *canvas = [[MCCanvas alloc] initWithContext:context];
        canvas.lastEditedDate = [NSDate now];
        [canvas release];
        
        NSError * _Nullable error = nil;
        [context save:&error];
        assert(error == nil);
    }];
}

- (void)_didTriggerPreferencesBarButtonItem:(UIBarButtonItem *)sender {
    PreferencesViewController *preferencesViewController = [PreferencesViewController new];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:preferencesViewController];
    [preferencesViewController release];
    [self presentViewController:navigationController animated:YES completion:nil];
    [navigationController release];
}

@end
