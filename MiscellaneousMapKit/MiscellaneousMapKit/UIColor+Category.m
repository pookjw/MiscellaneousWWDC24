//
//  UIColor+Category.m
//  MiscellaneousMapKit
//
//  Created by Jinwoo Kim on 4/17/25.
//

#import "UIColor+Category.h"

@implementation UIColor (Category)

+ (UIColor *)mmp_randomColor {
    CGFloat red = arc4random_uniform(256) / 255.0;
    CGFloat green = arc4random_uniform(256) / 255.0;
    CGFloat blue = arc4random_uniform(256) / 255.0;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

@end
