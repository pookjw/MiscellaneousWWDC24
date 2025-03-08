//
//  MCCanvas.h
//  MyCanvasData
//
//  Created by Jinwoo Kim on 3/6/25.
//

#import <CoreData/CoreData.h>
#import <PencilKit/PencilKit.h>
#import <MyCanvasData/MCCustomItem.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCCanvas : NSManagedObject
@property (copy, nonatomic, nullable) NSDate *lastEditedDate;
@property (retain, nonatomic, nullable) PKDrawing *drawing;
@property (retain, nonatomic, nullable) NSDictionary *toolPickerState;
+ (NSFetchRequest<MCCanvas *> *)fetchRequest;
@property (copy, nonatomic, nullable) NSData *canvasImageData;
@property (copy, nonatomic, nullable) NSData *customItemsImageData;
@property (retain, nonatomic, nullable) NSOrderedSet<MCCustomItem *> *customItems;
- (void)insertObject:(MCCustomItem *)value inCustomItemsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCustomItemsAtIndex:(NSUInteger)idx;
- (void)insertCustomItems:(NSArray<MCCustomItem *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCustomItemsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCustomItemsAtIndex:(NSUInteger)idx withObject:(MCCustomItem *)value;
- (void)replaceCustomItemsAtIndexes:(NSIndexSet *)indexes withCustomItems:(NSArray<MCCustomItem *> *)values;
- (void)addCustomItemsObject:(MCCustomItem *)value;
- (void)removeCustomItemsObject:(MCCustomItem *)value;
- (void)addCustomItems:(NSOrderedSet<MCCustomItem *> *)values;
- (void)removeCustomItems:(NSOrderedSet<MCCustomItem *> *)values;
@end

NS_ASSUME_NONNULL_END
