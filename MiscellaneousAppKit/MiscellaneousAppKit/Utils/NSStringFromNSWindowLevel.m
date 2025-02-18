//
//  NSStringFromNSWindowLevel.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/18/25.
//

#import "NSStringFromNSWindowLevel.h"

NSString * NSStringFromNSWindowLevel(NSWindowLevel level) {
    if (level == NSNormalWindowLevel) {
        return @"Normal";
    } else if (level == NSFloatingWindowLevel) {
        return @"Floating";
    } else if (level == NSSubmenuWindowLevel) { // NSSubmenuWindowLevel와 NSTornOffMenuWindowLevel은 동일한 값
        return @"Submenu";
    } else if (level == NSMainMenuWindowLevel) {
        return @"Main Menu";
    } else if (level == NSStatusWindowLevel) {
        return @"Status";
    } else if (level == NSModalPanelWindowLevel) {
        return @"Modal Panel";
    } else if (level == NSPopUpMenuWindowLevel) {
        return @"PopUp Menu";
    } else if (level == NSScreenSaverWindowLevel) {
        return @"Screen Saver";
    } else {
        abort();
    }
}

NSWindowLevel NSWindowLevelFromString(NSString *string) {
    if ([string isEqualToString:@"Normal"]) {
        return NSNormalWindowLevel;
    } else if ([string isEqualToString:@"Floating"]) {
        return NSFloatingWindowLevel;
    } else if ([string isEqualToString:@"Submenu"]) {
        return NSSubmenuWindowLevel;
    } else if ([string isEqualToString:@"Torn Off Menu"]) {
        return NSTornOffMenuWindowLevel;
    } else if ([string isEqualToString:@"Main Menu"]) {
        return NSMainMenuWindowLevel;
    } else if ([string isEqualToString:@"Status"]) {
        return NSStatusWindowLevel;
    } else if ([string isEqualToString:@"Modal Panel"]) {
        return NSModalPanelWindowLevel;
    } else if ([string isEqualToString:@"PopUp Menu"]) {
        return NSPopUpMenuWindowLevel;
    } else if ([string isEqualToString:@"Screen Saver"]) {
        return NSScreenSaverWindowLevel;
    } else {
        abort();
    }
}

NSWindowLevel * allNSWindowLevels(NSUInteger * _Nullable count) {
    static NSWindowLevel allLevels[] = {
        NSNormalWindowLevel,
        NSFloatingWindowLevel,
        NSSubmenuWindowLevel,
        NSTornOffMenuWindowLevel,
        NSMainMenuWindowLevel,
        NSStatusWindowLevel,
        NSModalPanelWindowLevel,
        NSPopUpMenuWindowLevel,
        NSScreenSaverWindowLevel
    };
    
    if (count != NULL) {
        *count = sizeof(allLevels) / sizeof(NSWindowLevel);
    }
    
    return allLevels;
}

