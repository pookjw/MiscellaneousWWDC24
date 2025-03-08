//
//  MCCustomItem.h
//  MyCanvasData
//
//  Created by Jinwoo Kim on 3/8/25.
//

#import <CoreData/CoreData.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@class MCCanvas;
@interface MCCustomItem : NSManagedObject
@property (copy, nonatomic, nullable) NSString *systemImageName;
@property (copy, nonatomic, nullable) NSDictionary<NSString *, id> *frame;
@property (copy, nonatomic, nullable) NSDictionary<NSString *, id> *tintColor;
@property (copy, nonatomic, nullable) NSDictionary<NSString *, id> *transform;
@property (assign, nonatomic, setter=setCGFrame:) CGRect cgFrame;
@property (assign, nonatomic, setter=setCGAffineTransform:) CGAffineTransform cgAffineTransform;
@property (retain, nonatomic, nullable) MCCanvas *canvas;
- (CGColorRef _Nullable)cgTintColor CF_RETURNS_RETAINED;
- (void)setCGTintColor:(CGColorRef _Nullable)cgTintColor;
@end

NS_ASSUME_NONNULL_END
