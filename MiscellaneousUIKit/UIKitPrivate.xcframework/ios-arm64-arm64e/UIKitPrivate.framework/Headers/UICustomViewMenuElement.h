#import <UIKit/UIKit.h>

NS_HEADER_AUDIT_BEGIN(nullability, sendability)

NS_SWIFT_UI_ACTOR
@interface UICustomViewMenuElement : UIMenuElement
+ (UICustomViewMenuElement *)elementWithViewProvider:(__kindof UIView * (^)(UICustomViewMenuElement *element))viewProvider;
@property (copy, nonatomic, nullable) void (^primaryActionHandler)(UICustomViewMenuElement *element);
@end

NS_HEADER_AUDIT_END(nullability, sendability)
