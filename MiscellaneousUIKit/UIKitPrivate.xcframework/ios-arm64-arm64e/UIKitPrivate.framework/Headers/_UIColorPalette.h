#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

NS_HEADER_AUDIT_BEGIN(nullability, sendability)

API_AVAILABLE(ios(18.0), visionos(2.0))
@interface _UIColorPalette : NSObject
+ (_UIColorPalette *)_coolColors;
+ (_UIColorPalette *)_warmColors;
+ (_UIColorPalette *)intelligenceAmbientPalette;
+ (_UIColorPalette *)intelligenceComputedPalette;
+ (_UIColorPalette *)intelligenceProcessingPalette;
+ (_UIColorPalette *)intelligenceSymbolLivingColorPalette;
+ (_UIColorPalette *)textAssistantPonderingFillPalette;
+ (_UIColorPalette *)textAssistantPonderingLightSheenPalette;
+ (_UIColorPalette *)textAssistantReplacementBuildInPalette;
+ (_UIColorPalette *)textAssistantReplacementBuildOutPalette;
+ (_UIColorPalette *)textAssistantReplacementSheenPalette;
@property (copy, nonatomic, readonly) NSArray<UIColor *> *colors;
@property (copy, nonatomic, readonly) NSArray<NSNumber *> *locations;
@property (copy, nonatomic, readonly) NSString *colorSpaceName;
@property (nonatomic, readonly) CGGradientRef gradientRepresentation;
- (instancetype)initWithColors:(NSArray<UIColor *> *)colors;
- (instancetype)initWithColors:(NSArray<UIColor *> *)colors colorSpaceName:(NSString *)colorSpaceName;
- (_UIColorPalette *)paletteByMergingPalette:(_UIColorPalette *)palette;
@end

NS_HEADER_AUDIT_END(nullability, sendability)
