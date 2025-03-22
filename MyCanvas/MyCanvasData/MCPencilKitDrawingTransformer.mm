//
//  MCPencilKitDrawingTransformer.m
//  MyCanvasData
//
//  Created by Jinwoo Kim on 3/6/25.
//

#import <MyCanvasData/MCPencilKitDrawingTransformer.h>
#import <PencilKit/PencilKit.h>

@implementation MCPencilKitDrawingTransformer

+ (NSValueTransformerName)transformerName {
    return @"MCPencilKitDrawing";
}

+ (void)load {
    MCPencilKitDrawingTransformer *transformer = [MCPencilKitDrawingTransformer new];
    [NSValueTransformer setValueTransformer:transformer forName:MCPencilKitDrawingTransformer.transformerName];
    [transformer release];
}

+ (NSArray<Class> *)allowedTopLevelClasses {
    return [[super allowedTopLevelClasses] arrayByAddingObject:[PKDrawing class]];
}

@end
