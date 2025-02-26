//
//  NSStringFromNSPasteboardAccessBehavior.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/23/25.
//

#import <Cocoa/Cocoa.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MA_EXTERN NSString * NSStringFromNSPasteboardAccessBehavior(NSPasteboardAccessBehavior behavior);
MA_EXTERN NSPasteboardAccessBehavior NSPasteboardAccessBehaviorFromString(NSString *string);
MA_EXTERN const NSPasteboardAccessBehavior * allNSPasteboardAccessBehaviors(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END
