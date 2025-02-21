//
//  WindowDemoRestoration.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/21/25.
//

#import "WindowDemoRestoration.h"
#import "WindowDemoWindow.h"

@implementation WindowDemoRestoration

+ (void)restoreWindowWithIdentifier:(nonnull NSUserInterfaceItemIdentifier)identifier state:(nonnull NSCoder *)state completionHandler:(nonnull void (^)(NSWindow * _Nullable, NSError * _Nullable))completionHandler {
    WindowDemoWindow *window = [WindowDemoWindow new];
    completionHandler(window, nil);
    [window release];
}

@end
