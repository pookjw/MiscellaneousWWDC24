//
//  main.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/23/24.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSApplication *application = NSApplication.sharedApplication;
        
        AppDelegate *delegate = [AppDelegate new];
        application.delegate = delegate;
        
        [application run];
        [delegate release];
    }
    
    return EXIT_SUCCESS;
}
