//
//  NSBundle+MA_Category.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 1/31/25.
//

#import "NSBundle+MA_Category.h"
#import <objc/message.h>
#import <objc/runtime.h>

@implementation NSBundle (MA_Category)

- (NSDictionary<NSString *, NSArray<NSString *> *> *)ma_localizedTablesForContatingKey:(NSString *)key {
    NSArray<NSURL *> *urls = [self URLsForResourcesWithExtension:@"loctable" subdirectory:nil];
    NSString *languageCode = NSLocale.currentLocale.languageCode;
    NSMutableDictionary<NSString *, NSArray<NSString *> *> *results = [NSMutableDictionary new];
    
    for (NSURL *url in urls) {
        NSString *table = [url URLByDeletingPathExtension].lastPathComponent;
        
        NSDictionary<NSString *, NSString *> *strings = reinterpret_cast<id (*)(id, SEL, id, id)>(objc_msgSend)(self, sel_registerName("localizedStringsForTable:localization:"), table, languageCode);
        
        NSMutableArray<NSString *> *keys = [NSMutableArray new];
        
        for (NSString *_key in strings.allKeys) {
            if ([_key containsString:key]) {
                [keys addObject:_key];
            }
        }
        
        if (keys.count > 1) {
            results[table] = keys;
        }
        
        [keys release];
    }
    
    return [results autorelease];
}

@end
