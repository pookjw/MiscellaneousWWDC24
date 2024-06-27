//
//  RulerView.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/27/24.
//

#import "RulerView.h"

@implementation MyScrollView

+ (Class)rulerViewClass {
    return [RulerView class];
}

@end

@implementation RulerView

// 숫자 및 눈금자 커스텀
- (void)drawHashMarksAndLabelsInRect:(NSRect)rect {
    [super drawHashMarksAndLabelsInRect:rect];
}

@end
