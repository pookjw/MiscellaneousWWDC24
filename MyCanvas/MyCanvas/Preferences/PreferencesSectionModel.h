//
//  PreferencesSectionModel.h
//  MyCanvas
//
//  Created by Jinwoo Kim on 3/6/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PreferencesSectionModelType) {
    PreferencesSectionModelTypeCoreData
};

__attribute__((objc_direct_members))
@interface PreferencesSectionModel : NSObject
@property (assign, nonatomic, readonly) PreferencesSectionModelType type;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(PreferencesSectionModelType)type;
@end

NS_ASSUME_NONNULL_END
