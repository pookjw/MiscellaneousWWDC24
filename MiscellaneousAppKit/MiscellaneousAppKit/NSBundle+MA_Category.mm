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

- (NSString *)ma_localizedTableForKey:(NSString *)key {
    NSArray<NSURL *> *urls = [self URLsForResourcesWithExtension:@"loctable" subdirectory:nil];
    NSString *languageCode = NSLocale.currentLocale.languageCode;;
    
    for (NSURL *url in urls) {
        NSString *table = [url URLByDeletingPathExtension].lastPathComponent;
        
        NSDictionary<NSString *, NSString *> *strings = reinterpret_cast<id (*)(id, SEL, id, id)>(objc_msgSend)(self, sel_registerName("localizedStringsForTable:localization:"), table, languageCode);
        
        if ([strings.allKeys containsObject:key]) {
            return table;
        }
    }
    
    return nil;
}

@end
