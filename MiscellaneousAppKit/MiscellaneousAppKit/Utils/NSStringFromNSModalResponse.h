//
//  NSStringFromNSModalResponse.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/14/25.
//

#import <Cocoa/Cocoa.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MA_EXTERN NSString * NSStringFromNSModalResponse(NSModalResponse response);
MA_EXTERN NSModalResponse NSModalResponseFromString(NSString *string);

NS_ASSUME_NONNULL_END
