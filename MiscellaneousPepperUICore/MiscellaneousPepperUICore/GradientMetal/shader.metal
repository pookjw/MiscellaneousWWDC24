//
//  shader.metal
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 9/3/24.
//

#include <metal_stdlib>
#import <simd/simd.h>
using namespace metal;

namespace grid {
    struct VertexIn {
        float4 position [[attribute(0)]];
    };
    
    struct VertexOut {
        float4 position [[position]];
    };
    
    vertex VertexOut vertex_main(VertexIn in [[stage_in]]) {
        return {
            .position = in.position
        };
    }
    
    fragment float4 fragment_main(VertexOut in [[stage_in]]) {
        return float4(0.f, 0.f, 0.f, 1.f);
    }
}

namespace color {
    struct VertexIn {
        float4 position [[attribute(0)]];
    };
    
    struct VertexOut {
        float4 position [[position]];
    };
    
    vertex VertexOut vertex_main(VertexIn in [[stage_in]]) {
        matrix_float4x4 rotationX = {
            {1.f, 0.f, 0.f, 0.f},
            {0.f, cos(M_PI_2_F), sin(M_PI_2_F), 0.f},
            {0.f, -sin(M_PI_2_F), cos(M_PI_2_F), 0.f},
            {0.f, 0.f, 0.f, 1.f}
        };
        matrix_float4x4 rotationZ = {
            {cos(M_PI_2_F), sin(M_PI_2_F), 0.f, 0.f},
            {-sin(M_PI_2_F), cos(M_PI_2_F), 0.f, 0.f},
            {0.f, 0.f, 1.f, 0.f},
            {0.f, 0.f, 0.f, 1.f}
        };
        
        return {
            .position = float4((rotationX * rotationZ * in.position).xy, 0.f, 1.f)
        };
    }
    
    fragment float4 fragment_main(VertexOut in [[stage_in]],
                                  constant simd_uint2 &size [[buffer(0)]],
                                  constant float &colorPivot [[buffer(1)]]) {
        float result = smoothstep(0, size.x, in.position.x);
        
        float3 color1 = float3(1 - colorPivot * 0.75f, colorPivot * 0.8f, 1 - colorPivot * 0.5f);
        float3 color2 = float3(1.f - colorPivot * 0.5f, 1.f - colorPivot, colorPivot * 0.75f);
        
        // x + (y - x) * 0.6f
        float3 color = mix(color1, color2, result);
        
        return float4(color, 1.f);
    }
}
