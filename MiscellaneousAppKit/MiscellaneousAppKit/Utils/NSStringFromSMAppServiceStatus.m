//
//  NSStringFromSMAppServiceStatus.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/13/25.
//

#import "NSStringFromSMAppServiceStatus.h"

NSString * NSStringFromSMAppServiceStatus(SMAppServiceStatus status) {
    switch (status) {
        case SMAppServiceStatusNotRegistered:
            return @"Not Registered";
        case SMAppServiceStatusEnabled:
            return @"Enabled";
        case SMAppServiceStatusRequiresApproval:
            return @"Requires Approval";
        case SMAppServiceStatusNotFound:
            return @"Not Found";
        default:
            abort();
    }
}
