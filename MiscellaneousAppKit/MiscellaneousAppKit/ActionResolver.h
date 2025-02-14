//
//  ActionResolver.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/14/25.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface ActionResolver : NSObject
@property (class, nonatomic, readonly) SEL action;
@property (copy, nonatomic, readonly) void (^resolver)(id sender);
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithResolver:(void (^)(id sender))resolver;
+ (ActionResolver *)resolver:(void (^)(id sender))resolver;
- (void)setupMenuItem:(NSMenuItem *)menuItem;
- (void)setupControl:(NSControl *)control;
@end

NS_ASSUME_NONNULL_END
