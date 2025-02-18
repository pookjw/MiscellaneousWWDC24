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
+ (NSDictionary<NSString *, NSArray<NSString *> *> *)ma_nsKitLocalizedTablesForContatingKey:(NSString *)key;
- (NSDictionary<NSString *, NSArray<NSString *> *> *)ma_localizedTablesForContatingKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
