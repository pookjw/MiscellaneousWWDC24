//
//  Grid.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 9/3/24.
//

#import "Grid.h"
#include <ranges>
#import <objc/message.h>
#import <objc/runtime.h>

@implementation Grid

- (instancetype)initWithDevice:(id)device {
    if (self = [super init]) {
        const std::vector<simd_float3> verticalVertices = std::views::iota(0, 38)
        | std::views::transform([](std::uint8_t num) -> simd_float3 {
            return simd_make_float3(-0.9f + (num / 2) * 0.1f,
                                    (num % 2 == 0) ? 1.f : -1.f,
                                    0.f);
        })
        | std::ranges::to<std::vector<simd_float3>>();
        
        const std::vector<simd_float3> horizontalVertices = std::views::iota(0, 38)
        | std::views::transform([](std::uint8_t num) -> simd_float3 {
            return simd_make_float3((num % 2 == 0) ? 1.f : -1.f,
                                    0.9f - (num / 2) * 0.1f,
                                    0.f);
        })
        | std::ranges::to<std::vector<simd_float3>>();
        
        _vertices = std::vector<simd_float3>();
        _vertices.reserve(verticalVertices.size() + horizontalVertices.size());
        _vertices.insert(_vertices.cend(), verticalVertices.cbegin(), verticalVertices.cend());
        _vertices.insert(_vertices.cend(), horizontalVertices.cbegin(), horizontalVertices.cend());
        
        id vertexBuffer = reinterpret_cast<id (*)(id, SEL, const void *, NSUInteger, NSUInteger)>(objc_msgSend)(device, sel_registerName("newBufferWithBytes:length:options:"), _vertices.data(), sizeof(simd_float3) * _vertices.size(), 2 << 8 /* MTLResourceHazardTrackingModeTracked */);
        
        //
        
        _indices = std::views::iota(0, 77) | std::ranges::to<std::vector<std::uint16_t>>();
        
        
        id indexBuffer = reinterpret_cast<id (*)(id, SEL, const void *, NSUInteger, NSUInteger)>(objc_msgSend)(device, sel_registerName("newBufferWithBytes:length:options:"), _indices.data(), sizeof(std::uint16_t) * _indices.size(), 2 << 8 /* MTLResourceHazardTrackingModeTracked */);
        
        //
        
        _vertexBuffer = [vertexBuffer retain];
        _indexBuffer = [indexBuffer retain];
        
        [vertexBuffer release];
        [indexBuffer release];
    }
    
    return self;
}

- (void)dealloc {
    [_vertexBuffer release];
    [_indexBuffer release];
    [super dealloc];
}

@end
