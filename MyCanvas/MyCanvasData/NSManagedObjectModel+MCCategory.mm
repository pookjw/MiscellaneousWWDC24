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
    
    NSEntityDescription *customItemEntity;
    {
        customItemEntity = [NSEntityDescription new];
        customItemEntity.name = @"CustomItem";
        customItemEntity.managedObjectClassName = NSStringFromClass([MCCustomItem class]);
        
        NSAttributeDescription *systemImageNameDescription = [NSAttributeDescription new];
        systemImageNameDescription.name = @"systemImageName";
        systemImageNameDescription.optional = YES;
        systemImageNameDescription.attributeType = NSStringAttributeType;
        systemImageNameDescription.preservesValueInHistoryOnDeletion = YES;
        
        NSCompositeAttributeDescription *frameDescription;
        {
            frameDescription = [NSCompositeAttributeDescription new];
            frameDescription.name = @"frame";
            frameDescription.optional = YES;
            frameDescription.preservesValueInHistoryOnDeletion = YES;
            
            NSAttributeDescription *xDescription = [NSAttributeDescription new];
            xDescription.name = @"x";
            xDescription.attributeType = NSDoubleAttributeType;
            xDescription.preservesValueInHistoryOnDeletion = YES;
            
            NSAttributeDescription *yDescription = [NSAttributeDescription new];
            yDescription.name = @"y";
            yDescription.attributeType = NSDoubleAttributeType;
            yDescription.preservesValueInHistoryOnDeletion = YES;
            
            NSAttributeDescription *widthDescription = [NSAttributeDescription new];
            widthDescription.name = @"width";
            widthDescription.attributeType = NSDoubleAttributeType;
            widthDescription.preservesValueInHistoryOnDeletion = YES;
            
            NSAttributeDescription *heightDescription = [NSAttributeDescription new];
            heightDescription.name = @"height";
            heightDescription.attributeType = NSDoubleAttributeType;
            heightDescription.preservesValueInHistoryOnDeletion = YES;
            
            frameDescription.elements = @[
                xDescription,
                yDescription,
                widthDescription,
                heightDescription
            ];
            
            [xDescription release];
            [yDescription release];
            [widthDescription release];
            [heightDescription release];
        }
        
        NSCompositeAttributeDescription *transformDescription;
        {
            transformDescription = [NSCompositeAttributeDescription new];
            transformDescription.name = @"transform";
            transformDescription.optional = YES;
            transformDescription.preservesValueInHistoryOnDeletion = YES;
            
            NSAttributeDescription *aDescription = [NSAttributeDescription new];
            aDescription.name = @"x";
            aDescription.attributeType = NSDoubleAttributeType;
            aDescription.preservesValueInHistoryOnDeletion = YES;
            
            NSAttributeDescription *bDescription = [NSAttributeDescription new];
            bDescription.name = @"b";
            bDescription.attributeType = NSDoubleAttributeType;
            bDescription.preservesValueInHistoryOnDeletion = YES;
            
            NSAttributeDescription *cDescription = [NSAttributeDescription new];
            cDescription.name = @"c";
            cDescription.attributeType = NSDoubleAttributeType;
            cDescription.preservesValueInHistoryOnDeletion = YES;
            
            NSAttributeDescription *dDescription = [NSAttributeDescription new];
            dDescription.name = @"d";
            dDescription.attributeType = NSDoubleAttributeType;
            dDescription.preservesValueInHistoryOnDeletion = YES;
            
            NSAttributeDescription *txDescription = [NSAttributeDescription new];
            txDescription.name = @"tx";
            txDescription.attributeType = NSDoubleAttributeType;
            txDescription.preservesValueInHistoryOnDeletion = YES;
            
            NSAttributeDescription *tyDescription = [NSAttributeDescription new];
            tyDescription.name = @"ty";
            tyDescription.attributeType = NSDoubleAttributeType;
            tyDescription.preservesValueInHistoryOnDeletion = YES;
            
            transformDescription.elements = @[
                aDescription,
                bDescription,
                cDescription,
                dDescription,
                txDescription,
                tyDescription
            ];
            
            [aDescription release];
            [bDescription release];
            [cDescription release];
            [dDescription release];
            [txDescription release];
            [tyDescription release];
        }
        
        NSCompositeAttributeDescription *tintColorDescription;
        {
            tintColorDescription = [NSCompositeAttributeDescription new];
            tintColorDescription.name = @"tintColor";
            tintColorDescription.optional = YES;
            tintColorDescription.preservesValueInHistoryOnDeletion = YES;
            
            NSAttributeDescription *colorSpaceNameDescription = [NSAttributeDescription new];
            colorSpaceNameDescription.name = @"colorSpaceName";
            colorSpaceNameDescription.attributeType = NSStringAttributeType;
            colorSpaceNameDescription.preservesValueInHistoryOnDeletion = YES;
            
            NSAttributeDescription *componentsDescription = [NSAttributeDescription new];
            componentsDescription.name = @"components";
            componentsDescription.attributeType = NSTransformableAttributeType;
            componentsDescription.preservesValueInHistoryOnDeletion = YES;
            componentsDescription.valueTransformerName = NSSecureUnarchiveFromDataTransformerName;
            componentsDescription.attributeValueClassName = NSStringFromClass([NSArray class]);
            
            tintColorDescription.elements = @[
                colorSpaceNameDescription,
                componentsDescription
            ];
            
            [colorSpaceNameDescription release];
            [componentsDescription release];
        }
        
        customItemEntity.properties = @[
            systemImageNameDescription,
            frameDescription,
            tintColorDescription,
            transformDescription
        ];
        
        [systemImageNameDescription release];
        [frameDescription release];
        [tintColorDescription release];
        [transformDescription release];
    }
    
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
            toolPickerStateDescription,
        ];
        
        [lastEditedDateDescription release];
        [drawingDescription release];
        [toolPickerStateDescription release];
        
        canvasEntity.uniquenessConstraints = @[@[@"lastEditedDate"]];
    }
    
    {
        NSRelationshipDescription *canvasToCustomItemsDescription = [NSRelationshipDescription new];
        canvasToCustomItemsDescription.name = @"customItems";
        canvasToCustomItemsDescription.ordered = YES;
        canvasToCustomItemsDescription.minCount = 0;
        canvasToCustomItemsDescription.maxCount = 0;
        canvasToCustomItemsDescription.deleteRule = NSCascadeDeleteRule;
        canvasToCustomItemsDescription.destinationEntity = customItemEntity;
        
        NSRelationshipDescription *customItemToCanvasDescription = [NSRelationshipDescription new];
        customItemToCanvasDescription.name = @"canvas";
        customItemToCanvasDescription.ordered = NO;
        customItemToCanvasDescription.minCount = 0;
        customItemToCanvasDescription.maxCount = 1;
        customItemToCanvasDescription.deleteRule = NSNullifyDeleteRule;
        customItemToCanvasDescription.destinationEntity = canvasEntity;
        
        canvasToCustomItemsDescription.inverseRelationship = customItemToCanvasDescription;
        customItemToCanvasDescription.inverseRelationship = canvasToCustomItemsDescription;
        
        canvasEntity.properties = [canvasEntity.properties arrayByAddingObject:canvasToCustomItemsDescription];
        customItemEntity.properties = [customItemEntity.properties arrayByAddingObject:customItemToCanvasDescription];
        
        [canvasToCustomItemsDescription release];
        [customItemToCanvasDescription release];
    }
    
    model.entities = @[
        canvasEntity,
        customItemEntity
    ];
    
    [canvasEntity release];
    [customItemEntity release];
    
    return [model autorelease];
}

@end
