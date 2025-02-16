#import <UIKit/UIKit.h>

NS_HEADER_AUDIT_BEGIN(nullability, sendability)

@interface UITextSuggestion : NSObject <NSCopying, NSSecureCoding>
// + (id) decodeTextSuggestions:(id)arg1;
// + (id) encodeTextSuggestions:(id)arg1;
+ (UITextSuggestion *)textSuggestionWithInputText:(NSString *)inputText;
+ (UITextSuggestion *)textSuggestionWithInputText:(NSString *)inputText searchText:(NSString *)searchText;
+ (UITextSuggestion *)textSuggestionWithInputText:(NSString *)inputText searchText:(NSString *)searchText customInfoType:(NSUInteger)customInfoType;
@property (copy, nonatomic) NSString* inputText;
@property (nonatomic) NSUInteger customInfoType;
// @property (readonly, nonatomic) TIKeyboardCandidate *_keyboardCandidate;
@property (readonly, nonatomic) NSUUID *uuid;
@property (copy, nonatomic) NSString *searchText;
@property (copy, nonatomic) NSString *displayText;
@property (copy, nonatomic) NSString *headerText;
@property (nonatomic) BOOL displayStylePlain;
@property (copy, nonatomic) UIImage *image;
@property (copy, nonatomic) UIColor *foregroundColor;
@property (copy, nonatomic) UIColor *backgroundColor;
@property (nonatomic) BOOL canDisplayInline;
- (instancetype)initWithInputText:(NSString *)inputText searchText:(NSString *)searchText displayText:(NSString *)displayText headerText:(NSString *)headerText customInfoType:(NSUInteger)customInfoType;
@end

NS_HEADER_AUDIT_END(nullability, sendability)
