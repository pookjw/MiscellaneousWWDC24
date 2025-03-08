//
//  MCCanvas.mm
//  MyCanvasData
//
//  Created by Jinwoo Kim on 3/6/25.
//

#import <MyCanvasData/MCCanvas.h>

@implementation MCCanvas
@dynamic lastEditedDate;
@dynamic drawing;
@dynamic toolPickerState;
@dynamic canvasImageData;
@dynamic customItemsImageData;
@dynamic customItems;

+ (NSFetchRequest<MCCanvas *> *)fetchRequest {
    return [[[NSFetchRequest alloc] initWithEntityName:@"Canvas"] autorelease];
}

@end
