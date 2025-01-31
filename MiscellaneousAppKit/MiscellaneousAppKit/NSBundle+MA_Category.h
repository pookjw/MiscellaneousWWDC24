//
//  NSBundle+MA_Category.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 1/31/25.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

APPKIT_EXTERN NSBundle * _NSKitBundle(void);
APPKIT_EXTERN NSString * _Nullable _NXKitString(NSString *table, NSString *key);

@interface NSBundle (MA_Category)
- (NSString * _Nullable)ma_localizedTableForKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
