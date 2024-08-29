//
//  ToggleImmersiveStylesSceneDelegate.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 8/29/24.
//

#import "ToggleImmersiveStylesSceneDelegate.h"
#import <objc/message.h>
#import <objc/runtime.h>

@implementation ToggleImmersiveStylesSceneDelegate

- (void)dealloc {
    [_window release];
    [super dealloc];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    BOOL responds = [super respondsToSelector:aSelector];
    
    if (!responds) {
        NSLog(@"%s", sel_getName(aSelector));
    }
    
    return responds;
}

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    id fbsScene = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(connectionOptions, sel_registerName("_fbsScene"));
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(fbsScene, sel_registerName("addObserver:"), self);
}

- (void)scene:(id)scene didUpdateSettings:(id)update {
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(update, sel_registerName("inspect:"), ^(id settings) {
        id otherSettings = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(settings, sel_registerName("otherSettings"));
        
        // allowedImmersionStyles : 3002, preferredImmersionStyle : 3001
        id value = reinterpret_cast<id (*)(id, SEL, NSUInteger)>(objc_msgSend)(otherSettings, sel_registerName("objectForSetting:"), 3001);
        
        NSLog(@"%@", value);
    });
}

@end
