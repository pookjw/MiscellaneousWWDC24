//
//  main.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 1/31/25.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"

@interface NSWindow (FFCategory)
@end
@implementation NSWindow (FFCategory)
- (NSString *)frameString {
    return NSStringFromRect(self.frame);
}
- (NSString *)cascadingReferenceFrameString {
    return NSStringFromRect(self.cascadingReferenceFrame);
}
@end

/*
 NSBannerView
 NSWidgetView
 NSOcclusionDetectionView
 _NSBoxMaterialCapableCustomView
 convertRectToLayer:r
 */

int main(int argc, const char * argv[]) {
    // https://developer.apple.com/documentation/appkit/nswindow/miniwindowimage?language=objc
    [NSUserDefaults.standardUserDefaults setValue:@YES forKey:@"AppleDockIconEnabled"];
    
    AppDelegate *delegate = [AppDelegate new];
    NSApplication *application = NSApplication.sharedApplication;
    application.delegate = delegate;
    
    [application run];
    [delegate release];
    
    return 0;
}
