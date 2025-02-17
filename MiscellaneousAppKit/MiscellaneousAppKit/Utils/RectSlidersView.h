//
//  RectSlidersView.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/14/25.
//

#import <Cocoa/Cocoa.h>
#import "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MA_EXTERN NSNotificationName const RectSlidersViewDidChangeValueNotification;

MA_EXTERN NSString * const RectSlidersIsTrackingKey;
MA_EXTERN NSString * const RectSlidersConfigurationKey;
MA_EXTERN NSString * const RectSlidersChangedKeyPath;

typedef NSString * RectSlidersKeyPath NS_TYPED_ENUM;
MA_EXTERN RectSlidersKeyPath const RectSlidersKeyPathX;
MA_EXTERN RectSlidersKeyPath const RectSlidersKeyPathY;
MA_EXTERN RectSlidersKeyPath const RectSlidersKeyPathWidth;
MA_EXTERN RectSlidersKeyPath const RectSlidersKeyPathHeight;

@interface RectSlidersConfiguration : NSObject <NSCopying, NSSecureCoding>
@property (assign, nonatomic, readonly) NSRect rect;
@property (assign, nonatomic, readonly) NSRect minRect;
@property (assign, nonatomic, readonly) NSRect maxRect;
@property (copy, nonatomic, readonly, nullable) NSSet<RectSlidersKeyPath> *keyPaths;
@property (copy, nonatomic, readonly, nullable) NSDictionary *userInfo;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithRect:(NSRect)rect minRect:(NSRect)minRect maxRect:(NSRect)maxRect keyPaths:(NSSet<RectSlidersKeyPath> * _Nullable)keyPaths userInfo:(NSDictionary * _Nullable)userInfo;
+ (RectSlidersConfiguration *)configurationWithRect:(NSRect)rect minRect:(NSRect)minRect maxRect:(NSRect)maxRect keyPaths:(NSSet<RectSlidersKeyPath> * _Nullable)keyPaths userInfo:(NSDictionary * _Nullable)userInfo;
- (RectSlidersConfiguration *)configurationWithNewRect:(NSRect)newRect;
@end

@interface RectSlidersView : NSView
@property (copy, nonatomic) RectSlidersConfiguration *configuration;
@end

NS_ASSUME_NONNULL_END
