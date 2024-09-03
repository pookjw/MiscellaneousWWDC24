//
//  Grid.h
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 9/3/24.
//

#import <Foundation/Foundation.h>
#include <vector>
#import <simd/simd.h>

NS_ASSUME_NONNULL_BEGIN

@interface Grid : NSObject
@property (assign, nonatomic, readonly) std::vector<simd_float3> vertices;
@property (assign, nonatomic, readonly) std::vector<std::uint16_t> indices;
@property (retain, nonatomic, readonly) id vertexBuffer;
@property (retain, nonatomic, readonly) id indexBuffer;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDevice:(id)device;
@end

NS_ASSUME_NONNULL_END
