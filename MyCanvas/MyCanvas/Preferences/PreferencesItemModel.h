//
//  PreferencesItemModel.h
//  MyCanvas
//
//  Created by Jinwoo Kim on 3/6/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PreferencesItemModelType) {
    PreferencesItemModelTypeDestoryAndExit
};

__attribute__((objc_direct_members))
@interface PreferencesItemModel : NSObject
@property (assign, nonatomic, readonly) PreferencesItemModelType type;
@property (copy, nonatomic, readonly, nullable) id (^valueResolver)(void);
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(PreferencesItemModelType)type valueResolver:(id (^ _Nullable)(void))valueResolver;
@end

NS_ASSUME_NONNULL_END
