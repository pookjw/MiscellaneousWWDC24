//
//  MCCustomItem.mm
//  MyCanvasData
//
//  Created by Jinwoo Kim on 3/8/25.
//

#import <MyCanvasData/MCCustomItem.h>
#include <vector>
#include <ranges>

@implementation MCCustomItem
@dynamic systemImageName;
@dynamic frame;
@dynamic tintColor;
@dynamic canvas;
@dynamic transform;

- (CGRect)cgFrame {
    if (NSDictionary<NSString *, id> *frame = self.frame) {
        auto x = static_cast<NSNumber *>(frame[@"x"]).doubleValue;
        auto y = static_cast<NSNumber *>(frame[@"y"]).doubleValue;
        auto width = static_cast<NSNumber *>(frame[@"width"]).doubleValue;
        auto height = static_cast<NSNumber *>(frame[@"height"]).doubleValue;
        
        return CGRectMake(x, y, width, height);
    }
    
    return CGRectNull;
}

- (void)setCGFrame:(CGRect)cgFrame {
    if (CGRectIsNull(cgFrame)) {
        self.frame = nil;
        return;
    }
    
    self.frame = @{
        @"x": @(CGRectGetMinX(cgFrame)),
        @"y": @(CGRectGetMinY(cgFrame)),
        @"width": @(CGRectGetWidth(cgFrame)),
        @"height": @(CGRectGetHeight(cgFrame)),
    };
}

- (CGColorRef)cgTintColor CF_RETURNS_RETAINED {
    if (NSDictionary<NSString *, id> *tintColor = self.tintColor) {
        NSString *colorSpaceName = tintColor[@"colorSpaceName"];
        NSArray<NSNumber *> *components = tintColor[@"components"];
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName((CFStringRef)colorSpaceName);
        
        std::vector<NSNumber *> numbers(components.count);
        [components getObjects:numbers.data() range:NSMakeRange(0, components.count)];
        
        std::vector<CGFloat> cgFloats = numbers
        | std::views::transform([](NSNumber *number) -> CGFloat {
#if CGFLOAT_IS_DOUBLE
            return number.doubleValue;
#else
            return number.floatValue;
#endif
        })
        | std::ranges::to<std::vector<CGFloat>>();
        
        CGColorRef color = CGColorCreate(colorSpace, cgFloats.data());
        CGColorSpaceRelease(colorSpace);
        
        return color;
    }
    
    return NULL;
}

- (void)setCGTintColor:(CGColorRef)cgTintColor {
    if (cgTintColor == NULL) {
        self.tintColor = nil;
        return;
    }
    
    CGColorSpaceRef colorSpace = CGColorGetColorSpace(cgTintColor);
    NSString *colorSpaceName = (NSString *)CGColorSpaceGetName(colorSpace);
    const CGFloat * _Nullable components = CGColorGetComponents(cgTintColor);
    if ((colorSpaceName == nil) or (components == NULL)) {
        self.tintColor = nil;
        return;
    }
    size_t numberOfComponents = CGColorGetNumberOfComponents(cgTintColor);
    
    auto componentNumbers = std::views::iota(components, components + numberOfComponents)
    | std::views::transform([](const CGFloat *ptr) {
        return @(*ptr);
    })
    | std::ranges::to<std::vector<NSNumber *>>();
    NSArray<NSNumber *> *componentsArray = [[NSArray alloc] initWithObjects:componentNumbers.data() count:componentNumbers.size()];
    
    self.tintColor = @{
        @"colorSpaceName": colorSpaceName,
        @"components": componentsArray
    };
    
    [componentsArray release];
}

- (CGAffineTransform)cgAffineTransform {
    if (NSDictionary<NSString *, id> *transform = self.transform) {
        auto aNumber = static_cast<NSNumber *>(transform[@"a"]);
        auto bNumber = static_cast<NSNumber *>(transform[@"b"]);
        auto cNumber = static_cast<NSNumber *>(transform[@"c"]);
        auto dNumber = static_cast<NSNumber *>(transform[@"d"]);
        auto txNumber = static_cast<NSNumber *>(transform[@"tx"]);
        auto tyNumber = static_cast<NSNumber *>(transform[@"ty"]);
        
        CGFloat a;
        CGFloat b;
        CGFloat c;
        CGFloat d;
        CGFloat tx;
        CGFloat ty;
        
#if CGFLOAT_IS_DOUBLE
        a = aNumber.doubleValue;
        b = bNumber.doubleValue;
        c = cNumber.doubleValue;
        d = dNumber.doubleValue;
        tx = txNumber.doubleValue;
        ty = tyNumber.doubleValue;
#else
        a = aNumber.floatValue;
        b = bNumber.floatValue;
        c = cNumber.floatValue;
        d = dNumber.floatValue;
        tx = txNumber.floatValue;
        ty = tyNumber.floatValue;
#endif
        
        return CGAffineTransformMake(a, b, c, d, tx, ty);
    }
    
    return CGAffineTransformIdentity;
}

- (void)setCGAffineTransform:(CGAffineTransform)cgAffineTransform {
    self.transform = @{
        @"a": @(cgAffineTransform.a),
        @"b": @(cgAffineTransform.b),
        @"c": @(cgAffineTransform.c),
        @"d": @(cgAffineTransform.d),
        @"tx": @(cgAffineTransform.tx),
        @"ty": @(cgAffineTransform.ty)
    };
}

@end
