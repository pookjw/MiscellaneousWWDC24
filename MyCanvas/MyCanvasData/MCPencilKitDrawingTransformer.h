//
//  MCPencilKitDrawingTransformer.h
//  MyCanvasData
//
//  Created by Jinwoo Kim on 3/6/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

__attribute__((objc_direct_members))
@interface MCPencilKitDrawingTransformer : NSSecureUnarchiveFromDataTransformer
@property (class, nonatomic, readonly) NSValueTransformerName transformerName;
@end

NS_ASSUME_NONNULL_END
