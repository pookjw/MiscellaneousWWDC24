//
//  NSManagedObjectModel+MCCategory.h
//  MyCanvasData
//
//  Created by Jinwoo Kim on 3/6/25.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

__attribute__((objc_direct_members))
@interface NSManagedObjectModel (MCCategory)
+ (NSManagedObjectModel *)mc_makeModel;
@end

NS_ASSUME_NONNULL_END
