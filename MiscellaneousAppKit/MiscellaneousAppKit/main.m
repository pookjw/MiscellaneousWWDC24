//
//  main.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 1/31/25.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"

int main(int argc, const char * argv[]) {
    AppDelegate *delegate = [AppDelegate new];
    NSApplication *application = NSApplication.sharedApplication;
    application.delegate = delegate;
    
    [application run];
    [delegate release];
    
    return 0;
}
