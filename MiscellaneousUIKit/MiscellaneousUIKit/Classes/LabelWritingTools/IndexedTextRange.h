//
//  IndexedTextRange.h
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 12/7/24.
//

#import <UIKit/UIKit.h>
#import "IndexedTextPosition.h"

NS_ASSUME_NONNULL_BEGIN

@interface IndexedTextRange : UITextRange
@property (copy, nonatomic, readonly) IndexedTextPosition *start;
@property (copy, nonatomic, readonly) IndexedTextPosition *end;
@property (nonatomic, readonly) NSRange nsRange;
- (instancetype)initWithNSRange:(NSRange)range;
- (instancetype)initWithStart:(IndexedTextPosition *)start end:(IndexedTextPosition *)end;
@end

NS_ASSUME_NONNULL_END
