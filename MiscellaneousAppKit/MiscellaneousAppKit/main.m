//
//  main.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/23/24.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"
#import "BaseMenu.hpp"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSApplication *application = NSApplication.sharedApplication;
        
        AppDelegate *delegate = [AppDelegate new];
        
        application.delegate = delegate;
        
        BaseMenu *menu = [BaseMenu new];
        application.menu = menu;
        [menu release];
        
        [application run];
        [delegate release];
    }
    
    return EXIT_SUCCESS;
}
