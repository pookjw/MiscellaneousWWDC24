//
//  NSWindow+MA_Category.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 2/2/25.
//

#import "NSWindow+MA_Category.h"
#import <objc/message.h>
#import <objc/runtime.h>
#include <dlfcn.h>

/*
 https://github.com/NUIKit/CGSInternal/blob/master/CGSEvent.h#L202
 
 More Types:
 ____NSDoOneTimeWindowNotificationRegistration_block_invoke
 */

NSNotificationName const MA_NSWindowActiveSpaceDidChangeNotification = @"MA_NSWindowActiveSpaceDidChangeNotification";

void _ma_NSWindow_Category_didReceiveEvent(unsigned int type, const void *data, size_t length, const void *context, unsigned int cid) {
    long windowNumber = *(long *)data;
    NSWindow *window = reinterpret_cast<id (*)(id, SEL, long)>(objc_msgSend)(NSApp, sel_registerName("windowWithWindowNumber:"), windowNumber);
    if (window == nil) return;
    
    [NSNotificationCenter.defaultCenter postNotificationName:MA_NSWindowActiveSpaceDidChangeNotification object:window];
}

void startWindowActiveSpaceObservation(void) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        void *handle = dlopen("/System/Library/PrivateFrameworks/SkyLight.framework/Versions/A/SkyLight", RTLD_NOW);
        void *symbol = dlsym(handle, "SLSRegisterConnectionNotifyProc");
        assert(symbol != NULL);
        
        __kindof NSNotificationCenter *notificationCenter = NSWorkspace.sharedWorkspace.notificationCenter;
        unsigned int connectionID = reinterpret_cast<unsigned int (*)(id, SEL)>(objc_msgSend)(notificationCenter, sel_registerName("connectionID"));
        reinterpret_cast<SInt16 (*)(unsigned int, void *, unsigned int, void *)>(symbol)(connectionID, (void *)_ma_NSWindow_Category_didReceiveEvent, 0x33b, NULL);
    });
}
