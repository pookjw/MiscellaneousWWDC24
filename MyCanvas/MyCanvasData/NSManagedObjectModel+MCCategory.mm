//
//  NSManagedObjectModel+MCCategory.mm
//  MyCanvasData
//
//  Created by Jinwoo Kim on 3/6/25.
//

#import <MyCanvasData/NSManagedObjectModel+MCCategory.h>
#import <MyCanvasData/MCCanvas.h>
#import <MyCanvasData/MCPencilKitDrawingTransformer.h>

@implementation NSManagedObjectModel (MCCategory)

+ (NSManagedObjectModel *)mc_makeModel {
    NSManagedObjectModel *model = [NSManagedObjectModel new];
    
    NSEntityDescription *canvasEntity;
    {
        canvasEntity = [NSEntityDescription new];
        canvasEntity.name = @"Canvas";
        canvasEntity.managedObjectClassName = NSStringFromClass([MCCanvas class]);
        
        NSAttributeDescription *lastEditedDateDescription = [NSAttributeDescription new];
        lastEditedDateDescription.name = @"lastEditedDate";
        lastEditedDateDescription.optional = YES;
        lastEditedDateDescription.attributeType = NSDateAttributeType;
        lastEditedDateDescription.preservesValueInHistoryOnDeletion = YES;
        
        NSAttributeDescription *drawingDescription = [NSAttributeDescription new];
        drawingDescription.name = @"drawing";
        drawingDescription.optional = YES;
        drawingDescription.attributeType = NSTransformableAttributeType;
        drawingDescription.valueTransformerName = MCPencilKitDrawingTransformer.transformerName;
        drawingDescription.attributeValueClassName = NSStringFromClass([PKDrawing class]);
        drawingDescription.preservesValueInHistoryOnDeletion = YES;
        
        NSAttributeDescription *toolPickerStateDescription = [NSAttributeDescription new];
        toolPickerStateDescription.name = @"toolPickerState";
        toolPickerStateDescription.optional = YES;
        toolPickerStateDescription.attributeType = NSTransformableAttributeType;
        toolPickerStateDescription.valueTransformerName = NSSecureUnarchiveFromDataTransformerName;
        toolPickerStateDescription.attributeValueClassName = NSStringFromClass([NSDictionary class]);
        toolPickerStateDescription.preservesValueInHistoryOnDeletion = YES;
        
        canvasEntity.properties = @[
            lastEditedDateDescription,
            drawingDescription,
            toolPickerStateDescription
        ];
        
        [lastEditedDateDescription release];
        [drawingDescription release];
        [toolPickerStateDescription release];
        
        canvasEntity.uniquenessConstraints = @[@[@"lastEditedDate"]];
    }
    
    model.entities = @[
        canvasEntity
    ];
    [canvasEntity release];
    
    return [model autorelease];
}

@end
