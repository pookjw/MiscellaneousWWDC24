//
//  MCCoreDataStack.h
//  MyCanvasData
//
//  Created by Jinwoo Kim on 3/6/25.
//

#import <CoreData/CoreData.h>
#import <MyCanvasData/Extern.h>

NS_ASSUME_NONNULL_BEGIN

MC_EXTERN NSNotificationName const MCCoreDataStackDidInitializeNotification;

NS_SWIFT_NAME(CoreDataStack)
@interface MCCoreDataStack : NSObject
@property (class, retain, readonly, nonatomic) MCCoreDataStack *sharedInstance NS_SWIFT_NAME(shared);
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@property (retain, nonatomic, readonly) NSManagedObjectContext *backgroundContext;
@property (assign, nonatomic, readonly, getter=isInitialized) BOOL initialized; // can call from any threads
- (void)destoryAndExit;
@end

NS_ASSUME_NONNULL_END
