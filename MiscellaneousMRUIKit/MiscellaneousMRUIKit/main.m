//
//  main.m
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 6/29/24.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"com.apple.UIKit"];
        
        [userDefaults setObject:@NO forKey:@"MRUIEnableOrnamentWindowDebugVis"];
        [userDefaults setObject:@NO forKey:@"MRUIEnableTextEffectstWindowDebugVis"];
        
        [userDefaults release];
    }
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
