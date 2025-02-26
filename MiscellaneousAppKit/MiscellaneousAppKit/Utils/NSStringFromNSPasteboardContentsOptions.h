//
//  NSStringFromNSPasteboardContentsOptions.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/23/25.
//

#import <Cocoa/Cocoa.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MA_EXTERN NSString * NSStringFromNSPasteboardContentsOptions(NSPasteboardContentsOptions options);
MA_EXTERN NSPasteboardContentsOptions NSPasteboardContentsOptionsFromString(NSString *string);
MA_EXTERN const NSPasteboardContentsOptions * allNSPasteboardContentsOptions(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END

