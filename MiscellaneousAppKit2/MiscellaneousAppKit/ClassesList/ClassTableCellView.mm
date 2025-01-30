//
//  ClassTableCellView.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/23/24.
//

#import "ClassTableCellView.h"

@implementation ClassTableCellView

- (void)setObjectValue:(id)objectValue {
    [super setObjectValue:objectValue];
    self.textField.stringValue = NSStringFromClass(objectValue);
}

@end
