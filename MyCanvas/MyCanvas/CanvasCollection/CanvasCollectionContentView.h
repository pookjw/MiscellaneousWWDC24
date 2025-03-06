//
//  CanvasCollectionContentView.h
//  MyCanvas
//
//  Created by Jinwoo Kim on 3/6/25.
//

#import <UIKit/UIKit.h>
#import "CanvasCollectionContentConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

__attribute__((objc_direct_members))
@interface CanvasCollectionContentView : UIView <UIContentView>
- (instancetype)initWithConfiguration:(CanvasCollectionContentConfiguration *)configuration;
@end

NS_ASSUME_NONNULL_END
