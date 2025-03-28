//
//  TextInputLabel.h
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 12/7/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TextInputLabel : UILabel <UITextInput>
@property (assign, nonatomic) NSRange selectedRange;
- (void)reloadSelectedTextRange;
- (CGRect)_muk_boundingRectForCharacterRange:(NSRange)range;
@end

NS_ASSUME_NONNULL_END
