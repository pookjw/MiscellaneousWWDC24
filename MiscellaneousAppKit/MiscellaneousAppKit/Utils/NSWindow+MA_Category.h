//
//  NSWindow+MA_Category.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/2/25.
//

#import <Cocoa/Cocoa.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MA_EXTERN NSNotificationName const MA_NSWindowActiveSpaceDidChangeNotification;
MA_EXTERN void startWindowActiveSpaceObservation(void);

NS_ASSUME_NONNULL_END
