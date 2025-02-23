//
//  NSBundle+MA_Category.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 1/31/25.
//

#import "NSBundle+MA_Category.h"
#import <objc/message.h>
#import <objc/runtime.h>
#include <dlfcn.h>
#include <execinfo.h>

namespace ma_NSBundle {

namespace bundleIdentifier {
NSString * (*original)(NSBundle *self, SEL _cmd);
NSString * custom(NSBundle *self, SEL _cmd) {
    if (![NSBundle.mainBundle isEqual:self]) {
        return original(self, _cmd);
    }
    
    void *buffer[2];
    int count = backtrace(buffer, 2);
    
    if (count < 2) {
        return original(self, _cmd);
    }
    
    void *addr = buffer[1];
    struct dl_info info;
    assert(dladdr(addr, &info) != 0);
    
    IMP baseAddr = class_getMethodImplementation(objc_lookUpClass("NSTextGenerationReceiver"), sel_registerName("init"));
    
    if (info.dli_saddr != baseAddr) {
        return original(self, _cmd);
    }
    
    return @"com.apple.mail";
}
void swizzle(void) {
    Method method = class_getInstanceMethod([NSBundle class], @selector(bundleIdentifier));
    original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}

}

}

@implementation NSBundle (MA_Category)

+ (void)load {
    ma_NSBundle::bundleIdentifier::swizzle();
}

+ (NSDictionary<NSString *,NSArray<NSString *> *> *)ma_nsKitLocalizedTablesForContatingKey:(NSString *)key {
    return [_NSKitBundle() ma_localizedTablesForContatingKey:key];
}

- (NSDictionary<NSString *, NSArray<NSString *> *> *)ma_localizedTablesForContatingKey:(NSString *)key {
    NSArray<NSURL *> *urls = [self URLsForResourcesWithExtension:@"loctable" subdirectory:nil];
    NSString *languageCode = NSLocale.currentLocale.languageCode;
    NSMutableDictionary<NSString *, NSArray<NSString *> *> *results = [NSMutableDictionary new];
    
    for (NSURL *url in urls) {
        NSString *table = [url URLByDeletingPathExtension].lastPathComponent;
        
        NSDictionary<NSString *, NSString *> *strings = reinterpret_cast<id (*)(id, SEL, id, id)>(objc_msgSend)(self, sel_registerName("localizedStringsForTable:localization:"), table, languageCode);
        
        NSMutableArray<NSString *> *keys = [NSMutableArray new];
        
        for (NSString *_key in strings.allKeys) {
            if ([_key localizedCaseInsensitiveContainsString:key]) {
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
