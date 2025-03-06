//
//  MCCoreDataStack.mm
//  MyCanvasData
//
//  Created by Jinwoo Kim on 3/6/25.
//

#import <MyCanvasData/MCCoreDataStack.h>
#import <MyCanvasData/MCCoreDataStack-Private.h>
#import <MyCanvasData/NSManagedObjectModel+MCCategory.h>

NSNotificationName const MCCoreDataStackDidInitializeNotification = @"MCCoreDataStackDidInitializeNotification";

__attribute__((objc_direct_members))
@interface MCCoreDataStack ()
@property (retain, nonatomic, readonly, getter=_persistentContainer) NSPersistentContainer *persistentContainer;
@end

@implementation MCCoreDataStack

+ (MCCoreDataStack *)sharedInstance {
    static MCCoreDataStack *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [MCCoreDataStack new];
    });
    
    return instance;
}

+ (NSURL *)_localStoreURLWithCreatingDirectory:(BOOL)createDirectory __attribute__((objc_direct)) {
    NSFileManager *fileManager = NSFileManager.defaultManager;
    NSURL *applicationSupportURL = [fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask][0];
    NSURL *containerURL = [applicationSupportURL URLByAppendingPathComponent:[NSBundle bundleForClass:[self class]].bundleIdentifier];
    
    if (createDirectory) {
        BOOL isDirectory;
        BOOL exists = [fileManager fileExistsAtPath:containerURL.path isDirectory:&isDirectory];
        
        NSError * _Nullable error = nil;
        
        if (!exists) {
            [fileManager createDirectoryAtURL:containerURL withIntermediateDirectories:YES attributes:nil error:&error];
            assert(error == nil);
        } else {
            assert(isDirectory);
        }
    }
    
    NSURL *result = [[containerURL URLByAppendingPathComponent:@"local"] URLByAppendingPathExtension:@"sqlite"];
    return result;
}

- (instancetype)init {
    if (self = [super init]) {
        NSManagedObjectContext *backgroundContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        
        [backgroundContext performBlock:^{
            NSPersistentContainer *persistentContainer = [[NSPersistentContainer alloc] initWithName:@"MyCanvas" managedObjectModel:[NSManagedObjectModel mc_makeModel]];
            
            NSPersistentStoreDescription *localPersistentStoreDescription = [[NSPersistentStoreDescription alloc] initWithURL:[MCCoreDataStack _localStoreURLWithCreatingDirectory:YES]];
            localPersistentStoreDescription.type = NSSQLiteStoreType;
            localPersistentStoreDescription.shouldAddStoreAsynchronously = NO;
            localPersistentStoreDescription.shouldInferMappingModelAutomatically = NO;
            localPersistentStoreDescription.shouldMigrateStoreAutomatically = NO;
            [localPersistentStoreDescription setOption:@YES forKey:NSPersistentHistoryTrackingKey];
            
            persistentContainer.persistentStoreDescriptions = @[localPersistentStoreDescription];
            [localPersistentStoreDescription release];
            
            [persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription * _Nonnull, NSError * _Nullable error) {
                assert(error == nil);
            }];
            
            assert(persistentContainer.persistentStoreCoordinator.persistentStores.count == 1);
            
            _persistentContainer = persistentContainer;
            backgroundContext.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator;
            
            [NSNotificationCenter.defaultCenter postNotificationName:MCCoreDataStackDidInitializeNotification object:self];
        }];
        
        _backgroundContext = backgroundContext;
    }
    
    return self;
}

- (void)dealloc {
    [_persistentContainer release];
    [_backgroundContext release];
    [super dealloc];
}

- (BOOL)isInitialized {
    return self.backgroundContext.persistentStoreCoordinator != nil;
}

- (void)_cleanup {
    
}

- (void)destoryAndExit {
    [self.backgroundContext performBlockAndWait:^{
        NSURL *url = [MCCoreDataStack _localStoreURLWithCreatingDirectory:NO];
        [NSFileManager.defaultManager removeItemAtURL:url error:NULL];
        exit(0);
    }];
}

@end
