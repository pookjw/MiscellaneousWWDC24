//
//  IndexedTextPosition.h
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 12/7/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IndexedTextPosition : UITextPosition <NSCopying>
@property (assign, nonatomic, readonly) NSInteger index;
- (instancetype)initWithIndex:(NSInteger)index;
- (NSComparisonResult)compare:(IndexedTextPosition *)otherPosition;
@end

NS_ASSUME_NONNULL_END
