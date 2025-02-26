//
//  NSStringFromNSWindowStyleMask.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/1/25.
//

#import "NSStringFromNSWindowStyleMask.h"

NSString * NSStringFromNSWindowStyleMask(NSWindowStyleMask styleMask) {
    if (styleMask == NSWindowStyleMaskBorderless) {
        return @"Borderless";
    }
    
    NSMutableArray<NSString *> *strings = [NSMutableArray new];
    
    if (styleMask & NSWindowStyleMaskTitled) {
        [strings addObject:@"Titled"];
    }
    
    if (styleMask & NSWindowStyleMaskClosable) {
        [strings addObject:@"Closable"];
    }
    
    if (styleMask & NSWindowStyleMaskMiniaturizable) {
        [strings addObject:@"Miniaturizable"];
    }
    
    if (styleMask & NSWindowStyleMaskResizable) {
        [strings addObject:@"Resizable"];
    }
    
    if (styleMask & NSWindowStyleMaskTexturedBackground) {
        [strings addObject:@"TexturedBackground"];
    }
    
    if (styleMask & NSWindowStyleMaskUnifiedTitleAndToolbar) {
        [strings addObject:@"UnifiedTitleAndToolbar"];
    }
    
    if (styleMask & NSWindowStyleMaskFullScreen) {
        [strings addObject:@"FullScreen"];
    }
    
    if (styleMask & NSWindowStyleMaskFullSizeContentView) {
        [strings addObject:@"FullSizeContentView"];
    }
    
    if (styleMask & NSWindowStyleMaskUtilityWindow) {
        [strings addObject:@"UtilityWindow"];
    }
    
    if (styleMask & NSWindowStyleMaskDocModalWindow) {
        [strings addObject:@"DocModalWindow"];
    }
    
    if (styleMask & NSWindowStyleMaskNonactivatingPanel) {
        [strings addObject:@"NonactivatingPanel"];
    }
    
    if (styleMask & NSWindowStyleMaskHUDWindow) {
        [strings addObject:@"HUDWindow"];
    }
    
    NSString *string = [strings componentsJoinedByString:@", "];
    [strings release];
    
    return string;
}

NSWindowStyleMask NSWindowStyleMaskFromString(NSString *string) {
    if ([string isEqualToString:@"Borderless"]) {
        return NSWindowStyleMaskBorderless;
    }
    
    NSWindowStyleMask styleMask = 0;
    
    NSArray<NSString *> *components = [string componentsSeparatedByString:@", "];
    
    for (NSString *component in components) {
        if ([component isEqualToString:@"Titled"]) {
            styleMask |= NSWindowStyleMaskTitled;
        } else if ([component isEqualToString:@"Closable"]) {
            styleMask |= NSWindowStyleMaskClosable;
        } else if ([component isEqualToString:@"Miniaturizable"]) {
            styleMask |= NSWindowStyleMaskMiniaturizable;
        } else if ([component isEqualToString:@"Resizable"]) {
            styleMask |= NSWindowStyleMaskResizable;
        } else if ([component isEqualToString:@"TexturedBackground"]) {
            styleMask |= NSWindowStyleMaskTexturedBackground;
        } else if ([component isEqualToString:@"UnifiedTitleAndToolbar"]) {
            styleMask |= NSWindowStyleMaskUnifiedTitleAndToolbar;
        } else if ([component isEqualToString:@"FullScreen"]) {
            styleMask |= NSWindowStyleMaskFullScreen;
        } else if ([component isEqualToString:@"FullSizeContentView"]) {
            styleMask |= NSWindowStyleMaskFullSizeContentView;
        } else if ([component isEqualToString:@"UtilityWindow"]) {
            styleMask |= NSWindowStyleMaskUtilityWindow;
        } else if ([component isEqualToString:@"DocModalWindow"]) {
            styleMask |= NSWindowStyleMaskDocModalWindow;
        } else if ([component isEqualToString:@"NonactivatingPanel"]) {
            styleMask |= NSWindowStyleMaskNonactivatingPanel;
        } else if ([component isEqualToString:@"HUDWindow"]) {
            styleMask |= NSWindowStyleMaskHUDWindow;
        } else {
            abort();
        }
    }
    
    assert(styleMask != 0);
    return styleMask;
}

const NSWindowStyleMask * allNSWindowStyleMasks(NSUInteger * _Nullable count) {
    static const NSWindowStyleMask allMasks[] = {
        NSWindowStyleMaskBorderless,
        NSWindowStyleMaskTitled,
        NSWindowStyleMaskClosable,
        NSWindowStyleMaskMiniaturizable,
        NSWindowStyleMaskResizable,
        NSWindowStyleMaskTexturedBackground,
        NSWindowStyleMaskUnifiedTitleAndToolbar,
        NSWindowStyleMaskFullScreen,
        NSWindowStyleMaskFullSizeContentView,
        NSWindowStyleMaskUtilityWindow,
        NSWindowStyleMaskDocModalWindow,
        NSWindowStyleMaskNonactivatingPanel,
        NSWindowStyleMaskHUDWindow
    };
    
    if (count != NULL) {
        *count = sizeof(allMasks) / sizeof(NSWindowStyleMask);
    }
    
    return allMasks;
}
