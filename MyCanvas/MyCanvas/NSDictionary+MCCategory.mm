//
//  NSDictionary+MCCategory.mm
//  MyCanvasData
//
//  Created by Jinwoo Kim on 3/8/25.
//

#import "NSDictionary+MCCategory.h"

@implementation NSDictionary (MCCategory)

- (NSDictionary *)mc_nestedDictionary {
    NSMutableDictionary *result = [NSMutableDictionary new];
    
    for (NSString *key in self.allKeys) {
        if (![key isKindOfClass:[NSString class]]) {
            result[key] = self[key];
            continue;
        }
        
        NSArray<NSString *> *separated = [key componentsSeparatedByString:@"."];
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            return static_cast<NSString *>(evaluatedObject).length > 0;
        }];
        separated = [separated filteredArrayUsingPredicate:predicate];
        
        if (separated.count < 2) {
            result[key] = self[key];
            continue;
        }
        
        NSMutableDictionary *target = result;
        for (NSString *subkey in [separated subarrayWithRange:NSMakeRange(0, separated.count - 1)]) {
            NSMutableDictionary *existing = target[subkey];
            if (existing == nil) {
                NSMutableDictionary *newDic = [NSMutableDictionary dictionary];
                target[subkey] = newDic;
                existing = newDic;
            }
            target = existing;
        }
        
        target[separated.lastObject] = self[key];
    }
    
    return [result autorelease];
}

@end
