#import <UIKitPrivate/_UIColorPalette.h>
#import <UIKitPrivate/_UIDirectionalLightPalette.h>

NS_HEADER_AUDIT_BEGIN(nullability, sendability)

API_AVAILABLE(ios(18.0), visionos(2.0))
@interface _UIDirectionalLightConfiguration : NSObject
@property (retain, nonatomic) _UIColorPalette *colorPalette;
@property (nonatomic) NSUInteger direction;
@property (nonatomic) BOOL reverse;
@property (nonatomic) NSTimeInterval duration;
@property (retain, nonatomic) _UIDirectionalLightPalette *palette;
- (instancetype)initWithColorPalette:(_UIColorPalette *)colorPalette;
- (instancetype)initWithPalette:(_UIDirectionalLightPalette *)palette; 
@end

NS_HEADER_AUDIT_END(nullability, sendability)
