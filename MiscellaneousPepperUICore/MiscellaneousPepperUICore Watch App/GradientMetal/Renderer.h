//
//  Renderer.h
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 9/3/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Renderer : NSObject
@property (assign, nonatomic) BOOL showGrid;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithView:(id)view;
@end

NS_ASSUME_NONNULL_END
