//
//  NSStringFromPKContentVersion.m
//  MyCanvas
//
//  Created by Jinwoo Kim on 3/6/25.
//

#import "NSStringFromPKContentVersion.h"

NSString * NSStringFromPKContentVersion(PKContentVersion version) {
    switch (version) {
        case PKContentVersion1:
            return @"version1";
        case PKContentVersion2:
            return @"version2";
        case PKContentVersion3:
            return @"version3";
        default:
            abort();
    }
}

PKContentVersion PKContentVersionFromString(NSString *string) {
    if ([string isEqualToString:@"version1"]) {
        return PKContentVersion1;
    } else if ([string isEqualToString:@"version2"]) {
        return PKContentVersion2;
    } else if ([string isEqualToString:@"version3"]) {
        return PKContentVersion3;
    } else {
        abort();
    }
}

const PKContentVersion * allPKContentVersions(NSUInteger * _Nullable count) {
    static const PKContentVersion allVersions[] = {
        PKContentVersion1,
        PKContentVersion2,
        PKContentVersion3
    };
    
    if (count != NULL) {
        *count = sizeof(allVersions) / sizeof(PKContentVersion);
    }
    
    return allVersions;
}
