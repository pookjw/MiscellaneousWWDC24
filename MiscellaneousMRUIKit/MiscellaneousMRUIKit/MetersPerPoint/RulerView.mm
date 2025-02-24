//
//  RulerView.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 2/9/25.
//

#import "RulerView.h"
#import <objc/message.h>
#import <objc/runtime.h>
#include <ranges>

@interface RulerView ()
@property (retain, nonatomic, getter=_pointsPerMeterRegistration, setter=_setPointsPerMeterRegistration:) id<UITraitChangeRegistration> pointsPerMeterRegistration;
@end

@implementation RulerView

- (void)dealloc {
    [_pointsPerMeterRegistration release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _commonInit_RulerView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self _commonInit_RulerView];
    }
    return self;
}

- (void)_commonInit_RulerView {
    self.contentMode = UIViewContentModeRedraw;
    self.backgroundColor = UIColor.clearColor;
    self.pointsPerMeterRegistration = [self registerForTraitChanges:@[objc_lookUpClass("UITraitPointsPerMeter")] withTarget:self action:@selector(_didChangePointsPerMeter:)];
    [self _didChangePointsPerMeter:self];
}

- (void)_didChangePointsPerMeter:(RulerView *)sender {
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGFloat _metersPerPoint = reinterpret_cast<CGFloat (*)(id, SEL)>(objc_msgSend)(self.traitCollection, sel_registerName("_metersPerPoint"));
    CGFloat _pointsPerMeter = reinterpret_cast<CGFloat (*)(id, SEL)>(objc_msgSend)(self.traitCollection, sel_registerName("_pointsPerMeter"));
    CGFloat meters = CGRectGetWidth(rect) * _metersPerPoint;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    {
        NSMeasurement *mesurement = [[NSMeasurement alloc] initWithDoubleValue:meters unit:NSUnitLength.meters];
        double centimeters = [mesurement measurementByConvertingToUnit:NSUnitLength.centimeters].doubleValue;
        [mesurement release];
        
        CATextLayer *textLayer = [CATextLayer new];
        textLayer.foregroundColor = UIColor.labelColor.CGColor;
        textLayer.fontSize = 20;
        textLayer.contentsScale = self.contentScaleFactor;
        textLayer.alignmentMode = kCAAlignmentCenter;
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 0., 0.);
        CGPathAddLineToPoint(path, NULL, 0., CGRectGetHeight(rect));
        
        for (NSInteger base : std::views::iota(0, static_cast<NSInteger>(ceil(centimeters / 4.0)))) {
            base *= 4;
            textLayer.string = @(base).stringValue;
            
            NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:textLayer.string attributes:@{NSFontAttributeName: (id)textLayer.font}];
            CGSize size = attributedString.size;
            [attributedString release];
            textLayer.frame = CGRectMake(0., 0., size.width, size.height);
            
            NSMeasurement *measurement = [[NSMeasurement alloc] initWithDoubleValue:base unit:NSUnitLength.centimeters];
            double meter = [measurement measurementByConvertingToUnit:NSUnitLength.meters].doubleValue;
            [measurement release];
            
            
            {
                CGContextSaveGState(ctx);
                CGAffineTransform translation = CGAffineTransformMakeTranslation(meter * _pointsPerMeter - size.width * 0.5,
                                                                                 self.safeAreaInsets.top);
                CGContextConcatCTM(ctx, translation);
                
                [textLayer renderInContext:ctx];
                CGContextRestoreGState(ctx);
            }
            
            {
                CGContextSaveGState(ctx);
                
                CGAffineTransform translation = CGAffineTransformMakeTranslation(meter * _pointsPerMeter,
                                                                                 self.safeAreaInsets.top + size.height);
                CGContextConcatCTM(ctx, translation);
                
                CGContextAddPath(ctx, path);
                CGContextSetLineWidth(ctx, 4.);
                CGContextSetRGBStrokeColor(ctx, 1., 1., 1., 0.5);
                CGContextDrawPath(ctx, kCGPathStroke);
                CGContextRestoreGState(ctx);
            }
        }
        
        [textLayer release];
        CGPathRelease(path);
    }
}

@end
