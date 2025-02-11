//
//  main.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 6/29/24.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ToolBox.h"
#import <objc/message.h>
#import <objc/runtime.h>

int main(int argc, char * argv[]) {
    @autoreleasepool {
        [ToolBox MRUIDebugVerbose];
        
//        id rootSettings = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("MRUIOrnamentSettingsDomain"), sel_registerName("rootSettings"));
//        reinterpret_cast<void (*)(id, SEL, CGFloat)>(objc_msgSend)(rootSettings, sel_registerName("setSystemZOffset:"), 600.);
//        NSLog(@"%@", rootSettings);
        
        {
            NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"com.apple.UIKit"];
            
            [userDefaults setObject:@NO forKey:@"MRUIEnableOrnamentWindowDebugVis"];
            [userDefaults setObject:@NO forKey:@"MRUIEnableTextEffectstWindowDebugVis"];
            [userDefaults setObject:@YES forKey:@"InternalPreferencesEnabled"];
            
            [userDefaults release];
        }
        {
            NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"com.apple.UIKit.InternalPreferences"];
            
            [userDefaults setObject:@YES forKey:@"EnableVolumetricPresentations"];
            
            [userDefaults release];
        }
    }
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
