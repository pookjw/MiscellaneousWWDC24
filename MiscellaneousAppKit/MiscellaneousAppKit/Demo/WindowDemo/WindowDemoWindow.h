//
//  WindowDemoWindow.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 1/31/25.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface WindowDemoWindow : NSWindow
@property (assign, nonatomic) BOOL tryToPerformEnabled;
- (void)cmdForTryToPerformWith:(id)object;
@end

NS_ASSUME_NONNULL_END
