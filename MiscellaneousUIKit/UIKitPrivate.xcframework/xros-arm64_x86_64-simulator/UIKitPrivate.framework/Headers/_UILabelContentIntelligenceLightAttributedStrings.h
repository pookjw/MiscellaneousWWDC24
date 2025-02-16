#import <Foundation/Foundation.h>

NS_HEADER_AUDIT_BEGIN(nullability, sendability)

API_AVAILABLE(ios(18.0), visionos(2.0))
@interface _UILabelContentIntelligenceLightAttributedStrings : NSObject
@property (copy, nonatomic) NSAttributedString *lightReactiveAttributedString;
@property (copy, nonatomic) NSAttributedString *lightInertAttributedString;
@end

NS_HEADER_AUDIT_END(nullability, sendability)
