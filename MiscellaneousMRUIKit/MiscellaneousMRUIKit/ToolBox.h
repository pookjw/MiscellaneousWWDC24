//
//  ToolBox.h
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 2/11/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ToolBox : NSObject
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
+ (void)MRUISeparateAllViews;
+ (void)MRUIDebug;
+ (void)MRUIDebugVerbose;
+ (NSString *)MRUIEntityRecursiveDescription:(void *)entity;
@end

NS_ASSUME_NONNULL_END
