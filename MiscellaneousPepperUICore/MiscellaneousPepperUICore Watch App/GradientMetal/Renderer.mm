//
//  Renderer.m
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 9/3/24.
//

#import "Renderer.h"
#import "Grid.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import <dlfcn.h>
#import <CoreGraphics/CoreGraphics.h>
#import <simd/simd.h>

typedef struct {
    double red, green, blue, alpha;
} MTLClearColor;

@interface Renderer ()
@property (retain, nonatomic, readonly) id view;
@property (retain, nonatomic, readonly) id device;
@property (retain, nonatomic, readonly) id commandQueue;
@property (retain, nonatomic, readonly) id gridRenderPipelineState;
@property (retain, nonatomic, readonly) id colorRenderPipelineState;
@property (retain, nonatomic, readonly) Grid *grid;
@property (retain, nonatomic, readonly) id colorMTKMesh;
@property (assign, nonatomic) float colorPivot;
@property (assign, nonatomic) BOOL isColorPivotIncreasing;
@property (assign, nonatomic) CGSize size;
@end

@implementation Renderer

// https://x.com/_silgen_name/status/1838782441827504251
//+ (void)load {
//    assert(dlopen("/System/Library/Frameworks/MetalKit.framework/MetalKit", RTLD_NOW) != NULL);
//    assert(class_addProtocol(Renderer.class, NSProtocolFromString(@"MTKViewDelegate")));
//}

- (instancetype)initWithView:(id)view {
    if (self = [super init]) {
        NSError * _Nullable error = nil;
        
        void *Metal = dlopen("/System/Library/Frameworks/Metal.framework/Metal", RTLD_NOW);
        void *MetalKit = dlopen("/System/Library/Frameworks/MetalKit.framework/MetalKit", RTLD_NOW);
        void *ModelIO = dlopen("/System/Library/Frameworks/ModelIO.framework/ModelIO", RTLD_NOW);
        
        auto MTLCreateSystemDefaultDevice = reinterpret_cast<id (*)()>(dlsym(Metal, "MTLCreateSystemDefaultDevice"));
        auto MTKMetalVertexDescriptorFromModelIOWithError = reinterpret_cast<id (*)(id, id *)>(dlsym(MetalKit, "MTKMetalVertexDescriptorFromModelIOWithError"));
        NSString *MDLVertexAttributePosition = *reinterpret_cast<id *>(dlsym(ModelIO, "MDLVertexAttributePosition"));
        
        id device = MTLCreateSystemDefaultDevice();
        id library = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(device, sel_registerName("newDefaultLibrary"));
        id commandQueue = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(device, sel_registerName("newCommandQueue"));
        NSUInteger colorPixelFormat = reinterpret_cast<NSUInteger (*)(id, SEL)>(objc_msgSend)(view, sel_registerName("colorPixelFormat"));
        
        //
        
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(view, sel_registerName("setDevice:"), device);
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(view, sel_registerName("setDelegate:"), self);
        reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(view, sel_registerName("setDepthStencilPixelFormat:"), 0 /* MTLPixelFormatInvalid */);
        reinterpret_cast<void (*)(id, SEL, MTLClearColor)>(objc_msgSend)(view, sel_registerName("setClearColor:"), {1.f, 1.f, 0.9f, 1.f});
        
        //
        
        id gridVertexFunction = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)(library, sel_registerName("newFunctionWithName:"), @"grid::vertex_main");
        id gridFragmentFunction = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)(library, sel_registerName("newFunctionWithName:"), @"grid::fragment_main");
        id colorVertexFunction = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)(library, sel_registerName("newFunctionWithName:"), @"color::vertex_main");
        id colorFragmentFunction = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)(library, sel_registerName("newFunctionWithName:"), @"color::fragment_main");
        
        [library release];
        
        //
        
        id gridVertexDescriptor = [objc_lookUpClass("MDLVertexDescriptor") new];
        
        id gridPositionVertexAttribute = [objc_lookUpClass("MDLVertexAttribute") new];
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(gridPositionVertexAttribute, sel_registerName("setName:"), MDLVertexAttributePosition);
        reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(gridPositionVertexAttribute, sel_registerName("setFormat:"), 0xC0000 | 3);
        reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(gridPositionVertexAttribute, sel_registerName("setOffset:"), 0);
        reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(gridPositionVertexAttribute, sel_registerName("setBufferIndex:"), 0);
        
        NSMutableArray *gridVertexAttributes = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(gridVertexDescriptor, sel_registerName("attributes"));
        gridVertexAttributes[0] = gridPositionVertexAttribute;
        [gridPositionVertexAttribute release];
        
        id gridVertexBufferLayout = [objc_lookUpClass("MDLVertexBufferLayout") new];
        reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(gridVertexBufferLayout, sel_registerName("setStride:"), sizeof(simd_float3));
        
        NSMutableArray *gridVertexLayouts = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(gridVertexDescriptor, sel_registerName("layouts"));
        gridVertexLayouts[0] = gridVertexBufferLayout;
        [gridVertexBufferLayout release];
        
        id gridRenderPipelineDescriptor = [objc_lookUpClass("MTLRenderPipelineDescriptor") new];
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(gridRenderPipelineDescriptor, sel_registerName("setVertexFunction:"), gridVertexFunction);
        [gridVertexFunction release];
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(gridRenderPipelineDescriptor, sel_registerName("setFragmentFunction:"), gridFragmentFunction);
        [gridFragmentFunction release];
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(gridRenderPipelineDescriptor, sel_registerName("setVertexDescriptor:"), MTKMetalVertexDescriptorFromModelIOWithError(gridVertexDescriptor, &error));
        [gridVertexDescriptor release];
        assert(error == nil);
        reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(gridRenderPipelineDescriptor, sel_registerName("setShaderValidation:"), 1 /* MTLShaderValidationEnabled */);
        
        id gridColorAttachments = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(gridRenderPipelineDescriptor, sel_registerName("colorAttachments"));
        id gridColorAttachmentDescriptor = reinterpret_cast<id (*)(id, SEL, NSUInteger)>(objc_msgSend)(gridColorAttachments, sel_registerName("objectAtIndexedSubscript:"), 0);
        reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(gridColorAttachmentDescriptor, sel_registerName("setPixelFormat:"), colorPixelFormat);
        
        id gridRenderPipelineState = reinterpret_cast<id (*)(id, SEL, id, id *)>(objc_msgSend)(device, sel_registerName("newRenderPipelineStateWithDescriptor:error:"), gridRenderPipelineDescriptor, &error);
        [gridRenderPipelineDescriptor release];
        assert(error == nil);
        
        Grid *grid = [[Grid alloc] initWithDevice:device];
        
        //
        
        id colorVertexDescriptor = [objc_lookUpClass("MDLVertexDescriptor") new];
        
        id colorPositionVertexAttribute = [objc_lookUpClass("MDLVertexAttribute") new];
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(colorPositionVertexAttribute, sel_registerName("setName:"), MDLVertexAttributePosition);
        reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(colorPositionVertexAttribute, sel_registerName("setFormat:"), 0xC0000 | 3);
        reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(colorPositionVertexAttribute, sel_registerName("setOffset:"), 0);
        reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(colorPositionVertexAttribute, sel_registerName("setBufferIndex:"), 0);
        
        NSMutableArray *colorVertexAttributes = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(colorVertexDescriptor, sel_registerName("attributes"));
        colorVertexAttributes[0] = colorPositionVertexAttribute;
        [colorPositionVertexAttribute release];
        
        id colorVertexBufferLayout = [objc_lookUpClass("MDLVertexBufferLayout") new];
        reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(colorVertexBufferLayout, sel_registerName("setStride:"), sizeof(simd_float3));
        
        NSMutableArray *colorVertexLayouts = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(colorVertexDescriptor, sel_registerName("layouts"));
        colorVertexLayouts[0] = colorVertexBufferLayout;
        [colorVertexBufferLayout release];
        
        id colorRenderPipelineDescriptor = [objc_lookUpClass("MTLRenderPipelineDescriptor") new];
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(colorRenderPipelineDescriptor, sel_registerName("setVertexFunction:"), colorVertexFunction);
        [colorVertexFunction release];
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(colorRenderPipelineDescriptor, sel_registerName("setFragmentFunction:"), colorFragmentFunction);
        [colorFragmentFunction release];
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(colorRenderPipelineDescriptor, sel_registerName("setVertexDescriptor:"), MTKMetalVertexDescriptorFromModelIOWithError(colorVertexDescriptor, &error));
        assert(error == nil);
        reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(colorRenderPipelineDescriptor, sel_registerName("setShaderValidation:"), 1 /* MTLShaderValidationEnabled */);
        
        id colorColorAttachments = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(colorRenderPipelineDescriptor, sel_registerName("colorAttachments"));
        id colorColorAttachmentDescriptor = reinterpret_cast<id (*)(id, SEL, NSUInteger)>(objc_msgSend)(colorColorAttachments, sel_registerName("objectAtIndexedSubscript:"), 0);
        reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(colorColorAttachmentDescriptor, sel_registerName("setPixelFormat:"), colorPixelFormat);
        
        id colorRenderPipelineState = reinterpret_cast<id (*)(id, SEL, id, id *)>(objc_msgSend)(device, sel_registerName("newRenderPipelineStateWithDescriptor:error:"), colorRenderPipelineDescriptor, &error);
        [colorRenderPipelineDescriptor release];
        assert(error == nil);
        
        id allocator = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("MTKMeshBufferAllocator") alloc], sel_registerName("initWithDevice:"), device);
        id colorMDLMesh = reinterpret_cast<id (*)(id, SEL, simd_float3, simd_uint2, NSUInteger, id)>(objc_msgSend)([objc_lookUpClass("MDLMesh") alloc], sel_registerName("initPlaneWithExtent:segments:geometryType:allocator:"), simd_make_float3(2.f, 2.f, 2.f), simd_make_uint2(1, 1), 2 /* MDLGeometryTypeTriangles */, allocator);
        [allocator release];
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(colorMDLMesh, sel_registerName("setVertexDescriptor:"), colorVertexDescriptor);
        [colorVertexDescriptor release];
        id colorMTKMesh = reinterpret_cast<id (*)(id, SEL, id, id, id *)>(objc_msgSend)([objc_lookUpClass("MTKMesh") alloc], sel_registerName("initWithMesh:device:error:"), colorMDLMesh, device, &error);
        [colorMDLMesh release];
        assert(error == nil);
        
        //
        
        _showGrid = YES;
        _device = [device retain];
        _commandQueue = [commandQueue retain];
        _gridRenderPipelineState = [gridRenderPipelineState retain];
        _colorRenderPipelineState = [colorRenderPipelineState retain];
        _grid = [grid retain];
        _colorMTKMesh = [colorMTKMesh retain];
        
        [device release];
        [commandQueue release];
        [gridRenderPipelineState release];
        [colorRenderPipelineState release];
        [grid release];
        [colorMTKMesh release];
    }
    
    return self;
}

- (void)dealloc {
    [_view release];
    [_device release];
    [_commandQueue release];
    [_gridRenderPipelineState release];
    [_colorRenderPipelineState release];
    [_grid release];
    [_colorMTKMesh release];
    [super dealloc];
}

- (void)mtkView:(id)view drawableSizeWillChange:(CGSize)size {
    _size = size;
}

- (void)drawInMTKView:(id)view {
    if (_colorPivot >= 1.f) {
        _isColorPivotIncreasing = NO;
    } else if (_colorPivot <= 0.f) {
        _isColorPivotIncreasing = YES;
    }
    
    if (_isColorPivotIncreasing) {
        _colorPivot += 0.005;
    } else {
        _colorPivot -= 0.005;
    }
    
    //
    
    id commandBufferDescriptor = [objc_lookUpClass("MTLCommandBufferDescriptor") new];
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(commandBufferDescriptor, sel_registerName("setRetainedReferences:"), NO);
    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(commandBufferDescriptor, sel_registerName("setErrorOptions:"), 1 << 0 /* MTLCommandBufferErrorOptionEncoderExecutionStatus */);
    
    id commandBuffer = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)(_commandQueue, sel_registerName("commandBufferWithDescriptor:"), commandBufferDescriptor);
    [commandBufferDescriptor release];
    
    id renderPassDescriptor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(view, sel_registerName("currentRenderPassDescriptor"));
    id renderCommandEncoder = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)(commandBuffer, sel_registerName("renderCommandEncoderWithDescriptor:"), renderPassDescriptor);
    
    //
    
    simd_uint2 size = simd_make_uint2(_size.width, _size.height);
    reinterpret_cast<void (*)(id, SEL, const void *, NSUInteger, NSUInteger)>(objc_msgSend)(renderCommandEncoder, sel_registerName("setFragmentBytes:length:atIndex:"), &size, sizeof(simd_uint2), 0);
    reinterpret_cast<void (*)(id, SEL, const void *, NSUInteger, NSUInteger)>(objc_msgSend)(renderCommandEncoder, sel_registerName("setFragmentBytes:length:atIndex:"), &_colorPivot, sizeof(float), 1);
    
    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(renderCommandEncoder, sel_registerName("setTriangleFillMode:"), 0 /* MTLTriangleFillModeFill */);
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(renderCommandEncoder, sel_registerName("setRenderPipelineState:"), _colorRenderPipelineState);
    
    NSArray *colorMTKMeshVertexBuffers = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(_colorMTKMesh, sel_registerName("vertexBuffers"));
    [colorMTKMeshVertexBuffers enumerateObjectsUsingBlock:^(id  _Nonnull meshBuffer, NSUInteger idx, BOOL * _Nonnull stop) {
        id buffer = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(meshBuffer, sel_registerName("buffer"));
        reinterpret_cast<void (*)(id, SEL, id, NSUInteger, NSUInteger)>(objc_msgSend)(renderCommandEncoder, sel_registerName("setVertexBuffer:offset:atIndex:"), buffer, 0, idx);
    }];
    
    NSArray *colorMTKSubmeshes = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(_colorMTKMesh, sel_registerName("submeshes"));
    for (id submesh in colorMTKSubmeshes) {
        NSUInteger indexCount = reinterpret_cast<NSUInteger (*)(id, SEL)>(objc_msgSend)(submesh, sel_registerName("indexCount"));
        NSUInteger indexType = reinterpret_cast<NSUInteger (*)(id, SEL)>(objc_msgSend)(submesh, sel_registerName("indexType"));
        id indexBuffer = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(submesh, sel_registerName("indexBuffer"));
        id buffer = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(indexBuffer, sel_registerName("buffer"));
        NSUInteger offset = reinterpret_cast<NSUInteger (*)(id, SEL)>(objc_msgSend)(indexBuffer, sel_registerName("offset"));
        
        reinterpret_cast<void (*)(id, SEL, NSUInteger, NSUInteger, NSUInteger, id, NSUInteger)>(objc_msgSend)(renderCommandEncoder, sel_registerName("drawIndexedPrimitives:indexCount:indexType:indexBuffer:indexBufferOffset:"), 3 /* MTLPrimitiveTypeTriangle */, indexCount, indexType, buffer, offset);
    }
    
    //
    
    if (_showGrid) {
        reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(renderCommandEncoder, sel_registerName("setTriangleFillMode:"), 1 /* MTLTriangleFillModeLines */);
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(renderCommandEncoder, sel_registerName("setRenderPipelineState:"), _gridRenderPipelineState);
        reinterpret_cast<void (*)(id, SEL, id, NSUInteger, NSUInteger)>(objc_msgSend)(renderCommandEncoder, sel_registerName("setVertexBuffer:offset:atIndex:"), _grid.vertexBuffer, 0, 0);
        reinterpret_cast<void (*)(id, SEL, NSUInteger, NSUInteger, NSUInteger, id, NSUInteger)>(objc_msgSend)(renderCommandEncoder, sel_registerName("drawIndexedPrimitives:indexCount:indexType:indexBuffer:indexBufferOffset:"), 1 /* MTLPrimitiveTypeLine */, _grid.indices.size(), 0 /* MTLIndexTypeUInt16 */, _grid.indexBuffer, 0);
    }
    
    //
    
    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(renderCommandEncoder, sel_registerName("endEncoding"));
    
    id currentDrawable = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(view, sel_registerName("currentDrawable"));
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(commandBuffer, sel_registerName("presentDrawable:"), currentDrawable);
    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(commandBuffer, sel_registerName("commit"));
}

@end
