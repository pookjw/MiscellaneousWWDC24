//
//  NSStringFromPKContentVersion.h
//  MyCanvas
//
//  Created by Jinwoo Kim on 3/6/25.
//

#import <PencilKit/PencilKit.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MC_EXTERN NSString * NSStringFromPKContentVersion(PKContentVersion version);
MC_EXTERN PKContentVersion PKContentVersionFromString(NSString *string);
MC_EXTERN const PKContentVersion * allPKContentVersions(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END
