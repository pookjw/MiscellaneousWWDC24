//
//  MCCanvas.h
//  MyCanvasData
//
//  Created by Jinwoo Kim on 3/6/25.
//

#import <CoreData/CoreData.h>
#import <PencilKit/PencilKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCCanvas : NSManagedObject
@property (copy, nonatomic, nullable) NSDate *lastEditedDate;
@property (retain, nonatomic, nullable) PKDrawing *drawing;
+ (NSFetchRequest<MCCanvas *> *)fetchRequest;
@end

NS_ASSUME_NONNULL_END
